import peasy.PeasyCam;

import processing.opengl.PGL;
import processing.opengl.PGraphics3D;
import processing.opengl.PJOGL;



/////MAPPING//////
// IMPORT THE SPOUT LIBRARY
import spout.*;
// DECLARE A SPOUT OBJECT
Spout spout;

///////////////////


Analysor s1;


/// how many viewports --> 1 for mapping!!
final int NX = 1;
final int NY = 1;
PeasyCam[] cameras = new PeasyCam[NX * NY];

PImage back;
PImage sun;

PShape sphere;
PImage part;

float ry;

// view de base sur la terre
int ID=2;

PlanetData[] planets= {   //nom, taille, position base
  new PlanetData("mercury", 15, 15),
  new PlanetData("venus", 20, 5 ),
  new PlanetData("earth", 22, 1),
  new PlanetData("mars", 18, 35),
  new PlanetData("jupiter", 15, 0.04),
  new PlanetData("saturn", 60, 2 ),
  new PlanetData("uranus", 40, 6),
  new PlanetData("neptune", 42, 45),
  new PlanetData("pluto", 13, 20)
};

Planet [] tabPlan = new Planet[planets.length];

Asteroid [] tabAst = new Asteroid [5];

Etoile [] etoiles = new Etoile[2500];

float [] posLook;

public void settings() {

  /////MAPPING//////
  //scene
  //fullScreen(P3D);  // Modifier par Nico 20230502


  // PROJECTION SIZE
  size (7000, 1200, P3D);


  /////////////////////

  //SOUND
  s1 = new Analysor (this, "1.mp3", 60);
}

///////////////////////////////////////////SETUP///////////////////////////////////////////

public void setup() {

  /////MAPPING//////
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


  ///////////////////




  int gap = 0;

  //SUN
  sphere = createShape(SPHERE, 100);
  this.sphere.disableStyle();
  sun=loadImage("sun.jpg");

  //PLANETS
  for (int i=0; i<planets.length; i++) {
    tabPlan[i] = new Planet(planets[i].nom, 300+ i*200, planets[i].taille, planets[i].vitesse );
  }

  //ASTEROIDS
  for (int i=0; i<tabAst.length; i++) {
    tabAst[i] = new Asteroid(random(width), random(height));
  }

  //STARS
  part = loadImage("particules.png");
  for (int i=0; i<etoiles.length; i++) {
    etoiles[i] = new Etoile(new PVector(random(-3000, 3000), random(-3000, 3000), random(-3000, 3000)), part);
  }


  // tiling size
  int tilex = floor((width  - gap) / NX);
  int tiley = floor((height - gap) / NY);

  // viewport offset ... corrected gap due to floor()
  int offx = (width  - (tilex * NX - gap)) / 2;
  int offy = (height - (tiley * NY - gap)) / 2;

  // viewport dimension
  int cw = tilex - gap;
  int ch = tiley - gap;

  // create new viewport for each camera
  for (int y = 0; y < NY; y++) {
    for (int x = 0; x < NX; x++) {
      int id = y * NX + x;
      int cx = offx + x * tilex;
      int cy = offy + y * tiley;
      cameras[id] = new PeasyCam(this, 400);
      cameras[id].setViewport(cx, cy, cw, ch);
    }
  }

  posLook = tabPlan[ID].actualPosition();

}

///////////////////////////////////////////DRAW///////////////////////////////////////////

public void draw() {

  println(posLook[0], posLook[1], posLook[2], tabPlan[ID].actualPosition()[0], tabPlan[ID].actualPosition()[1], tabPlan[ID].actualPosition()[2]);

  //sound
  s1.runAnalyse();

  // background(back);
  background(0);
  ambientLight(100, 100, 150);
  pointLight(255, 255, 255, 0, 0, 0);

  // render scene once per camera/viewport
  for (int i = 0; i < cameras.length; i++) {
    pushStyle();
    pushMatrix();
    displayScene(cameras[i]);
    popMatrix();
    popStyle();
  }

  //////////////////////// KEYBOARDS


  if (keyPressed) {
    if (key == '0') {
      ID=0;
    } else if (key == '1') {
      ID=1;
    } else if (key == '2') {
      ID=2;
    } else if (key == '3') {
      ID=3;
    } else if (key == '4') {
      ID=4;
    } else if (key == '5') {
      ID=5;
    } else if (key == '6') {
      ID=6;
    } else if (key == '7') {
      ID=7;
    } else if (key == '8') {
      ID=8;
    //} else if (key == '9') {
    //  ID=9;
    }

    if (key == 'a') {
      println(ID);
    }
  }

    // Send the texture of the drawing sufrface
    spout.sendTexture();


  println(frameRate);
}

///////////////////////// END

// some OpenGL instructions to set our custom viewport
//   https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glViewport.xhtml
//   https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glScissor.xhtml
void setGLGraphicsViewport(int x, int y, int w, int h) {
  PGraphics3D pg = (PGraphics3D) this.g;
  PJOGL pgl = (PJOGL) pg.beginPGL();
  pg.endPGL();

  pgl.enable(PGL.SCISSOR_TEST);
  pgl.scissor (x, y, w, h);
  pgl.viewport(x, y, w, h);
}


public void displayScene(PeasyCam cam) {

  int[] viewport = cam.getViewport();
  int w = viewport[2];
  int h = viewport[3];
  int x = viewport[0];
  int y = viewport[1];
  int y_inv =  height - y - h; // inverted y-axis

  // scissors-test and viewport transformation
  setGLGraphicsViewport(x, y_inv, w, h);

  // modelview - using camera state
  cam.feed();

  // projection - using camera viewport
  perspective(60 * PI/180, w/(float)h, 1, 5000);




  /////////// CAMERAS


  // Move lookAt position (posLook) towards target planet
  for (int i=0; i < 3; i++) {
    posLook[i] += (tabPlan[ID].actualPosition()[i] - posLook[i]) * 0.02; //facteur a modifier pour la vitesse du deplacement
  }

  cam.lookAt(posLook[0], posLook[1], posLook[2], 400, 0); //x,y,z,distance,delay


  // clear background (scissors makes sure we only clear the region we own)
  background(0);


  //////////////OBJECTS DRAW

  //SUN
  pushMatrix();
  //pointLight(255, 200, 200, 0+100, 0, 0);
  //lights();
  //translate(width/2, height/2);
  noStroke();
  rotateZ(PI);
  rotateY(-ry);
  sphere.setTexture(sun);
  shape(sphere);
  ry += 0.0001;
  popMatrix();

  //PLANETS
  for (int i=0; i<tabPlan.length; i++) {
    tabPlan[i].display();
  }

  //ASTEROIDS
  for (int i=0; i<tabAst.length; i++) {
    tabAst[i].display();
  }

  //STARS
  for (int i=0; i<etoiles.length; i++) {
    etoiles[i].draw();
  }
}
