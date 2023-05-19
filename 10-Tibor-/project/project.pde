/*  //<>//
A long take on particles 
Tibor Udvari
2022 */

// connect OSC with Chuck

import java.util.HashMap; 
import java.util.concurrent.ConcurrentHashMap;
import java.util.Map;
import java.util.function.Function;
import spout.*;

boolean isWindows = false;

Spout spout;
String oscRemoteAddress = "10.0.1.91";
int oscPort = 12000;

final int instagramMinW = 500;
final int instagramMinH = 888;

// Option 1
/*
int W = instagramMinW;
int H = instagramMinH;
float ratio = 1;
*/

// Option 2
// /*

// 1080

/*
int W = 15000;
int H = 2000;
float ratio = 0.1;
*/

/*
int W = 5760; 
int H = 1080;
11488x1800
*/

/*
int W = 11488; 
int H = 1800;
*/

int W = 5744; 
int H = 900;
float ratio = 0.1;

// */

OpenSimplexNoise noise;
ControlP5 cp5;
boolean wrappingX = true;

float numFrames = 60;

int displayW = (int)(W * ratio);
int displayH = (int)(H * ratio);

PGraphics b; // b for buffer

// Audio
Minim minim;
AudioOutput out;
Oscil wave;
Pan panPatch;

ArrayList<controlP5.Controller> controllers;

int seed = 12345;
float scl = 0.018;
float rad = 1.3;

int cols = 1;
int rows = 1;

float mx = 0.5;
float my = 0.5;

float off1 = 1.;
float off2 = 0.;
float off3 = 0.;

boolean periodicFuncDebug = true;
float offScl = 0.15;
float periodicFuncScale = 1;
float dotSizePct = 0.01;

boolean cp5Visible = true;

// Animation
// Has 10 slots for states
// Change - load next one and transition with anki

int animIndex;

float offMultX = 20;
float offMultY = 20;
float bgFill = 50;
float aFillMix = 0.5;
int lastLoad = 0;

AniSequence seq;
float delayHack = 0;

boolean aniLooping = false;

float ani1Start = 0.;
float ani1Dur = 0.2;

float ani2Start = 0.5;
float ani2Dur = 0.2;


float gAccu = 0;

//int audioFreq = 180;
int audioFreq = 720;
float[] waveTable;

float gpan = 0f; // global pan

class CustomWaveForm implements Waveform {
  int loopCounter = 0;

  float value(float v) {
    float t = 1.0 * frameCount/numFrames;
    //v = (v + (t * audioFreq ) % 1) % 1;
    v = fract(t) + 1. * loopCounter/audioFreq;
    float pv = fract(t) + 1. * ((loopCounter * 2. - 1) % loopCounter)/audioFreq;

    float accu = 0;
    float tot = rows + cols;

    float _mx = W * mx;
    float _my = H * my;

    float pan = 0;

    int maxSamples = 8;
    int maxSamplesRecording = 80;

    int inc = !recording ? cols * rows / maxSamples  : cols * rows / maxSamplesRecording;
    inc = (int)max(1, (float)inc);
    //println(inc);

    for (int i=0; i < cols; i+=inc) {
      for (int j = 0; j < rows; j+=inc) {
        float x = map(i, 0, max(cols-1, 1), _mx, W-_mx);
        float y = map(j, 0, max(rows-1, 1), _my, H-_my);

        float dx = offMultX * periodicFunction(v, 0, x, y);
        float dy = offMultY * periodicFunction(v + offset(x, y), 123, x, y);

        float pdx = offMultX * periodicFunction(pv, 0, x, y);
        float pdy = offMultY * periodicFunction(pv + offset(x, y), 123, x, y);

        // Result should go between -1 and 1. Just using the x to keep it simple
        //accu += (( abs(dx  / W)) +  abs(dy  / H) );
        // It should be the speed, it would make more sense auditively

        //accu += dx / W;
        float val = ((dx - pdx) / W + (dy - pdy) / H) / max(1, (cols * rows / inc));
        accu += val * 100 ;

        pan += 1. * (x + dx) / W * 2. - 1.;
        //accu = dx / W;
      }
    }
    accu = constrain(accu, -.9, .9);
    
    if (loopCounter == 0) accu = 0; // there is some sort of bug here
    
    waveTable[loopCounter] = accu;
    loopCounter = (loopCounter + 1) % audioFreq;
    gpan = pan;
    gpan = constrain(gpan, -.9, .9);
    panPatch.setPan(gpan);
    gAccu = accu;
    return accu;
  }
}

// attempt to normalize
float off1Func(float x, float y) {
  return dist(x, y, W/2, H/2) / max(W, H);
} 

float off2Func(float x, float y) {
  // angular  
  
  return fract((atan2(x - W / 2, y - H / 2) + PI) / TAU * 16);
}

