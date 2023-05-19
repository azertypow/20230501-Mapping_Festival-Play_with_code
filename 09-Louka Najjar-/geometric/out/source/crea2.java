import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import peasy.*; 
import themidibus.*; 
import ddf.minim.analysis.*; 
import ddf.minim.*; 
import javax.sound.sampled.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class crea2 extends PApplet {



//Camera
PeasyCam cam;
enum CamState {
    INIT, DEZOOM, TORNADO
};
CamState camState = CamState.INIT;

//Sound
Analysor s1;

//Constants
int maxZ = 10000;
int minZ = -10000;

//Spawners stuff
ArrayList<SquareSpawner> spawners  = new ArrayList<SquareSpawner>();
float spawnerRadius = 100;
float rotationSpeed = 1;
int spawnerCount = 3;

//Squares stuff
ArrayList<Square> squares = new ArrayList<Square>();
enum SquareState {
    NONE, FRONT, BACK
};
SquareState stateToSpawn = SquareState.NONE;
float velocityMultiplier = 1;
float velocityZ = 0;
float squareSize = 30;

//Background
float backgroundOpacity = 10;


//Position stuff
PVector center;

//Globe
Globe globe;

public void setup() {
    
    //size(1280, 720, P3D);
    rectMode(CENTER);
    
    //Camera
    cam = new PeasyCam(this, 1000);
    
    //Midi Controller
    midiSetup();
    
    //Sound
    //s1 = new Analysor(this, "Home.mp3", 60);
    //s1 = new Analysor(this, "sunset.mp3", 60);
    //s1 = new Analysor(this, "subterra.mp3", 60);
    s1 = new Analysor(this, "scavenger.mp3", 60);
    
    //Init spawners
    for (int i = 0; i < spawnerCount; i++) {
        float angle = map(i, 0, spawnerCount, 0, TWO_PI);
        spawners.add(new SquareSpawner(angle));
    }
    
    center = new PVector(0, 0, 0);
    
    //Globe setup
    globe = new Globe(width / 2, height / 2, 170);
}

public void draw() {
    float fov = PI / 3;
    float cameraZ = (height / 2) / tan(fov / 2);
    perspective(fov, PApplet.parseFloat(width) / PApplet.parseFloat(height), cameraZ / 10, cameraZ * 10000);
    
    pushMatrix();
    translate(0, 0, minZ);
    fill(0, backgroundOpacity);
    
    fill(0, 255, 0, backgroundOpacity);
    rect(0, 0, width * 30, height * 30);
    
    fill(255, 0, 0, backgroundOpacity);
    translate(0, minZ, maxZ);
    rotateX(radians(90));
    rect(0, 0, width * 30, height * 20);
    
    popMatrix();
    
    pushMatrix();
    center = new PVector(0, 0, 0);
    for (SquareSpawner spawner : spawners) {
        spawner.update();
        if (s1.getPower() > 1.5f) spawner.spawn();
        if (s1.getPower() > 5f) {
            float radiusOffset = map(s1.getPower(), 0, 50, 1, 50);
            spawnerRadius = 100 * radiusOffset;
        }
    }
    popMatrix();
    
    for (Square square : squares) {
        square.update();
        square.display();
    }
    
    globe.display();
    
    s1.runAnalyse();
    s1.drawPreAnalyse( -width / 2, 0, width, 300);
    
    // fill(random(255));
    //text(squares.size(), 0, 0);
    // text(frameRate, 0, 20);
    
    removeSquare();
    handleCamera();
}

public void removeSquare() {
    //if framerate less than 30, remove oldest square
    if (frameRate < 60 && squares.size() > 0) {
        squares.remove(0);
    }
}

public void setSpawnerCount(int count) {
    spawners.clear();
    spawnerCount = count;
    for (int i = 0; i < spawnerCount; i++) {
        float angle = map(i, 0, spawnerCount, 0, TWO_PI);
        spawners.add(new SquareSpawner(angle));
    }
}

boolean isMoving = false;
public void handleCamera() {
    switch(camState) {
        case INIT:
            if (spawnerCount != 4) setSpawnerCount(4);
            
            if (!isMoving && cam.getDistance() != 1000) {
                isMoving = true;
                cam.reset(500);
            }
            if (cam.getDistance() == 1000) {
                isMoving = false;
            }
            break;
        
        case DEZOOM:
            if (spawnerCount != 12) setSpawnerCount(12);
            
            if (!isMoving && cam.getDistance() != 10000) {
                isMoving = true;
                cam.setDistance(10000, 500);
            }
            if (cam.getDistance() == 10000) {
                isMoving = false;
            }
            // floatrotX = cam.getRotations()[0];
            // floatrotY = cam.getRotations()[1];
            // floatrotZ = cam.getRotations()[2];
            // if (rotX != 0) cam.setRotations(0, rotY, rotZ);
            // if (rotY != 0) cam.setRotations(rotX, 0, rotZ);
            // if (rotZ != 0) cam.setRotations(rotX, rotY, 0);
            // floatcamX = cam.getLookAt()[0];
            // floatcamY = cam.getLookAt()[1];
            // floatcamZ = cam.getLookAt()[2];
            // if (camX != 0) cam.lookAt(0, camY, camZ);
            // if (camY != 0) cam.lookAt(camX, 0, camZ);
            // if (camZ != 0) cam.lookAt(camX, camY, 0);
            break;
        case TORNADO:
            if (!isMoving && cam.getDistance() != 7500) {
                isMoving = true;
                cam.setDistance(7500, 500);
                float rotX = cam.getRotations()[0];
                float rotY = cam.getRotations()[1];
                float rotZ = cam.getRotations()[2];
                if (rotX != -1.4f) cam.setRotations( -1.4f, rotY, rotZ);
                if (rotY != 0) cam.setRotations(rotX, 0, rotZ);
                if (rotZ != 0) cam.setRotations(rotX, rotY, 0);
                float camX = cam.getLookAt()[0];
                float camY = cam.getLookAt()[1];
                float camZ = cam.getLookAt()[2];
                if (camX != 0) cam.lookAt(0, camY, camZ);
                if (camY != 0) cam.lookAt(camX, 0, camZ);
                if (camZ != 3000) cam.lookAt(camX, camY, 3000);
            }
            
            if (cam.getDistance() == 7500) {
                isMoving = false;
            }
            
            break;
    }
}


// public void dezoom2() {
//     cam.setDistance(5200);
//     cam.setRotations( - 1.4, 0, 0);
//     cam.lookAt(0, 0, 3000);
//     // cam.setPositions(0, 3350, 1250);
//     // cam.set
// }

//Debug
public void keyPressed() {
    if (key == 'm') {
        println("positions:");
        println(cam.getPosition());
        println("distance:");
        println(cam.getDistance());
        println("rotations:");
        println(cam.getRotations());
    }
}
class Globe {
    PShape globe;
    PVector location;
    float radius = 300;
    int col = color(255);
    ArrayList<PVector> initialPos = new ArrayList<PVector>();
    ArrayList<PVector> shape = new ArrayList<PVector>();
    int sides = 16;
    float angle = 360 / sides;
    int opacity = 0;
    int groupMult = 1;
    boolean isProducing = true;
    boolean isRotating = false;
    float deformMultiplier = 1.5f;
    float deformMax = 10;
    boolean appeared = false;
    
    Globe(float xi, float yi, float zi) {
        
        location = new PVector(xi, yi, zi);
        
        globe = createShape();
        globe.beginShape();
        for (int i = 0; i < sides; i++) {
            for (int j = 0; j < sides; j++) {
                float x = radius * cos(radians(angle * i)) * sin(radians(angle * j));
                float y = radius * sin(radians(angle * i)) * sin(radians(angle * j));
                float z = radius * cos(radians(angle * j));
                globe.vertex(x, y, z);
                initialPos.add(new PVector(x, y, z));
            }
        }
        globe.endShape();
        for (int i = 0; i < globe.getVertexCount(); i++) {
            PVector v = globe.getVertex(i);
            initialPos.add(v);
            shape.add(v);
        }
    }
    
    public void display() {
        pushMatrix();
        translate(location.x, location.y, location.z);
        //rotateX(1.3676498 + 1.5);
        rotateX(radians(180));
        PShape newGlobe = createShape();
        newGlobe.beginShape();
        newGlobe.noFill();
        newGlobe.stroke(col, opacity);
        for (int i = 0; i < globe.getVertexCount(); i++) {
            PVector v = globe.getVertex(i);
            float deformValue = s1.getPower() * deformMultiplier;
            deformValue = constrain(deformValue, 0, deformMax);
            
            if (s1.getPower() >  1 && millis() < 94960 || millis() > 124000) {
                v.x += random( -deformValue, deformValue);
                v.y += random( -deformValue, deformValue);
                v.z += random( -deformValue, deformValue);
            }
            PVector pos = initialPos.get(i);
            PVector dir = pos.copy().sub(v).normalize().mult(groupMult);
            float dist = pos.copy().sub(v).mag();
            if (dist > .5f) {
                v.add(dir);
            }
            newGlobe.vertex(v.x, v.y, v.z);
        }
        newGlobe.endShape();
        fill(0, 0);
        if (opacity == 0 && !appeared) {
            Ani.to(this, 3, "opacity", 255);
            appeared = true;
        }
        
        if (isRotating) {
            rotateZ(frameCount);
        }
        
        shape(newGlobe);
        globe = newGlobe;
        
        popMatrix();
    }
    
    public void disapear() {
        if (opacity > 0) opacity -= 5;
    }
}

MidiBus myBus;

public void midiSetup() {
    MidiBus.list(); // List all devices
    myBus = new MidiBus(this, 0, 0);
}

public void noteOn(Note note) {
    //Receive a noteOn
    println();
    println("Note On:");
    println("--------");
    println("Channel:" + note.channel());
    println("Pitch:" + note.pitch());
    println("Velocity:" + note.velocity());
    
    if (note.pitch() == 40)  {
        if (!isMoving) camState = CamState.DEZOOM;
    }
    
    if (note.pitch() == 36)  {
        if (!isMoving) camState = CamState.TORNADO;
    }
    
    if (note.pitch() == 39)  {
        if (!isMoving) camState = CamState.INIT;
    }
    
}

public void noteOff(Note note) {
    //Receive a noteOff
    println();
    println("Note Off:");
    println("--------");
    println("Channel:" + note.channel());
    println("Pitch:" + note.pitch());
    println("Velocity:" + note.velocity());
}

public void controllerChange(ControlChange change) {
    //Receive a controllerChange
    println();
    println("Controller Change:");
    println("--------");
    println("Channel:" + change.channel());
    println("Number:" + change.number());
    println("Value:" + change.value());
    
    //if (change.number() == 70) {
    //    spawnerRadius = map(change.value(), 0, 127, 100, height);
    //}
    
    if (change.number() == 71) {
        velocityZ = map(change.value(), 0, 127, -10, 10);
        if (velocityZ == 0) {
            stateToSpawn = SquareState.NONE;
        } else if (velocityZ > 0) {
            stateToSpawn = SquareState.FRONT;
        } else if (velocityZ < 0) {
            stateToSpawn = SquareState.BACK;
        }
    }
    
    //if (change.number() == 74) {
    //    backgroundOpacity = map(change.value(), 0, 127, 100, 10);
    //}
    
    if (change.number() == 75) {
        //rotationSpeed = map(change.value(), 0, 127, 1, 10);
        rotationSpeed = map(change.value(), 0, 127, 0.1f, 3f);
    }
    
    if (change.number() == 72) {
        velocityMultiplier = map(change.value(), 0, 127, 1, 10);
    }
    
    //if (change.number() == 76) {
    //    squareSize = map(change.value(), 0, 127, 30, 500);
    //}
}




public class Analysor {
    
    boolean debug = true;
    
    //------------------------------------------------------------
    //>> MINIM AND ANALYSIS SYSTEM
    //------------------------------------------------------------
    private PApplet app;
    Minim minim;
    
    BeatDetect beat;
    
    FFT fftLin;
    String path;
    int echan;
    
    AudioPlayer jingle;
    AudioInput in;
    
    AudioSource source;
    
    float senbility = 1;
    float lissage = 0.05f;
    float[] tabChannel;
    float[] tabChannelSmooth;
    boolean[] pointer;
    
    //------------------------------------------------------------
    //>> CONSTRUCTOR FOR MP3
    //------------------------------------------------------------
    Analysor(PApplet app, String path, int echan) {
        this.app = app;
        this.path = path;
        this.echan = echan;
        minim = new Minim(app);
        
        jingle = minim.loadFile(path);
        jingle.loop();
        
        initAnalysor();
}
    //------------------------------------------------------------
    //>> CONSTRUCTOR FOR LINE IN
    //------------------------------------------------------------
    Analysor(PApplet app, int echan) {
        this.app = app;
        this.path = path;
        this.echan = echan;
        minim = new Minim(app);
        
        in =minim.getLineIn();
        
        initAnalysor();
}
    
    public void initAnalysor() {
        if (jingle!= null)source = jingle;
        if (in!= null)source = in;
        
        fftLin = new FFT(source.bufferSize(), source.sampleRate());
        //fftLin.linAverages(echan);
        fftLin.logAverages(echan, 10);
        
        beat= new BeatDetect();
        beat.detectMode(BeatDetect.FREQ_ENERGY);
        beat.setSensitivity(500);
        
        this.app.registerMethod("keyEvent", this);
        //noSmooth();
        pointer = new boolean[fftLin.avgSize()];
        tabChannel = new float[fftLin.avgSize()];
        tabChannelSmooth = new float[fftLin.avgSize()];
        for (int i = 0; i < pointer.length; i++)pointer[i] = false;
}
    //-------------------------------------------------------------
    //RUN SYSTEM
    //-------------------------------------------------------------
    public void runAnalyse() {
        beat.detect(source.mix);
        if (jingle!= null)fftLin.forward(jingle.mix);
        if (in!= null)fftLin.forward(in.mix);
        
        for (int i = 0; i < tabChannel.length; i++)tabChannel[i] = fftLin.getAvg(i) * senbility;
        for (int i = 0; i < tabChannel.length; i++) {
            tabChannelSmooth[i] -= (tabChannelSmooth[i] - tabChannel[i]) * lissage;
        }
}
    //-------------------------------------------------------------
    //DRAW PRE ANALYSE DU SYSTEME
    //-------------------------------------------------------------
    int margeH = 90;
    int margeV = 30;
    
    public void drawPreAnalyse(int x, int y, int w, int h) {
        if (debug) {
            //--------------------------------------------------
          //  FOND NOIR
            //--------------------------------------------------
            strokeWeight(1);
            pushStyle();
            rectMode(CORNER);
            noStroke();
            fill(0);
            rect(x, y, w, h);
            
            fill(255);
            text("Graphic Analyser \nHelper Class for student " + "\nSensibility : " + senbility, x + 20, y + 20);
            
            text("Power : " + PApplet.parseInt(getPower()), x + margeH + 500, y + margeV / 2 + 10);
            rect(x + margeH + 600, y + margeV / 2, getPower(), 10);
            
            float sLarg = PApplet.parseFloat(w - margeV * 2) / fftLin.avgSize();
            
            for (int i = 0; i < fftLin.avgSize(); i++) {
                // draw a rectangle for each average, multiply the value by spectrumScale so we can see it better
                stroke(100);
                line(PApplet.parseInt(margeV + x + i * sLarg), y + h - margeH, PApplet.parseInt(margeV + x + i * sLarg), y + h - margeH - 100);
                fill(255);
                noStroke();
                rect(PApplet.parseInt(margeV + x + i * sLarg), y + h - margeH, PApplet.parseInt(sLarg), -fftLin.getAvg(i) * senbility);
                
                //--------------------------------------------------
                //  affichage Fréquence
                //--------------------------------------------------
                pushMatrix();
                translate(PApplet.parseInt(margeV + x + i * sLarg), PApplet.parseInt(y + h - margeH + 40));
                rotate(PI / 2);
                text(PApplet.parseInt(fftLin.getAverageCenterFrequency(i)), 0, 0);
                popMatrix();
                
                //--------------------------------------------------
                //  affichage colonne
                //--------------------------------------------------
                if (pointer[i] ==  false) {
                    fill(0, 255, 255);
            } else {
                    fill(255, 40, 40);
                }
                
                pushMatrix();
                if (i % 2 ==  0) {
                    translate(PApplet.parseInt(margeV + x + i * sLarg), PApplet.parseInt(y + h - margeH + 20));
            } else {
                    translate(PApplet.parseInt(margeV + x + i * sLarg), PApplet.parseInt(y + h - margeH + 25));
                }
                text(i, 0, 0);
                popMatrix();
        }
            
            popStyle();
        }
        
        for (int i = 0; i < pointer.length; i++)pointer[i] = false;
}
    
    //--------------------------------------------------
    //Student method usefull
    //--------------------------------------------------
    public float getChannel(int cha) {
        pointer[cha] = true;
        return fftLin.getAvg(cha) * senbility;
}
    public float getChannelSmooth(int cha) {
        pointer[cha] = true;
        return tabChannelSmooth[cha];
}
    public int getNbreChannel() {
        return fftLin.avgSize();
}
    
    public boolean getBeat() {
        return beat.isOnset();
}
    
    public boolean getSnare() {
        return beat.isSnare();
}
    
    public float getPower() {
        float result = 0;
        for (int i = 0; i < tabChannel.length; i++)result += tabChannel[i] * senbility;
        result /=  tabChannel.length;
        return result;
}
    
    public void setLissage(float lissage) {
        this.lissage = lissage;
}
    
    //--------------------------------------------------
    //setter
    //--------------------------------------------------
    public void volume(float vol) {
        source.setVolume(vol);
}
    
    public void changeMixerChannel(int channel) {
        Mixer.Info[] mixerInfo;
        mixerInfo = AudioSystem.getMixerInfo();
        
        Mixer mixer = AudioSystem.getMixer(mixerInfo[channel]);
        minim.setInputMixer(mixer);
        in =minim.getLineIn(Minim.STEREO);
}
    
    //--------------------------------------------------
    //keyEvent
    //--------------------------------------------------
    public void keyEvent(KeyEvent e) {
        println(e.getKeyCode());
        if (e.getAction() ==  e.RELEASE && e.getKeyCode() ==  32) {
            debug =! debug;
        }
        if (e.getAction() ==  e.RELEASE && e.getKeyCode() ==  38) {
            senbility += .5f;
        }
        if (e.getAction() ==  e.RELEASE && e.getKeyCode() ==  40) {
            senbility -= .5f;
        }
}
    
    
    //----------------------------------------------------------------------------------------------------
}
class Square {

  PVector location;
  PVector velocity;
  PVector destination;

  SquareState state;

  int col = color(255);
  // char c;
  float wiggleMultiplier = 0.2f;

  Square(PVector location, SquareState state) {
    this.location = location;
    this.state = state;
    // c = (char) int(random(0, 127));
  }

  public void display() {
    //color
    noFill();
    stroke(col);

    pushMatrix();
    translate(location.x, location.y, location.z);
    float camMult = (float)cam.getDistance() / 5000;
    float pow38 = s1.getChannel(38) / 1000;
    float pow10 = s1.getChannel(10) / 1000;
    rect(0, 0, squareSize + s1.getPower() * pow10 * camMult, squareSize + s1.getPower() * pow38 * camMult);
    // circle(0, 0, radius);
    popMatrix();
  }

  public void update() {

    float camMult = (float)cam.getDistance() / 1000;
    PVector dir = location.copy().sub(center).normalize().mult(velocityMultiplier * camMult);
    location.add(dir);

    switch(state) {
    case NONE:
      // if (location.z > 0) {
      //     location.z--;
      // } else if (location.z < 0) {
      //     location.z++;
      // }
      break;
    case FRONT:
      if (velocityZ > 0) location.z += velocityZ * camMult;
      break;
    case BACK:
      if (velocityZ < 0) location.z += velocityZ * camMult;
      break;
    }

    float wiggle = s1.getPower() * wiggleMultiplier;

    if (s1.getPower() > 0.5f) {
      if (random(0, 1) == 0) {
        location.x += random( -wiggle, wiggle);
      } else {
        location.y += random( -wiggle, wiggle);
      }
    }
  }
}



class SquareSpawner {
  PVector location;
  PVector velocity;
  float angle;
  float size = 10;

  SquareSpawner(float angle) {
    this.angle = angle;
  }

  public void update() {
    angle += radians(rotationSpeed);
    float camMult = (float)cam.getDistance() / 500;
    float x = cos(angle) * spawnerRadius + camMult;
    float y = sin(angle) * spawnerRadius + camMult;

    x = x % (width + size);
    location = new PVector(x, y, 0);
  }

  public void spawn() {
    float x = modelX(location.x, location.y, 0);
    float y = modelY(location.x, location.y, 0);
    squares.add(new Square(new PVector(x, y, 0), stateToSpawn));
  }
}
  public void settings() {  fullScreen(P3D, SPAN); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "crea2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
