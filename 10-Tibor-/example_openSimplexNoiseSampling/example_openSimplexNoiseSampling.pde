// https://bleuje.com/tutorial3/

// Noise propagation

import controlP5.*;

OpenSimplexNoise noise;
ControlP5 cp5;

float mult = 0.01;
int seed = 12345;

int samples = 100;
float rad = 100;

void setup() {
  size(500, 500);

  noise = new OpenSimplexNoise(12345);

  cp5 = new ControlP5(this);

  cp5.addSlider("sliderMult", 0.001, 0.1, 0.01, 10, 10, 100, 14);
  cp5.addSlider("sliderSeed", 10000, 99999, 12345, 10, 14 + 10 + 8, 100, 14);
  cp5.addSlider("sliderSamples", 10, 10000, 100, 10, 14 + 10 * 2 + 8 * 2, 100, 14);
  cp5.addSlider("sliderRad", 1, width / 2, width / 4, 10, 14 + 10 * 3 + 8 * 3, 100, 14);
}

void draw() {
  loadPixels();

  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float val = (float)noise.eval(mult * x, mult * y);
      color c = color(val * 255);
      pixels[y * width + x] = c;
    }
  }

  updatePixels();

  drawSampling();
  drawPeriodicFunction();
}

void drawSampling() {
  stroke(0, 255, 0);

  for (int i = 0; i < samples; i++) {
    float x = cos(1.0 / samples * i * TAU) * rad + width * 0.5;
    float y = sin(1.0 / samples * i * TAU) * rad + height * 0.5;

    point(x, y);
  }
}

void drawPeriodicFunction() {
  stroke(0, 255, 0);
  
  for (int i = 0; i < width; i++) {
    point(i, getValue(i) * height);
    // draw line between them
    line(i, getValue(i) * height, i+1, getValue(i+1) * height);
  }
}

float getValue(int x) {
  float delta = 1.0 / width;
  float t = delta * x;
  float samplingX = cos(t * TAU) * rad + width * 0.5;
  float samplingY = sin(t * TAU) * rad + height * 0.5;
  float val = (float)noise.eval(mult * samplingX, mult * samplingY);
  float normalized = (val + 1) / 2;
  return normalized;
}

// Control P5
public void sliderMult(float value) {
  mult = value;
}

public void sliderSeed(int value) {
  noise = new OpenSimplexNoise(value);
}

public void sliderSamples(int value) {
  samples = value;
}

public void sliderRad(float value) {
  rad = value;
}
