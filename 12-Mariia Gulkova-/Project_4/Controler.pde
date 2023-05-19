// from 
// https://github.com/sparks/themidibus
 

import themidibus.*;
MidiBus myBus;

float circleWidth = 100;
float circleColor = 255;

void draw11() {
  background(0);
 
  circle(width / 2, height / 2, circleWidth);
  
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
  
  if( change.number() == 16 ) opacity = map(change.value(), 0, 127, 0, 255);
  if( change.number() == 17 ) angleStep = map(change.value(), 0, 127, 0.01, 0.1);
  if( change.number() == 18 ) globalScale = map(change.value(), 0, 127, 0, 1);
  
}
