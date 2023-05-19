class Serpentin2 extends Espece {


  float[] xArray = new float[26];
  float[] yArray = new float[26];
  float segLength = 20;

  float vx, vy;
  float taille;
  float couleur;
  color col;
  color col2;

  Serpentin2() {
    strokeWeight(2);
    stroke(5, 100);
    x=random(width);
    y=random(height);
    vx=random(-5, 5);
    vy=random(-5, 5);
    taille = random(2, 7);
    col = color(random(30), random(255), random(255));
    col2 = color(random(255), random(70), random(255));

    if (taille < 4) {
      fill(col);
    } else if (taille > 4) {
      fill(col2);
    }
  }

  void display() {
    x+=vx;
    y+=vy;
    if (x<0 || x>width)vx*=-1;
    if (y<0 || y>height)vy*=-1;

    dragSegment(0, x, y);

    for (int i=0; i<xArray.length-1; i++) {
      dragSegment(i+1, xArray[i], yArray[i]);
      //ellipse(random(width), random(height), random(100), random(100));
      layer.fill(10, 10, 10);
    }
  }
  void dragSegment(int i, float xin, float yin) {
    float dx = xin - xArray[i];
    float dy = yin - yArray[i];
    float angle = atan2(dy, dx);
    xArray[i] = xin - cos(angle) * segLength;
    yArray[i] = yin - sin(angle) * segLength;
    segment(this.xArray[i], this.yArray[i], angle);
  }


  void segment(float x, float y, float a) {
    //segment(color f); //fill(255,0,255);
    layer.pushMatrix();
    layer.translate(x, y);
    layer.rotate(a);
    layer.strokeWeight(taille);
    layer.stroke(random(255), random(30), random(255)); // couleur stroke, étrange que random pas dispo sur les 3 valeurs
    layer.line(50, 70, segLength, 70);
    layer.popMatrix();
  }
}
