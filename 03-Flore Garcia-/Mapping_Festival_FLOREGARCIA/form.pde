class Form extends Espece2 {
  float x, y;
  float vx, vy;
  int t=0;
  int tMax=int(random(2480, 11000));
  float taille;

  Form () {
    this.life = random(60*80, 60*50);
    x=random(width);
    y=random(height);
    vx=random(-2, 2);
    vy=random(-2, 2);
    taille = random(5, 50);
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
      this.vx=random(-1, 0.5);
      this.vy=random(-0.5, 1);
      t=0;
      tMax=int(random(2480, 11000));
    }
    //stroke(2);
    noStroke();
    fill(190, 32, 100);
    rect(x, y, taille, taille);
  }
}
