import java.util.Comparator;
import java.util.Collections;
import java.util.Arrays;
//canvas beginning point x,y
int rectX = 0;
int rectY = 0;
//canvas width [square(width)>dense], for 128000, minWidth is 358
int rectW = 800;
int dense = 4000;
float avgD = 32;
float r = sqrt(avgD*rectW*rectW/dense/PI);
float time1 = 0;
float time2 = 0;
int Msum = 0;
int Vsum = dense;
int PGenSum = 0;
boolean isSorted = false;
ArrayList<Vertex> vertexs = new ArrayList<Vertex>();

class Vertex{
  float x;
  float y;
  ArrayList<Vertex> edges;
  int dgr;
  int index;
  int orgDgr;
  boolean isDeleted;
  int colorNum;
  
  public Vertex(){
    this.x = 0;
    this.y = 0;
    this.edges = new ArrayList<Vertex>();
    this.dgr = edges.size();
    this.index = 0;
    this.orgDgr = 0;
    this.isDeleted = false;
    this.colorNum = -1;
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
  //frameRate(100000000);
  setCanvas();
  //r = 320;
}

void draw(){
  if(PGenSum<dense){
    genPoints(vertexs);
  }else if(PGenSum==dense){
    //testPoints(vertexs);
  }else if(PGenSum>dense&&PGenSum<dense*2){
    if(!isSorted){
      Collections.sort(vertexs, new VertexCmp());
      //testSort(vertexs);
      isSorted = true;
    }
    conPointsBound(vertexs.get(PGenSum-dense-1));
  }else if(PGenSum==2*dense){
    testRGG(vertexs);
  }else if(PGenSum==2*dense+1){
    //ArrayList<Vertex>[] dgrList = new ArrayList[200];
    //genDegreeList(vertexs, dgrList);
    ////testDgrList(dgrList);
    //ArrayList<Vertex> slovertexs = new ArrayList<Vertex>();
    //genSLOList(vertexs, dgrList, slovertexs);
    ////testSLO(slovertexs);
    ////println();
    //ArrayList<ArrayList<Vertex>> colorList = new ArrayList<ArrayList<Vertex>>();
    //genColoringSet(vertexs, slovertexs, colorList);
    //testColorSet(colorList);
    
    //time2 = millis()-time1;
    //println("Exiting at " + time2/1000.0 + " seconds");
    //println("Exiting at " + millis()/1000.0 + " seconds");
    ////testColorSet(colorList);
  }
  PGenSum++;
}

void setCanvas(){
  background(255);
  rectX = (displayWidth-rectW)/2;
  rectY = (displayHeight-rectW)/2;
  rect(rectX,rectY,rectW,rectW);
}

void genPoints(ArrayList<Vertex> vertexs){
  stroke(0);
  strokeWeight(2);
    Vertex vertex = new Vertex();
    float x,y;
    x=random(0,rectW);
    y=random(0,rectW);
    point(rectX+x,rectY+y);
    vertex.x = x;
    vertex.y = y;
    vertexs.add(vertex);
}

void conPointsBound(Vertex vertex){
  //stroke(0,30);
  stroke(0);
  strokeWeight(1);
    vertex.index = vertexs.indexOf(vertex);
    int i = vertex.index+1;
    while(i<vertexs.size()&&abs(vertex.x-vertexs.get(i).x)<=r){
      if(abs(vertex.y-vertexs.get(i).y)>r){
        i++;
      }else{
        if(sqrt(sq(abs(vertex.x-vertexs.get(i).x))+sq(abs(vertex.y-vertexs.get(i).y)))<=r){
            line(rectX+vertex.x,rectY+vertex.y,rectX+vertexs.get(i).x,rectY+vertexs.get(i).y);
            vertex.edges.add(vertexs.get(i));
            vertexs.get(i).edges.add(vertex);
        }
        i++;
      }
    }
}

void genDegreeList(ArrayList<Vertex> vertexs, ArrayList<Vertex>[] dgrList){
  for(Vertex vertex : vertexs){
    vertex.dgr = vertex.edges.size();
    vertex.orgDgr = vertex.dgr;
    if(dgrList[vertex.dgr]==null){
      dgrList[vertex.dgr] = new ArrayList<Vertex>();
    }
    dgrList[vertex.dgr].add(vertex);
  }
}

void genSLOList(ArrayList<Vertex> vertexs, ArrayList<Vertex>[] dgrList, ArrayList<Vertex> slovertexs){
  PrintWriter pw = createWriter("delete&avg.txt");
  int maxDelDgr = 0;
  for(int mindgr = 0; mindgr<dgrList.length; mindgr++){ //<>//
    if(dgrList[mindgr]==null||dgrList[mindgr].isEmpty())continue;
    while(dgrList[mindgr].size()>0){
      int minUpdateDgr = 1000;
      Vertex rmvertex = (Vertex)dgrList[mindgr].remove(0);
      writeDeletedAvg(rmvertex,pw);
      rmvertex.isDeleted = true;
      if(rmvertex.dgr>maxDelDgr)maxDelDgr = rmvertex.dgr;
      slovertexs.add(rmvertex);
      for(Vertex updateVertex : vertexs.get(rmvertex.index).edges){
        //println(dgrList[updateVertex.dgr].remove(updateVertex));
        if(updateVertex.isDeleted)continue;
        for(int i = 0; i<dgrList[updateVertex.dgr].size();i++){
          if(dgrList[updateVertex.dgr].get(i).index == updateVertex.index){
            dgrList[updateVertex.dgr].remove(i);
            break;
          }
        }
        int updateVertexDgr = updateVertex.dgr-1;
        if(updateVertexDgr==-1){slovertexs.add(updateVertex);continue;}
        if(dgrList[updateVertexDgr]==null)dgrList[updateVertexDgr] = new ArrayList<Vertex>();
        dgrList[updateVertexDgr].add(updateVertex);
        updateVertex.dgr=updateVertexDgr;
        if(updateVertexDgr<minUpdateDgr)minUpdateDgr=updateVertexDgr;
        //println(minUpdateDgr);
      }
      //println("Remove:"+rmvertex.index);
      //testDgrList(dgrList);
      if(minUpdateDgr<mindgr){
        mindgr=minUpdateDgr-1;
        break;
      }
    }
  }
  pw.flush();pw.close();
  println("MaxDelDgr:"+maxDelDgr);
}

void genColoringSet(ArrayList<Vertex> vertexs, ArrayList<Vertex> slovertexs, ArrayList<ArrayList<Vertex>> colorList){
  for(int i = slovertexs.size()-1;i>-1;i--){
    Vertex vertex = slovertexs.get(i);
    boolean available[] = new boolean[100];
    Arrays.fill(available, true);
    for(Vertex adjVertex : vertexs.get(vertex.index).edges){
      if(adjVertex.colorNum==-1)continue;
      available[adjVertex.colorNum]=false;
    }
    for(int j = 0;j<available.length;j++){
      if(available[j]){
        vertex.colorNum = j;
        break;
      }
    }
    if(vertex.colorNum>colorList.size()-1)colorList.add(new ArrayList<Vertex>());
    colorList.get(vertex.colorNum).add(vertex);
    //testColorSet(colorList);
    //println();
  }
}

void testPoints(ArrayList<Vertex> vertexs){
  println("Num is:"+vertexs.size());
}

void testSort(ArrayList<Vertex> vertexs){
  for(Vertex vertex : vertexs){
    println(vertex.x+" "+vertex.y);
  }
}

void testRGG(ArrayList<Vertex> vertexs){
  time1 = millis();
  println("Exiting at " + time1/1000.0 + " seconds");
  int min=100000;
  int max=0;
  int sum=0;
  for(Vertex vertex : vertexs){
    int dgr = vertex.edges.size();
    if(dgr>max)max=dgr;
    if(dgr<min)min=dgr;
    sum+=dgr;
  }
  println("avg:"+sum/dense);
  println("M:"+sum);Msum=sum;
  println("min:"+min);
  println("max:"+max);
  PrintWriter pw = createWriter("orgDgr.txt");
  for(Vertex vertex : vertexs){
    pw.println(vertex.index+"\t"+vertex.edges.size());
  }
  pw.flush();pw.close();
}

void testDgrList(ArrayList<Vertex>[] dgrList){
  //int sum=0;
  //for(int i=0;i<200;i++){
  //  if(dgrList[i]==null||dgrList[i].isEmpty())continue;
  //  sum+=dgrList[i].size();
  //}
  //println("dgr Sum:"+sum);
  
  for(int i=0;i<200;i++){
    if(dgrList[i]==null||dgrList[i].isEmpty())continue;
    print("Degree:"+i+"||");
    for(Vertex vertex : dgrList[i]){
      print(vertex.index+" ");
    }
    println();
  }
  println();
}

void testSLO(ArrayList<Vertex> slovertexs){
  //println("SLO Size:"+slovertexs.size());
  //println("Exiting at " + millis()/1000.0 + " seconds");
  print("SL-O List: ");
  for(Vertex vertex:slovertexs){
    print(vertex.index+" ");
  }
  println();
}

void testColorSet(ArrayList<ArrayList<Vertex>> colorList){
  //println("ColorSize:"+colorList.size());
  //int max = 0;
  //for(ArrayList<Vertex> colorSet : colorList){
  //  if(colorSet.size()>max){
  //    max = colorSet.size();
  //  }
  //}
  //println("MaxColorSize:"+max);
  //---------
  //for(ArrayList<Vertex> colorSet : colorList){
  //  print("Color:"+colorList.indexOf(colorSet)+"|| ");
  //  for(Vertex vertex : colorSet){
  //    print(vertex.index+" ");
  //  }
  //  println();
  //}
  //--------
  PrintWriter pw = createWriter("colorDis.txt");
  for(int i = 0;i<colorList.size();i++){
    pw.println(i+"\t"+colorList.get(i).size());
  }
  pw.flush();pw.close();
}

void writeDeletedAvg(Vertex vertex, PrintWriter pw){
  if(Vsum==1)return;
  pw.println(vertex.dgr+"\t"+(int)(Msum-vertex.dgr*2)/(Vsum-1));
  Msum-=vertex.dgr*2;
  Vsum--;
}