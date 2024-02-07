// JavaのArrayListをProcessingで使用する例

// インポート文（Processingでは自動的に追加されることが一般的）
import java.util.ArrayList;
import java.util.Collections;
import java.util.Random;
import java.util.Arrays;

void setup() {
  ArrayList<ArrayList<Double>> x = new ArrayList<> ();
  ArrayList<ArrayList<Double>> t = new ArrayList<> ();
  make_data(x, t, 6);
  for (ArrayList<Double> row : x) {
    println(row);
  }
  for (ArrayList<Double> row : t) {
    println(row);
  }
  make_initial_value(x, 0, 1);
  for (ArrayList<Double> row : x) {
    println(row);
  }

  ArrayList<Integer> id = new ArrayList<>();
  for (int i=0; i<6; ++i) {
    id.add(i);
  }
  Collections.shuffle(id, random);
  println(id);


  shuffle_AAD(x, id);
  for (ArrayList<Double> row : x) {
    println(row);
  }
  matrix_show(x);

  ArrayList<ArrayList<Double>> a = initial_AAD(2, 3, 1);
  ArrayList<ArrayList<Double>> b = initial_AAD(3, 1, 2);
  a.get(0).set(2, (double)(4));
  matrix_show(a);
  ArrayList<ArrayList<Double>> c = matrix_multi(a, b);
  matrix_show(b);
  matrix_show(c);

  ArrayList<ArrayList<Double>> d = expansion_bias(a, 5);
  matrix_show(d);
  d.get(0).set(1, (double)3);
  matrix_show(d);
  matrix_show(a);
  d = expansion_bias(d, 5);
  matrix_show(d);
  a = initial_AAD(2, 3, 1);
  b = initial_AAD(2, 3, 2);
  //matrix_show(a);
  //matrix_show(b);
  //copy_AAD(a, b);
  //matrix_show(a);
  //matrix_show(b);
  //a.get(1).set(1, (double)3);
  //matrix_show(a);
  //matrix_show(b);


  main();
}


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

