void keyPressed() {
  int numCode = keyCode - 48;
  if (numCode >= 0 && numCode < 10) {
    animIndex = numCode;
    // Load the json file if exists
    println("Load params");
    var fn = String.format("data/%d.json", animIndex);
    println(fn);
    //cp5.loadProperties(fn);
  }

  if (key == 'c')
  {
    toggleCP5Visible();
  } else if (key == 'l') // l
  {
    var fn = String.format("data/%d.json", animIndex);
    println("Load data from " + fn);
    //cp5.loadProperties(fn);
    String propertyList = jsonFileToPropertyList(fn);

    Ani.to(this, 1, propertyList, Ani.SINE_IN_OUT, "onEnd:transitionFinished");
  } else if (key == 's')
  {
    println("Save current data");
    var fn = String.format("data/%d.json", animIndex);
    println("Save data to " + fn);
    cp5.saveProperties(fn);
  } else if (key == 'd')
  {
    periodicFuncDebug = !periodicFuncDebug;
  } else if  (key == ' ')
  {
    println("Space pressed");
    if (seq.isPlaying())
    {
      Ani.setDefaultTimeMode(Ani.FRAMES);

      println("Pause sequence");
      seq.pause();
    } else {
      Ani.setDefaultTimeMode(Ani.SECONDS);

      println("Resume sequence");
      seq.resume();
    }
  } else if (key == 'b') {
    // load in everything again
    sequence();
    Ani.setDefaultTimeMode(Ani.SECONDS);
    seq.start();
  }

  if (key == CODED)
  {
    if (keyCode == LEFT) {
      animIndex = (maxAnimIndex + animIndex - 1) % maxAnimIndex;
    } else if (keyCode == RIGHT) {
      animIndex = (animIndex + 1) % maxAnimIndex;
    }
  }


  animLabel.setText("anim " + animIndex + "/" + maxAnimIndex);
}
