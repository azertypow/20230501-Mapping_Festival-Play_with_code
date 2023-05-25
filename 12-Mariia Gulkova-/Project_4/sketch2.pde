/////////////////////////////////////////////
//sketch 2
float angle;
float a = 0.0;
float s = 0.0;

color[] colArray2 = {
  color(103, 19, 18),
  color(151, 14, 14),
  color(193, 23, 23),
  color(147, 25, 25),
  color(122, 19, 19),
  color(203, 37, 37),
};

void setup2() {
  frameRate(30);
}

void draw2() {
  background(0, 15, 30);
  stroke(0, 15, 30);
  strokeWeight(1);

  pushMatrix();
  a = a + 0.01;
  //s = cos(a)*2;

  translate(width/2, height/2);
  scale(5);
  for (int i=0; i<100; i++) {
    fill( colArray2[int(random(5))], opacity);
    //fill(255, 0, 0);
    scale(0.98);
    rotate(radians(angle));
    rect(0, 0, 6000, 6000);
  }
  popMatrix();

  angle+=angleStep;
}
