void setup() {
  size(600, 400, P3D);
}

void draw() {
  background(220);
  lights();
  translate(width / 2, height / 2);
  drawEllipsoid(100, 150, 200);
}

void drawEllipsoid(float rx, float ry, float rz) {
  int detail = 30;
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= detail; i++) {
    float lat0 = PI * (-0.5 + (float) (i - 1) / detail);
    float z0 = sin(lat0) * rz;
    float zr0 = cos(lat0) * rz;

    float lat1 = PI * (-0.5 + (float) i / detail);
    float z1 = sin(lat1) * rz;
    float zr1 = cos(lat1) * rz;

    for (int j = 0; j <= detail; j++) {
      float lon = TWO_PI * (float) (j - 1) / detail;
      float x = cos(lon) * rx;
      float y = sin(lon) * ry;
      vertex(x * zr0, y * zr0, z0);
      vertex(x * zr1, y * zr1, z1);
    }
  }
  endShape();
}
