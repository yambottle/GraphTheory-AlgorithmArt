import java.util.Comparator;
import java.util.Collections;
import java.util.Iterator;

//canvas beginning point x,y
int rectX = 0;
int rectY = 0;

int rectW = 400;
int dense = 6;
float avgD = 5;
float r = sqrt(avgD*rectW*rectW/dense/PI);

class Vertex{
  float x;
  float y;
  ArrayList<Vertex> edges;
  int index;
  int dfsNum;
  int degree;
  
  public Vertex(){
    this.x = 0;
    this.y = 0;
    this.edges = new ArrayList<Vertex>();
    this.index = 0;
    this.dfsNum = -1;
    this.degree = 0;
  }
  
  public Vertex(Vertex v){
    this.x = v.x;
    this.y = v.y;
    this.edges = v.edges;
    this.index = v.index;
    this.dfsNum = v.dfsNum;
    this.degree = v.degree;
  }
}

void setup(){
  fullScreen();
  smooth();
  noLoop();
}

void draw(){
  while(true){
    setCanvas();
    ArrayList<Vertex> vertexs = new ArrayList<Vertex>();
    genPoints(vertexs);
    genEdges(vertexs);
    ArrayList<Vertex> mCompo = findMajorComponent(vertexs);
    if(checkEulerianTrail(mCompo)){
      //printAdjList(mCompo, color(0,0,0));
      showTrail(mCompo);
      break;
    }
  }
}

void setCanvas(){
  background(255);
  rectX = (displayWidth-rectW)/2;
  rectY = (displayHeight-rectW)/2;
  rect(rectX,rectY,rectW,rectW);
}

void genPoints(ArrayList<Vertex> vertexs){
  for(int i=0;i<dense;i++){
    Vertex vertex = new Vertex();
    float x,y;
    x=random(0,rectW-5);
    y=random(0,rectW-5);
    vertex.x = x;
    vertex.y = y;
    vertexs.add(vertex);
  }
}

void genEdges(ArrayList<Vertex> vertexs){
  Collections.sort(vertexs, new VertexCmp());
  for(Vertex vertex : vertexs){
    vertex.index = vertexs.indexOf(vertex);
    int i = vertex.index+1;
    while(i<vertexs.size()&&abs(vertex.x-vertexs.get(i).x)<=r){
      if(abs(vertex.y-vertexs.get(i).y)>r){
        i++;
      }else{
        if(sqrt(sq(abs(vertex.x-vertexs.get(i).x))+sq(abs(vertex.y-vertexs.get(i).y)))<=r){
            vertex.edges.add(vertexs.get(i));
            vertex.degree++;
            vertexs.get(i).edges.add(vertex);
            vertexs.get(i).degree++;
        }
        i++;
      }
    }
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

ArrayList<Vertex> findMajorComponent(ArrayList<Vertex> vertexs){
  int dfsNum = 0;
  int count[] = new int[128000];
  int maxCount = 0;
  int maxIndex = 0;
  for(Vertex vertex:vertexs){
    if(vertex.dfsNum<0){
      dfsRetrivel(vertex,dfsNum,count);
      dfsNum++;
    }
  }
  for(int i=0;i<128000;i++){
    if(count[i]>maxCount){
      maxCount=count[i];
      maxIndex=i;
    }
  }
  ArrayList<Vertex> majorComp = new ArrayList<Vertex>();
  for(Vertex vertex:vertexs){
    if(vertex.dfsNum==maxIndex){
      majorComp.add(vertex);
    }
  }
  return majorComp;
}

void dfsRetrivel(Vertex vertex, int Num, int[] count){
  if(vertex.dfsNum>=0)return;
  vertex.dfsNum = Num;
  count[Num]++;
  for(Vertex nextVertex:vertex.edges){
    if(nextVertex.dfsNum<0){
      dfsRetrivel(nextVertex,Num,count);
    }
  }
}

void printAdjList(ArrayList<Vertex> vertexs, color c){
  stroke(c);
  for(Vertex vertex:vertexs){
    strokeWeight(10);
    point(rectX+vertex.x,rectY+vertex.y);
    if(vertex.edges!=null){
      for(Vertex edge:vertex.edges){
        strokeWeight(1);
        line(rectX+vertex.x,rectY+vertex.y,rectX+edge.x,rectY+edge.y);
      }
    }
  }
}

boolean checkEulerianTrail(ArrayList<Vertex> vertexs){
  int oddNum = 0;
  for(Vertex vertex:vertexs){
    if(vertex.edges.size()%2==0){
      continue;
    }else{
      oddNum++;
      //print(oddNum);
    }
  }
  return oddNum==0||oddNum==2?true:false;
}

void showTrail(ArrayList<Vertex> vertexs){
  boolean isEven = true;
  Vertex start = null;
  
  Collections.sort(vertexs, new DegreeCmp());
  for(Vertex v:vertexs){
    if(v.degree%2!=0&&isEven==true){
      isEven = false;
      start = v;
      Collections.sort(v.edges, new DegreeCmp());
    }
  }
  if(isEven){
    printAdjList(vertexs, color(255,0,0));
    return;
  }else{
    Vertex next = start.edges.get(0);
    float x = start.x;
    float y = start.y;
    stroke(0,0,255);
    strokeWeight(10);
    point(rectX+start.x,rectY+start.y);
    while(next!=null){
      if(next.edges.size()==1&&next.edges.get(0)==start){
        stroke(color(0,255,0));
      }else{
        stroke(color(0));
      }
      
      strokeWeight(10);
      if(next.x!=x&&next.y!=y){
        point(rectX+next.x,rectY+next.y);
      }
      stroke(color(255,0,0));
      strokeWeight(1);
      drawArrow(rectX+start.x,rectY+start.y,rectX+next.x,rectY+next.y);
      //print(start.index+" "+next.index+"\n");
      start.edges.remove(next);
      start.degree--;
      next.edges.remove(start);
      next.degree--;
      Collections.sort(next.edges, new DegreeCmp());
      start = next;
      try{
        next = start.edges.get(0);
      }catch(IndexOutOfBoundsException e){
        return;
      }
    }
  }
}

class DegreeCmp implements Comparator<Vertex>{
    @Override
    public int compare(Vertex v1, Vertex v2) {
        return v1.degree>=v2.degree?-1:1;
    }
}

// referenced from: http://gaelbn.com/processing/2014/01/10/a_simple_way_to_draw_arrows_in_Processing.html
void drawArrow(float x1, float y1, float x2, float y2) {
  float a = dist(x1, y1, x2, y2) / 50;
  pushMatrix();
  translate(x2, y2);
  rotate(atan2(y2 - y1, x2 - x1));
  //triangle(- a * 2 , - a, 0, 0, - a * 2, a);
  triangle(0, 0, -10, 5, -10, -5);
  popMatrix();
  line(x1, y1, x2, y2);  
}
