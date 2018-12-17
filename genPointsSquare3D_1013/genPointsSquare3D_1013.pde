import java.lang.reflect.Type;
import java.util.Map;
//canvas beginning point x,y
int rectX = 0;
int rectY = 0;
//canvas width [square(width)>dense], for 128000, minWidth is 358
int rectW = 500;
int dense = 32000;
int avgD = 128;
int r = int(sqrt(avgD*rectW*rectW/dense/PI));//float???
//Degree Test
int maxDgr = 0;
int dgr[] = new int[5000];
int sum=0;
HashMap result = new HashMap<String, String>();
Gson gson = new Gson();
Type type = new TypeToken<ArrayList<Object>>(){}.getType();

void setup(){
  fullScreen();
  noLoop();
}

class Point{
  float x;
  float y;
}

void draw(){
  ArrayList cell[][] = new ArrayList[rectW/r+1][rectW/r+1];
  setCanvas();
  genPoints(cell);
  //println(result.size());
  //testCell(cell);
  conPointsBound(cell);
  testRGG();
  //println("Exiting at " + millis()/1000.0 + " seconds");
}

void setCanvas(){
  background(255);
  rectX = (displayWidth-rectW)/2;
  rectY = (displayHeight-rectW)/2;
  rect(rectX,rectY,rectW,rectW);
}

void genPoints(ArrayList cell[][]){
  strokeWeight(1);
  for(int i=0;i<dense;i++){
    float x=random(rectW);
    float y=random(rectW);
    Point newP = new Point();
    newP.x = x;
    newP.y = y;
    if(cell[int(x/r)][int(y/r)]==null){
      cell[int(x/r)][int(y/r)] = new ArrayList<Point>();
    }
    cell[int(x/r)][int(y/r)].add(newP);
    //result.put(String.valueOf(x)+","+String.valueOf(y), gson.toJson(new ArrayList<Point>()));
    point(rectX+x,rectY+y);
  }
}

void conPointsBound(ArrayList cell[][]){
  for(int i=0; i<rectW/r+1;i++){
    for(int j=0; j<rectW/r+1;j++){
      if(cell[i][j]==null)
        continue;
      int m=i;
      int n=j;
      int count = 0;
      for(int cnum=0;cnum<5;cnum++){
        if(m<0||n<0||m>rectW/r||n>rectW/r||cell[m][n]==null){
          continue;
        }else{
          compareTwoCells(cell,i,j,m,n);
        }
        //cell self
        if(m==i&&n==j){
          ++n;
        }
        else if(m==i&&n==j+1){
          ++m;n-=2;
        }
        else if((m==i+1&&n==j-1)||(m==i+1&&n==j)){
          ++n;
        }
      }
    }
  }
}

void compareTwoCells(ArrayList cell[][], int sx, int sy, int tx, int ty){
  for(int s=0;s<cell[sx][sy].size();s++){
    Point sp = (Point)cell[sx][sy].get(s);
    for(int t=0;t<cell[tx][ty].size();t++){
      Point tp = (Point)cell[tx][ty].get(t);
      if(dist(sp.x,sp.y,tp.x,tp.y)<=r&&dist(sp.x,sp.y,tp.x,tp.y)!=0){
        
        line(rectX+sp.x,rectY+sp.y,rectX+tp.x,rectY+tp.y);
        
        //ArrayList<Point> spList = gson.fromJson(result.get(String.valueOf(sp.x)+","+String.valueOf(sp.y)).toString(), type);
        //spList.add(tp);
        //result.put(String.valueOf(sp.x)+","+String.valueOf(sp.y),gson.toJson(spList));
        
        //ArrayList<Point> tpList = gson.fromJson(result.get(String.valueOf(tp.x)+","+String.valueOf(tp.y)).toString(), type);
        //tpList.add(sp);
        //result.put(String.valueOf(tp.x)+","+String.valueOf(tp.y),gson.toJson(tpList));
      }
    }
  }
}

void testCell(ArrayList cell[][]){
  int count=0;
  for(int i=0; i<rectW/r+1;i++){
    for(int j=0; j<rectW/r+1;j++){
      if(cell[i][j]!=null){
        println(i+" "+j+":"+cell[i][j].size());
        count+=cell[i][j].size();
      }
    }
  }
  println(count);
}

void testRGG(){
  int sum = 0;
  for (Object entry : result.values()) {  
    ArrayList<Point> flag = gson.fromJson(entry.toString(), type);
    //println(flag.size());
    sum+=flag.size();
    dgr[flag.size()]++;
  } 
  for(int i =0;i<200;i++){
    if(dgr[i]!=0){
      println(i+"\t"+dgr[i]);
    }
  }
  println(sum/dense);
  println("Exiting at " + millis()/1000.0 + " seconds");
}