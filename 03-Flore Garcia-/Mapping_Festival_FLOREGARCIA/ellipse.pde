class Ellipse extends Espece {
  
  float vx, vy;
  int t=0;
  float taille;

  int tMax=int(random(2480, 11000));


  Ellipse () {
    x=random(width);
    y=random(height);
    vx=random(-2, 2);
    vy=random(-2, 2);
    taille = random(30, 300);
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
      this.vx=random(-12, 13);
      this.vy=random(-13, 12);
      t=0;
      tMax=int(random(2480, 11000));
    }
    //stroke(2);
    noStroke();
    fill(192, 192, 192);
    ellipse(x, y, taille, taille);
  }
}
