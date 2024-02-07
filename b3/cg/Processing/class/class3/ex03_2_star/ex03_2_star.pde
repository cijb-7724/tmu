void setup(){
  size(400, 20);
  smooth();
  noStroke();
  fill(200, 255, 200);
  ellipseMode(CORNER);
  frameRate(30);
}

int d = 20, vx = 1,r=10;
float x0=0,y0=10;
float x,y;
int j=0;
float theta2=0;
    
void draw(){
  background(255);
  noStroke();
  fill(0);
  theta2 += HALF_PI/20; 
  beginShape();
  for(int i = 0; i < 5; i++){
    float theta = 2 * TWO_PI / 5 * j - HALF_PI;
    x = r * cos(theta+theta2)+x0;
    y = r * sin(theta+theta2)+y0;
    vertex(x, y);
    j++;
   }
  endShape();
  x0+=vx;
}
