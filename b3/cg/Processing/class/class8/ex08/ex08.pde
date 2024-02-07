int n = 0;
void setup(){
  size(800,800);
  background(255);
  fill(0);
  smooth();
}

int h(int x) {
  if (x == 0) return 0;
  else return 1;
}

void drawSierpinskiGasket(int m,float wid){
  if(m==0){
    wid/=2;
    triangle(0,0,-wid,sqrt(3)*wid,wid,sqrt(3)*wid);
    return;
  }
  --m; wid /= 2;
  
  for (int i=0; i<3; ++i) {
    pushMatrix();
    translate(h(i)*wid*.5*(int)pow(-1, i%2),h(i)*sqrt(3)*wid*.5);
    drawSierpinskiGasket(m, wid);
    popMatrix();  
  }
}

void mousePressed(){
  if((mouseButton == LEFT)&&(n<8))n++;
  else if((mouseButton == RIGHT)&&(n>0))n--;
}

void draw(){
  background(255);
  translate(width/2, 0);
  drawSierpinskiGasket(n,width);
}
