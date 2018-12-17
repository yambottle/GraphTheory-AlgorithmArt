//canvas beginning point x,y
int rectX = 0;
int rectY = 0;
//canvas width [square(width)>dense], for 128000, minWidth is 358
int rectW = 800;
int strkWidth = 5;
int dense = 32000;
int avgD = 128;
int r = int(sqrt(avgD*rectW*rectW/dense/PI));
//Degree Test
int maxDgr = 0;
int minDgr = 100000;
int dgr[] = new int[200];
int sum = 0;

void setup(){
  fullScreen();
  smooth();
  noLoop();
}

void draw(){
  int p[][] = new int[rectW+2*r][rectW+2*r];//coordinate
  setCanvas();
  initCord(p);
  genPoints(p);//testPoints(a);
  conPointsBound(p);
  testRGG();
}

void setCanvas(){
  background(255);
  rectX = (displayWidth-rectW)/2;
  rectY = (displayHeight-rectW)/2;
  rect(rectX,rectY,rectW,rectW);
}

void initCord(int p[][]){
  for(int i = 0;i<rectW;i++){
    for(int j = 0;j<rectW;j++){
      if(i<r||j<r||i>rectW+r||j>rectW+r)p[i][j]=0;
    }
  }
}

void genPoints(int p[][]){
  stroke(0);
  strokeWeight(2);
  for(int i=0;i<dense;i++){
    int x;
    int y;
    while(true){//verify random, no collision
      x=(int)random(r,rectW+r);
      y=(int)random(r,rectW+r);
      if(p[x][y]==1){
        continue;
      }else{
        break;
      }
    }
    point(rectX+x-r,rectY+y-r);
    p[x][y] = 1;
  }
}

void conPointsBound(int p[][]){
  stroke(0,30);
  strokeWeight(0.1);
  for(int i = r; i<rectW+r; i++){
    for(int j = r; j<rectW+r; j++){
      if(p[i][j]==0)continue;
      //important
      int count = 0;
      for(int m = i-r; m<i+r;m++){
        for(int n = j-r; n<j+r;n++){
          if(p[m][n]!=1)continue;
          if(sqrt(sq(abs(i-m))+sq(abs(j-n)))<=r){
            count++;
            line(rectX+i-r,rectY+j-r,rectX+m-r,rectY+n-r);
          }
        }
      }
      dgr[count]++;
      sum+=count;
      if(count>maxDgr)maxDgr=count;
      if(count<minDgr)minDgr=count;
    }
  }
  //println(maxDgr);
}

void testPoints(int p[][]){
  int num = 0;
  for(int i = 0; i<rectW;i++){
    for(int j = 0; j<rectW;j++){
      if(p[i][j]==1)num++;
    }
  }
  println("Num is:"+num);
}

void testRGG(){
  println("Exiting at " + millis()/1000.0 + " seconds");
  for(int i = 0;i<200;i++){
    if(dgr[i]!=0)
      println(i+"\t"+dgr[i]);
  }
  println("avg:"+sum/dense);
  println("M:"+sum);
  println("min:"+minDgr);
  println("max:"+maxDgr);
}