void main() {
  ArrayList<ArrayList<Double>> x = initial_AAD(0, 0, 0);
  ArrayList<ArrayList<Double>> t = initial_AAD(0, 0, 0);
  double eta = 0.03, attenuation = 0.4;
  int n = 10000;
  int show_interval = 1000;
  int learning_plan = 1000;
  int loop = 10000;
  int batch_size = 32;
  ArrayList<Integer> nn_form = new ArrayList<> (Arrays.asList(2, 6, 8, 4, 1));
  //ArrayList<Integer> nn_form = new ArrayList<> (Arrays.asList(2, 4, 1));
  int depth = nn_form.size()-1;

  Layer layer = new Layer();
  ArrayList<Layer> nn = layer.createLayerList(depth);
  ArrayList<Integer> id = new ArrayList<>();
  for (int i=0; i<n; ++i) {
    id.add(i);
  }

  //Heの初期化
  for (int i=0; i<depth; ++i) {
    nn.get(i).w = initial_AAD(nn_form.get(i), nn_form.get(i+1), 0);
    nn.get(i).b = initial_AAD(batch_size, nn_form.get(i+1), 0);
    make_initial_value(nn.get(i).w, 0, Math.sqrt(2.0/nn_form.get(i)));
    make_initial_value(nn.get(i).b, 0, Math.sqrt(2.0/nn_form.get(i)));
    nn.get(i).b = expansion_bias(nn.get(i).b, batch_size);
  }

  println("first parameters");
  for (int i=0; i<depth; ++i) {
    println("w " + i);
    matrix_show(nn.get(i).w);
  }
  for (int i=0; i<depth; ++i) {
    println("b " + i);
    matrix_show_b(nn.get(i).b);
  }

  make_data(x, t, n);

  //learn
  for (int i=0; i<loop; ++i) {
    ArrayList<ArrayList<Double>> x0 = initial_AAD(0, 0, 0);
    ArrayList<ArrayList<Double>> t0 = initial_AAD(0, 0, 0);
    Collections.shuffle(id, random);
    shuffle_AAD(t, id);
    shuffle_AAD(x, id);

    //choice top batch_size
    for (int j=0; j<batch_size; ++j) {
      x0.add(new ArrayList<>(x.get(j)));
      t0.add(new ArrayList<>(t.get(j)));
    }

    //forward propagation
    for (int k=0; k<depth; ++k) {
      if (k == 0) nn.get(k).a = matrix_add(matrix_multi(x0, nn.get(k).w), nn.get(k).b);
      else nn.get(k).a = matrix_add(matrix_multi(nn.get(k-1).x, nn.get(k).w), nn.get(k).b);
      if (k < depth-1) nn.get(k).x = hm_tanh(nn.get(k).a);
      else nn.get(k).x = hm_identity(nn.get(k).a);
    }

    //back propagation
    for (int k=depth-1; k>=0; --k) {
      if (k == depth-1) {
        ArrayList<ArrayList<Double>> r_fL_xk = calc_r_MSE(nn.get(k).x, t0);
        ArrayList<ArrayList<Double>> r_hk_ak = calc_r_identity(nn.get(k).x);
        nn.get(k).delta = matrix_adm_multi(r_fL_xk, r_hk_ak);
      } else {
        ArrayList<ArrayList<Double>> r_h_a = calc_r_tanh(nn.get(k).a);
        nn.get(k).delta = matrix_adm_multi(r_h_a, matrix_multi(nn.get(k+1).delta, matrix_t(nn.get(k+1).w)));
      }

      nn.get(k).rb = calc_r_bias(nn.get(k).b, nn.get(k).delta);
      if (k != 0) nn.get(k).rw = matrix_multi(matrix_t(nn.get(k-1).x), nn.get(k).delta);
      else nn.get(k).rw = matrix_multi(matrix_t(x0), nn.get(k).delta);
    }

    //update parameters
    for (int k=0; k<depth; ++k) {
      update_weights(nn.get(k).w, nn.get(k).rw, eta);
      update_weights(nn.get(k).b, nn.get(k).rb, eta);
    }



    //update learning plan
    if ((i+1) % learning_plan == 0) eta *= attenuation;

    if (i % show_interval == 0) {
      print(i + " MSE ");
      println(hm_MSE(nn.get(depth-1).x, t0));
    }

    //println("===========================i= "+i);
    //show_all(nn, depth);
  }
  //================================================
  // train set
  for (int i=0; i<40; ++i) print("=");
  println(" ");
  println("train set");
  for (int i=0; i<depth; ++i) {
    nn.get(i).b = expansion_bias(nn.get(i).b, n);
  }
  //formard propagation
  for (int k=0; k<depth; ++k) {
    if (k == 0) nn.get(k).a = matrix_add(matrix_multi(x, nn.get(k).w), nn.get(k).b);
    else nn.get(k).a = matrix_add(matrix_multi(nn.get(k-1).x, nn.get(k).w), nn.get(k).b);
    if (k < depth-1) nn.get(k).x = hm_tanh(nn.get(k).a);
    else nn.get(k).x = hm_identity(nn.get(k).a);
  }
  println("MSE = " + hm_MSE(nn.get(depth-1).x, t));
  for (int i=0; i<40; ++i) print("=");
  println(" ");
  //================================================

  //================================================
  // test set
  for (int i=0; i<40; ++i) print("=");
  println(" ");
  println("test set");
  make_data(x, t, n);
  //formard propagation
  for (int k=0; k<depth; ++k) {
    if (k == 0) nn.get(k).a = matrix_add(matrix_multi(x, nn.get(k).w), nn.get(k).b);
    else nn.get(k).a = matrix_add(matrix_multi(nn.get(k-1).x, nn.get(k).w), nn.get(k).b);
    if (k < depth-1) nn.get(k).x = hm_tanh(nn.get(k).a);
    else nn.get(k).x = hm_identity(nn.get(k).a);
  }
  println("MSE = " + hm_MSE(nn.get(depth-1).x, t));
  for (int i=0; i<40; ++i) print("=");
  println(" ");
  //================================================
}












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
  //if (to.size() != from.size() || to.get(0).size() != from.get(0).size()) {
  //  println("The matrix sizes are different.");
  //  return ;
  //}
  int n = from.size(), m = from.get(0).size();
  for (int i=0; i<n; ++i) {
    for (int j=0; j<m; ++j) {
      to.get(i).set(j, from.get(i).get(j));
    }
  }
}

//void shuffle_AAD(ArrayList<ArrayList<Double>> v, ArrayList<Integer> id) {
//  int n = v.size(), m = v.get(0).size();
//  ArrayList<ArrayList<Double>> tmp = initial_AAD(n, m, 0.0);
//  copy_AAD(tmp, v);
//  for (int i=0; i<n; ++i) {
//    for (int j=0; j<m; ++j) {
//      tmp.get(i).set(j, v.get(id.get(i)).get(j));
//    }
//  }
//  copy_AAD(v, tmp);
//}
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
