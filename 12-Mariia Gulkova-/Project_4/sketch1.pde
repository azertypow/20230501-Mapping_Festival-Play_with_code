float a_3 = 0.0;
float s_3 = 0.0;

void draw1() {

  background(0, 15, 30);

  a_3 = a_3 + 0.02;
  s_3 = cos(a_3)*1;
  
  pushMatrix();
  
  translate(width/2, height/2);
  scale(globalScale * s_3);
  fill(#D12323, opacity);
  ellipse(0, 0, 11387, 11387);
  fill(#762E2E, opacity);
  ellipse(0, 0, 6507, 6507);
  fill(0, opacity);
  ellipse(0, 0, 407, 407);
  popMatrix();
  
}
