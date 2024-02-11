



void setup() {
  size(1000, 1000, P3D);  
  lights();
}

float t = 0;
float wid = 20;
void draw() {
  float startX = 100;   // 線の始点のx座標
  float startY = 100;   // 線の始点のy座標
  float startZ = -100;  // 線の始点のz座標
  float endX = 500;     // 線の終点のx座標
  float endY = 500;     // 線の終点のy座標
  float endZ = -100;     // 線の終点のz座標
  draw_lines(startX, startY, startZ, endX, endY, endZ);
}
void draw_lines(float startX, float startY, float startZ, float endX, float endY, float endZ) {
  float lineLength = dist(startX, startY, startZ, endX, endY, endZ);  // 線の長さ
  float lineDirX = (endX - startX) / lineLength;  // 線の方向ベクトルのx成分
  float lineDirY = (endY - startY) / lineLength;  // 線の方向ベクトルのy成分
  float lineDirZ = (endZ - startZ) / lineLength;  // 線の方向ベクトルのz成分
  
  float gx = startX + lineDirX*lineLength/3;
  float gy = startY + lineDirY*lineLength/3;
  float gz = startZ + lineDirZ*lineLength/3;
  
  float t0x = startX + lineDirX*t;
  float t0y = startY + lineDirY*t;
  float t0z = startZ + lineDirZ*t;
  
  float t0x2 = t0x + lineDirX*wid;
  float t0y2 = t0y + lineDirY*wid;
  float t0z2 = t0z + lineDirZ*wid;
  
  float t1x = t0x + lineLength/3*lineDirX;
  float t1y = t0y + lineLength/3*lineDirY;
  float t1z = t0z + lineLength/3*lineDirZ;
  
  float t1x2 = t1x + lineDirX*wid;
  float t1y2 = t1y + lineDirY*wid;
  float t1z2 = t1z + lineDirZ*wid;
  
  float t2x = t0x + lineLength*2/3*lineDirX;
  float t2y = t0y + lineLength*2/3*lineDirY;
  float t2z = t0z + lineLength*2/3*lineDirZ;
  
  float t2x2 = t2x + lineDirX*wid;
  float t2y2 = t2y + lineDirY*wid;
  float t2z2 = t2z + lineDirZ*wid;
 
  t += 1;
  if (dot(t0x2-t0x, t0y2-t0y, t0z2-t0z, t0x-gx, t0y-gy, t0z-gz) >= 0) {
    t = 0;
  }
  //green
  stroke(0, 255, 0);
  strokeWeight(4);
  line(startX, startY, startZ, t0x, t0y, t0z);
  line(t0x2, t0y2, t0z2, t1x, t1y, t1z);
  line(t1x2, t1y2, t1z2, t2x, t2y, t2z);
  line(t2x2, t2y2, t2z2, endX, endY, endZ);
  
  //white
  stroke(255);
  strokeWeight(10);
  line(t0x, t0y, t0z, t0x2, t0y2, t0z2);
  line(t1x, t1y, t1z, t1x2, t1y2, t1z2);
  line(t2x, t2y, t2z, t2x2, t2y2, t2z2);
  

}

float dot(float a, float b, float c, float d, float e, float f) {
  return a*d + b*e + c*f;
}
