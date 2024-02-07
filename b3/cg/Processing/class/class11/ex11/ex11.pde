PImage img1;
void setup(){
  size(1200,1200,P3D);
  noStroke();
}

void draw(){
  background(255);
  translate(600,600,0);
  rotateX(map(mouseY, 0, height, 6, -6));
  rotateY(map(-mouseX, 0, width, -6, 6));
  scale(200);
  draw_help();
}

void draw_help(){
  img1=loadImage("screenshot.png");
  beginShape();
    texture(img1);
    textureMode(NORMAL);
    vertex(0,0,0,0,1);
    vertex(1,0,0,1,1);
    vertex(1,0,1,1,0);
    vertex(0,0,1,0,0);
  endShape();
  
  beginShape();
    texture(img1);
    textureMode(NORMAL);
    vertex(0,0,0,0,1);
    vertex(1,0,0,1,1);
    vertex(1/2, 3, 1/2, 1/2, 0);
  endShape();
  
  beginShape();
    texture(img1);
    textureMode(NORMAL);
    vertex(1,0,0,0,1);
    vertex(1,0,1,1,1);
    vertex(1/2, 3, 1/2, 1/2, 0);
  endShape();

    beginShape();
    texture(img1);
    textureMode(NORMAL);
    vertex(1,0,1,0,1);
    vertex(0,0,1,1,1);
    vertex(1/2, 3, 1/2, 1/2, 0);
  endShape();
  
  beginShape();
    texture(img1);
    textureMode(NORMAL);
    vertex(0,0,1,0,1);
    vertex(0,0,0,1,1);
    vertex(1/2, 3, 1/2, 1/2, 0);
  endShape();
}
