import themidibus.*;
MidiBus myBus;
import java.util.ArrayList;

// IMPORT THE SPOUT LIBRARY
import spout.*;
// DECLARE A SPOUT OBJECT
Spout spout;

boolean performanceRunning = true;

//Jellyfish [] tabJelly = new Jellyfish[15];
int jellyNbr = 1;
ArrayList<Jellyfish> tabJelly = new ArrayList<Jellyfish>();
//Seaweed [] swArray = new Seaweed[5];
Seaweed [] swArray = new Seaweed[1];
Flock flock;
Analysor s1;
int limit = 0;
color col = color(50, 168, 121);
int blue;
FloatList startXList = new FloatList();
FloatList startYList = new FloatList();
float startX = 0;
float startY = random(0, height);
int channel = 27;
float startTime = millis();
float currentTime = millis();
float period = 300;
float soundAvg = 0;
int background = 120;
boolean pressing = false;
int transparency = 1;

void setup() {
  // size(1000, 600, P2D); // Modifier par Nico 20230502
  //size(1920, 1080);
  // fullScreen(P2D,SPAN); // Modifier par Nico 20230502

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




  s1 = new Analysor(this, "wondrous-waters-119518.mp3", 60);

  for (int i=0; i<1; i++) {
    tabJelly.add(new Jellyfish(random(width), random(height), s1));
  }

  for (int g = 0; g < swArray.length; g++) {
    startY = random(0, height);
    while (startY > 5 && startY < height-5) {
      startY = random(0, height);
      //println(startY);
    }
    //println("out");
    startYList.set(g, startY);
  }


  for (int f = 0; f < swArray.length; f++) {
    startX = width/swArray.length * (f+1);
    startXList.set(f, startX);
  }

  for (int i=0; i<swArray.length; i++) {
    swArray[i] = new Seaweed(tabJelly, startXList.get(i), startYList.get(i));
  }

  flock = new Flock();

  //for (int i = 0; i < 800; i++) {
  //  flock.addBoid(new Boid(random(width), height/2));
  //}
  for (int i = 0; i < 80; i++) {
    flock.addBoid(new Boid(random(width), random(height)));
  }
  MidiBus.list(); // List all available Midi devices

  //                      select input here
  //                        |
  myBus = new MidiBus(this, 2, 0);
}

int index=7;

void draw() {
  //println(startTime);
  currentTime = millis();
  //println("Temps écoulé : "+(currentTime-startTime)*10000+" secondes");


  background(0, 0, background);

  //Sound
  //s1.runAnalyse();
  //fill(255, 0, 0);
  //rect(s1.getChannel(32), s1.getChannel(33), s1.getChannel(40)*10, 200);
  //s1.drawPreAnalyse(0, 0, width, 300);


  //Seaweed
  strokeWeight(0.5);
  soundAvg = (s1.getChannelSmooth(27)+s1.getChannelSmooth(20))+s1.getChannelSmooth(15)/2;
  blue = (int) map(s1.getChannelSmooth(27), 0, 30, 0, 255);
  col = color(35, 128, blue, 200);
  //println(s1.getChannelSmooth(index)*10);

  for (int i = 0; i < swArray.length; i++) {
    swArray[i].display(col);
    swArray[i].jf = tabJelly.get((int) random(0, tabJelly.size()));
  }


  //banc de poissons
  flock.run();

  //Jellyfish
  for (int i=0; i<tabJelly.size(); i++) {
    tabJelly.get(i).display();
    tabJelly.get(i).touch(tabJelly);
  }

  //if (!performanceRunning) {
  //  // reduce opacity of jellyfish and fish
  //  for (Jellyfish jelly : tabJelly) {
  //    jelly.reduceOpacity();
  //  }
  //  for (Boid boid : flock.boids) {
  //    boid.reduceOpacity();
  //  }
  //}


  index++;
  if (index>=36)index=7;

  if(!performanceRunning){
  fill(0, 0, 0, transparency);  // adjust the last value to get the desired opacity
  rect(0, 0, width*2, height*2);
  transparency+=1;
  }


  // Send the texture of the drawing sufrface
  spout.sendTexture();

  //println(frameRate);
}

// Add a new boid into the System
void mousePressed() {
  flock.addBoid(new Boid(mouseX, mouseY));
}

//Midi Controller


void noteOn(Note note) {
  if ( note.pitch() == 44 ) {
    println("44");

    jellyNbr++;
    tabJelly.add(new Jellyfish(0, 0, s1));
  }
  if ( note.pitch() == 45 ) {
    println("45");
    performanceRunning = false;
  }

  //if ( note.pitch() == 45 ) {
  //  jellyNbr--;
  //  println(jellyNbr);
  //  tabJelly.remove(tabJelly.size()-1);
  //}
}

void controllerChange(ControlChange change) {

  if ( change.number() == 1 ) {
    background = change.value();
    println(background);
  }

  if ( change.number() == 2 ) {
    println("in 2");
    for (int i = 0; i < swArray.length; i++) {
      swArray[i].r.set(swArray[i].r.size(), 50);
    }
  }

  if ( change.number() == 3 ) {
    println("in 3");
    for (int i = 0; i < flock.boids.size(); i++) {
        flock.boids.get(i).maxforce = map(change.value(), 0, 127, 0.005, 0.05);
    }
  }

  if ( change.number() == 4 ) {
    println("in 4");
    for (int i = 0; i < flock.boids.size(); i++) {
        flock.boids.get(i).maxspeed = map(change.value(), 0, 127, 1, 5);
    }
  }




  //if ( change.number() == 44 ) {
  //  if (!pressing) {
  //    if (currentTime - startTime <= period) {
  //      pressing = true;
  //    }
  //    startTime = millis();
  //    currentTime = millis();
  //  }
  //  if (pressing) {
  //    jellyNbr++;
  //    tabJelly.add(new Jellyfish(random(width), height-random(10), s1));
  //    pressing = false;
  //  }
  //}


  //if ( change.number() == 105 ) {
  //  if (!pressing) {
  //    if (currentTime - startTime <= period) {
  //      pressing = true;
  //    }
  //    startTime = millis();
  //    currentTime = millis();
  //  }
  //  if (pressing && jellyNbr > 1) {
  //    jellyNbr--;
  //    println(jellyNbr);
  //    tabJelly.remove(tabJelly.size()-1);
  //    pressing = false;
  //  }
  //}
}
