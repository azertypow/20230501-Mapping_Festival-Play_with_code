class Troisangles extends Espece3 {

  float x, y;

  float vx, vy;
  int t=0;

  float taille;
  float taille2;

  int tMax=int(random(2480, 11000));

  Troisangles() {
    x=random(width);
    y=random(height);
    this.vx=random(-0.5, 0.5);
    this.vy=random(-0.5, 0.5);
  }

  void display() {
    x+=vx;
    y+=vy;

    this.x+=this.vx;
    this.y+=this.vy;
    if (this.x>width || this.x<0)this.vx*=-0.5;
    if (this.y>height || this.y<0)this.vy*=-0.5;
    if (t>tMax) {
      this.vx=random(-0.5, 0.5);
      this.vy=random(-0.5, 0.5);
      t=0;
      tMax=int(random(2480, 11000));
    }
    //stroke(2);
    noStroke();

    fill(50, 100, 180);
    triangle(0, 0, x, y+30, x, y+45);
  }
}
