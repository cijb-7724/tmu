


void setup(){
  size(400, 400);
  smooth();
  stroke(255, 255, 100);
  frameRate(60);
}


void draw() {
  background(0);
  float theta = 0, step = 0.1, r = 150;
  float x1, x2, y1, y2;
  while (theta < 2*PI) {
    x1 = r*pow(cos(theta),3);
    y1 = r*pow(sin(theta), 3);
    x2 = r*pow(cos(theta+step), 3);
    y2 = r*pow(sin(theta+step), 3);
    x1 += 200;
    x2 += 200;
    y1 += 200;
    y2 += 200;
    line(x1, y1, x2, y2);
    theta += step;
  }
}
