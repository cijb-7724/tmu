void setup(){
  size(400, 300);
  smooth();
  noStroke();
  fill(250, 230, 20);
  ellipseMode(CORNER);
  frameRate(60);
}


int d = 40, x = 0, y = 0, vx = 2, vy = 4;
float phi = 0, vphi = 0.1;
void draw() {
  background(0);
  //ellipse(x, y, d, d);
  arc(x, y, d, d, atan2(vy, vx)+phi, atan2(vy, vx)+2*PI-phi);
  x += vx; y += vy; phi += vphi;
  if (x > width-d || x < 0) vx *= -1;
  if (y > height-d || y < 0) vy *= -1;
  if (phi > PI/6 || phi < -PI/6) vphi *= -1;
}
