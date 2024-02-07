void setup(){
  img=loadImage("screenshot.png");
  surface.setSize(img.width*3, img.height);
  background(255);
  draw();
}
int x,y;
PImage img;
int left, right;
void draw(){
  img.loadPixels(); 
   x=img.width;
   y=img.height;
  PImage img2 = createImage(x,y,RGB);
  PImage img3 = createImage(x,y,RGB);
  for (int i=0; i<y; ++i) for (int j=0; j<x/2; ++j) {
    left  = i * x + j;
    right = i * x + (x-1-j);
    img2.pixels[left] = img.pixels[left];
    img2.pixels[right] = img.pixels[left];
    img3.pixels[left] = img.pixels[right];
    img3.pixels[right] = img.pixels[right];
  }
  img2.updatePixels();
  img3.updatePixels();
  image(img,0,0);
  image(img2,x,0);
  image(img3,x*2,0);
}
