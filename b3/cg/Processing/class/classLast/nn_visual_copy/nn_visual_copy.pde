// JavaのArrayListをProcessingで使用する例
import java.util.ArrayList;
import java.util.Collections;
import java.util.Random;
import java.util.Arrays;

Properties p;
int[][] amb = {{102, 153, 10}, {0, 0, 0}, {125, 31, 100}};
int[][] spe = {{63, 62, 78}, {225, 221, 200}, {0, 0, 128}};
int[][] emi = {{99, 98, 150}, {106, 99, 46}, {106, 99, 46}};

int [] red_amb = {130, 40, 40};
int [] red_spe = {114, 78, 111};
int [] red_emi = {130, 10, 10};
int red_shi = 100;

int [] blue_amb = {40, 40, 130};
int [] blue_spe = {114, 78, 111};
int [] blue_emi = {10, 10, 130};
int blue_shi = 100;

int[] shi = {10, 10, 50};

ArrayList<ArrayList<Double>> G_x = initial_AAD(0, 0, 0);
ArrayList<ArrayList<Double>> G_t = initial_AAD(0, 0, 0);
double G_eta = 0.03, G_attenuation = 0.4;
int G_n = 3000;
int G_show_interval = 500;
int G_learning_plan = 500;
int G_loop = 10000;
int G_loop_i = 0;
int G_batch_size = 32;
ArrayList<Integer> G_nn_form = new ArrayList<> (Arrays.asList(2, 6, 8, 4, 1));
//ArrayList<Integer> G_nn_form = new ArrayList<> (Arrays.asList(2, 10, 10, 10, 1));
int G_depth = G_nn_form.size()-1;

Layer layer = new Layer();
ArrayList<Layer> G_nn = layer.createLayerList(G_depth);
ArrayList<Integer> G_id = new ArrayList<>();

boolean isProcessing = false;

void setup() {
  size(1000, 1000, P3D);
  p = new Properties();
  lights();
  main_setup();
}

int time = 0;
int rotate_speed = 200;

void draw() {
  learn();
  //test();
  
  background(0);
  pushMatrix();
    translate(width/2, width/4, 0);
    rotateX(PI/5);
    rotateZ(time/400.0);
    draw_function();
    draw_estimated_function();
  popMatrix();

  draw_nn();
  ++time;
  if (time == 360*rotate_speed) time = 0;
}


void draw_function() {
  stroke(0);
  strokeWeight(0.5);
  noStroke();

  float step = 0.5; // ポイント間の距離
  float range = 10; // xおよびyの範囲

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
      float minZ = -60.2; // 最小のZ値
      float maxZ = 100.9; // 最大のZ値
      
      // zの値に基づいて色を計算
      float t = map(sz, minZ, maxZ, 0, 1);
      color c = lerpColor(color(138, 224, 189, 250), color(224, 138, 173, 250), t);
      pushStyle();
      fill(c);

      vertex(sx, sy, sz);
      vertex(sx1, sy1, sz1);
      vertex(sx2, sy2, sz2);

      vertex(sx1, sy1, sz1);
      vertex(sx2, sy2, sz2);
      vertex(sx3, sy3, sz3);
      endShape();
      popStyle();
    }
  }
}
//=============================================================================================
void draw_estimated_function() {
  stroke(0);
  strokeWeight(0.5);
  //noStroke();

  float step = 1; // ポイント間の距離
  float range = 10; // xおよびyの範囲

  // xとyの範囲をループ
  for (float x = -range; x <= range; x += step) {
    for (float y = -range; y <= range; y += step) {
      // 3次元座標を計算
      float z = (float) estimate_function(x, y); // true_functionからz値を計算
      //pushMatrix();
      //translate(x, y, z);
      //sphere(5);
      //popMatrix();
      float sx = map(x, -range, range, -width/4, width/4);
      float sy = map(y, -range, range, -height/4, height/4);
      float sz = map(z, -range, range, -200, 200);

      // 隣接する3点の座標を計算
      float z1 = (float) estimate_function(x, y + step);
      float z2 = (float) estimate_function(x + step, y);
      float z3 = (float) estimate_function(x + step, y + step);
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
      float minZ = -4.2; // 最小のZ値
      float maxZ = 9.9; // 最大のZ値
      
      // zの値に基づいて色を計算
      float t = map(sz, minZ, maxZ, 0, 1);
      color c = lerpColor(color(255, 0, 255, 150), color(255, 255, 0, 150), t);
      pushStyle();
      fill(c);

      vertex(sx, sy, sz);
      vertex(sx1, sy1, sz1);
      vertex(sx2, sy2, sz2);

      vertex(sx1, sy1, sz1);
      vertex(sx2, sy2, sz2);
      vertex(sx3, sy3, sz3);
      endShape();
      popStyle();
    }
  }
}







