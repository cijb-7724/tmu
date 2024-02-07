


void setup(){
  size(400, 400);
  smooth();
  stroke(255, 255, 100);
  frameRate(60);
}


void draw() {
  background(0);
  float theta = 0, step = 0.1, A = 150, B = 150, a = 2, b = 3, sig = 0;
  float x1, x2, y1, y2;
  while (theta < 2*PI*4) {
    x1 = A*sin(a*theta+sig);
    y1 = B*cos(b*theta);
    x2 = A*sin(a*(theta+step)+sig);
    y2 = B*cos(b*(theta+step));
    
    x1 += 200;
    x2 += 200;
    y1 += 200;
    y2 += 200;
    line(x1, y1, x2, y2);
    theta += step;
  }
}
