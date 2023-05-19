
ArrayList<SampleElement> listOfSampleElement         = new ArrayList<SampleElement>();
ArrayList<SampleElement> listOfSampleElementToRemove = new ArrayList<SampleElement>();

class SampleElement {

  float lifespan = 2500; // milliseconds
  float rectX, rectY, rectWidth, rectHeight;
  int rectIndex = 0;
  int timeOfCreation = millis();
  float vx=random(-1,1);
  float vy=random(-1,1);

  SampleElement(float rectX, float rectY, float rectWidth, float rectHeight) {
    this.rectX = rectX;
    this.rectY = rectY;
    this.rectWidth = rectWidth;
    this.rectHeight = rectHeight;
  }
 void draw() {
   rectX+=vx;
   rectY+=vy;
   
    noStroke();
    fill(255);
    rect(this.rectX, this.rectY, this.rectWidth, this.rectHeight);
    this.rectIndex++;
  }
}
