class Square {

  PVector location;
  PVector velocity;
  PVector destination;

  SquareState state;

  color col = color(255);
  // char c;
  float wiggleMultiplier = 0.2f;

  Square(PVector location, SquareState state) {
    this.location = location;
    this.state = state;
    // c = (char) int(random(0, 127));
  }

  void display() {
    //color
    noFill();
    col = color(255, squareOpacity);
    stroke(col);

    pushMatrix();
    translate(location.x, location.y, location.z);
    float camMult = (float)cam.getDistance() / 5000;
    float pow38 = s1.getChannel(38) / 1000;
    float pow10 = s1.getChannel(10) / 1000;
    rect(0, 0, squareSize + s1.getPower() * pow10 * camMult, squareSize + s1.getPower() * pow38 * camMult);
    // circle(0, 0, radius);
    popMatrix();
  }

  void update() {

    float camMult = (float)cam.getDistance() / 1000;
    PVector dir = location.copy().sub(center).normalize().mult(velocityMultiplier * camMult * velocityBoost);
    location.add(dir);

    switch(state) {
    case NONE:
      // if (location.z > 0) {
      //     location.z--;
      // } else if (location.z < 0) {
      //     location.z++;
      // }
      break;
    case FRONT:
      if (velocityZ > 0) location.z += velocityZ * camMult;
      break;
    case BACK:
      if (velocityZ < 0) location.z += velocityZ * camMult;
      break;
    }

    float wiggle = s1.getPower() * wiggleMultiplier;

    if (s1.getPower() > 0.5f) {
      if (random(0, 1) == 0) {
        location.x += random( -wiggle, wiggle);
      } else {
        location.y += random( -wiggle, wiggle);
      }
    }
  }
  
  void distribute() {
    if (destination == null) {
      float maxRadius = 10;
      float radius = (float)Math.cosh(random(PI)) * maxRadius;
      float angle = random(TWO_PI);
      float x = cos(angle) * radius;
      float y = sin(angle) * radius;
      float z = random(-100, 100);
      destination =  new PVector(x, y, z);
    }

    float camMult = (float)cam.getDistance() / 1000;
    PVector dir = location.copy().sub(destination).normalize().mult(-1 * velocityMultiplier * camMult * 2 * velocityBoost);
    float dist = location.copy().sub(destination).mag();
    if (dist > 10) {
      location.add(dir);
    }
  }
}



class SquareSpawner {
  PVector location;
  PVector velocity;
  float angle;
  float size = 10;

  SquareSpawner(float angle) {
    this.angle = angle;
  }

  void update() {
    angle += radians(rotationSpeed);
    float camMult = (float)cam.getDistance() / 500;
    float x = cos(angle) * spawnerRadius + camMult;
    float y = sin(angle) * spawnerRadius + camMult;

    x = x % (width + size);
    location = new PVector(x, y, 0);
  }

  void spawn() {
    float x = modelX(location.x, location.y, 0);
    float y = modelY(location.x, location.y, 0);
    squares.add(new Square(new PVector(x, y, 0), stateToSpawn));
  }
}
