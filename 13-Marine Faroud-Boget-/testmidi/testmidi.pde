// IMPORT THE SPOUT LIBRARY
import spout.*;
// DECLARE A SPOUT OBJECT
Spout spout;



import themidibus.*;
MidiBus myBus;

PGraphics p1;
PGraphics p2;

int nbr = 1;

ArrayList<poin> tabpoin = new ArrayList<poin>();
ArrayList<Courbe> tabCourbe = new ArrayList<Courbe>();
Analysor s1;
Courbe c;

void setup() {
  //fullScreen (P3D, SPAN);
  //size(1300, 800, P3D);  // Modifier par Nico 20230502
  //fullScreen(P3D);
  

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
  
  
  
  
  
  
  
  background(0);

  MidiBus.list(); // List all available Midi devices

  //                      select input here
  //                        |
  myBus = new MidiBus(this, 2 , 0);


  s1 = new Analysor(this, "son.mp3", 60);
  noStroke();
  p1 = createGraphics(width, height, P3D);

  for (int j=0; j<nbr; j++) {
    tabCourbe.add(new Courbe(random(width), 0, random(1000), random(300), 40, random(1)));
    tabCourbe.get(j).py = random(height);
  }

  for (int j=0; j<1000; j++) {
    tabpoin.add(new poin(random(width), random(height), random(5), random(5)));
  }
}


void draw() {

  //background(0);
  fill(0, 30);
  noStroke();
  rect(0, 0, width, height);
  s1.runAnalyse();
  s1.drawPreAnalyse(0, 0, width, 300);

  for (int a=0; a<40; a++) {
    float r=map(s1.getChannel(a), 0, 1, -10, 10);

    for (int i=0; i<tabCourbe.size(); i++) {
      tabCourbe.get(i).nombres[a]=r;

      fill(0, 0);
      color col = color(
        map(a, 0, 40, 0, 255),
        map(s1.getChannel(a), 0, 1, -10, 10),
        200,
        80);
      tabCourbe.get(i).tabColor[a]=col;
    }
  }

  for (int j=0; j<tabpoin.size(); j++) {
    tabpoin.get(j).draw();
  }

  for (int j=0; j<tabpoin.size(); j++) {
    if (tabpoin.get(j).life<0)tabpoin.remove(j);
  }

  for (int i=0; i<tabCourbe.size(); i++) {
    tabCourbe.get(i).draw();
  }



  if (tabpoin.size()<1000) {
    tabpoin.add(new poin(random(width), random(height), random(5), random(5)));
  }
  
  
  // Send the texture of the drawing sufrface
  spout.sendTexture();
  
  //println(frameRate);
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

  for (int i=0; i<tabpoin.size(); i++) {
    if ( change.number() == 0 ) tabpoin.get(i).c = change.value()/ random(40, 50);
  }
  //for (int j=0; j<tabCourbe.size(); j++) {
  //  if ( change.number() == 1 ) nbr = change.value();
  //}

  if ( change.number() == 43 ) {
    if (change.value()==127) {
      //funtion add
        println("ADD");
         tabCourbe.add(new Courbe(random(width), 0, random(1000), random(300), 40, random(1)));
    }
  }
  
    if ( change.number() == 44 ) {
    if (change.value()==127) {
      
         //funtion remove
         println("REMOVE");
              tabCourbe.remove(0);

    }
  }
  //if( change.channel() == 1 ) 
  //nbr = (int)map(change.value(), 0, 127, 0, 20);
}
