Properties p;

int[][] amb = {{102,153,10},{0,0,0},{125,31,100}};
int[][] spe = {{63,62,78},{225,221,200},{0,0,128}};
int[][] emi = {{99,98,150},{106,99,46},{106,99,46}};
int[] shi = {10,10,50};

void setup(){
  size(1000, 600, P3D);
  textFont(createFont("ArialMT", 18), 18);
  p = new Properties();
}


void draw(){
  background(0);
  noStroke();
  sphereDetail(120);
  lightSpecular(25, 225, 55);
  directionalLight(p.getDirectionalLR(), p.getDirectionalLG(), p.getDirectionalLB(), -.5, .5, -1);
  ambientLight(p.getAmbientLR(), p.getAmbientLG(), p.getAmbientLB());
  
  pushMatrix();
    ambient(amb[0][0], amb[0][1], amb[0][2]);
    specular(spe[0][0], spe[0][1], spe[0][2]);
    emissive(emi[0][0], emi[0][1], emi[0][2]);
    shininess(shi[0]);
    translate(250, height / 2, 0); 
    sphere(100);
      
    ambient(amb[1][0], amb[1][1], amb[1][2]);
    specular(spe[1][0], spe[1][1], spe[1][2]);
    emissive(emi[1][0], emi[1][1], emi[1][2]);
    shininess(shi[1]);
    translate(250, 0, 0); 
    sphere(100);
      
    ambient(amb[2][0], amb[2][1], amb[2][2]);
    specular(spe[2][0], spe[2][1], spe[2][2]);
    emissive(emi[2][0], emi[2][1], emi[2][2]);
    shininess(shi[2]); 
    translate(250, 0, 0); 
    sphere(100);
  popMatrix();
  
}

void mouseReleased(){
  p.release();
}

class Properties{
  HandleRGB ambientL = new HandleRGB(400, 2, "AmbientLight", 128, 128, 128);
  HandleRGB ambient = new HandleRGB(400, 84, "Ambient", 128, 128, 128);
  HandleRGB directionalL = new HandleRGB(400, 166, "DirectionalLight", 128, 128, 128);
  HandleRGB specular = new HandleRGB(400, 248, "Specular", 128, 128, 128);
  HandleRGB emissive = new HandleRGB(400, 330, "Emissive", 0, 0, 0);
  HandleA shininess = new HandleA(400, 412, "Shininess", 1); 
  Properties(){};
  void update(){
    ambientL.update();
    ambient.update();
    directionalL.update();
    specular.update();
    emissive.update();
    shininess.update();
  }
  
  void release(){
    ambientL.release();
    ambient.release();
    directionalL.release();
    specular.release();
    emissive.release();
    shininess.release();
  }
  
  int getAmbientR(){ return ambient.getR(); }
  int getAmbientG(){ return ambient.getG(); }
  int getAmbientB(){ return ambient.getB(); }
  int getAmbientLR(){ return ambientL.getR(); }
  int getAmbientLG(){ return ambientL.getG(); }
  int getAmbientLB(){ return ambientL.getB(); }
  int getDirectionalLR(){ return directionalL.getR(); }
  int getDirectionalLG(){ return directionalL.getG(); }
  int getDirectionalLB(){ return directionalL.getB(); }
  int getSpecularR(){ return specular.getR(); }
  int getSpecularG(){ return specular.getG(); }
  int getSpecularB(){ return specular.getB(); }
  int getEmissiveR(){ return emissive.getR(); }
  int getEmissiveG(){ return emissive.getG(); }
  int getEmissiveB(){ return emissive.getB(); }
  int getShininess(){ return shininess.getA(); }
}

class HandleA extends Handle{
  final int handleAHeight = 40;
  int x, y;
  int offsetY = 30;
  private int A;
  Handle handleA;
  String title;
  
  HandleA(){};
  
  HandleA(int ix, int iy, String s, int a){
    x = ix; y = iy;
    handleA = new Handle(x, y + offsetY, "r", color(255, 0, 0), A = a);
    title = s;
  }
  
  int getA(){ return handleA.getColor(); }
  
  void release(){
    handleA.release();
  }
  
  void update(){
    A = getA();
    handleA.update();
    noStroke(); fill(A);
    rect(x, y, handleWidth, offsetY - 8);
    fill(0);
    text(title + ": (" + A + ")", x + 4, y + offsetY - 12);
    stroke(0); noFill();
    rect(x, y, handleWidth, handleAHeight);

    fill(255);
  }
}

class HandleRGB extends HandleA{
  final int handleRGBHeight = 80;
  private int R, G, B;
  Handle handleR, handleG, handleB;
  
  HandleRGB(){};
  
  HandleRGB(int ix, int iy, String s, int r, int g, int b){
    x = ix; y = iy;
    handleR = new Handle(x, y + offsetY, "r", color(255, 0, 0), R = r);
    handleG = new Handle(x, y + boxHeight + offsetY, "g", color(0, 255, 0), G = g);
    handleB = new Handle(x, y + 2 * boxHeight + offsetY, "b", color(0, 0, 255), B = b);
    title = s;
  }
  
  int getR(){ return handleR.getColor(); }
  int getG(){ return handleG.getColor(); }
  int getB(){ return handleB.getColor(); }
  
  void release(){
    handleR.release();
    handleG.release();
    handleB.release();
  }
  
  void update(){
    R = getR(); G = getG(); B = getB();
    handleR.update();
    handleG.update();
    handleB.update();
    noStroke(); fill(R, G, B);
    rect(x, y, handleWidth, offsetY - 8);
    fill(0);
    text(title + ": (" + R + ", " + G + ", " + B + ")", x + 4, y + offsetY - 12);
    stroke(0); noFill();
    rect(x, y, handleWidth, handleRGBHeight);

    fill(255);
  }
}

public class Handle{
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
  
  Handle(){};
  
  Handle(int x, int y, String s, color cl, int v){
    handleX = x; handleY = y;
    setBoxPosition();
    label = s;
    c = cl;
    value = v;
  }
  
  void setBoxPosition(){
    boxXleft = handleX + value - boxWidth / 2;  boxYbottom = handleY - boxWidth / 2;
    boxXright = handleX + value + boxWidth / 2; boxYtop = handleY + boxWidth / 2;
  }
  
  int getColor(){ return value; }
  
  int getValue(){
    int val = mouseX - handleX - boxWidth / 2;
    if(val < 0) return 0;
    else if(val > 255) return 255;
    else return val;
  } 
  
  void update(){
    setBoxPosition();

    over();
    boxPress();
    
    if(press) {
      value = getValue();
    }
    
    display();
  }
  
  void over(){
    if(overRect(boxXleft, boxYbottom, boxXright, boxYtop)) over = true;
    else over = false;
  }
  
  void boxPress(){
    if(over && mousePressed || locked) {
      press = true;
      locked = true;
    }
    else{
      press = false;
    }
  }
  
  void release(){
    locked = false;
  }
  
  boolean overRect(int xl, int yb, int xr, int yt){
    if (mouseX >= xl && mouseX <= xr && mouseY >= yb && mouseY <= yt) return true;
    else return false;
  }
  
  void display(){
    stroke(c);
    line(handleX, handleY, handleX + value, handleY);
    fill(c);
    rect(boxXleft, boxYbottom, boxWidth, boxWidth);
    stroke(0);
    if(over || press) {
      line(boxXleft, boxYbottom, boxXright, boxYtop);
      line(boxXleft, boxYtop, boxXright, boxYbottom);
    }
  }
}
