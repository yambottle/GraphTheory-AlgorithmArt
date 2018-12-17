
PImage imgs[] = new PImage[3];
int imgIndex = -1;
PImage img;
Paint paint;
int subStep = 800;
int z = 0;
boolean isStop = false;

void setup(){
  setCanvas();
  preload();
  img = createImage(width, height, RGB);
  nextImage();
  paint = new Paint(new PVector(width/2, height/2));
  background(255, 255, 255);
  colorMode(RGB, 255, 255, 255, 255);
}

void preload(){
  imgs[0] = loadImage("test1.png");
  imgs[1] = loadImage("test2.png");
  imgs[2] = loadImage("test3.png");
}

void nextImage() {
  if (img==null) return;
  imgIndex = (++imgIndex) % imgs.length;
  PImage targetImg = imgs[imgIndex];
  img.copy(targetImg, 0, 0, targetImg.width, targetImg.height, 0, 0, img.width, img.height);
  //original comment//img.resize(width, height);
  img.loadPixels();
  clear();
}

void setCanvas(){
  int rectW = 1000;
  background(255);
  int rectX = (displayWidth-rectW)/2;
  int rectY = (displayHeight-rectW)/2;
  rect(rectX,rectY,rectW,rectW);
}

void draw(){
  if (!isStop) {
    for (int i = 0 ; i < subStep ; i++) {
      //paint.update();
      //paint.show();
      z+= 0.01;
    }
  }
}

color fget(int i, int j) {
  int index = j * img.width + i;
  index *= 4;
  return color(img.pixels[index], img.pixels[index+1], img.pixels[index+2], img.pixels[index+3]);
}

void fset(int i, int j, color c) {
  int index = j * img.width + i;
  index *= 4;
  img.pixels[index] = (int)red(c);
  img.pixels[index+1] = (int)green(c);
  img.pixels[index+2] = (int)blue(c);
  img.pixels[index+3] = (int)alpha(c);
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    isStop = !isStop;
  } 
}
void mouseClicked() {
  nextImage();
}