float off3Func(float x, float y, int c, int r) {
    return r % 2;
}

float offset(float x, float y) {
  return offset(x, y, 0, 0);
}

float offset(float x, float y, int c, int r)
{
  float tot = off1 + off2 + off3;
  float rat = 3. / tot;
  //println(off3Func(x, y, c, r));
  //return 0;
  //return off3Func(x, y, c, r);
  return 10 * offScl * (off1Func(x, y) * off1 + off2Func(x, y) * off2 + off3Func(x, y, c, r) * off3) / 3.;
}

Function<Float, Function<Float, Function<Float, Function<Float, Float>>>> myFunction = p -> seed -> x -> y -> {
  // compute result here
  return periodicFuncScale * (float)noise.eval(seed+rad*cos(TAU*p), rad*sin(TAU*p), scl*x, scl*y);
};


float periodicFunction(float p, float seed, float x, float y)
{
  return periodicFuncScale * (float)noise.eval(seed+rad*cos(TAU*p), rad*sin(TAU*p), scl*x, scl*y);
}


void drawDots() {
  float sw2screen = 1.0 / ratio;

  b.beginDraw();

  float pt = 1.0 * ((frameCount + numFrames - 1) % 2)/numFrames;
  float t = 1.0 * frameCount/numFrames;

  b.fill(0, bgFill);
  b.noStroke();
  b.rect(0, 0, W, H);

  b.strokeCap(SQUARE);

  b.stroke(255);
  b.strokeWeight(100 * sw2screen * dotSizePct * displayWidth/displayHeight );
  b.strokeCap(ROUND);

  //b.strokeWeight(6);

  float _mx = W * mx;
  float _my = H * my;

  for (int i=0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float x = map(i, 0, max(cols-1, 1), _mx, W-_mx);
      float y = map(j, 0, max(rows-1, 1), _my, H-_my);

      float dx = offMultX * periodicFunction(t + offset(x, y, i, j), 0, x, y);
      float dy = offMultY * periodicFunction(t + offset(x, y, i, j), 123, x, y);

      float pdx = offMultX * periodicFunction(pt + offset(x, y, i, j), 0, x, y);
      float pdy = offMultY * periodicFunction(pt + offset(x, y, i, j), 123, x, y);

      float deltaPos = (abs(dx) / W + abs(dy) / H) / 2. ;
      float deltaPosFactor = map(deltaPos, 0, 1, 1, 0.6);
      //dx = 0;
      //dy = 0;
      //float dMovement = (dx - pdx) + (dy );
      float s = 10 * sw2screen * dotSizePct * min(displayW, displayH) * deltaPosFactor;
      //b.strokeWeight( 1 / ( dx + dy)  * 10 * sw2screen * dotSizePct * min(displayW, displayH) );
      // is not affected by the audio wave
      //println(gAccu);
      //b.stroke(255, 255, 255, constrain(abs(gAccu * 10000), 0.5, 1.0 ) * 255);

      float strokeVal = lerp(255., periodicFunction(t / 60 * 44000 + offset(x, y), 24, x, y) * 255., aFillMix);
      b.stroke(255, 255, 255, strokeVal );
      float strokeWeight = 5000 * sw2screen * dotSizePct * displayWidth/displayHeight * deltaPosFactor;
      b.strokeWeight(strokeWeight);
      
      int newX = (int)(x+dx);
      int newY = (int)(y+dy);
      b.point(newX, newY);
      
      if (wrappingX) {
        if (newX > W - strokeWeight * .5) {
          b.point( newX - W, newY );
        } else if (newX < strokeWeight * .5) {
          b.point( W + newX, newY);
        }
        
      } 
      
      //b.point((int)x+dx, (int)y+dy);
    }
  }

  b.endDraw();

  drawRecording();
}

void setup() {
  // TODO Interaction
  // Load the entire sequence and then seek inside of it
  // Play - should go through the states and the transitions
  // Stop - stop the current animation
  // Go to a specific step and start playing from there - arrow up and down
  // 

  b = createGraphics(W, H, P2D);
  b.smooth(8);
  waveTable = new float[audioFreq];
  noise = new OpenSimplexNoise(12345);
  Ani.init(this);
  seq = new AniSequence(this);

  //sequence();

  minim = new Minim(this);
  out = minim.getLineOut();

  CustomWaveForm customWaveForm = new CustomWaveForm();

  // 10 - frequency, 1f - amplitude
  
  
  //wave = new Oscil( audioFreq, 1f, customWaveForm );
  // debug the addition of the waveform
  panPatch = new Pan(0.);
  //dotSizePct
  //wave = new Oscil( map(), 1f, customWaveForm );
  //wave.patch(panPatch).patch(out);

  setupCP5();
  frameRate(60);
  
  //Ani.timeMode = Ani.FRAMES;
  //Ani.setDefaultTimeMode(Ani.FRAMES);
  
  String osName = System.getProperty("os.name");
  isWindows = osName.startsWith("Windows");
  
  if (isWindows) {
    spout = new Spout(this);
  spout.setSenderName("Spout Processing Sender");
  }


}

