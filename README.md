// IMPORT THE SPOUT LIBRARY
import spout.*;
// DECLARE A SPOUT OBJECT
Spout spout;



…your code



void setup() {

  // PROJECTION SIZE
  size (7000, 1200, {});

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



  …your code
}




void draw()  {

    …your code



    // Send the texture of the drawing sufrface
    spout.sendTexture();
}

// Modifier par Nico 20230502