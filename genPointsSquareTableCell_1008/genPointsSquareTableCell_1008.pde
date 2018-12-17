//canvas beginning point x,y
int rectX = 0;
int rectY = 0;
//canvas width [square(width)>dense], for 128000, minWidth is 358
int rectW = 500;
int dense = 4000;
int avgD = 32;
int r = int(sqrt(avgD*rectW*rectW/dense/PI));
//Degree Test
int maxDgr = 0;
int dgr[] = new int[500];

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
  conPointsBound(p);
  testRGG();
}

void setCanvas(){
  background(255);
  rectX = (displayWidth-rectW)/2;
  rectY = (displayHeight-rectW)/2;
  rect(rectX,rectY,rectW,rectW);
}

void genPoints(Table p){
  strokeWeight(1);
  for(int i=0;i<dense;i++){
    float x=random(rectW);
    float y=random(rectW);
    TableRow newRow = p.addRow();
    newRow.setFloat("x",x);
    newRow.setFloat("y",y);
    newRow.setInt("cellX",int((x-rectX)/r));
    newRow.setInt("cellY",int((y-rectY)/r));
    newRow.setString("cell",String.valueOf(int((x-rectX)/r))+","+String.valueOf(int((y-rectY)/r)));
    point(rectX+x,rectY+y);
  }
}

void conPointsBound(Table p){
  for (TableRow row : p.rows()) {
    int cellPointX = row.getInt("cellX");
    int cellPointY = row.getInt("cellY");
    int cellNextX = cellPointX;
    int cellNextY = cellPointY;
    int count = 0;
    while(true){
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
      for(TableRow rowNext : p.findRows(String.valueOf(cellNextX)+","+String.valueOf(cellNextY),"cell")){
        if(dist(rectX+row.getFloat("x"),rectY+row.getFloat("y"),rectX+rowNext.getFloat("x"),rectY+rowNext.getFloat("y"))<=r){
          line(rectX+row.getFloat("x"),rectY+row.getFloat("y"),rectX+rowNext.getFloat("x"),rectY+rowNext.getFloat("y"));
          count++;
        }
      }
    }
    dgr[count]++;
  }
}

void testPoints(Table p){
  println(p.getRowCount());
}

void testRGG(){
  println("Exiting at " + millis()/1000.0 + " seconds");
  for(int i = 0;i<100;i++)
    if(dgr[i]!=0)
      print(" "+i+":"+dgr[i]);
}