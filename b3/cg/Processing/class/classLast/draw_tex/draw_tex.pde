PImage img; // 画像を保持する変数

void setup() {
  img = loadImage("tex.png"); // 画像の読み込み
  size(800, 600);
  background(255); // 白背景を描画
}

void draw() {
  if (img != null) { // 画像が読み込まれている場合
    float imgWidth = img.width;
    float imgHeight = img.height;
    float aspectRatio = imgWidth / imgHeight;

    // 画面サイズに合わせて画像のサイズを調整
    if (imgWidth > width || imgHeight > height) {
      if (imgWidth > imgHeight) {
        imgWidth = width;
        imgHeight = width / aspectRatio;
      } else {
        imgHeight = height;
        imgWidth = height * aspectRatio;
      }
    }

    // 画像を中央に配置
    float x = (width - imgWidth) / 2;
    float y = (height - imgHeight) / 2;
    image(img, x, y, imgWidth, imgHeight);
  } else {
    println("画像が読み込まれていません");
  }
}
