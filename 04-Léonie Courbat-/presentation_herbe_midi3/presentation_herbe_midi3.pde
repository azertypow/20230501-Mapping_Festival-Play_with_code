//écran 360° : 15'000 x 2000 px

import peasy.PeasyCam;
import peasy.org.apache.commons.math.geometry.*;
import peasy.*;

Herbe [] tabHerbe = new Herbe[20000];
//Forme [] tabForme = new Forme[60]; => FORME
PeasyCam cam;
Analysor s1;

import themidibus.*;
MidiBus myBus;

PGraphics pg;
PShader blur;

//int m = millis();
int m = frameCount;

color ora = color(238, 150, 75);
color ver = color(85, 130, 139);

float colorControlForHerbe = 0;
float taillecontrolforHerbe = 5;

void setup() {
  //fullScreen(P3D, SPAN);
  //size(1500, 200, P3D);
  //size(15000, 2000, P3D);  // Modifier par Nico 20230502

  // PROJECTION SIZE
  size (7000, 1200, P3D);

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

  pg = createGraphics (width, height, P2D);
  blur = loadShader("blur.glsl");
  s1 = new Analysor(this, "halp.mp3", 60);

  //PeasyCam(PApplet parent, double lookAtX, double lookAtY, double lookAtZ, double distance);
  cam = new PeasyCam(this, 400);

  cam.lookAt(1000, 100, 0.0, 1141.0087774794538);
  cam.setRotations(-1.185902, -0.014753667, -0.0065380344);

    MidiBus.list(); // List all available Midi devices

  //                      select input here
  //                        |
  myBus = new MidiBus(this, 1, 0);

  int index=0;
  for (int i=0; i<200; i++) {
    for (int j=0; j<100; j++) {

      float h = noise(i*0.1, j*0.1);
      tabHerbe[index] = new Herbe(i*20-(20*100/2)+random(-30, 30), j*20-(20*100/2)+random(-30, 30), h*200);
      index++;
    }
  }
  //for (int i=0; i<tabForme.length; i++) { => FORME
    //tabForme[i] = new Forme(random(width), random(height), random(140, 160)); => FORME
  //} => FORME
}

void draw() {

  //background(54, 73, 88); => ANCIEN BACKGROUND
  background(0);

  pg.beginDraw();
  //pg.background(54, 73, 88); => ANCIEN BACKGROUND
  background(0);
  //pg.clear();
 //for (int i=0; i<tabForme.length; i++) { => FORME
    //tabForme[i].display(pg); => FORME
    //filter(blur);
  //} => FORME
  pg.filter(blur);
  pg.endDraw();

  s1.runAnalyse();
  pushMatrix();
  for (int i=0; i<tabHerbe.length; i++) {

    tabHerbe[i].colorControl = colorControlForHerbe;

    tabHerbe[i].controltaille = taillecontrolforHerbe;

    tabHerbe[i].display();
  }
  translate(0-(20*100/2)-300, 0-(20*100/2)-500);
  //fill(38, 70, 83); => ANCIEN FILL
  fill(0);
  noStroke();
  rect(0, 0, 4*width, 5*height);
  popMatrix();

  //cam.beginHUD et cam.endHUD permettent de désactiver la 3D dans une zone concerner pour y travailler en 2D
  cam.beginHUD();
  pushMatrix();
  //BlendMode et Tint permettent de jouer avec les teintes et fusions comme dans PS
  blendMode(ADD);
  tint(255, 100);
  image(pg, 0, 0, width, height);
  popMatrix();
  //Blend => C = A*factor + B
  blendMode(BLEND);
  cam.endHUD();

  //if (frameCount==200) {
    //for (int i=0; i<tabHerbe.length; i++) {
      //tabHerbe[i].mode="pousse";
    //}
  //}

  /*if (frameCount==2200) {
    for (int i=0; i<tabHerbe.length; i++) {
      tabHerbe[i].mode="petit";
    }
  }

  if (frameCount==2500 || frameCount==2700 ||
  frameCount==2900 || frameCount==3100 || frameCount==3300 ||
  frameCount==3500 || frameCount==3700 || frameCount==3900 ||
  frameCount==4100 || frameCount==4300 || frameCount==4500 ||
  frameCount==4700 || frameCount==4900 || frameCount==5100 ||
  frameCount==5300 || frameCount==5500 || frameCount==5700/*||
  frameCount==5900 || frameCount==6100 || frameCount==6300 ||
  frameCount==6500 || frameCount==6700 || frameCount==6900 ||
  frameCount==7100 || frameCount==7300 || frameCount==7500 ||
  frameCount==7700 || frameCount==7900 || frameCount==8100 ||
  frameCount==8300 || frameCount==8500 || frameCount==8700 ||
  frameCount==8900 || frameCount==9100 || frameCount==9300 ||
  frameCount==9500 || frameCount==9700 || frameCount==9900 ) {
    thread("vague");
  }
   if (frameCount==2600 || frameCount==2800 ||
  frameCount==3000 || frameCount==3200 || frameCount==3400 ||
  frameCount==3600 || frameCount==3800 || frameCount==4000 ||
  frameCount==4200 || frameCount==4400 || frameCount==4600 ||
  frameCount==4800 || frameCount==5000 || frameCount==5200 ||
  frameCount==5400 || frameCount==5600 || frameCount==5800/* ||
  frameCount==6000 || frameCount==6200 || frameCount==6400 ||
  frameCount==6600 || frameCount==6800 || frameCount==7000 ||
  frameCount==7200 || frameCount==7400 || frameCount==7600 ||
  frameCount==7800 || frameCount==8000 || frameCount==8200 ||
  frameCount==8400 || frameCount==8600 || frameCount==8800 ||
  frameCount==9000 || frameCount==9200 || frameCount==9400 ||
  frameCount==9600 || frameCount==9800 || frameCount==10000) {
    thread("devague");
  }*/

    // Send the texture of the drawing sufrface
    spout.sendTexture();

    //println(frameRate);

}


