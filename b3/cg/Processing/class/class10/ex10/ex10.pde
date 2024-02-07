void setup(){
  size(800,800,P3D);
  noStroke();
  smooth();
}

float x=0,y=0,z=0;
int h=200;
void draw(){
  background(255);
  x-=PI/100;
  y-=PI/200;
  z-=PI/300;
  translate(width/2,height/2,0);
  rotateX(x);
  rotateY(y);
  rotateZ(z);
  
  scale(100);
  beginShape(QUADS);
  
  //fill(255,0,0,255);
  fill(#F192A1);
  vertex(1,-1,-1);
  vertex(1,-1,1);
  vertex(1,1,1);
  vertex(1,1,-1);

  fill(#F9A49E);
  vertex(1,1,1);
  vertex(-1,1,1);
  vertex(-1,1,-1);
  vertex(1,1,-1);
  
  fill(#FFB9A7);
  vertex(-1,1,1);
  vertex(1,1,1);
  vertex(1,-1,1);
  vertex(-1,-1,1);
  
  fill(#FFCAB6);
  vertex(-1,-1,-1);
  vertex(-1,-1,1);
  vertex(1,-1,1);
  vertex(1,-1,-1);
  
  fill(#FEDACF);
  vertex(-1,1,-1);
  vertex(-1,1,1);
  vertex(-1,-1,1);
  vertex(-1,-1,-1);
  
  fill(#C0C88B);
  vertex(1,1,-1);
  vertex(-1,1,-1);
  vertex(-1,-1,-1);
  vertex(1,-1,-1);
  endShape();
}
