
class Tetard extends Espece {
  PImage tetards;
 
  float vx, vy;
  int t=0;
  int tMax=int(random(20, 200));

  Tetard () {
    tetards = (loadImage("tetard.png"));
    x=random(width);
    y=random(height);
    vx=random(-2, 2);
    vy=random(-2, 2);
  }



  void display() {
    x+=vx;
    y+=vy;
    if (x<0 || x>width)vx*=-1;
    if (y<0 || y>height)vy*=-1;

    this.x+=this.vx;
    this.y+=this.vy;
    if (this.x>width || this.x<0)this.vx*=-0.5;
    if (this.y>height || this.y<0)this.vy*=-0.5;
    if (t>tMax) {
      this.vx=random(-0.5, 0.5);
      this.vy=random(-0.5, 0.5);
      t=0;
      tMax=int(random(50, 100));
    }
    image(tetards, x, y, 180, 180);
  }
}