void draw_nn() {
  noStroke();
  sphereDetail(30);
  lightSpecular(25, 225, 55);
  directionalLight(p.getDirectionalLR(), p.getDirectionalLG(), p.getDirectionalLB(), -1, 1, -1);
  ambientLight(p.getAmbientLR(), p.getAmbientLG(), p.getAmbientLB());

  int width_sph = 180;

  translate(width_sph, height * 0.75, 0);
  rotateX(1.0*time/rotate_speed);
  translate(-width_sph, -height * 0.75, 0);
  
  pushMatrix();/////////////////////////////////////push
  
  int [] rs = {100, 130, 160, 100, 0};
  
  for (int lay=0; lay<G_depth; ++lay) {
    if (lay == 0) {
      translate(width_sph, height * 0.75, 0);
    } else {
      translate(width_sph, 0, 0);
    }
    
    if (lay % 2 == 0) {
      ambient(red_amb[0], red_amb[1], red_amb[2]);
      specular(red_spe[0], red_spe[1], red_spe[2]);
      emissive(red_emi[0], red_emi[1], red_emi[2]);
      shininess(red_shi);
    } else {
      ambient(blue_amb[0], blue_amb[1], blue_amb[2]);
      specular(blue_spe[0], blue_spe[1], blue_spe[2]);
      emissive(blue_emi[0], blue_emi[1], blue_emi[2]);
      shininess(blue_shi);
    }
    
    
    for (int i=0; i<G_nn_form.get(lay); ++i) {
      pushMatrix();
      translate(0, (int)(rs[lay]*Math.cos(2*Math.PI/G_nn_form.get(lay)*i)), (int)(rs[lay]*Math.sin(2*Math.PI/G_nn_form.get(lay)*i)));
      sphere(30);
      popMatrix();
    }
    
    //edge
    for (int i=0; i<G_nn_form.get(lay); ++i) {
      for (int j=0; j<G_nn_form.get(lay+1); ++j) {
        stroke(0, 255, 0);
        strokeWeight(4);
        line(0, (int)(rs[lay]*Math.cos(2*Math.PI/G_nn_form.get(lay)*i)), (int)(rs[lay]*Math.sin(2*Math.PI/G_nn_form.get(lay)*i)), width_sph, (int)(rs[lay+1]*Math.cos(2*Math.PI/G_nn_form.get(lay+1)*j)), (int)(rs[lay+1]*Math.sin(2*Math.PI/G_nn_form.get(lay+1)*j)));
        noStroke();
      }
    }
    
  }

  translate(width_sph, 0, 0);
  ambient(red_amb[0], red_amb[1], red_amb[2]);
  specular(red_spe[0], red_spe[1], red_spe[2]);
  emissive(red_emi[0], red_emi[1], red_emi[2]);
  shininess(red_shi);
  sphere(30);
  
  popMatrix();//////////////////////////////pop
}





//=============================================================================================









//=============================================================================================
public class Layer {
  ArrayList<ArrayList<Double>> w;
  ArrayList<ArrayList<Double>> b;
  ArrayList<ArrayList<Double>> a;
  ArrayList<ArrayList<Double>> x;
  ArrayList<ArrayList<Double>> delta;
  ArrayList<ArrayList<Double>> rw;
  ArrayList<ArrayList<Double>> rb;

  public Layer() {
    w = new ArrayList<> ();
    b = new ArrayList<> ();
    a = new ArrayList<> ();
    x = new ArrayList<> ();
    delta = new ArrayList<> ();
    rw = new ArrayList<> ();
    rb = new ArrayList<> ();
  }
  public ArrayList<Layer> createLayerList(int depth) {
    ArrayList<Layer> nn = new ArrayList<>();
    for (int i=0; i<depth; ++i) {
      nn.add(new Layer());
    }
    return nn;
  }
}

void main_setup() {
  for (int i=0; i<G_n; ++i) {
    G_id.add(i);
  }
  //Heの初期化
  for (int i=0; i<G_depth; ++i) {
    G_nn.get(i).w = initial_AAD(G_nn_form.get(i), G_nn_form.get(i+1), 0);
    G_nn.get(i).b = initial_AAD(G_batch_size, G_nn_form.get(i+1), 0);
    make_initial_value(G_nn.get(i).w, 0, Math.sqrt(2.0/G_nn_form.get(i)));
    make_initial_value(G_nn.get(i).b, 0, Math.sqrt(2.0/G_nn_form.get(i)));
    G_nn.get(i).b = expansion_bias(G_nn.get(i).b, G_batch_size);
  }
  make_data(G_x, G_t, G_n);
}

