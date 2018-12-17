import java.lang.reflect.Type;
import java.util.Map;
//canvas center x,y
int rectX = 0;
int rectY = 0;
int cellX = 0;
int cellY = 0;
//canvas r=rectW/2 [square(r)*pi>dense], for 8000, minR is 51
int rectW = 500;
int dense = 32000;
int avgD = 32;
int r = int(sqrt(avgD*PI*sq(rectW/2)/dense/PI));
//Degree Test
int maxDgr = 0;
int minDgr = 100000;
int dgr[] = new int[500];
int sum = 0;
HashMap result = new HashMap<String, String>();
Gson gson = new Gson();
Type type = new TypeToken<ArrayList<Object>>(){}.getType();

void setup(){
  fullScreen();
  noLoop();
}

void draw(){
  Table p = new Table();
  p.addColumn("x", Table.FLOAT);
  p.addColumn("y", Table.FLOAT);
  p.addColumn("cell",Table.STRING);//areaAttribute
  p.addColumn("cellX",Table.INT);//areaX
  p.addColumn("cellY",Table.INT);//areaY
  setCanvas();
  genPoints(p);//testPoints(p);
  conPoints(p);
  testRGG();//test is not good
}

void setCanvas(){
  background(255);
  rectX = (displayWidth)/2;
  rectY = (displayHeight)/2;
  cellX = rectX-rectW/2;
  cellY = rectY-rectW/2;
  ellipse(rectX,rectY,rectW,rectW);
}

class Point{
  float x;
  float y;
}

void genPoints(Table p){
  strokeWeight(2);
  for(int i=0;i<dense;i++){
    //miss!!! verify random, no collision
    float gR=random(1);
    float th=random(360);
    float x = rectW/2*sqrt(gR)*sin(th);
    float y = rectW/2*sqrt(gR)*cos(th);
    TableRow newRow = p.addRow();
    newRow.setFloat("x",x);
    newRow.setFloat("y",y);
    newRow.setInt("cellX",int((rectX+x-cellX)/r));
    newRow.setInt("cellY",int((rectY+y-cellY)/r));
    newRow.setString("cell",String.valueOf(int((rectX+x-cellX)/r))+","+String.valueOf(int((rectY+y-cellY)/r)));
    //result.put(String.valueOf(x)+","+String.valueOf(y), gson.toJson(new ArrayList<Point>()));
    point(rectX+x,rectY+y);
  }
}

void conPoints(Table p){
  stroke(0,30);
  strokeWeight(0.1);
  for (TableRow row : p.rows()) {
    int cellPointX = row.getInt("cellX");
    int cellPointY = row.getInt("cellY");
    int cellNextX = cellPointX;
    int cellNextY = cellPointY;
    int count = 0;
    while(true){
      for(TableRow rowNext : p.findRows(String.valueOf(cellNextX)+","+String.valueOf(cellNextY),"cell")){
        if(dist(rectX+row.getFloat("x"),rectY+row.getFloat("y"),rectX+rowNext.getFloat("x"),rectY+rowNext.getFloat("y"))<=r){
          line(rectX+row.getFloat("x"),rectY+row.getFloat("y"),rectX+rowNext.getFloat("x"),rectY+rowNext.getFloat("y"));
          
          Point sp = new Point();
          sp.x=row.getFloat("x");
          sp.y=row.getFloat("y");
          Point tp = new Point();
          tp.x=rowNext.getFloat("x");
          tp.y=rowNext.getFloat("y");
          
          //ArrayList<Point> spList = gson.fromJson(
          //result.get(String.valueOf(sp.x)+","+String.valueOf(sp.y)).toString(), type);
          //spList.add(tp);
          //result.put(String.valueOf(sp.x)+","+String.valueOf(sp.y),gson.toJson(spList));
        
          //ArrayList<Point> tpList = gson.fromJson(
          //result.get(String.valueOf(tp.x)+","+String.valueOf(tp.y)).toString(), type);
          //tpList.add(sp);
          //result.put(String.valueOf(tp.x)+","+String.valueOf(tp.y),gson.toJson(tpList));
        }
      }
      if(cellNextX==cellPointX&&cellNextY==cellPointY){
        ++cellNextX;
        --cellNextY;
      }else if(cellNextX==cellPointX+1&&cellNextY==cellPointY-1){
        ++cellNextY;
      }else if(cellNextX==cellPointX+1&&cellNextY==cellPointY){
        ++cellNextY;
      }else if(cellNextX==cellPointX+1&&cellNextY==cellPointY+1){
        --cellNextX;
      }else if(cellNextX==cellPointX&&cellNextY==cellPointY+1){
        break;
      }
      
    }
  }
}

void testPoints(Table p){
  println(p.getRowCount());
}

void testRGG(){
  
  for (Object entry : result.values()) {  
    int count = 0;
    ArrayList<Point> flag = gson.fromJson(entry.toString(), type);
    //println(flag.size());
    count+=flag.size();
    dgr[flag.size()]++;
    sum+=count;
    if(count>maxDgr)maxDgr=count;
    if(count<minDgr)minDgr=count;
  } 
  println("avg:"+sum/dense);
  println("M:"+sum);
  println("min:"+minDgr);
  println("max:"+maxDgr);
  println("Exiting at " + millis()/1000.0 + " seconds");
  for(int i =0;i<200;i++){
    if(dgr[i]!=0)
      println(i+"\t"+dgr[i]);
  }
}

void verifyRandom(Table p){//not compelete
    float x;
    float y;
    while(true){//verify random, no collision
      boolean dupFlag = false;
      float r=random(1);
      float th=random(360);
      x = rectW/2*sqrt(r)*sin(th);
      y = rectW/2*sqrt(r)*cos(th);
      for(TableRow row:p.findRows(String.valueOf(x),"x")){
        if(row.getFloat("y")==y)dupFlag = true;
      }
      if(dupFlag){
        continue;
      }else{
        break;
      }
    }
}