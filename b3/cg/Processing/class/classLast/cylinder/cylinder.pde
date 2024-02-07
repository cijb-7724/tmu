PVector point1, point2;
float radius = 10;

void setup() {
  size(400, 400, P3D);
  point1 = new PVector(100, 100, 0);
  point2 = new PVector(300, 300, 100);
  noStroke();
}

void draw() {
  background(255);
  lights();
  translate(40, 50, 0);
  drawCylinder(point1, point2, radius);
  drawCylinder(point1, point2, 2);
}

void drawCylinder(PVector p1, PVector p2, float r) {
  PVector d = PVector.sub(p2, p1); // ベクトルの差を計算
  float cylLength = d.mag(); // ベクトルの長さを計算
  float a = atan2(d.y, d.x); // XY平面内の角度を計算
  float zAngle = atan2(d.z, dist(p1.x, p1.y, p2.x, p2.y)); // Z軸周りの角度を計算
  
  pushMatrix();
  translate(p1.x, p1.y, p1.z);
  rotateZ(a);
  rotateY(zAngle);
  drawCylinderSurface(r, cylLength);
  popMatrix();
}

void drawCylinderSurface(float r, float h) {
  int detail = 24; // 円柱の分割数
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= detail; i++) {
    float theta = map(i, 0, detail, 0, TWO_PI);
    float x = cos(theta) * r;
    float y = sin(theta) * r;
    vertex(x, y, 0);
    vertex(x, y, h);
  }
  endShape();
}
