class Espece {

  float life=random(60*10, 60*30);
  boolean dead = false;
  float x, y;
 

  Espece() {
  }

  void run() {
    life-=1;
  }

  void display() {
  }
  
  void checkCollision (Espece inspectEspece) {
  if(dist(this.x, this.y, inspectEspece.x,inspectEspece.y)<100)
  {
  this.dead = true;
  }
  
  }
}
