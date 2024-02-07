int rate = 70;
void setup(){
  background(238,28,37);
  surface.setResizable(true);
  surface.setSize(30*rate, 20*rate);
}
//https://en.wikipedia.org/wiki/Flag_of_China
void draw(){
  fill(255, 255, 0);
  smooth();
  noStroke();
  
  pushMatrix();
  translate(5*rate, 5*rate);
  scale(6*rate, 6*rate);
  star();
  popMatrix();

  pushMatrix();
  translate(10*rate, 2*rate);
  rotate(2*PI/5/3);
  scale(2*rate, 2*rate);
  star();
  popMatrix();
  
  pushMatrix();
  translate(12*rate, 4*rate);
  rotate(2*2*PI/5/3);
  scale(2*rate, 2*rate);
  star();
  popMatrix();
  
  pushMatrix();
  translate(12*rate, 7*rate);
  rotate(2*3*PI/5/3);
  scale(2*rate, 2*rate);
  star();
  popMatrix();
  
  pushMatrix();
  translate(10*rate, 9*rate);
  rotate(2*4*PI/5/3);
  scale(2*rate, 2*rate);
  star();
  popMatrix();
}


void star(){
  beginShape();
  for(int i = 0; i < 5; i++){
    float theta = 2 * TWO_PI / 5 * i - HALF_PI;
    vertex(.5 * cos(theta), .5 * sin(theta));
  }
  endShape();
}
