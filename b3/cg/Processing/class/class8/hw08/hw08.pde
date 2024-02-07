int n = 0;
float theta = PI/7;
float gamma = 0.74;
void setup(){
  size(800,800);
  background(255);
  fill(0);
  smooth();
}

void drawTree(int m,float wid){
  if(m == 0)return;
  line(0,0,0,wid*gamma);
  --m;
  wid *= gamma;
  translate(0,wid);
  
  for (int i=0; i<2; ++i) {
    pushMatrix();
    rotate((int)pow(-1, i%2) * theta);
    drawTree(m, wid);
    popMatrix();
  }
}

void mousePressed(){
  if((mouseButton == LEFT)&&(n<18))n++;
  else if((mouseButton == RIGHT)&&(n>0))n--;
}

void draw(){
  background(255);
  translate(width/2, height);
  line(0,0,0,height);
  rotate(PI);
  drawTree(n,height*.271828);
}
