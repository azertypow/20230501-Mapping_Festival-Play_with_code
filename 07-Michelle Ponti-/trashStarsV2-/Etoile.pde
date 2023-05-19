class Star {  // Modifier par Nico 20230502
  PVector pos;
  PImage ima;
  
  Star(PVector pos,PImage ima){ // Modifier par Nico 20230502
    this.pos=pos;
    this.ima=ima;
  }

  void draw(){
    pushMatrix();
    translate(pos.x,pos.y,pos.z);
    tint(255, 255,255, random(255));
    drawParticle(15,ima);
    noTint();
    popMatrix();
  }

}