void learn() {
  if (G_loop_i > G_loop) return;
  ArrayList<ArrayList<Double>> x0 = initial_AAD(0, 0, 0);
  ArrayList<ArrayList<Double>> t0 = initial_AAD(0, 0, 0);
  Collections.shuffle(G_id, random);
  shuffle_AAD(G_t, G_id);
  shuffle_AAD(G_x, G_id);
  
  //bias size resize
  for (int i=0; i<G_depth; ++i) {
    G_nn.get(i).b = expansion_bias(G_nn.get(i).b, G_batch_size);
  }

  //choice top batch_size
  for (int j=0; j<G_batch_size; ++j) {
    x0.add(new ArrayList<>(G_x.get(j)));
    t0.add(new ArrayList<>(G_t.get(j)));
  }

  //forward propagation
  for (int k=0; k<G_depth; ++k) {
    if (k == 0) G_nn.get(k).a = matrix_add(matrix_multi(x0, G_nn.get(k).w), G_nn.get(k).b);
    else G_nn.get(k).a = matrix_add(matrix_multi(G_nn.get(k-1).x, G_nn.get(k).w), G_nn.get(k).b);
    if (k < G_depth-1) G_nn.get(k).x = hm_tanh(G_nn.get(k).a);
    else G_nn.get(k).x = hm_identity(G_nn.get(k).a);
  }

  //back propagation
  for (int k=G_depth-1; k>=0; --k) {
    if (k == G_depth-1) {
      ArrayList<ArrayList<Double>> r_fL_xk = calc_r_MSE(G_nn.get(k).x, t0);
      ArrayList<ArrayList<Double>> r_hk_ak = calc_r_identity(G_nn.get(k).x);
      G_nn.get(k).delta = matrix_adm_multi(r_fL_xk, r_hk_ak);
    } else {
      ArrayList<ArrayList<Double>> r_h_a = calc_r_tanh(G_nn.get(k).a);
      G_nn.get(k).delta = matrix_adm_multi(r_h_a, matrix_multi(G_nn.get(k+1).delta, matrix_t(G_nn.get(k+1).w)));
    }

    G_nn.get(k).rb = calc_r_bias(G_nn.get(k).b, G_nn.get(k).delta);
    if (k != 0) G_nn.get(k).rw = matrix_multi(matrix_t(G_nn.get(k-1).x), G_nn.get(k).delta);
    else G_nn.get(k).rw = matrix_multi(matrix_t(x0), G_nn.get(k).delta);
  }
  //update parameters
  for (int k=0; k<G_depth; ++k) {
    update_weights(G_nn.get(k).w, G_nn.get(k).rw, G_eta);
    update_weights(G_nn.get(k).b, G_nn.get(k).rb, G_eta);
  }

  //update learning plan
  if ((G_loop_i+1) % G_learning_plan == 0) G_eta *= G_attenuation;

  if (G_loop_i % G_show_interval == 0) {
    print(G_loop_i + " MSE ");
    println(hm_MSE(G_nn.get(G_depth-1).x, t0));
  }

  //println("===========================i= "+i);
  //show_all(nn, depth);
  ++G_loop_i;
}

void test() {
  //================================================
  // test set
  for (int i=0; i<40; ++i) print("=");
  println(" ");
  println("test set " + G_loop_i);
  for (int i=0; i<G_depth; ++i) {
    G_nn.get(i).b = expansion_bias(G_nn.get(i).b, G_n);
  }
  println("G_n " + G_n);
  make_data(G_x, G_t, G_n);
  //formard propagation
  for (int k=0; k<G_depth; ++k) {
    if (k == 0) G_nn.get(k).a = matrix_add(matrix_multi(G_x, G_nn.get(k).w), G_nn.get(k).b);
    else G_nn.get(k).a = matrix_add(matrix_multi(G_nn.get(k-1).x, G_nn.get(k).w), G_nn.get(k).b);
    if (k < G_depth-1) G_nn.get(k).x = hm_tanh(G_nn.get(k).a);
    else G_nn.get(k).x = hm_identity(G_nn.get(k).a);
  }
  println("MSE = " + hm_MSE(G_nn.get(G_depth-1).x, G_t));
  for (int i=0; i<40; ++i) print("=");
  println(" ");
  //================================================
}
double estimate_function(double px, double py) {
  for (int i=0; i<G_depth; ++i) {
    G_nn.get(i).b = expansion_bias(G_nn.get(i).b, 1);
  }
  
  ArrayList<ArrayList<Double>> point = new ArrayList<>(1);
  ArrayList<Double> tmp = new ArrayList<>();
  tmp.add(px);
  tmp.add(py);
  point.add(tmp);
  //px, py
  //formard propagation
  for (int k=0; k<G_depth; ++k) {
    if (k == 0) G_nn.get(k).a = matrix_add(matrix_multi(point, G_nn.get(k).w), G_nn.get(k).b);
    else G_nn.get(k).a = matrix_add(matrix_multi(G_nn.get(k-1).x, G_nn.get(k).w), G_nn.get(k).b);
    if (k < G_depth-1) G_nn.get(k).x = hm_tanh(G_nn.get(k).a);
    else G_nn.get(k).x = hm_identity(G_nn.get(k).a);
  }
  return G_nn.get(G_depth-1).x.get(0).get(0);
}

