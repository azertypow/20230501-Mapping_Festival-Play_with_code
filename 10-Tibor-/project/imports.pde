import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import controlP5.*;
import java.time.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.*;

import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress remote;

OscP5 chuckOSC;
NetAddress chuckRemote;

Easing[] easings = { Ani.LINEAR, Ani.QUAD_IN, Ani.QUAD_OUT, Ani.QUAD_IN_OUT, Ani.CUBIC_IN, Ani.CUBIC_IN_OUT, Ani.CUBIC_OUT, Ani.QUART_IN, Ani.QUART_OUT, Ani.QUART_IN_OUT, Ani.QUINT_IN, Ani.QUINT_OUT, Ani.QUINT_IN_OUT, Ani.SINE_IN, Ani.SINE_OUT, Ani.SINE_IN_OUT, Ani.CIRC_IN, Ani.CIRC_OUT, Ani.CIRC_IN_OUT, Ani.EXPO_IN, Ani.EXPO_OUT, Ani.EXPO_IN_OUT, Ani.BACK_IN, Ani.BACK_OUT, Ani.BACK_IN_OUT, Ani.BOUNCE_IN, Ani.BOUNCE_OUT, Ani.BOUNCE_IN_OUT, Ani.ELASTIC_IN, Ani.ELASTIC_OUT, Ani.ELASTIC_IN_OUT};
String[] easingsVariableNames = {"Ani.LINEAR", "Ani.QUAD_IN", "Ani.QUAD_OUT", "Ani.QUAD_IN_OUT", "Ani.CUBIC_IN", "Ani.CUBIC_IN_OUT", "Ani.CUBIC_OUT", "Ani.QUART_IN", "Ani.QUART_OUT", "Ani.QUART_IN_OUT", "Ani.QUINT_IN", "Ani.QUINT_OUT", "Ani.QUINT_IN_OUT", "Ani.SINE_IN", "Ani.SINE_OUT", "Ani.SINE_IN_OUT", "Ani.CIRC_IN", "Ani.CIRC_OUT", "Ani.CIRC_IN_OUT", "Ani.EXPO_IN", "Ani.EXPO_OUT", "Ani.EXPO_IN_OUT", "Ani.BACK_IN", "Ani.BACK_OUT", "Ani.BACK_IN_OUT", "Ani.BOUNCE_IN", "Ani.BOUNCE_OUT", "Ani.BOUNCE_IN_OUT", "Ani.ELASTIC_IN", "Ani.ELASTIC_OUT", "Ani.ELASTIC_IN_OUT"};
String code = "";

DropdownList d1;
DropdownList d2;

// Recording
String recordingName;
boolean recording = false;
boolean pRecording = false;
int startFrame = 0;
Textlabel fpsLabel;
Textlabel animLabel;
Textlabel stepLabel;
int maxAnimIndex = 45;

// Video export does not work with resolutions that widths are not divisible by 2
/*
  360 degrees
 Diameter: 8 m
 Resolution 180:  4500 x 1080 – 4.16
 Resolution 360: 11000 x 2000 – 5.5
 
 Resolution thing 7680 x 1440 – 5.3
 */

// vid.avi -s 800x800 -sws_flags neighbor -sws_dither none -vcodec rawvideo vid2.avi

final int instagramW = 1080;
final int instagramH = 1920;

final int circularScreenW = 15000;
final int circularScreenH = 2000;

void sequence() {
  println("Load sequence");
  JSONObject performance = loadJSONObject("performance.json");
  JSONArray stateSequence = performance.getJSONArray("sequence");
  JSONArray transitions = performance.getJSONArray("transitions");
  ArrayList<String> states = new ArrayList<String>();
  for (int i = 0; i < maxAnimIndex; i++) {
    var fn = String.format("data/%d.json", i);
    String pl = jsonFileToPropertyList(fn);
    states.add(pl);
  }

  // Get a member from a JSONArray
  //JSONObject s = stateSequence.getJSONObject(0);
  //println(s.getString("duration"));
  // get an int

  seq = new AniSequence(this);
  seq.beginSequence();
  seq.add(Ani.to(this, 0.0001, states.get(1)));
  for (int i = 0; i < transitions.size(); i++) {
    JSONObject t = transitions.getJSONObject(i);
    println(states.get(t.getInt("to")) + ",animIndex:" + t.getInt("to"));
    var animations = Ani.to(this, 
          t.getFloat("duration"), 
          t.getFloat("delay"),
          states.get(t.getInt("to")) + ",animIndex:" + t.getInt("to"), 
          easings[
            Arrays.asList(easingsVariableNames).indexOf(t.getString("fade"))]
          );
          
    seq.add(animations);
    
  }
  seq.endSequence();
  //seq.start();
}

