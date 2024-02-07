void setup(){
  size(400,400,P3D);
  noStroke();
}
float n=0,r=10;

void draw(){
  lights();
  background(20);
  translate(200,200,-50);
  rotateX(radians(160));
  rotateY(radians(-30));
  
  float theta = n;
  float theta2 = theta+2*PI/3;
  float theta3 = theta+4*PI/3;

  pushMatrix();
    spotLight(255,0,0,0,100,0,r*sin(theta),-50,r*cos(theta),PI/2,100);
    spotLight(0,255,0,0,100,0,r*sin(theta2),-50,r*cos(theta2),PI/2,100);
    spotLight(0,0,255,0,100,0,r*sin(theta3),-50,r*cos(theta3),PI/2,100);
  popMatrix();
  n+=0.07*PI;
  draw_floor();
}

void draw_floor(){
  fill(150);
  int s=10;
  for(int z=-100;z<100;z+=s)for(int x=-100;x<100;x+=s){
    beginShape(QUADS);
      vertex(x,0,z);
      vertex(x,0,z+s);
      vertex(x+s,0,z+s);
      vertex(x+s,0,z);
    endShape();
  }
}
