class Microbe extends Espece {
  float x;
  float y;
  float vx=random(-0.5, 0.5);
  float vy=random(-0.5, 0.5);
  float taille;
  color col;

  int t=0;
  int tMax=int(random(1440, 7000));
  PImage papillon2;

  Microbe( PImage ima) {
    x=random(width);
    y=random(height);
    vx=random(-2, 2);
    vy=random(-2, 2);
    col = color(random(255), 245, random(230));
    taille = random(10, 125);
    papillon2=ima;
  }
  void display() {
    this.x+=this.vx;
    this.y+=this.vy;
    noStroke();
    fill(col);
    rectMode(CENTER);
    noTint();
    //image(papillon2, x, y, 100, 100);
    image(papillon2, x, y, taille, taille);

    //ellipse(x, y, random(50), random(50));
    //triangle(random(x), random(y), random(x,width), random(y,height), 900, 1000);
    if (this.x>width || this.x<0)this.vx*=-0.5;
    if (this.y>height || this.y<0)this.vy*=-0.5;
    if (t>tMax) {
      this.vx=random(-0.5, 0.5);
      this.vy=random(-0.5, 0.5);
      t=0;
      tMax=int(random(1440, 7000));
    }
    t++;
  }
}
