PGraphics offscreen;
void setup(){
  size(800,600);
  offscreen = createGraphics(width, height);
}

void draw(){
  PGraphics current = g;
  g = offscreen;
  g.beginDraw();
  background(255,0,0);
  rect(width/2, height/2, 50,50);
  g.endDraw();
  g = current;
  image(offscreen, 0,0);
}