void mouseReleased() {
  p.release();
}

class Properties {
  HandleRGB ambientL = new HandleRGB(400, 2, "AmbientLight", 128, 128, 128);
  HandleRGB ambient = new HandleRGB(400, 84, "Ambient", 128, 128, 128);
  HandleRGB directionalL = new HandleRGB(400, 166, "DirectionalLight", 128, 128, 128);
  HandleRGB specular = new HandleRGB(400, 248, "Specular", 128, 128, 128);
  HandleRGB emissive = new HandleRGB(400, 330, "Emissive", 0, 0, 0);
  HandleA shininess = new HandleA(400, 412, "Shininess", 1);
  Properties() {
  };
  void update() {
    ambientL.update();
    ambient.update();
    directionalL.update();
    specular.update();
    emissive.update();
    shininess.update();
  }

  void release() {
    ambientL.release();
    ambient.release();
    directionalL.release();
    specular.release();
    emissive.release();
    shininess.release();
  }

  int getAmbientR() {
    return ambient.getR();
  }
  int getAmbientG() {
    return ambient.getG();
  }
  int getAmbientB() {
    return ambient.getB();
  }
  int getAmbientLR() {
    return ambientL.getR();
  }
  int getAmbientLG() {
    return ambientL.getG();
  }
  int getAmbientLB() {
    return ambientL.getB();
  }
  int getDirectionalLR() {
    return directionalL.getR();
  }
  int getDirectionalLG() {
    return directionalL.getG();
  }
  int getDirectionalLB() {
    return directionalL.getB();
  }
  int getSpecularR() {
    return specular.getR();
  }
  int getSpecularG() {
    return specular.getG();
  }
  int getSpecularB() {
    return specular.getB();
  }
  int getEmissiveR() {
    return emissive.getR();
  }
  int getEmissiveG() {
    return emissive.getG();
  }
  int getEmissiveB() {
    return emissive.getB();
  }
  int getShininess() {
    return shininess.getA();
  }
}

class HandleA extends Handle {
  final int handleAHeight = 40;
  int x, y;
  int offsetY = 30;
  private int A;
  Handle handleA;
  String title;

  HandleA() {
  };

  HandleA(int ix, int iy, String s, int a) {
    x = ix;
    y = iy;
    handleA = new Handle(x, y + offsetY, "r", color(255, 0, 0), A = a);
    title = s;
  }

  int getA() {
    return handleA.getColor();
  }

  void release() {
    handleA.release();
  }

  void update() {
    A = getA();
    handleA.update();
    noStroke();
    fill(A);
    rect(x, y, handleWidth, offsetY - 8);
    fill(0);
    text(title + ": (" + A + ")", x + 4, y + offsetY - 12);
    stroke(0);
    noFill();
    rect(x, y, handleWidth, handleAHeight);

    fill(255);
  }
}

class HandleRGB extends HandleA {
  final int handleRGBHeight = 80;
  private int R, G, B;
  Handle handleR, handleG, handleB;

  HandleRGB() {
  };

  HandleRGB(int ix, int iy, String s, int r, int g, int b) {
    x = ix;
    y = iy;
    handleR = new Handle(x, y + offsetY, "r", color(255, 0, 0), R = r);
    handleG = new Handle(x, y + boxHeight + offsetY, "g", color(0, 255, 0), G = g);
    handleB = new Handle(x, y + 2 * boxHeight + offsetY, "b", color(0, 0, 255), B = b);
    title = s;
  }

  int getR() {
    return handleR.getColor();
  }
  int getG() {
    return handleG.getColor();
  }
  int getB() {
    return handleB.getColor();
  }

  void release() {
    handleR.release();
    handleG.release();
    handleB.release();
  }

