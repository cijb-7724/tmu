int x,y;
PImage img;
void setup(){
  img=loadImage("screenshot.png");
  surface.setSize(img.width*2, img.height);
  background(255);
   draw();
}

void draw(){
   x=img.width;
   y=img.height;

  PImage img2 = createImage(x,y,ALPHA);
  img.loadPixels();
  img2.loadPixels();
  for(int i=0; i<x*y; ++i)img2.pixels[int(i/x)*x + (x-1-(i%x))]=img.pixels[i];
  
  img2.updatePixels();
  image(img,0,0);
  image(img2,x,0);
}
