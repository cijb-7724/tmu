Button3D button;
int number = 0;

void setup() {
  size(1000, 1000, P3D);
  button = new Button3D(100, 1000, -100, 100, 50, "+");
}

void draw() {
  background(220);
  lights();
  button.display();
  
  // 数字の表示
  fill(0);
  textSize(48);
  textAlign(CENTER, CENTER);
  text(number, width/2, height/2);
}

void mouseClicked() {
  if (button.isClicked(mouseX, mouseY)) {
    number++;
    println("clicked");
  }
}

class Button3D {
  float x, y, z;
  float w, h;
  String label;

  Button3D(float x, float y, float z, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = w;
    this.h = h;
    this.label = label;
  }

  void display() {
    pushMatrix();
    translate(x, y, z);
    fill(200);
    box(w, h, 10);
    fill(0);
    textSize(24);
    textAlign(CENTER, CENTER);
    text(label, 0, 0);
    popMatrix();
  }
  
  boolean isClicked(float mx, float my) {
    float buttonX = screenX(x, y, z); // ボタンの3D座標を2D座標に変換
    float buttonY = screenY(x, y, z);
    return (mx > buttonX - w/2 && mx < buttonX + w/2 && my > buttonY - h/2 && my < buttonY + h/2);
  }
}