  void update() {
    R = getR();
    G = getG();
    B = getB();
    handleR.update();
    handleG.update();
    handleB.update();
    noStroke();
    fill(R, G, B);
    rect(x, y, handleWidth, offsetY - 8);
    fill(0);
    text(title + ": (" + R + ", " + G + ", " + B + ")", x + 4, y + offsetY - 12);
    stroke(0);
    noFill();
    rect(x, y, handleWidth, handleRGBHeight);

    fill(255);
  }
}

public class Handle {
  int handleX, handleY;
  final int handleWidth = 260;
  final int boxWidth = 10, boxHeight = 20;
  int boxXleft, boxXright, boxYtop, boxYbottom; // (boxXleft, boxYbottom)縺ｨ(boxXright, boxYtop)繧貞ｷｦ荳奇ｼ悟承荳九�鬆らせ縺ｫ謖√▽box
  int value;
  color c;
  String label;
  boolean over;
  boolean press;
  boolean locked = false;

  Handle() {
  };

  Handle(int x, int y, String s, color cl, int v) {
    handleX = x;
    handleY = y;
    setBoxPosition();
    label = s;
    c = cl;
    value = v;
  }

  void setBoxPosition() {
    boxXleft = handleX + value - boxWidth / 2;
    boxYbottom = handleY - boxWidth / 2;
    boxXright = handleX + value + boxWidth / 2;
    boxYtop = handleY + boxWidth / 2;
  }

  int getColor() {
    return value;
  }

  int getValue() {
    int val = mouseX - handleX - boxWidth / 2;
    if (val < 0) return 0;
    else if (val > 255) return 255;
    else return val;
  }

  void update() {
    setBoxPosition();

    over();
    boxPress();

    if (press) {
      value = getValue();
    }

    display();
  }

  void over() {
    if (overRect(boxXleft, boxYbottom, boxXright, boxYtop)) over = true;
    else over = false;
  }

  void boxPress() {
    if (over && mousePressed || locked) {
      press = true;
      locked = true;
    } else {
      press = false;
    }
  }

  void release() {
    locked = false;
  }

  boolean overRect(int xl, int yb, int xr, int yt) {
    if (mouseX >= xl && mouseX <= xr && mouseY >= yb && mouseY <= yt) return true;
    else return false;
  }

  void display() {
    stroke(c);
    line(handleX, handleY, handleX + value, handleY);
    fill(c);
    rect(boxXleft, boxYbottom, boxWidth, boxWidth);
    stroke(0);
    if (over || press) {
      line(boxXleft, boxYbottom, boxXright, boxYtop);
      line(boxXleft, boxYtop, boxXright, boxYbottom);
    }
  }
}


//============================================================================================















//  #######  ##   ##  ##   ##    ####   ######    ####     #####   ##   ##
//   ##   #  ##   ##  ###  ##   ##  ##  # ## #     ##     ##   ##  ###  ##
//   ## #    ##   ##  #### ##  ##         ##       ##     ##   ##  #### ##
//   ####    ##   ##  ## ####  ##         ##       ##     ##   ##  ## ####
//   ## #    ##   ##  ##  ###  ##         ##       ##     ##   ##  ##  ###
//   ##      ##   ##  ##   ##   ##  ##    ##       ##     ##   ##  ##   ##
//  ####      #####   ##   ##    ####    ####     ####     #####   ##   ##
Random random = new Random(0);
double rand() {
  return -10 + 20 * random.nextDouble();
}
double gaussianDistribution(double mu, double sig) {
  double u1 = 1.0 - random.nextDouble();
  double u2 = 1.0 - random.nextDouble();
  double z = Math.sqrt(-2.0 * Math.log(u1)) * Math.cos(2.0 * Math.PI * u2);
  return mu + sig * z;
}

double true_function(double x, double y) {
  double z = 0.0;
  z += Math.sin(Math.sqrt(x*x+y*y)/2);
  z -= 4*Math.cos(y/3);
  z += Math.log10(1 + Math.pow(x+y, 4));
  return z;
}

void make_data(ArrayList<ArrayList<Double>> x, ArrayList<ArrayList<Double>> t, int n) {
  x.clear();
  t.clear();

  for (int i=0; i<n; ++i) {
    ArrayList<Double> row = new ArrayList<>();
    for (int j=0; j<2; ++j) {
      row.add(rand());
    }
    x.add(row);
    ArrayList<Double> row2 = new ArrayList<> ();
    row2.add(true_function(row.get(0), row.get(1)));
    t.add(row2);
  }
}

