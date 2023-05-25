import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import themidibus.*;
MidiBus myBus;
//AudioOutput output;
//import processing.sound.*;

// IMPORT THE SPOUT LIBRARY
import spout.*;
// DECLARE A SPOUT OBJECT
Spout spout;

ArrayList<Source> sources= new ArrayList<Source>();
ArrayList<Sols> sols= new ArrayList<Sols>();


PImage [] textures = new PImage[2];
PImage [] nuages = new PImage [2];
//PImage [] feuilles = new PImage [9];
PImage [] suns = new PImage [2];
PImage [] nuits = new PImage[2];
PImage [] boues = new PImage[2];
PImage [] champs = new PImage[2];
PImage [] herbes = new PImage[2];
PImage [] sables = new PImage[2];

PGraphics layer ;

int time =0;
int lastMillis;
boolean button;
boolean birds;
boolean moon;
int checksol;
int checkciel;
float circleWidth = 100; // taille de la lune

//Variables camera

int eyeX = 600;
int eyeY = 0;
int eyeZ = 200;

int centerX = 0;
int centerY = 0;
int centerZ = 0;

int upX = 0;
int upY = 0;
int upZ = 0;


Minim minim ;
LowPassFS   lpf; // lowpass filter
AudioPlayer nazz;
AudioPlayer orage;
AudioPlayer pioupiou;
AudioPlayer vent;
AudioPlayer pouic;
AudioPlayer everywhere;
//Reverb reverb;

Flock flock;
void setup() {
  //size (900, 900, P2D);
  //fullScreen(P2D, SPAN);

  // PROJECTION SIZE
  size (7000, 1200, P2D);

  // WINDOW POSITION
  surface.setResizable(true);
  surface.setLocation(0, 0);

  // CREATE A NEW SPOUT OBJECT
  spout = new Spout(this);

  // GIVE THE SENDER A NAME
  // A sender can be given any name.
  // Otherwise the sketch folder name is used
  // the first time "sendTexture" is called.
  spout.setSenderName("MappingFestival");

  minim = new Minim(this);
  flock = new Flock();
  //  reverb = new Reverb(this);

  nazz = minim.loadFile("Solo-nazz.mp3");
  orage = minim.loadFile("storm.mp3");
  pioupiou = minim.loadFile("bird.mp3");
  vent = minim.loadFile("wind.mp3");
  pouic = minim.loadFile("pouet.mp3");
  everywhere = minim.loadFile("everywhere.mp3");

  /*  lpf = new LowPassFS(100, output.sampleRate());
   nazz.patch( lpf ).patch( output );
   nazz.loop();*/
  //  reverb.process(nazz);
  // frameRate(25);



  for (int i=0; i<2; i++) {
    textures[i] = loadImage("texture"+int(i+1)+".png");
  }
  for (int i=0; i<2; i++) {
    nuages[i] = loadImage("nuage"+int(i+1)+".png");
  }

  for (int i=0; i<2; i++) {
    suns[i] = loadImage("sun"+int(i+1)+".png");
  }

  for (int i=0; i<2; i++) {
    nuits[i] = loadImage("nuit"+int(i+1)+".png");
  }

  for (int i = 0; i<2; i++) {
    boues [i] = loadImage("boue"+int(i+1)+".png");
  }

  for (int i = 0; i<2; i++) {
    champs [i] = loadImage("champ"+int(i+1)+".png");
  }

  for (int i = 0; i<2; i++) {
    herbes [i] = loadImage("herbe"+int(i+1)+".png");
  }
  for (int i = 0; i<2; i++) {
    sables [i] = loadImage("sable"+int(i+1)+".png");
  }

  layer = createGraphics (width, height);

  construcSource();

  MidiBus.list();
  myBus = new MidiBus(this, 3, 0);
}

void construcSource() {

  //sources du ciel
  for (int i=0; i<width; i = i+300) {
    sources.add(new Source(i, random(20, 80), suns, 0));
  }

  // source du sol
  for (int j=0; j<width; j = j+300) {
    sols.add(new Sols(j, random(height-20, height-80), herbes, 0));
  }
}


void draw () {

  flock.run();
  time+=millis()-lastMillis;
  everywhere.play();



  // int index=int(random(soles.length));

  /* if(time>random(20000,10000)){
   for (int i=0; i<sources.size(); i++) {
   sources.get(i).textures = nuages;
   }
   time=0;
   }*/
  lastMillis=millis();
  //println(lastMillis);
  for (int i=0; i<sources.size(); i++) {
    sources.get(i).display();
  }

  for (int i=0; i<sols.size(); i++) {
    sols.get(i).display();
  }
  // time();

  if (checkciel == 2 && checksol == 2) {
    moon = true;
    if (moon== true) {
      lune();
      //filter(POSTERIZE, 25);
      //filter(INVERT);
      // filter(BLUR, 6);
      //filter(THRESHOLD);
      //filter(DILATE);
    }
  } else {
    moon = false;
  }

  camera(eyeX, eyeY, eyeZ, // eyeX, eyeY, eyeZ
         centerX, centerY, centerZ, // centerX, centerY, centerZ
         upX, upY, upZ);

  /*  if (checkciel == 1 && checksol==1) {
   birds = true;
   if (birds == true) {
   oiseau();

   }
   }*/

    // Send the texture of the drawing sufrface
    spout.sendTexture();

   println(frameRate);

}
void lune() {
  pushMatrix();
  frameRate(25);
  //translate(random(20,50),random(20,50));
  //scale(random(0.2,1));
  fill(255, 10);
  noStroke();
  circle(width/4, height/3.7, random(135, 150));
  popMatrix();
}

