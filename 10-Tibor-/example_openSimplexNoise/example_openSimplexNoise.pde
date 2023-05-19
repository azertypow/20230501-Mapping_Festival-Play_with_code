// https://bleuje.com/tutorial3/

// Noise propagation

OpenSimplexNoise noise;

void setup() {
  size(500, 500);
  
  noise = new OpenSimplexNoise(12345);
}

void draw() {
  loadPixels();

  float mult = 0.01;
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float val = (float)noise.eval(mult * x , mult * y);
      color c = color(val * 255);
      pixels[y * width + x] = c;
    }
  }
  
  updatePixels();
}