void make_initial_value(ArrayList<ArrayList<Double>> table, double mu, double sig) {
  int n = table.size(), m = table.get(0).size();
  for (int i=0; i<n; ++i) {
    for (int j=0; j<m; ++j) {
      table.get(i).set(j, gaussianDistribution(mu, sig));
    }
  }
}
ArrayList<ArrayList<Double>> initial_AAD(int row, int col, double num) {
  ArrayList<ArrayList<Double>> tmp = new ArrayList<>(row);
  for (int i=0; i<row; ++i) {
    ArrayList<Double> rowArray = new ArrayList<>();
    for (int j=0; j<col; ++j) {
      rowArray.add(num);
    }
    tmp.add(rowArray);
  }
  return tmp;
}

void copy_AAD(ArrayList<ArrayList<Double>> to, ArrayList<ArrayList<Double>> from) {
  int n = from.size(), m = from.get(0).size();
  for (int i=0; i<n; ++i) {
    for (int j=0; j<m; ++j) {
      to.get(i).set(j, from.get(i).get(j));
    }
  }
}


void shuffle_AAD(ArrayList<ArrayList<Double>> v, ArrayList<Integer> id) {
  int n = v.size(), m = v.get(0).size();
  ArrayList<ArrayList<Double>> tmp = initial_AAD(n, m, 0.0);
  copy_AAD(tmp, v);
  for (int i = 0; i < n; ++i) {
    for (int j = 0; j < m; ++j) {
      tmp.get(i).set(j, v.get(id.get(i)).get(j));
    }
  }
  // コピー元とコピー先で異なるインスタンスを使う
  copy_AAD(v, tmp);
}

void show_all(ArrayList<Layer> nn, int depth) {
  for (int i=0; i<40; ++i) print("=");
  println(" ");
  for (int i=0; i<depth; ++i) {
    println("depth = " + i);
    println("w");
    matrix_show(nn.get(i).w);
    println("b");
    matrix_show_b(nn.get(i).b);
    println("a");
    matrix_show(nn.get(i).a);
    println("x");
    matrix_show(nn.get(i).x);
    println("delta");
    matrix_show(nn.get(i).delta);
    println("rw");
    matrix_show(nn.get(i).rw);
    println("rb");
    matrix_show_b(nn.get(i).rb);
  }
  for (int i=0; i<40; ++i) print("=");
  println(" ");
}


//  ##   ##    ##     ######   ######    ####    ##  ##
//  ### ###   ####    # ## #    ##  ##    ##     ##  ##
//  #######  ##  ##     ##      ##  ##    ##      ####
//  #######  ##  ##     ##      #####     ##       ##
//  ## # ##  ######     ##      ## ##     ##      ####
//  ##   ##  ##  ##     ##      ##  ##    ##     ##  ##
//  ##   ##  ##  ##    ####    #### ##   ####    ##  ##

void matrix_show(ArrayList<ArrayList<Double>> a) {
  int n = a.size(), m = a.get(0).size();
  for (int i=0; i<m; ++i) print("------");
  println("-");
  for (int i=0; i<n; ++i) {
    for (int j=0; j<m; ++j) {
      print(String.format("%.2f", a.get(i).get(j)));
      if (j != m-1) {
        print(", ");
      } else {
        println(" ");
      }
    }
  }
  for (int i=0; i<m; ++i) print("------");
  println("-");
}

void matrix_show_b(ArrayList<ArrayList<Double>> a) {
  int n = a.size(), m = a.get(0).size();
  for (int i=0; i<m; ++i) print("------");
  println("-");
  int ii=0;
  for (int j=0; j<m; ++j) {
    print(String.format("%.2f", a.get(ii).get(j)));
    if (j != m-1) {
      print(", ");
    } else {
      println(" ");
    }
  }
  for (int i=0; i<m; ++i) print("------");
  println("-");
}

ArrayList<ArrayList<Double>> matrix_multi(ArrayList<ArrayList<Double>> a, ArrayList<ArrayList<Double>> b) {
  ArrayList<ArrayList<Double>> a2 = initial_AAD(a.size(), a.get(0).size(), 0);
  copy_AAD(a2, a);
  ArrayList<ArrayList<Double>> b2 = initial_AAD(b.size(), b.get(0).size(), 0);
  copy_AAD(b2, b);
  int n = a.size(), m = b.size(), l = b.get(0).size();
  ArrayList<ArrayList<Double>> c = initial_AAD(n, l, 0);
  for (int i=0; i<n; ++i) {
    for (int j=0; j<l; ++j) {
      for (int k=0; k<m; ++k) {
        c.get(i).set(j, c.get(i).get(j) + a2.get(i).get(k)*b2.get(k).get(j));
      }
    }
  }
  return c;
}

