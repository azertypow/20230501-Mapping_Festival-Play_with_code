import peasy.*;

// IMPORT THE SPOUT LIBRARY
import spout.*;
// DECLARE A SPOUT OBJECT
Spout spout;

boolean start = false;

enum State {
  TURN, HOLE
};

State state = State.TURN;

//Camera
PeasyCam cam;
enum CamState {  
  INIT, DEZOOM
};
CamState camState = CamState.INIT;

float camRotation = 0;
float rotationMultiplier = 0;

//Sound
Analysor s1;

//Constants
int maxZ = 10000;
int minZ = -10000;

//Spawners stuff
ArrayList<SquareSpawner> spawners  = new ArrayList<SquareSpawner>();
float spawnerRadius = 100;
float rotationSpeed = 1;
//int spawnerCount = 3;
int spawnerCount = 12;

//Squares stuff
ArrayList<Square> squares = new ArrayList<Square>();
enum SquareState {
  NONE, FRONT, BACK
};
SquareState stateToSpawn = SquareState.NONE;
float velocityMultiplier = 1;
float velocityBoost = 1;
float velocityZ = 0;
float squareSize = 30 * 2;
float squareOpacity = 255;

//Background
float backgroundOpacity = 10;


//Position stuff
PVector center;

//Globe
Globe globe;

void setup() {
  //fullScreen(P3D, SPAN);  // Modifier par Nico 20230502
  //size(1280, 720, P3D);
  
  // PROJECTION SIZE
  size (7000, 1200, P3D);

  // WINDOW POSITION
  //surface.setResizable(true);
  surface.setLocation(0, 0);

  // CREATE A NEW SPOUT OBJECT
  spout = new Spout(this);

  // GIVE THE SENDER A NAME
  // A sender can be given any name.
  // Otherwise the sketch folder name is used
  // the first time "sendTexture" is called.    
  spout.setSenderName("MappingFestival");
  
  
  rectMode(CENTER);

  //Camera
  cam = new PeasyCam(this, 1000);

  //Midi Controller
  midiSetup();

  //Sound
  //s1 = new Analysor(this, "Home.mp3", 60);
  //s1 = new Analysor(this, "sunset.mp3", 60);
  //s1 = new Analysor(this, "subterra.mp3", 60);
  //s1 = new Analysor(this, "scavenger.mp3", 60);
  
  translate(width/2, height/2);

  //Init spawners
  for (int i = 0; i < spawnerCount; i++) {
    float angle = map(i, 0, spawnerCount, 0, TWO_PI);
    spawners.add(new SquareSpawner(angle));
  }

  center = new PVector(0, 0, 0);
}

void draw() {
  if (!start) {
    background(0, 0, 0);
  } else {
    if (s1 == null) s1 = new Analysor(this, "scavenger.mp3", 60);
    float fov = PI / 3;
    float cameraZ = (height / 2) / tan(fov / 2);
    perspective(fov, float(width) / float(height), cameraZ / 10, cameraZ * 10000);

    rotate(radians(camRotation));
    camRotation += rotationMultiplier * s1.getPower() * 0.1;

    pushMatrix();
    translate(0, 0, minZ);
    fill(0, backgroundOpacity);
    rect(0, 0, width * 200, height * 200);
    popMatrix();

    pushMatrix();
    center = new PVector(0, 0, 0);
    for (SquareSpawner spawner : spawners) {
      spawner.update();
      if (s1.getPower() > 1.5f && state != State.HOLE) spawner.spawn();
      if (s1.getPower() > 5f) {
        float radiusOffset = map(s1.getPower(), 0, 50, 1, 50);
        spawnerRadius = 100 * radiusOffset;
      }
    }
    popMatrix();

    for (Square square : squares) {

      switch(state) {
      case TURN:
        square.update();
        break;
      case HOLE:
        square.distribute();
        break;
      }
      square.display();
    }

    s1.runAnalyse();
    removeSquare();
    handleCamera();
  }
  
    // Send the texture of the drawing sufrface
    spout.sendTexture();
    
    //println(frameRate);
}

void removeSquare() {
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
void handleCamera() {
  switch(camState) {
  case INIT:
    //if (spawnerCount != 4) setSpawnerCount(4);

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
      //cam.setDistance(10000, 500);
      cam.setDistance(10000, 20000);
    }
    if (cam.getDistance() == 10000) {
      isMoving = false;
    }
    break;
  }
}

//Debug
void keyPressed() {
  //if (key == 'm') {
  //  println("positions:");
  //  println(cam.getPosition());
  //  println("distance:");
  //  println(cam.getDistance());
  //  println("rotations:");
  //  println(cam.getRotations());
  //}


  if (key == 'q') {
    if (!isMoving) {
      if (camState != CamState.DEZOOM) {
        camState = CamState.DEZOOM;
      } else {
        camState = CamState.INIT;
      }
    }
  }
  
  if (key == 'a') {
  if (state != State.HOLE) state = State.HOLE;
  }
  
  if (key == 's') {
  if (state != State.TURN) state = State.TURN;
  }
  
  if (key == 'r') {
  start = !start;
  }
}
