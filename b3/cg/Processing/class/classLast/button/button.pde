Button button;
int number = 0;

void setup() {
  size(800, 600, P3D);
  button = new Button(100, 100, 100, 50, "+");
}

void draw() {
  background(220);
  lights();
  translate(width/2, height/2, 0);
  rotateY(frameCount * 0.01);
  button.display();
  
  // 数字の表示
  fill(0);
  textSize(48);
  textAlign(CENTER, CENTER);
  text(number, 0, 0);
}

void mousePressed() {
  if (button.isClicked(mouseX, mouseY)) {
    number++; // ボタンがクリックされたら数字を増加
  }
}

class Button {
  float x, y, w, h;
  String label;

  Button(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }

  void display() {
    pushMatrix();
    translate(x, y, 0);
    fill(200);
    box(w, h, 10);
    fill(0);
    textSize(24);
    textAlign(CENTER, CENTER);
    text(label, 0, 0);
    popMatrix();
  }
  
  boolean isClicked(float mx, float my) {
    // マウスの座標がボタンの範囲内にあるかをチェック
    return (mx > x - w/2 && mx < x + w/2 && my > y - h/2 && my < y + h/2);
  }
}