/*void oiseau() {

 flock.addBoid(new Boid(width/1.3, height/4));
 }*/

void keyPressed () {

  if (keyCode==10) {
    save("capture/frame"+frameCount+".png");
  }

  if (key=='a') {
    for (int i=0; i<sources.size(); i++) {
      sources.get(i).textures = nuages;
    }
    checkciel=1;
    vent.play();
    vent.rewind();
  }
  /*else{
   checkciel  = 0;
   }*/

  if (key=='z') {
    for (int i=0; i<sources.size(); i++) {
      sources.get(i).textures = suns;
    }
    checkciel=2;
    pioupiou.play();
    pioupiou.rewind();
  }
  /*else{
   checkciel  = 0;
   }*/
  /*  if (key=='e') {
   for (int i=0; i<sources.size(); i++) {
   sources.get(i).textures = suns;
   }
   }*/

  if (key=='e') {
    for (int i=0; i<sources.size(); i++) {
      sources.get(i).textures = nuits;
    }
    orage.play();
    orage.rewind();
    checkciel = 3;
  }

  if (key=='s') {
    for (int i=0; i<sols.size(); i++) {
      sols.get(i).textures = boues;
    }
    pouic.play();
    pouic.rewind();
    checksol = 5;
  }

  if (key=='q') {
    for (int i=0; i<sols.size(); i++) {
      sols.get(i).textures = textures;
      checksol = 4;
    }
  }

  if (key=='d') {
    for (int i=0; i<sols.size(); i++) {
      sols.get(i).textures = champs;
    }
    checksol = 2;
  }
  /*else{
   checksol  = 0;
   }*/

  if (key=='f') {
    for (int i=0; i<sols.size(); i++) {
      sols.get(i).textures = herbes;
    }
    checksol = 1;
  }
  /*else{
   checksol  = 0;
   }*/

  if (key=='g') {
    for (int i=0; i<sols.size(); i++) {
      sols.get(i).textures = sables;
    }
    checksol = 3;
  }
}
void noteOn(Note note) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+note.channel());
  println("Pitch:"+note.pitch());
  println("Velocity:"+note.velocity());

// CONTROL CIELS
  if(note.pitch() == 9 ){
    for (int i=0; i<sources.size(); i++) {
      sources.get(i).textures = nuages;
    }
    checkciel=1;
    vent.play();
    vent.rewind();
    }

   if(note.pitch() == 10 ){
       for (int i=0; i<sources.size(); i++) {
      sources.get(i).textures = suns;
    }
    checkciel=2;
    pioupiou.play();
    pioupiou.rewind();
   }


   if(note.pitch() == 11 ){
     for (int i=0; i<sources.size(); i++) {
      sources.get(i).textures = nuits;
    }
    orage.play();
    orage.rewind();
    checkciel = 3;
  }


 if(note.pitch() == 12 ){
  for (int i=0; i<sols.size(); i++) {
      sols.get(i).textures = boues;
    }
    pouic.play();
    pouic.rewind();
    checksol = 5;
}

// CONTROL SOLS

   if(note.pitch() == 25 ){
       for (int i=0; i<sols.size(); i++) {
      sols.get(i).textures = textures;
      checksol = 4;
    }
}
   if(note.pitch() == 26 ){
         for (int i=0; i<sols.size(); i++) {
      sols.get(i).textures = champs;
    }
    checksol = 2;
}
   if(note.pitch() == 27 ){
         for (int i=0; i<sols.size(); i++) {
      sols.get(i).textures = herbes;
    }
    checksol = 1;
}
   if(note.pitch() == 28 ){
         for (int i=0; i<sols.size(); i++) {
      sols.get(i).textures = sables;
    }
    checksol = 3;
}
}


void noteOff(Note note) {
  // Receive a noteOff
  println();
  println("Note Off:");
  println("--------");
  println("Channel:"+note.channel());
  println("Pitch:"+note.pitch());
  println("Velocity:"+note.velocity());
}

void controllerChange(ControlChange change) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+change.channel());
  println("Number:"+change.number());
  println("Value:"+change.value());


}


/*  if(key=='k'){
 }*/


/*    if (key=='c') {
 construcSource();
 }
 if (key=='d') {
 while (sources.size()>0) {
 sources.remove(0);
 }
 }*/