void toggleCP5Visible() {
  cp5Visible = !cp5Visible;
  if (cp5Visible) {
    cp5.show();
  }
  if (!cp5Visible) {
    cp5.hide();
  }
}

void transitionFinished(Ani theAni) {
  animLabel.setText("anim " + animIndex + "/" + maxAnimIndex);

  
  /*
  var fn = String.format("data/%d.json", animIndex);
  int now = millis();
  if (now - lastLoad > 1000) {
    println("Load data from " + fn);
    lastLoad = millis();
    cp5.loadProperties(fn);
  }*/
}

HashMap<String, controlP5.Controller> fromOscToController;
HashMap<controlP5.Controller, String> fromControllerToRemote;

void initHook() {

  fromOscToController = new HashMap();
  fromControllerToRemote = new HashMap();

  osc.addListener(new OscEventListener() {
    public void oscEvent(OscMessage m) {
      chuckOSC.send(m, chuckRemote);

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
    }
    public void oscStatus(OscStatus s) {
    }
  }
  );

  cp5.addListener(new ControlListener() {
    public void controlEvent(ControlEvent theEvent) {
      String addr = fromControllerToRemote.get(theEvent.getController());
      if (addr!=null) {
        OscMessage m = new OscMessage(addr);
        controlP5.Controller c = theEvent.getController();
        float rawValue = c.getValue();
        float mappedValue = map(rawValue, c.getMin(), c.getMax(), 0., 1.);
        m.add(mappedValue);
        osc.send(m, remote);
        
        OscMessage chuckMessage = new OscMessage("/" + c.getName());
        chuckMessage.add(mappedValue);
        
        chuckOSC.send(chuckMessage, chuckRemote);
      }
    }
  }
  );
}

void hook(String theAddr, controlP5.Controller theController) {
  fromOscToController.put(theAddr, theController);
}

void hook(controlP5.Controller theController, String theAddr) {
  fromControllerToRemote.put(theController, theAddr);
}