boolean greybox = false;


void settings() {
  size(displayW, displayH, P2D);
  //fullScreen(P2D, SPAN);
  
  if (greybox) {
    fullScreen(P2D, 2);
  }
  
  noSmooth();

  //smooth(8);
  //fullScreen(2);
  //noSmooth();
  //pixelDensity(2);
};

int stepCounter = 0;
int pStepCounter = 0;

void draw() {
  //println(seq.getTime() + " - " + seq.getStepNumber());
  
  drawDots();
  image(b, 0, 0, width, height);
  if (isWindows) {
    spout.sendTexture(b);
  }
  // HACK
  //s.changeValue(scl);

  //wave.setFrequency(constrain(map(dotSizePct, 0.0, 0.01, 22, 10), 10, 22));
  fpsLabel.setText(String.format("%.2f", frameRate) + "FPS");
  if (periodicFuncDebug) {
    drawPeriodicFunction();
    drawWaveTable();
  }

  // get the t
  float pt = fract(1.0 * (frameCount - 1)/numFrames);
  float t = fract(1.0 * frameCount/numFrames);

  if (aniLooping && pt > t) {
    println("Started loop");
    ArrayList<String> sequences = new ArrayList<String>();

    for (int i = 0; i < maxAnimIndex; i++) {
      var fn = String.format("data/%d.json", i);
      String pl = jsonFileToPropertyList(fn, "numFrames");
      sequences.add(pl);
    }
    //println("The ani1Dur is " + ani1Dur);
    //println(sequences.get(0));
    //Ani.to(this, ani1Start * numFrames, 1.0 * numFrames * ani1Dur, sequences.get(0));
    //Ani.to(this, ani2Start * numFrames, 1.0 * numFrames * ani2Dur, sequences.get(1));
    loopSequence = new AniSequence(this);
    loopSequence.beginSequence();

    // 1st is speed, second one is delay
    loopSequence.add(Ani.to(this, ani1Dur * numFrames, ani1Start * numFrames, sequences.get(0), easings[(int)d1.getValue()]));
    loopSequence.add(Ani.to(this, ani2Dur * numFrames, (ani2Start - ani1Start - ani1Dur) * numFrames, sequences.get(1), easings[(int)d2.getValue()]));
    
    loopSequence.endSequence();
    loopSequence.start();
    //Ani.to(this, ani2Start * numFrames, 1.0 * numFrames * ani2Dur, sequences.get(1));
  }
  
  boolean isPlayingMainSequence = seq.isPlaying() && !seq.isEnded();
  stepCounter = seq.getStepNumber();
  if (isPlayingMainSequence && stepCounter != pStepCounter) {
    println("UPDATE ANIM INDEX " + animIndex);
    animLabel.setText("anim " + animIndex + "/" + maxAnimIndex);
    stepLabel.setText("step " + stepCounter);
  }
  pStepCounter = stepCounter;
  if (periodicFuncDebug) {
    float pct = isPlayingMainSequence ? seq.getTime() / seq.getDuration() : t;
    
    float bw = pct * width;
    float bh = 20;
    fill(255);
    rect(0, height - bh, bw, bh);
    
    if (!isPlayingMainSequence) {
      noStroke();
      fill(100, 125);
      rect( ani1Start * width, height - bh, ani1Dur * width, bh);
      fill(200, 125);
      rect( ani2Start * width, height - bh, ani2Dur * width, bh);
    }
  }
  
  
}

void drawWaveTable() {
  stroke(255, 0, 0);
  strokeWeight(1);
  float step = 1. * width / audioFreq;
  for (int i = 0; i < audioFreq - 1; i++) {
    float val1 = waveTable[i];
    float val2 = waveTable[i+1];

    val1 = map(val1, -1, 1, 0, 1);
    val2 = map(val2, -1, 1, 0, 1);

    // draw line between them
    line(i * step, val1 * height, (i+1) * step, val2 * height);
  }
  line(0, H / 2, W, H / 2);
  stroke(255, 255, 255);
}

/*
float getValue(int x) {
 float delta = 1.0 / W;
 float t = delta * x;
 float samplingX = cos(t * TAU) * rad + W * 0.5;
 float samplingY = sin(t * TAU) * rad + H * 0.5;
 float val = (float)noise.eval(scl * samplingX, scl * samplingY);
 float normalized = (val + 1) / 2;
 return normalized;
 }*/
