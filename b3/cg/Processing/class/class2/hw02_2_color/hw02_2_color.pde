float rate = 1;//ここでサイズを変更できる
void setup() {
  surface.setSize(int(400*rate), int(400*rate));
}

void draw() {
  background(255);
  colorMode(HSB,100);
  
  for(int i=0; i<100; ++i){
    float theta=TWO_PI/100*i, r=150*rate, x, y;
    stroke(i,100,100);
    x = r*cos(theta)+200*rate;
    y = r*sin(theta)+200*rate;
    line(x,y,200*rate,200*rate);
  }
  
  colorMode(RGB,255);
  fill(255);
  noStroke();
  ellipse(200*rate,200*rate,100*rate,100*rate);
}