ArrayList<ArrayList<Double>> matrix_adm_multi(ArrayList<ArrayList<Double>> a, ArrayList<ArrayList<Double>> b) {
  ArrayList<ArrayList<Double>> a2 = initial_AAD(a.size(), a.get(0).size(), 0);
  copy_AAD(a2, a);
  ArrayList<ArrayList<Double>> b2 = initial_AAD(b.size(), b.get(0).size(), 0);
  copy_AAD(b2, b);
  int n = a.size(), m = a.get(0).size();
  ArrayList<ArrayList<Double>> c = initial_AAD(n, m, 0);
  for (int i=0; i<n; ++i) {
    for (int j=0; j<m; ++j) {
      c.get(i).set(j, a2.get(i).get(j) * b2.get(i).get(j));
    }
  }
  return c;
}

ArrayList<ArrayList<Double>> matrix_add(ArrayList<ArrayList<Double>> a, ArrayList<ArrayList<Double>> b) {
  ArrayList<ArrayList<Double>> a2 = initial_AAD(a.size(), a.get(0).size(), 0);
  copy_AAD(a2, a);
  ArrayList<ArrayList<Double>> b2 = initial_AAD(b.size(), b.get(0).size(), 0);
  copy_AAD(b2, b);
  int n = a.size(), m = a.get(0).size();
  ArrayList<ArrayList<Double>> c = initial_AAD(n, m, 0);
  for (int i=0; i<n; ++i) {
    for (int j=0; j<m; ++j) {
      c.get(i).set(j, a2.get(i).get(j) + b2.get(i).get(j));
    }
  }
  return c;
}

ArrayList<ArrayList<Double>> matrix_t(ArrayList<ArrayList<Double>> a) {
  ArrayList<ArrayList<Double>> a2 = initial_AAD(a.size(), a.get(0).size(), 0);
  copy_AAD(a2, a);
  int n = a.size(), m = a.get(0).size();
  ArrayList<ArrayList<Double>> c = initial_AAD(m, n, 0);
  for (int i=0; i<n; ++i) {
    for (int j=0; j<m; ++j) {
      c.get(j).set(i, a2.get(i).get(j));
    }
  }
  return c;
}

//    ##       ####   ######    ####    ##   ##    ##     ######    ####     #####   ##   ##
//   ####     ##  ##  # ## #     ##     ##   ##   ####    # ## #     ##     ##   ##  ###  ##
//  ##  ##   ##         ##       ##      ## ##   ##  ##     ##       ##     ##   ##  #### ##
//  ##  ##   ##         ##       ##      ## ##   ##  ##     ##       ##     ##   ##  ## ####
//  ######   ##         ##       ##       ###    ######     ##       ##     ##   ##  ##  ###
//  ##  ##    ##  ##    ##       ##       ###    ##  ##     ##       ##     ##   ##  ##   ##
//  ##  ##     ####    ####     ####       #     ##  ##    ####     ####     #####   ##   ##

double h_tanh(double x) {
  return (Math.exp(x) - Math.exp(-x)) / (Math.exp(x) + Math.exp(-x));
}
double h_identity(double x) {
  return x;
}
ArrayList<ArrayList<Double>> hm_identity(ArrayList<ArrayList<Double>> x) {
  ArrayList<ArrayList<Double>> y = initial_AAD(x.size(), x.get(0).size(), 0);
  copy_AAD(y, x);
  return y;
}
ArrayList<ArrayList<Double>> hm_tanh(ArrayList<ArrayList<Double>> x) {
  ArrayList<ArrayList<Double>> x2 = initial_AAD(x.size(), x.get(0).size(), 0);
  copy_AAD(x2, x);
  int n = x.size(), m = x.get(0).size();
  ArrayList<ArrayList<Double>> tmp = initial_AAD(n, m, 0);
  for (int i=0; i<n; ++i) {
    for (int j=0; j<m; ++j) {
      tmp.get(i).set(j, h_tanh(x2.get(i).get(j)));
    }
  }
  return tmp;
}
double hm_MSE(ArrayList<ArrayList<Double>> y, ArrayList<ArrayList<Double>> t) {
  int n = y.size(), m = y.get(0).size();
  if (m != 1) {
    println("not 1value regression");
    return 0;
  }
  double sum = 0;
  for (int i=0; i<n; ++i) {
    sum += Math.pow(y.get(i).get(0) - t.get(i).get(0), 2);
  }
  return sum / (2*n);
}

//  ######     ##       ####   ###  ##
//   ##  ##   ####     ##  ##   ##  ##
//   ##  ##  ##  ##   ##        ## ##
//   #####   ##  ##   ##        ####
//   ##  ##  ######   ##        ## ##
//   ##  ##  ##  ##    ##  ##   ##  ##
//  ######   ##  ##     ####   ###  ##

