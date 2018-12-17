//canvas center x,y
int rectX = 0;
int rectY = 0;
//canvas r=rectW/2 [square(r)*pi>dense], for 8000, minR is 51
int rectW = 500;
int dense = 8000;
int avgD = 128;
float r = sqrt(avgD*PI*sq(rectW/2)/dense/PI);
//Degree Test
int maxDgr = 0;
int dgr[] = new int[500];

void setup(){
  fullScreen(P3D);
  noLoop();
}

void draw(){
  setCanvas();
  //genPoints(p);//testPoints(p);
  //conPoints(p);
  //testRGG();//test is not good
}

void setCanvas(){
  background(255);
  rectX = (displayWidth)/2;
  rectY = (displayHeight)/2;
  noStroke();
  translate(rectX,rectY);
  sphere(rectW/2);
  lights();
}