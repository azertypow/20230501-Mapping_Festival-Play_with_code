/////////////////////////////////////////////
//sketch 4
void setup5(){
  
}

void draw5() {
  sl.runAnalyse();
  pushMatrix();
  //image(land,0,0);


  for (int i=0; i<300; i++) {
  
    int x = int(random(land.width));
    int y = int(random(land.height));
    color col = land.get(x, y);
    //color col = land.get(x - width/2+land.width/2, y);

    col = color(red(col), green(col)-0, blue(col));

    //noStroke();
    //fill(col);
    //rect(x,y,20,20);

    noStroke();
    stroke(col, opacity);
    strokeWeight(random(1, 4));
    
    // offset point to center on the screen
    x += width/2 - land.width/2;
    y += height/2 - land.height/2;
    
    line(x, y, x+random(-20, 20), y+random(-20, 20));
  }
  color col2 = land.get(mouseX, mouseY);
  println("r:"+red(col2)+" g:"+green(col2)+" b:"+blue(col2));
  popMatrix();
}
