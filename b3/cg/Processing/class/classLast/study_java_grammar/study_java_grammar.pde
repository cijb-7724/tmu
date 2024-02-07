// JavaのArrayListをProcessingで使用する例

// インポート文（Processingでは自動的に追加されることが一般的）
import java.util.ArrayList;
import java.util.Collections;

void setup() {
  // 新しいArrayListの作成
  ArrayList<Integer> numbers = new ArrayList<Integer>();
   

  // 要素の追加
  numbers.add(10);
  numbers.add(40);
  numbers.add(30);
  
  println(numbers);
  Collections.sort(numbers);
  //Collections.sort(numbers, Collections.reverseOrder());
  
  println(numbers);

  // 要素の取得
  int firstElement = numbers.get(0);
  println("First Element: " + firstElement);

  // 要素の変更
  numbers.set(1, 25);

  // 要素の削除
  numbers.remove(1);

  // ArrayListの中身を表示
  println("ArrayList: " + numbers);

  // 要素数の取得
  int size = numbers.size();
  println("Size: " + size);
  
  ArrayList<ArrayList<Integer>> twoDArrayList = new ArrayList<>();

  // 各行のArrayListを追加
  for (int i = 0; i < 3; i++) {
      ArrayList<Integer> row = new ArrayList<>();
      for (int j = 0; j < 4; j++) {
          // 2次元ArrayListに要素を追加
          row.add(i * 4 + j + 1);
      }
      // 各行のArrayListを2次元ArrayListに追加
      twoDArrayList.add(row);
  }

  // 2次元ArrayListの中身を表示
  for (ArrayList<Integer> row : twoDArrayList) {
      println(row);
  }
}
