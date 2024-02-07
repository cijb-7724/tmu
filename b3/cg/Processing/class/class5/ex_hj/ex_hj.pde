void setup(){
  size(360, 180);
  background(255);
  fill(0, 0, 139);
  rect(0, 0, width, height/3);
  rect(0, height*2/3, width, height/3);
  smooth();
  noStroke();
 
}
void draw() {
  translate(width/2, height/2);
  scale(20, 20);
  star();
  
  translate(-3, -1.5/2);
  star();
  translate(0, 1.5);
  star();
  
  translate(6, 0);
  star();
  translate(0, -1.5);
  star();
}

//star method
void star(){
  beginShape();
  for(int i = 0; i < 5; i++){
    float theta = 2 * TWO_PI / 5 * i - HALF_PI;
    vertex(.5 * cos(theta), .5 * sin(theta));
  }
  endShape();
}
