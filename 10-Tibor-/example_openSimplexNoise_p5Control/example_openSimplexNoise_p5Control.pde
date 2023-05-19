// https://bleuje.com/tutorial3/

// Noise propagation

import controlP5.*;

OpenSimplexNoise noise;
ControlP5 cp5;

float mult = 0.01;
int seed = 12345;

void setup() {
  size(500, 500);

  noise = new OpenSimplexNoise(12345);

  cp5 = new ControlP5(this);

  cp5.addSlider("sliderMult", 0.001, 0.1, 0.01, 10, 10, 100, 14);
  cp5.addSlider("sliderSeed", 10000, 99999, 12345, 10, 14 + 10 + 8, 100, 14);
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
}

public void sliderMult(float value) {
  mult = value;
}

public void sliderSeed(int value) {
  noise = new OpenSimplexNoise(value);
}
