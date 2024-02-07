PImage img; 
float[][] sovelH = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}}; // horizontal direction
float[][] sovelV = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}}; // vertical direction
float[] dH,dV,dist,size;
int all_pixel;
  
void setup(){
  img=loadImage("screenshot.png");
  surface.setSize(img.width, img.height);
  all_pixel = img.width * img.height;
  noStroke();
  frameRate(500);
  background(255);
  ellipseMode(CENTER);
  dH=filtering(sovelH);
  dV=filtering(sovelV);
  dist=grad_dist();
  size=grad_size();
}

float[] filtering(float filter[][]){
  float ans[] = new float[all_pixel];
  for (int i=0; i<all_pixel; ++i) ans[i] = 0;
  for (int i=1; i<img.height-1; ++i) for (int j=1; j<img.width; ++j) for (int ii=-1; ii<=1; ++ii) for (int jj=-1; jj<=1; ++jj) {
    ans[i * img.width + j] += filter[ii+1][jj+1] * red(img.pixels[(j+jj) * img.width + (i+ii)]);
  }
  return ans;
}

float[] grad_size(){
  float mx = 0;
  float[] ans = new float[all_pixel];
  for(int i=0; i<all_pixel; ++i){
    ans[i] = sqrt(sq(dH[i]) + sq(dV[i]));
    mx = max(mx, ans[i]);
  }
  mx /= 41;
  for(int i=0; i<all_pixel; ++i) ans[i] /= mx;
  return ans;
}

float[] grad_dist(){
  float[] ans = new float[all_pixel];
  for(int i=0; i<all_pixel; ++i) ans[i] = atan2(dH[i], dV[i]);
  return ans;
}

void draw(){
  int x = int(random(img.width)), y = int(random(img.height));
  color c = img.get(x,y);
  fill(c);
  pushMatrix();
  translate(x, y);
  rotate(dist[y * img.width+x]);
  float dx = size[y * img.width +x] + 5;
  float dy =  sqrt(size[y* img.width +x] + 5);
  //float dy =  size[y* img.width +x] + 5;
  
  ellipse(0, 0, dx*5,dy*5);
  popMatrix();
}
