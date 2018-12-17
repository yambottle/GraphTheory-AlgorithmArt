import java.util.Comparator;
import java.util.Collections;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Iterator;
//canvas beginning point x,y
int rectX = 0;
int rectY = 0;
//canvas width [square(width)>dense], for 128000, minWidth is 358
int rectW = 800;
int dense = 8000;
float avgD = 32;
float r = sqrt(avgD*sq(rectW/2)/dense);
float time1 = 0;
float time2 = 0;
float time3 = 0;
int Msum = 0;
int Vsum = dense;
int terminaldgr = 0;
int vertexColor[] = {#FF0000,#00FF00,#0000FF,#FFFFFF};
int edgeColor[] = {#8B0000,#8E8E8E};

class Vertex implements Cloneable{
  float x;
  float y;
  ArrayList<Vertex> edges;
  ArrayList<Vertex> coloredges;
  int dgr;
  int index;
  int orgDgr;
  boolean isDeleted;
  int cdgr;
  int colorNum;
  int edgeColorNum;
  int dfsNum;
  
  public Vertex(){
    this.x = 0;
    this.y = 0;
    this.edges = new ArrayList<Vertex>();
    this.coloredges = new ArrayList<Vertex>();
    this.dgr = edges.size();
    this.index = 0;
    this.orgDgr = 0;
    this.isDeleted = false;
    this.cdgr = 0;
    this.colorNum = -1;
    this.edgeColorNum = 0;
    this.dfsNum = -1;
  }
  
  public Vertex(Vertex v){
    this.x = v.x;
    this.y = v.y;
    this.edges = v.edges;
    this.coloredges = new ArrayList<Vertex>();
    this.coloredges.addAll(v.coloredges);
    this.dgr = v.dgr;
    this.index = v.index;
    this.orgDgr = v.orgDgr;
    this.isDeleted = v.isDeleted;
    this.cdgr = v.cdgr;
    this.colorNum = v.colorNum;
    this.edgeColorNum = v.edgeColorNum;
    this.dfsNum = v.dfsNum;
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

class SizeCmp implements Comparator<ArrayList<Vertex>>{
    @Override
    public int compare(ArrayList<Vertex> l1, ArrayList<Vertex> l2) {
        if(l1.size()>=l2.size()){
          return 1;
        }else{
          return -1;
        }
    }
}

void setup(){
  fullScreen();
  smooth();
  noLoop();
  //r = 320;
}

void draw(){
  ArrayList<Vertex> vertexs = new ArrayList<Vertex>();
  setCanvas();
  genPoints(vertexs);
  //testPoints(vertexs);
  conPointsBound(vertexs);
  //testSort(vertexs);
  testRGG(vertexs);
  
  time1 = millis();
  println("Exiting at " + time1/1000.0 + " seconds");
  
  ArrayList<Vertex>[] dgrList = new ArrayList[200];
  genDegreeList(vertexs, dgrList);
  //testDgrList(dgrList);
  ArrayList<Vertex> slovertexs = new ArrayList<Vertex>();
  genSLOList(vertexs, dgrList, slovertexs);
  //testSLO(slovertexs);
  //println();
  ArrayList<ArrayList<Vertex>> colorList = new ArrayList<ArrayList<Vertex>>();
  genColoringSet(vertexs, slovertexs, colorList);
  //testColorSet(colorList);
  
  time2 = millis()-time1;
  println("Exiting at " + time2/1000.0 + " seconds");
  //println("Exiting at " + millis()/1000.0 + " seconds");
  
  ArrayList<ArrayList<Vertex>> prebackboneList = new ArrayList<ArrayList<Vertex>>();
  genSixBip(vertexs, prebackboneList, colorList);
  ArrayList<Vertex> backbone = new ArrayList<Vertex>();
  genBackbone(backbone, prebackboneList);
  printBackbone(backbone);
  
  time3 = millis()-time2-time1;
  println("Exiting at " + time3/1000.0 + " seconds");
  println("Exiting at " + millis()/1000.0 + " seconds");
  //testColorSet(colorList);
}

void setCanvas(){
  background(255);
  rectX = (displayWidth)/2;
  rectY = (displayHeight)/2;
  ellipse(rectX,rectY,rectW,rectW);
}

void genPoints(ArrayList<Vertex> vertexs){
  stroke(0);
  strokeWeight(2);
  for(int i=0;i<dense;i++){
    Vertex vertex = new Vertex();
    float gR=random(1);
    float th=random(360);
    float x = rectW/2*sqrt(gR)*sin(th);
    float y = rectW/2*sqrt(gR)*cos(th);
    point(rectX+x,rectY+y);
    vertex.x = x;
    vertex.y = y;
    vertexs.add(vertex);
  }
}

void conPointsBound(ArrayList<Vertex> vertexs){
  Collections.sort(vertexs, new VertexCmp());
  //stroke(0,30);
  stroke(0);
  strokeWeight(1);
  int sum = 0;
  for(Vertex vertex : vertexs){
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
            sum++;
        }
        i++;
      }
    }
  }
  //println("Edges Num:"+sum);
}

void printBackbone(ArrayList<Vertex> backbone){
  clear();
  setCanvas();
  for(Vertex vertex:backbone){
    strokeWeight(5);
    stroke(vertexColor[vertex.colorNum]);
    point(rectX+vertex.x,rectY+vertex.y);
    strokeWeight(1);
    stroke(edgeColor[vertex.edgeColorNum]);
    for(Vertex adjvertex:vertex.coloredges){
      line(rectX+vertex.x,rectY+vertex.y,rectX+adjvertex.x,rectY+adjvertex.y);
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
  for(int mindgr = 0; mindgr<dgrList.length; mindgr++){
    if(dgrList[mindgr]==null||dgrList[mindgr].isEmpty())continue;
    while(dgrList[mindgr].size()>0){
      boolean terminal = true;
      for(int i=mindgr+1;i<dgrList.length;i++){
        if(dgrList[i]!=null&&dgrList[i].size()!=0)terminal=false;
      }
      if(terminaldgr<1&&terminal){
        println("TerminalCliqueSize:"+dgrList[mindgr].size());
        terminaldgr++;
      }
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

void genSixBip(ArrayList<Vertex> vertexs,ArrayList<ArrayList<Vertex>> prebackboneList, ArrayList<ArrayList<Vertex>> colorList){
  for(int i=0;i<4;i++){
    for(int j=i+1;j<4;j++){
      for(Vertex orgver:vertexs){
        orgver.coloredges.clear();
        orgver.cdgr=0;
        orgver.edgeColorNum=0;
        orgver.dfsNum=-1;
      }
      ArrayList<Vertex> bip = new ArrayList<Vertex>();
      for(Vertex vertexi:colorList.get(i)){
        for(Vertex vertexj:colorList.get(j)){
          for(Vertex adj:vertexi.edges){
            if(adj==vertexj){
              vertexi.coloredges.add(vertexj);
              vertexi.cdgr++;
              vertexj.coloredges.add(vertexi);
              vertexj.cdgr++;
            }
          }
        }
      }
      for(Vertex vertexi:colorList.get(i)){
        if(vertexi.cdgr==0)continue;
        bip.add(vertexi);
      }
      for(Vertex vertexj:colorList.get(j)){
        if(vertexj.cdgr==0)continue;
        bip.add(vertexj);
      }
      deleteTails(bip);
      ArrayList<Vertex> maxClique = findMaxClique(bip);
      ArrayList<Vertex> newClique = new ArrayList<Vertex>();
      for(Vertex vertex :maxClique){
        newClique.add(new Vertex(vertex));
      }
      prebackboneList.add(newClique);
    }
  }
}

void deleteTails(ArrayList<Vertex> prebackbone){
  Queue<Vertex> tails = new LinkedList<Vertex>();
  for(Vertex vertex:prebackbone){
    if(vertex.coloredges.size()==1){
      tails.offer(vertex);
    }
  }
  while(!tails.isEmpty()){
    Vertex vertex = tails.poll();
    if(vertex.coloredges.size()==0){
      prebackbone.remove(vertex);
      continue;
    }
    for(Vertex flagvertex:vertex.coloredges){
      flagvertex.coloredges.remove(vertex);
      flagvertex.cdgr-=1;
      if(flagvertex.cdgr<=1){
        tails.offer(flagvertex);
      }
    }
    prebackbone.remove(vertex);
  }
}

ArrayList<Vertex> findMaxClique(ArrayList<Vertex> prebackbone){
  int dfsNum = 0;
  int count[] = new int[128000];
  int maxCount = 0;
  int maxIndex = 0;
  for(Vertex vertex:prebackbone){
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
  ArrayList<Vertex> maxClique = new ArrayList<Vertex>();
  for(Vertex vertex:prebackbone){
    if(vertex.dfsNum==maxIndex){
      maxClique.add(vertex);
    }
  }
  return maxClique;
}

void dfsRetrivel(Vertex vertex, int Num, int[] count){
  if(vertex.dfsNum>=0)return;
  vertex.dfsNum = Num;
  count[Num]++;
  for(Vertex nextVertex:vertex.coloredges){
    if(nextVertex.dfsNum<0){
      dfsRetrivel(nextVertex,Num,count);
    }
  }
}

void genBackbone(ArrayList<Vertex> backbone, ArrayList<ArrayList<Vertex>> prebackboneList){
  Collections.sort(prebackboneList,new SizeCmp());
  int sum=0;
  for(Vertex vertex:prebackboneList.get(0)){
    sum+=vertex.coloredges.size();
  }
  println("LagestBipEdges:"+sum/2);
  for(Vertex vertex:prebackboneList.get(0)){
    vertex.edgeColorNum=0;
  }
  backbone.addAll(prebackboneList.get(0));
  //printBackbone(prebackboneList.get(0));
  for(Vertex vertex:prebackboneList.get(0)){
    vertex.edgeColorNum=1;
  }
  backbone.addAll(prebackboneList.get(1));
  //printBackbone(prebackboneList.get(1));
  //for(int i =0;i<backbone.size();i++){
  //  Vertex vertexi = backbone.get(i);
  //  for(int j =0;j<backbone.size();j++){
  //    if(i==j)continue;
  //    Vertex vertexj = backbone.get(j);
  //    if(vertexi.x==vertexj.x&&vertexi.y==vertexj.y){
  //      backbone.remove(vertexj);
  //    }
  //  }
  //}
} //<>// //<>//

////////////////////////////////////////////TEST
void testPoints(ArrayList<Vertex> vertexs){
  println("Num is:"+vertexs.size());
}

void testSort(ArrayList<Vertex> vertexs){
  for(Vertex vertex : vertexs){
    println(vertex.x+" "+vertex.y);
  }
}

void testRGG(ArrayList<Vertex> vertexs){
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
  println("E:"+sum/2);
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