float a_18 = 0.0;
float s_18 = 0.0;

color[] colArray = {
  color(25, 165, 190),
  color(95, 170, 200),
  color(255, 248, 185),
  color(255, 244, 148),
  color(255, 237, 72),
  color(220, 240, 250),
};

void setup8() {
  size(1080, 600);
  background(0, 15, 30);
  frameRate(25);
}
void draw8() {

  a_18 = a_18 + 0.01;
  s_18 = cos(a_18)*1;
  
  pushMatrix();
  int gridSize = 40;
  translate(width/2, height/2);
  scale(globalScale * s_18);
  for (int x = gridSize; x <= width - gridSize; x += gridSize) {
    for (int y = gridSize; y <= height - gridSize; y += gridSize) {
      noStroke();

      fill(colArray[int(random(5))], opacity);
      rect(x-1, y-1, 3, 3);
      stroke(0);
      rotate(frameCount / 50.0);
      line(x, y, width/2, height/2);
    }
  }
  popMatrix();
  
}
