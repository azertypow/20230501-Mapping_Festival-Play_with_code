class Bleuet extends Espece {
  float x;
  float y;
  float vx=random(-2, 3);
  float vy=random(-3, 2);
  float taille;
  //color col;
  int t=0;
  //int tMax=int(random(50, 300));
  int tMax=int(random(1440, 7000));
  PImage blue;

  Bleuet (PImage ima) {

    x=random(width);
    y=random(height);
    vx=random(-2, 2);
    vy=random(-2, 2);
    //col = color(random(255), 245, random(230));
    taille = random(60, 660);
    blue=ima;
  }
  void display() {
    this.x+=this.vx;
    this.y+=this.vy;
    //noStroke();
    //fill(col);
    //rectMode(CENTER);
    // noTint();
    image(blue, x, y, taille, taille);

    //ellipse(x, y, random(50), random(50));
    if (this.x>width || this.x<0)this.vx*=-0.5;
    if (this.y>height || this.y<0)this.vy*=-0.5;
    if (t>tMax) {
      this.vx=random(-0.5, 0.5);
      this.vy=random(-0.5, 0.5);
      t=0;
      //tMax=int(random(50, 100));
      tMax=int (random(1440, 7000));
    }
    t++;
  }
}
