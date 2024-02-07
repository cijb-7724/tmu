void setup(){
  size(640, 480);
  background(255);
  //fill(255, 0, 0);
  noStroke();
  smooth();

}
void draw() { }
int cnt = 0;
int [] xs = {0, 0, 0, 0};
int [] ys = {0, 0, 0, 0};
boolean first = true;
void mouseClicked(){
  if(mouseButton == LEFT) {
    fill(0, 255, 0);
    noStroke();
    ellipse(mouseX, mouseY, 10, 10);
    if (first) {
      first = false;
      xs[0] = mouseX;
      ys[0] = mouseY;
    } else {
      xs[cnt] = mouseX;
      ys[cnt] = mouseY;
    }
    ++cnt;
    if (cnt == 4){
      cnt = 1;
      stroke(255, 0, 0);
      noFill();
      bezier(xs[0], ys[0], xs[1], ys[1],xs[2], ys[2],xs[3], ys[3]);
      xs[0] = xs[3];
      ys[0] = ys[3];
    }
  }
  else if(mouseButton == RIGHT) {
    cnt = 0;
    background(255);
  }
}
