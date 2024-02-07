void setup(){
  size(400, 300);
  smooth();
  noStroke();
  fill(200, 100, 200);
  ellipseMode(CORNER);
  frameRate(60);
}


int d = 20, x = 0, y = 0, vx = 2, vy = 4;
int cnt = 0;
void draw() {
  background(255);
  ellipse(x, y, d, d);
  x += vx; y += vy;
  if (x > width-d || x < 0) vx *= -1;
  if (y > height-d || y < 0) vy *= -1;
}
