
int rate = 7;//ここでサイズを変更できる
void setup() {
  surface.setResizable(true);
  surface.setSize(108*2*rate, 72*2*rate);
}

void draw() {
background(237, 41, 57);


noStroke(); // 外枠の非表示
fill(255);
rect(0, 72*rate, 108*2*rate, 72*2*rate);
ellipse(45.5*rate, 36*rate, 26.5*2*rate, 26.5*2*rate);
fill(237, 41, 57);
ellipse(60*rate, 36*rate, 29*2*rate, 29*2*rate);
fill(255);

float centerX = 60, centerY = 36, pi = 3.14159, r = 15.2, theta = pi*2/5, small=(3-sqrt(5))/2, r2 = 6.4, x, y;
for (int i=0; i<5; ++i) {
  float scX = centerX+r*cos(theta*i-pi/2), scY = centerY+r*sin(theta*i-pi/2);
  beginShape();
  for (int j=0; j<5; ++j) {
    x = scX + r2*cos(theta*j-pi/2);
    y = scY + r2*sin(theta*j-pi/2);
    vertex(x*rate, y*rate);
    x = scX + r2*small*cos(theta*j-pi/2+theta/2);
    y = scY + r2*small*sin(theta*j-pi/2+theta/2);
    vertex(x*rate, y*rate);
  }
  endShape();
}
}
