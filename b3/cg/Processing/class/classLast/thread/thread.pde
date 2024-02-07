// メインスレッドで描画処理を行うかどうかを制御するフラグ
boolean isProcessing = false;
int result = 0; // 処理の結果を保持する変数
void setup() {
  size(800, 600);
  background(255);
  // 結果を描画する
  textSize(32);
  textAlign(CENTER, CENTER);
}
int h = 0;
void draw() {
  // もし処理中でなければ、時間のかかる処理を開始する
  if (!isProcessing) {
    // 時間のかかる処理を開始するための関数を呼び出す
    startLongProcess();
    isProcessing = true;
  }
  ++h;
  if (h % 100 == 0) println("here " + h);
  // 処理が終了したら描画を行う
  if (!isProcessing) {
    println("Drawing..."); // 描画開始のログを出力
    // 描画処理を行う関数を呼び出す
    render();
    println("Drawn"); // 描画完了のログを出力
  }
}
void startLongProcess() {
  // 時間のかかる処理を別のスレッドで実行する
  Thread longProcessThread = new Thread(new Runnable() {
    public void run() {
      println("Processing..."); // 処理開始のログを出力
      // 時間のかかる処理を行う
      performLongProcess();
      // 処理が完了したらフラグを更新して描画処理を再開する
      isProcessing = false;
      println("Processed"); // 処理完了のログを出力
    }
  }
  );
  longProcessThread.start();
}
void performLongProcess() {
  // 時間のかかる処理をシミュレートするために数秒間待機する
  delay(5000); // 5秒間待機
  // 仮の結果を計算する
  println("dekitaaaaaaaaaaaaaaaaaaaaaaa");
  result = 42;
}
void render() {
  // 結果を描画する
  text("Result: " + result, width/2, height/2);
}
