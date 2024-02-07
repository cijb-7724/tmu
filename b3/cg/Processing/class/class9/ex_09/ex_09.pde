int n = 11, wid = 50, boxSize = 37;
float rate = 255.0/10.0;

void setup(){
  size(1200,1200,P3D);
  noStroke();
}

void draw(){
  background(255);
  translate(width/2, height/2, 0);
  rotateX(map(mouseY, 0, height, PI, -PI));
  rotateY(map(mouseX, 0, width, -PI, PI));
  coloredCubes();
}

void coloredCubes() {
  for (int r=0; r<n; ++r) {
    for (int g=0; g<n; ++g) {
      for (int b=0; b<n; ++b) {
        pushMatrix();
          fill(r*rate, g*rate, b*rate);
          translate((r-5)*wid, (g-5)*wid, (b-5)*wid);
          box(boxSize);
        popMatrix();
      }
    }
  }
}
