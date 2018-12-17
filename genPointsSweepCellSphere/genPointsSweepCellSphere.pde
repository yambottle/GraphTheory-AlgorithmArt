import java.util.Comparator;
import java.util.Collections;
//canvas beginning point x,y
int rectX = 0;
int rectY = 0;
//canvas width [square(width)>dense], for 128000, minWidth is 358
int rectW = 800;
int dense = 128000;
int avgD = 128;
float r = sqrt(avgD*rectW*rectW/dense/PI);

class Vertex{
  float x;
  float y;
  ArrayList<Vertex> conn;
  
  public Vertex(){
    this.x = 0;
    this.y = 0;
    this.conn = new ArrayList<Vertex>();
  }
}

class VertexCmp implements Comparator<Vertex>{
    @Override
    public int compare(Vertex v1, Vertex v2) {
        if(v1.x > v2.x){
            return 1;
        }else if(v1.x==v2.x){
          if(v1.y>=v2.y){
            return 1;
          }else{
            return -1;
          }
        }else {
            return -1;
        }
    }
}

void setup(){
  fullScreen();
  smooth();
  noLoop();
}

void draw(){
  ArrayList<Vertex> vertexs = new ArrayList<Vertex>();
  setCanvas();
  genPoints(vertexs);//testPoints(vertexs);
  conPointsBound(vertexs);//testSort(vertexs);
  testRGG(vertexs);
}

void setCanvas(){
  background(255);
  //
}

void genPoints(ArrayList<Vertex> vertexs){
  stroke(0);
  strokeWeight(2);
  for(int i=0;i<dense;i++){
    Vertex vertex = new Vertex();
    float x,y;
    //x=random(0,rectW);
    //y=random(0,rectW);
    //point(rectX+x,rectY+y);
    //vertex.x = x;
    //vertex.y = y;
    vertexs.add(vertex);
  }
}

void conPointsBound(ArrayList<Vertex> vertexs){
  Collections.sort(vertexs, new VertexCmp());
  stroke(0,30);
  strokeWeight(0.1);
  for(Vertex vertex : vertexs){
    int i = vertexs.indexOf(vertex);
    while(i<vertexs.size()&&abs(vertex.x-vertexs.get(i).x)<=r){
      if(abs(vertex.y-vertexs.get(i).y)>r){
        i++;
      }else{
        if(sqrt(sq(abs(vertex.x-vertexs.get(i).x))+sq(abs(vertex.y-vertexs.get(i).y)))<=r){
            line(rectX+vertex.x,rectY+vertex.y,rectX+vertexs.get(i).x,rectY+vertexs.get(i).y);
            vertex.conn.add(vertexs.get(i));
            vertexs.get(i).conn.add(vertex);
        }
        i++;
      }
    }
  }
}

void testPoints(ArrayList<Vertex> vertexs){
  int num = 0;
  for(Vertex vertex : vertexs){
    num++;
  }
  println("Num is:"+num);
}

void testSort(ArrayList<Vertex> vertexs){
  for(Vertex vertex : vertexs){
    println(vertex.x+" "+vertex.y);
  }
}

void testRGG(ArrayList<Vertex> vertexs){
  println("Exiting at " + millis()/1000.0 + " seconds");
  int min=100000;
  int max=0;
  int sum=0;
  for(Vertex vertex : vertexs){
    int dgr = vertex.conn.size();
    if(dgr>max)max=dgr;
    if(dgr<min)min=dgr;
    sum+=dgr;
  }
  println("avg:"+sum/dense);
  println("M:"+sum);
  println("min:"+min);
  println("max:"+max);
}