void vague() {
  println("VENI");
  for (int i=0; i<tabHerbe.length; i++) {
    //println("VEDI");
   tabHerbe[i].mode="pousse";
   //println("VICI");
   delay(1);
  }
  println("-THREAD VAGUE");
}

void devague() {
  for (int i=0; i<tabHerbe.length; i++) {
    tabHerbe[i].mode="petit";
    delay(1);
  }
  println("-THREAD DEVAGUE");
}

void keyPressed() {

  if (key=='d') {
    //println(cam.getLookAt());
    //println(cam.getDistance());
    //println(cam.getRotations());
  }

  println(frameCount);

  //lookAt(lookAt[0],lookAt[1],lookAt[2],getDistance)
  if (key=='a') {
    CameraState stat = new CameraState(
      new Rotation(RotationOrder.XYZ, -1.185902, -0.014753667, -0.0065380344),
      new Vector3D(1000, 100, 0),
      (double)1141.0087774794538
      );

    cam.setState(stat, (long)6000);
  }

  if (key=='b') {
    cam.lookAt(0.0, 0.0, 0.0, 1098.33);
    //setRotation(getRotations()[0],getRotations()[1],getRotations()[2]);
    cam.setRotations(-1.2276181, -0.7656701, 0.33582705);
  }


  /*if (key=='q') {
    for (int i=0; i<tabHerbe.length; i++) {
      tabHerbe[i].mode="pousse";
    }
  }
  if (key=='x') {
    for (int i=0; i<tabHerbe.length; i++) {
      tabHerbe[i].mode="petit";
    }
  }

  if (key=='c') {
    thread("vague");
  }
   if (key=='v') {
    thread("devague");
  }
}

void vague() {
  for (int i=0; i<tabHerbe.length; i++) {
    tabHerbe[i].mode="pousse";
    delay(1);
  }
}

void devague() {
  for (int i=0; i<tabHerbe.length; i++) {
    tabHerbe[i].mode="petit";
    delay(1);
  }*/
}

void noteOn(Note note) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+note.channel());
  println("Pitch:"+note.pitch());
  println("Velocity:"+note.velocity());
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


  //To adapt to the midi controler used during the mapping festival
  if( change.number() == 16 ) colorControlForHerbe = map(change.value(), 0, 127, 0, 100) * 2;

  if (change.number() == 17) taillecontrolforHerbe = map(change.value(), 0, 127, 5, 100);

  if (change.number() == 32){
    if(change.value() == 127){
      //println("IN");
    //vague();
    thread("vague");
    println("+THREAD VAGUE");
    }
  }

  if (change.number() == 64){
    if(change.value() == 127){
    //devague();
    thread("devague");
    println("+THREAD DEVAGUE");
    }
  }

}
