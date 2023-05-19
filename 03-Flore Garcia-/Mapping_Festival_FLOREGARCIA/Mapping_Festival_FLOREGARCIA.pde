

PImage photo;
PImage realphoto;

ArrayList<Espece> toutlemonde = new ArrayList<Espece>();
ArrayList<Espece> toutlemonde2 = new ArrayList<Espece>();
ArrayList<Espece2> pluslong = new ArrayList<Espece2>();
ArrayList<Espece2> pluslong2 = new ArrayList<Espece2> ();
ArrayList<Espece3> rare= new ArrayList<Espece3>();
ArrayList<Espece3> rare2 = new ArrayList<Espece3> ();

PGraphics layer;
int i = 0;

PImage pap;
PImage pap2;
PImage blue;
PImage vers;

int addCarnivore = 0;


import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

// IMPORT THE SPOUT LIBRARY
import spout.*;
// DECLARE A SPOUT OBJECT
Spout spout;



Minim minim ;
AudioPlayer grotte;



void setup() {
  //size(1200, 891, P2D);
  //fullScreen(P2D, SPAN);
  
  
  // PROJECTION SIZE
  size(7000, 1200, P2D);

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





  //photo = (loadImage("fonddecoupepleincopie(1).png"));
   realphoto= (loadImage("Décor.png"));

  minim = new Minim(this);
  grotte = minim.loadFile("grotte.mp3");
  grotte.play();
  grotte.loop();

  layer = createGraphics(width, height, P2D);

  pap = loadImage("Paps 1.png");
  pap2 = loadImage("Paps 2deux.png");
  blue = loadImage("bleuet.png");
  vers = loadImage("vers.png");
}
// --- Touches pour faire apparaître les formes sur le layer supérieur
void keyPressed () {
  switch(key) {
  case'z' :
    toutlemonde.add(new Serpentin());
    break;
  case'q' :
    toutlemonde.add(new Serpentin2());
    break;
  case's' :
    toutlemonde.add(new Tetard());
    break;
  case'd' :
    toutlemonde.add(new Vers(vers));
    break;
  case'r' :
    toutlemonde.add(new Ant(pap));
    break;
    case'a' :
    toutlemonde.add(new Microbe(pap2));
    break;
   case'w' :
   toutlemonde.add(new Bleuet(blue));
   break;
}
}
void draw() {
  background(3, 34, 76);

  // Section Forms Rect
  //---------------------------------------------------------
  //avant image
  //---------------------------------------------------------
  for (int i = 0; i < toutlemonde2.size(); i++) {
    toutlemonde2.get(i).run();
    toutlemonde2.get(i).display();
  }

  for (int i = 0; i < pluslong2.size(); i++) {
    pluslong2.get(i).run();
    pluslong2.get(i).display();
  }
  for (int i = 0; i < rare2.size(); i++) {
    rare2.get(i).run();
    rare2.get(i).display();
  }
  //---------------------------------------------------------
  //image
  //---------------------------------------------------------
  image(realphoto, 0, 0, width, height);

  //---------------------------------------------------------
  //layer
  //---------------------------------------------------------
  layer.beginDraw();
  layer.clear();
  layer.tint(255, 20);
  //layer.rect(0, 0, width, height);
  layer.image(realphoto, 0, 0);
  //layer.image(photo, 0, 0);
  //Sections des Serpentins


  for (int addCarnivore = 0; addCarnivore < toutlemonde.size(); addCarnivore++) {
    toutlemonde.get(addCarnivore).run();
    if (i > 0)toutlemonde.get(i).checkCollision(toutlemonde.get(0));
    toutlemonde.get(addCarnivore).display();
  }





  for (int i = 0; i < pluslong.size(); i++) {
    pluslong.get(i).run();
    pluslong.get(i).display();
  }

  for (int i = 0; i <rare.size(); i++) {
    rare.get(i).run();
    rare.get(i).display();
  }

  layer.endDraw();

  image(layer, 0, 0);
  



  
  for (int addCarnivore = toutlemonde.size()-1; addCarnivore >= 0; addCarnivore--) {
    if (toutlemonde.get(addCarnivore).life<0)toutlemonde.remove(addCarnivore);
    else if (toutlemonde.get(addCarnivore).dead)toutlemonde.remove(addCarnivore);
  }
  for (int i = 0; i < toutlemonde2.size(); i++) {
    if (toutlemonde2.get(i).life<0)toutlemonde2.remove(i);
  }
  
  for (int i = 0; i < pluslong2.size(); i++) {
    if (pluslong2.get(i).life<0)pluslong2.remove(i);
  }
  
  for (int i = 0; i < rare2.size(); i++) {
    if (rare2.get(i).life<0)rare2.remove(i);
  }

  
  if (frameCount%(60*2)==0)gen2();
  
  // Send the texture of the drawing sufrface
    spout.sendTexture();
    
  println(frameRate);
}






void gen2() {
  int de = int(random(60));

  if (de > 0 && de < 40) {
    pluslong2.add(new Form());
  }
  if (de > 30 && de < 50) {
    toutlemonde2.add(new Ellipse());
  }
  if (de > 50 && de < 60) {
    rare2.add(new Troisangles());
  }
}
