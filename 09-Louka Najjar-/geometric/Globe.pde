class Globe {
  PShape globe;
  ArrayList<PVector> initialPos = new ArrayList<PVector>();
  ArrayList<PVector> shape = new ArrayList<PVector>();
  int sides = 16;
  float radius = 50;
  float angle = 360 / sides;

  Globe() {
    globe = createShape();
    globe.beginShape();
    for (int i = 0; i < sides; i++) {
      for (int j = 0; j < sides; j++) {
        float x = radius * cos(radians(angle * i)) * sin(radians(angle * j));
        float y = radius * sin(radians(angle * i)) * sin(radians(angle * j));
        float z = radius * cos(radians(angle * j));
        globe.vertex(x, y, z);
        initialPos.add(new PVector(x, y, z));
      }
    }
    globe.endShape();
    for (int i = 0; i < globe.getVertexCount(); i++) {
      PVector v = globe.getVertex(i);
      initialPos.add(v);
      shape.add(v);
    }
  }

  void display() {
    pushMatrix();
    translate(0, 0, 0);
    rotateX(radians(180));
    rotateZ(frameCount);
    PShape newGlobe = createShape();
    newGlobe.beginShape();
    newGlobe.noFill();
    newGlobe.stroke(255);

    for (int i = 0; i < globe.getVertexCount(); i++) {
      PVector v = globe.getVertex(i);


      if (s1.getPower() >  1) {
        float deformValue = s1.getPower() / 10;
        deformValue = constrain(deformValue, 0, 1);
        v.x += random( -deformValue, deformValue);
        v.y += random( -deformValue, deformValue);
        v.z += random( -deformValue, deformValue);
      }


      //PVector initDir = initialPos.get(i).copy().sub(v).normalize().mult(100);
      //float dist = initialPos.get(i).copy().sub(v).mag();
      //if (dist > .5) {
      //  v.add(initDir);
      //}


      PVector pos = new PVector(0, 0, 0);
      float mult =  spawnerRadius / 3;
      PVector dir = pos.copy().sub(v).normalize().mult(mult);
      v.add(dir);
      newGlobe.vertex(v.x, v.y, v.z);
    }
    newGlobe.endShape();
    fill(0, 0);

    shape(newGlobe);
    globe = newGlobe;

    popMatrix();
  }
}
