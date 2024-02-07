void setup() {
  size(400, 20);
  background(255);
  fill(255, 0, 152);
  smooth();
  noStroke();
}

float t = 0, dt = 0.7;

void draw() {
  background(255);
  translate(t, height / 2);
  rotate(t/10);
  star();
  t += dt;
  if (t >= width) t = 0;
}
  
void star() {
  beginShape();
  for (int i = 0; i < 5; i++) {
    float theta = 2*2 * PI / 5 * i - HALF_PI;
    float x = 10 * cos(theta);
    float y = 10 * sin(theta);
    vertex(x, y);
  }
  endShape(CLOSE);
}
