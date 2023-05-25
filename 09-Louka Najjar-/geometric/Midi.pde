import themidibus.*;
MidiBus myBus;

void midiSetup() {
  MidiBus.list(); // List all devices
  myBus = new MidiBus(this, 2, 0);
}

void noteOn(Note note) {
  //Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:" + note.channel());
  println("Pitch:" + note.pitch());
  println("Velocity:" + note.velocity());

  if (note.pitch() == 43) {
    start = !start;
  }


  if (note.pitch() == 40) {
    if (!isMoving) {
      if (camState != CamState.DEZOOM) {
        camState = CamState.DEZOOM;
      } else {
        camState = CamState.INIT;
      }
    }
  }

  if (note.pitch() == 36) {
    if (state != State.HOLE) state = State.HOLE;
  }

  if (note.pitch() == 37) {
    if (state != State.TURN) state = State.TURN;
  }

  if (note.pitch() == 39) {
    velocityBoost = 2;
  }
}

void noteOff(Note note) {
  //Receive a noteOff
  println();
  println("Note Off:");
  println("--------");
  println("Channel:" + note.channel());
  println("Pitch:" + note.pitch());
  println("Velocity:" + note.velocity());

  if (note.pitch() == 39) {
    velocityBoost = 1;
  }
}

void controllerChange(ControlChange change) {
  //Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:" + change.channel());
  println("Number:" + change.number());
  println("Value:" + change.value());

  if (change.number() == 71) {
    velocityZ = map(change.value(), 0, 127, -10, 10);
    if (velocityZ == 0) {
      stateToSpawn = SquareState.NONE;
    } else if (velocityZ > 0) {
      stateToSpawn = SquareState.FRONT;
    } else if (velocityZ < 0) {
      stateToSpawn = SquareState.BACK;
    }
  }

  if (change.number() == 70) {
      rotationMultiplier = map(change.value(), 0, 127, 0, 1);
  }

  if (change.number() == 75) {
    //rotationSpeed = map(change.value(), 0, 127, 1, 10);
    rotationSpeed = map(change.value(), 0, 127, 0.1f, 3f);
  }

  if (change.number() == 72) {
    velocityMultiplier = map(change.value(), 0, 127, 1, 10);
  }

  if (change.number() == 77) {
      squareOpacity = map(change.value(), 0, 127, 255, 0);
  }
}
