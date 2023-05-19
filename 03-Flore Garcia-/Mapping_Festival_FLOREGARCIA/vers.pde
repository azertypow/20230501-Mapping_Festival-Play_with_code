
class Vers extends Espece {

 
  float vx=(random(-2, 3));
  float vy=(random(-2, 3));
  int t=0;
  float taille;
  int tMax=int(random(1440, 7000));
  PImage vers;


  Vers(PImage ima) {
    //vers = (loadImage("vers.png"));
    x=random(width);
    y=random(height);
    vx=random(-2, 2);
    vy=random(-2, 2);
    taille = random(5, 100);
    vers=ima;
  }



  void display () {

    this.x+=this.vx;
    this.y+=this.vy;
    image(vers, x, y, taille, taille);
    if (this.x>width || this.x<0)this.vx*=-0.25;
    if (this.y>height || this.y<0)this.vy*=-0.25;
    if (t>tMax) {
      this.vx=random(-0.25, 0.25);
      this.vy=random(-0.25, 0.25);
      t=0;
      tMax=int(random(1440, 7000));
    }
    t++;
  }
}
