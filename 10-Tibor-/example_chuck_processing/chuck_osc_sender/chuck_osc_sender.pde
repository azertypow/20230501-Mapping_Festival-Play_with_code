import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  size(400, 400);
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 6449);
}

void draw() {
  background(255);

  float frequency = map(mouseX, 0, width, 100, 1000);
  float amplitude = map(mouseY, 0, height, 1, 0);

  sendOscMessage("/frequency", frequency);
  sendOscMessage("/amplitude", amplitude);
}

void sendOscMessage(String address, float value) {
  OscMessage msg = new OscMessage(address);
  msg.add(value);
  oscP5.send(msg, myRemoteLocation);
}
