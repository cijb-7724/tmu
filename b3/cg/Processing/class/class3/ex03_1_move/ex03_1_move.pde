void setup(){
  size(400, 20);
  smooth();
  noStroke();
  fill(200, 255, 200);
  ellipseMode(CORNER);
  frameRate(30);
}

int d = 20, x = 400, vx = -3;
  void draw(){
  background(255);
  ellipse(x,0, d, d); // draw the ball at time t
  x+= vx;
  if(x+20<0)x=400;
}