//  ######   ######    #####   ######     ##       ####     ##     ######    ####     #####   ##   ##
//   ##  ##   ##  ##  ##   ##   ##  ##   ####     ##  ##   ####    # ## #     ##     ##   ##  ###  ##
//   ##  ##   ##  ##  ##   ##   ##  ##  ##  ##   ##       ##  ##     ##       ##     ##   ##  #### ##
//   #####    #####   ##   ##   #####   ##  ##   ##       ##  ##     ##       ##     ##   ##  ## ####
//   ##       ## ##   ##   ##   ##      ######   ##  ###  ######     ##       ##     ##   ##  ##  ###
//   ##       ##  ##  ##   ##   ##      ##  ##    ##  ##  ##  ##     ##       ##     ##   ##  ##   ##
//  ####     #### ##   #####   ####     ##  ##     #####  ##  ##    ####     ####     #####   ##   ##

ArrayList<ArrayList<Double>> expansion_bias(ArrayList<ArrayList<Double>> b, int batch) {
  ArrayList<ArrayList<Double>> c = initial_AAD(0, 0, 0);
  for (int i=0; i<batch; ++i) {
    c.add(new ArrayList<>(b.get(0)));
    //c.add(b.get(0));
  }
  return c;
}
ArrayList<ArrayList<Double>> calc_r_bias(ArrayList<ArrayList<Double>> b, ArrayList<ArrayList<Double>> delta) {
  ArrayList<ArrayList<Double>> d2 = initial_AAD(delta.size(), delta.get(0).size(), 0);
  copy_AAD(d2, delta);
  int n = b.size(), m = b.get(0).size();
  ArrayList<ArrayList<Double>> rb = initial_AAD(1, m, 0);
  for (int j=0; j<m; ++j) {
    for (int i=0; i<n; ++i) {
      rb.get(0).set(j, rb.get(0).get(j) + d2.get(i).get(j));
    }
  }
  rb = expansion_bias(rb, n);
  return rb;
}
ArrayList<ArrayList<Double>> calc_r_identity(ArrayList<ArrayList<Double>> x) {
  int n = x.size(), m = x.get(0).size();
  ArrayList<ArrayList<Double>> tmp = initial_AAD(n, m, 1);
  return tmp;
}
ArrayList<ArrayList<Double>> calc_r_tanh(ArrayList<ArrayList<Double>> a) {
  ArrayList<ArrayList<Double>> a2 = initial_AAD(a.size(), a.get(0).size(), 0);
  copy_AAD(a2, a);
  int n = a.size(), m = a.get(0).size();
  ArrayList<ArrayList<Double>> tmp = initial_AAD(n, m, 0);
  for (int i=0; i<n; ++i) {
    for (int j=0; j<m; ++j) {
      double x = a2.get(i).get(j);
      tmp.get(i).set(j, (double)4 / (Math.exp(-x) + Math.exp(x)) / (Math.exp(-x) + Math.exp(x)));
    }
  }
  return tmp;
}

ArrayList<ArrayList<Double>> calc_r_MSE(ArrayList<ArrayList<Double>> y, ArrayList<ArrayList<Double>> t) {
  ArrayList<ArrayList<Double>> y2 = initial_AAD(y.size(), y.get(0).size(), 0);
  copy_AAD(y2, y);
  ArrayList<ArrayList<Double>> t2 = initial_AAD(t.size(), t.get(0).size(), 0);
  copy_AAD(t2, t);
  int n = y.size(), m = y.get(0).size();
  ArrayList<ArrayList<Double>> tmp = initial_AAD(n, m, 0);
  if (m != 1) {
    println("not 1value regression");
    return tmp;
  }
  for (int i=0; i<n; ++i) {
    tmp.get(i).set(0, (y2.get(i).get(0) - t2.get(i).get(0)) / n);
  }
  return tmp;
}

void update_weights(ArrayList<ArrayList<Double>> w, ArrayList<ArrayList<Double>> rw, double eta) {
  ArrayList<ArrayList<Double>> w2 = initial_AAD(w.size(), w.get(0).size(), 0);
  copy_AAD(w2, w);
  ArrayList<ArrayList<Double>> rw2 = initial_AAD(rw.size(), rw.get(0).size(), 0);
  copy_AAD(rw2, rw);
  int n = w.size(), m = w.get(0).size();
  for (int i=0; i<n; ++i) {
    for (int j=0; j<m; ++j) {
      w.get(i).set(j, w2.get(i).get(j) - eta * rw2.get(i).get(j));
    }
  }
}
