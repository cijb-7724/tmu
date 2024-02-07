PImage img;
void setup(){
  img=loadImage("screenshot.png");
  surface.setSize(img.width, img.height);
  noStroke();
  frameRate(600);
  background(255);
  draw();
}
int x, y;
void draw(){
  x = int(random(img.width));
  y = int(random(img.height));
  fill(img.get(x,y));
  translate(x, y);
  rotate(-PI / 5);
  ellipse(0, 0, 90, 40);
}