void setupCP5() {
  cp5 = new ControlP5(this);

  osc = new OscP5(this, oscPort);
  chuckOSC = new OscP5(this, 12001); 
  
  remote = new NetAddress(oscRemoteAddress, oscPort);
  chuckRemote = new NetAddress("127.0.0.1", 6449);
  
  initHook();
  
  int pl = 10; // padding left
  int pt = 10; // padding top
  int w = 100;
  int h = 14;
  int gap = 4;


  if (greybox) {
    pl = width / 2;
    h = 48;
  }

  ArrayList<controlP5.Controller> sliders = new ArrayList<controlP5.Controller>();
  ArrayList<controlP5.Controller> dropdowns = new ArrayList<controlP5.Controller>();

  controllers = new ArrayList<controlP5.Controller>();

  Slider seedSlider = cp5.addSlider("sliderSeed", 10000, 99999);
  seedSlider.setDefaultValue(12345);
  //seedSlider.listen(true);
  controllers.add(seedSlider);
  sliders.add(seedSlider);

  Slider scaleSlider = cp5.addSlider("scl", 0.001, 0.099);
  scaleSlider.setDefaultValue(0.018);
  scaleSlider.listen(true);
  controllers.add(scaleSlider);
  sliders.add(scaleSlider);
    

  
  Slider radSlider = cp5.addSlider("rad", 0.01, 5);
  radSlider.setDefaultValue(1.3);
  radSlider.listen(true);
  controllers.add(radSlider);
  sliders.add(radSlider);

  Slider off1Slider = cp5.addSlider("off1", 0., 1.);
  off1Slider.setDefaultValue(1.);
  off1Slider.listen(true);
  controllers.add(off1Slider);
  sliders.add(off1Slider);

  Slider off2Slider = cp5.addSlider("off2", 0., 1.);
  off2Slider.setDefaultValue(0.);
  off2Slider.listen(true);
  controllers.add(off2Slider);
  sliders.add(off2Slider);

  Slider off3slider = cp5.addSlider("off3", 0., 1.);
  off3slider.setDefaultValue(0.);
  off3slider.listen(true);
  controllers.add(off3slider);
  sliders.add(off3slider);


  Slider periodicFuncScaleSlider = cp5.addSlider("periodicFuncScale", 0.01, 10);
  periodicFuncScaleSlider.setDefaultValue(0.5);
  periodicFuncScaleSlider.listen(true);
  controllers.add(periodicFuncScaleSlider);
  sliders.add(periodicFuncScaleSlider);

  Slider dotSizePctSlider = cp5.addSlider("dotSizePct", 0, 0.04);
  dotSizePctSlider.setDefaultValue(0.1);
  dotSizePctSlider.listen(true);
  controllers.add(dotSizePctSlider);
  sliders.add(dotSizePctSlider);

  //Slider colsSlider = cp5.addSlider("cols", 1, 300 * 7.1);
  Slider colsSlider = cp5.addSlider("cols", 1, 50);
  colsSlider.listen(true);
  colsSlider.setDefaultValue(5);
  //colsSlider.listen(true);
  controllers.add(colsSlider);
  sliders.add(colsSlider);

  Slider rowsSlider = cp5.addSlider("rows", 1, 50);
  rowsSlider.listen(true);
  rowsSlider.setDefaultValue(5);
  controllers.add(rowsSlider);
  sliders.add(rowsSlider);

  Slider offMultXSlider = cp5.addSlider("offMultX", 0, 1000);
  offMultXSlider.listen(true);
  offMultXSlider.setDefaultValue(20);
  controllers.add(offMultXSlider);
  sliders.add(offMultXSlider);

  Slider offMultYSlider = cp5.addSlider("offMultY", 0, 1000);
  offMultYSlider.setDefaultValue(20);
  offMultYSlider.listen(true);
  controllers.add(offMultYSlider);
  sliders.add(offMultYSlider);


  Slider bgFillSlider = cp5.addSlider("bgFill", 0, 255);
  bgFillSlider.setDefaultValue(255);
  bgFillSlider.listen(true);
  controllers.add(bgFillSlider);
  sliders.add(bgFillSlider);

  Slider aFillMixSlider = cp5.addSlider("aFillMix", 0, 1);
  aFillMixSlider.setDefaultValue(0.5);
  aFillMixSlider.listen(true);
  controllers.add(aFillMixSlider);
  sliders.add(aFillMixSlider);

  Slider numFramesSlider = cp5.addSlider("numFrames", 10, 1000);
  numFramesSlider.setDefaultValue(255);
  numFramesSlider.listen(true);
  controllers.add(numFramesSlider);
  sliders.add(numFramesSlider);

  Slider mxSlider = cp5.addSlider("mx", 0.01, 1.0);
  mxSlider.setDefaultValue(0.5);
  mxSlider.listen(true);
  controllers.add(mxSlider);
  sliders.add(mxSlider);

  Slider mySlider = cp5.addSlider("my", 0.01, 1.0);
  mySlider.setDefaultValue(0.5);
  mySlider.listen(true);
  controllers.add(mySlider);
  sliders.add(mySlider);

  Slider offsetScaleSlider = cp5.addSlider("offScl", 0., 1.);
  offsetScaleSlider.listen(true);
  offsetScaleSlider.setDefaultValue(1);
  controllers.add(offsetScaleSlider);
  sliders.add(offsetScaleSlider);
  
  




  Slider ani1StartSlider = cp5.addSlider("ani1Start", 0., 1.);
  controllers.add(ani1StartSlider);
  sliders.add(ani1StartSlider);

  Slider ani1DurSlider = cp5.addSlider("ani1Dur", 0., 1.);
  ani1DurSlider.setDefaultValue(.2);
  controllers.add(ani1DurSlider);
  sliders.add(ani1DurSlider);

  d1 = cp5.addDropdownList("ani1trans")
    .setPosition(100, 100)
    .setItemHeight(h)
    .setBarHeight(h)
    .setDefaultValue(1.)
    .setOpen(false);

  for (int i=0; i<easingsVariableNames.length; i++) {
    d1.addItem(easingsVariableNames[i], i);
  }

  d2 = cp5.addDropdownList("ani2trans")
    .setPosition(100, 100)
    .setItemHeight(h)
    .setBarHeight(h)
    .setValue(2)
    .setOpen(false)
    ;

  for (int i=0; i<easingsVariableNames.length; i++) {
    d2.addItem(easingsVariableNames[i], i);
  }

  d2.setValue(2.);

  Slider ani2StartSlider = cp5.addSlider("ani2Start", 0., 1.);
  ani2StartSlider.setDefaultValue(.5);
  controllers.add(ani2StartSlider);
  sliders.add(ani2StartSlider);

  Slider ani2DurSlider = cp5.addSlider("ani2Dur", 0., 1.);
  ani2DurSlider.setDefaultValue(.2);
  controllers.add(ani2DurSlider);
  sliders.add(ani2DurSlider);

  var loopAniButton = cp5.addButton("toggleLoop");
  controllers.add(loopAniButton);
  sliders.add(loopAniButton);

  var sameParamsButton = cp5.addButton("saveParamsDefault");
  controllers.add(sameParamsButton);
  sliders.add(sameParamsButton);

  var loadParamsButton = cp5.addButton("loadParams");
  controllers.add(loadParamsButton);
  sliders.add(loadParamsButton);

  var recordSketchButton = cp5.addButton("recordSketch");
  controllers.add(recordSketchButton);
  sliders.add(recordSketchButton);

  controllers.add(d1);
  controllers.add(d2);

  //sliders.add(d1);


  fpsLabel = cp5.addTextlabel("label")
    .setText("60.23FPS")
    .setPosition(width - 50, 10)
    .setColorValue(0xffffffff)
    .setFont(createFont("Arial", 10))
    ;
    
   animLabel = cp5.addTextlabel("Animlabel")
    .setText("anim " + animIndex + "/" + maxAnimIndex)
    .setPosition(width - 50, 30)
    .setColorValue(0xffffffff)
    .setFont(createFont("Arial", 10))
    ;
    
   stepLabel = cp5.addTextlabel("stepLabel")
    .setText("step ")
    .setPosition(width - 50, 50)
    .setColorValue(0xffffffff)
    .setFont(createFont("Arial", 10))
    ;

  /*
  var debugRadio = cp5.addRadioButton("radioDebug");
   debugRadio.addItem("debug", 1);
   debugRadio.setPosition(pl, pt + (h + gap) * controllers.size());
   debugRadio.setSize(w, h);
   */
  /*
  var resolutionRadio = cp5.addRadioButton("resolutionPreset");
   resolutionRadio.addItem("IG vs 360", 1);
   resolutionRadio.setPosition(pl, pt + (h + gap) * (controllers.size() + 1));
   resolutionRadio.setSize(w, h);
   */

  for (int i = 0; i < sliders.size(); i++) {
    controlP5.Controller c = sliders.get(i);
    //c.listen(true);
    
    
    hook(c, "/1/fader/" + (i + 1));
    hook("/1/fader/" + (i + 1), c);
  }
  
  
  

  for (int i = 0; i < controllers.size(); i++) {
    controlP5.Controller c = controllers.get(i);
    c.setSize(w, h);
    c.setPosition(pl, pt + h * i + gap * i);
  }

  d1.setHeight(h*10);
  d2.setHeight(h*10);
}


// https://github.com/sojamo/controlp5/issues/57



void controlEvent(ControlEvent theEvent) {
  // When a control event happens it should update osc










  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    //println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } else if (theEvent.isController()) {
    //println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
    //ani1trans
    //theEvent.getController().getValue()
  }
}


AniSequence loopSequence;

void toggleLoop() {
  println("Toggle loop");
  aniLooping = !aniLooping;
  println("Value of aniLooping");
  println(aniLooping);

  if (!aniLooping) {
    //loopSequence.pause();
    //loopSequence = null;
  }
  /*
  if (aniLooping) {
   loopSequence = new AniSequence(this);
   loopSequence.beginSequence();
   
   loopSequence.beginStep();
   loopSequence.add(Ani.to(this, ani1start, 1.0 * numFrames * ani1dur, sequences.get(0), Ani.SINE_IN_OUT, "onEnd:transitionFinished"));
   loopSequence.add(Ani.to(this, ani2start, 1.0 * numFrames * ani2dur, sequences.get(1), Ani.SINE_IN_OUT, "onEnd:transitionFinished"));
   loopSequence.endStep();
   loopSequence.endSequence();
   loopSequence.start();
   } else if (!aniLooping) {
   loopSequence.stop();
   loopSequence = null;
   }*/
}
