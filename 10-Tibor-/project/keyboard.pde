float transitionTime = 1.;
Ani[] anims;

void setTransitionTime(float _transitionTime) {
  transitionTime = _transitionTime;
  setOscValue("/label/transitionTime", transitionTime);  
}

void loadAnimation(int i) {
  var fn = String.format("data/%d.json", animIndex);
  println("Load data from " + fn);
  //cp5.loadProperties(fn);
  String propertyList = jsonFileToPropertyList(fn);
  //Ani.to(this, 1, propertyList, Ani.SINE_IN_OUT, "onEnd:transitionFinished");
  
  /*
  if (anims != null && anims[0].isPlaying()) {
    for (Ani anim : anims) 
    {   
      anim.end();
    }
  }*/
  
  anims = Ani.to(this, transitionTime, propertyList, Ani.SINE_IN_OUT, "onEnd:transitionFinished");
  println("There are anims " + anims.length);
  
}

void saveCurrentAnimation() {
  println("Save current data");
  var fn = String.format("data/%d.json", animIndex);
  println("Save data to " + fn);
  cp5.saveProperties(fn);
}

public String interpolateStates(String startStateStr, String endStateStr, float interpolationPercentage) {
    // Split the input strings into arrays of property-value strings
    String[] startProperties = startStateStr.split(",");
    String[] endProperties = endStateStr.split(",");

    Map<String, Float> startState = new HashMap<>();
    Map<String, Float> endState = new HashMap<>();

    // Parse the start and end state strings into maps
    for (String prop : startProperties) {
        String[] parts = prop.split(":");
        startState.put(parts[0], Float.parseFloat(parts[1]));
    }

    for (String prop : endProperties) {
        String[] parts = prop.split(":");
        endState.put(parts[0], Float.parseFloat(parts[1]));
    }

    // Calculate the target state
    Map<String, Float> targetState = new HashMap<>();
    for (String key : startState.keySet()) {
        float startValue = startState.get(key);
        float endValue = endState.get(key);

        // Calculate the target value which is interpolationPercentage between the start and end values
        float targetValue = startValue + interpolationPercentage * (endValue - startValue);

        // Put the target value in the target state
        targetState.put(key, targetValue);
    }

    // Construct the output string
    StringBuilder sb = new StringBuilder();
    for (Map.Entry<String, Float> entry : targetState.entrySet()) {
        sb.append(entry.getKey());
        sb.append(":");
        sb.append(String.format("%.20f", entry.getValue())); // Using 20 decimal places as in your example
        sb.append(",");
    }

    // Remove the trailing comma
    sb.deleteCharAt(sb.length() - 1);

    return sb.toString();
}

int leftAnimIndex = 0;
int rightAnimIndex = 0;

String leftPropertyList;
String rightPropertyList;

// Interpolate the values

int getAddress(OscMessage m) {
  return getAddress(m, 8);
}

int getAddress(OscMessage m, int cols) {
  String[] parts = m.addrPattern().split("/");
  int r = abs(Integer.parseInt(parts[3]) - cols);
  int c = Integer.parseInt(parts[4]) - 1;
  int animIndex = r * cols + c;
  return animIndex;
}

void end() {
  println("end");
}

void setOscValue(String k, int val) {
  OscMessage oscMessage = new OscMessage(k);
  oscMessage.add(String.valueOf(val));
  osc.send(oscMessage, remote);
}

void setOscValue(String k, float val) {
  OscMessage oscMessage = new OscMessage(k);
  oscMessage.add(String.format("%.02f", val));
  osc.send(oscMessage, remote);
}

void setAnimIndex(int _animIndex) {
  animIndex = _animIndex;
  setOscValue("/label/animIndex", animIndex);
}


void setupKeyboardOscListener() {
  osc.addListener(new OscEventListener() {

    public void oscEvent(OscMessage m) {
      println(m);
      ///2/toggle/1/8 f
      println(m.addrPattern());

      String addrPattern = m.addrPattern();
      if (addrPattern.startsWith("/transition/toggle/")) {
        int animIndex = getAddress(m);

        setAnimIndex(animIndex);
        loadAnimation(animIndex);
        
        println("loaded toggle");
      }
      else if (addrPattern.startsWith("/transition/transitionTime")) {
        float tt = m.get(0).floatValue();
        setTransitionTime(tt);
        
        
      }
      else if (addrPattern.startsWith("/transition/audioToggle")) {
        int val = getAddress(m, 4);
        
          OscMessage chuckMessage = new OscMessage("/audioToggle");
          chuckMessage.add(val);
          chuckOSC.send(chuckMessage, chuckRemote);
        // send chuck value
        
      }
       else if (addrPattern.startsWith("/button/reload")) {
        loadAnimation(animIndex);
      } else if (addrPattern.startsWith("/button/next")) {
        setAnimIndex( animIndex + 1 );
      } else if (addrPattern.startsWith("/button/previous")) {
        setAnimIndex( animIndex - 1 );
      } else if (addrPattern.startsWith("/button/save")) {
        saveCurrentAnimation();
      } else if (addrPattern.startsWith("/3/multitoggleLeft")) {
        leftAnimIndex = getAddress(m);
        setOscValue("/label/leftAnimIndex", leftAnimIndex);
        var fn = String.format("data/%d.json", leftAnimIndex);        
        leftPropertyList = jsonFileToPropertyList(fn);
        
      } else if (addrPattern.startsWith("/3/multitoggleRight")) {
        rightAnimIndex = getAddress(m);
        setOscValue("/label/rightAnimIndex", rightAnimIndex);
        var fn = String.format("data/%d.json", rightAnimIndex);        
        rightPropertyList = jsonFileToPropertyList(fn);
        
      } else if (addrPattern.startsWith("/3/faderMix")) {
        
        faderMix = m.get(0).floatValue();
        String res = interpolateStates(leftPropertyList, rightPropertyList, faderMix);
       
        //Ani.to(this, 1, res, Ani.SINE_IN_OUT, "onEnd:end");
        
        setPropertiesFromString( cp5, res);
        /*println("The current object is ");
        println(this);*/
        
        
        //println(propertyList);
      }

      /*
      if (m.checkAddrPattern("/2/toggle")) {
       println("check pass");
       }
       */
      /*Object[] o = m.arguments();
       println(o);
       */
      /*
      controlP5.Controller c = fromOscToController.get(m.addrPattern());
       if (c!=null) {
       Object[] o = m.arguments();
       try {
       Number v1 = (Number)o[0];
       // do the mapping
       float mappedValue = map(v1.floatValue(), 0., 1., c.getMin(), c.getMax());
       c.setValue(mappedValue);
       }
       catch(ClassCastException e) {
       println("type mismatch, expecting a number.", e);
       }
       }
       */
    }


    public void oscStatus(OscStatus s) {
    }
  }
  );
}



void keyPressed() {
  int numCode = keyCode - 48;
  if (numCode >= 0 && numCode < 10) {
    setAnimIndex(numCode);
    /*
    println("Load params");
     var fn = String.format("data/%d.json", animIndex);
     println(fn);
     */
  }

  if (key == 'c')
  {
    toggleCP5Visible();
  } else if (key == 'l') // l
  {
    loadAnimation(animIndex);
  } else if (key == 's')
  {
    saveCurrentAnimation();
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
