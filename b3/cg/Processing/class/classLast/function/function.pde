// JavaのArrayListをProcessingで使用する例
import java.util.ArrayList;
import java.util.Collections;
import java.util.Random;
import java.util.Arrays;

void setup() {
  size(1000, 1000, P3D);
  textFont(createFont("ArialMT", 18), 18);
  lights();
   //noStroke();
}

int time = 0;
int rotate_speed = 200;


int h = 0;
void draw() {
  //rotateX(PI/4);
  //rotateZ(PI/4);
  
  //rotateY(PI/4);
  pushMatrix();
  translate(width/2, width/4, 0);
  pushMatrix();
  rotateX(PI/5);
  rotateZ(h/100.0);
  ++h;
  
  
  //scale(100);
  //drawAxises();
  
  //translate(50, 0, -50);
  //rotateX(PI/4);
  scale(0.7);
  draw_nn();
  popMatrix();
  popMatrix();
}

double true_function(double x, double y) {
  double z = 0.0;
  z += Math.sin(Math.sqrt(x*x+y*y)/2);
  z -= 4*Math.cos(y/3);
  z += Math.log10(1 + Math.pow(x+y, 4));
  return z;
}

void draw_nn() {
  background(255);
  //translate(width/2, height/2);

  float step = 1; // ポイント間の距離
  float range = 20; // xおよびyの範囲

  // xとyの範囲をループ
  for (float x = -range; x <= range; x += step) {
    for (float y = -range; y <= range; y += step) {
      // 3次元座標を計算
      float z = (float) true_function(x, y); // true_functionからz値を計算
      //pushMatrix();
      //translate(x, y, z);
      //sphere(5);
      //popMatrix();
      float sx = map(x, -range, range, -width/4, width/4);
      float sy = map(y, -range, range, -height/4, height/4);
      float sz = map(z, -range, range, -200, 200);

      // 隣接する3点の座標を計算
      float z1 = (float) true_function(x, y + step);
      float z2 = (float) true_function(x + step, y);
      float z3 = (float) true_function(x + step, y + step);
      float sx1 = map(x, -range, range, -width/4, width/4);
      float sy1 = map(y + step, -range, range, -height/4, height/4);
      float sz1 = map(z1, -range, range, -200, 200);
      float sx2 = map(x + step, -range, range, -width/4, width/4);
      float sy2 = map(y, -range, range, -height/4, height/4);
      float sz2 = map(z2, -range, range, -200, 200);
      float sx3 = map(x + step, -range, range, -width/4, width/4);
      float sy3 = map(y + step, -range, range, -height/4, height/4);
      float sz3 = map(z3, -range, range, -200, 200);

      // 三角形を描画
      beginShape(TRIANGLES);
      //fill(255, 0, 0, 128); // 赤色で塗りつぶし
      // 三角形の色を高さに応じてグラデーションにする
      float minZ = -200; // 最小のZ値
      float maxZ = 200; // 最大のZ値
      
      // zの値に基づいて色を計算
      float t = map(sz, minZ, maxZ, 0, 1);
      color c = lerpColor(color(0, 0, 255), color(255, 0, 0), t);
      fill(c);

      vertex(sx, sy, sz);
      vertex(sx1, sy1, sz1);
      vertex(sx2, sy2, sz2);

      vertex(sx1, sy1, sz1);
      vertex(sx2, sy2, sz2);
      vertex(sx3, sy3, sz3);
      endShape();
    }
  }
}
