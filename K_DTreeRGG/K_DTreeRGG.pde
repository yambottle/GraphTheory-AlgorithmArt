import java.util.Comparator;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.LinkedList;
import java.lang.IndexOutOfBoundsException;

//canvas beginning point x,y
int rectX = 0;
int rectY = 0;

int rectW = 400;
int dense = 1000;
float avgD = 10;
float r = sqrt(avgD*rectW*rectW/dense/PI);

void setup(){
  fullScreen();
  smooth();
  noLoop();
}

void draw(){
  setCanvas();
  ArrayList<Vertex> vertexs = new ArrayList<Vertex>();
  genPoints(vertexs);
  //genEdgesBF(vertexs);
  ArrayList<Vertex> tempVertexs = new ArrayList<Vertex>(vertexs);
  genEdgesKDT(tempVertexs);
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
    stroke(0);
    strokeWeight(5);
    point(rectX+vertex.x,rectY+vertex.y);
  }
}

void genEdgesBF(ArrayList<Vertex> vertexs){
  float time = millis()/1000.0;
  println("Brute Force:");
  for(Vertex vertex:vertexs){
    for(Vertex v:vertexs){
      if(sqrt(sq(abs(vertex.x-v.x))+sq(abs(vertex.y-v.y)))<=r){
        vertex.edges.add(v);
        vertex.degree++;
        v.edges.add(vertex);
        v.degree++;
        strokeWeight(1);
        line(rectX+vertex.x,rectY+vertex.y,rectX+v.x,rectY+v.y);
      }
    }
  }
  println("Consuming time: " + ((millis()/1000.0)-time) + " seconds");
}

/*
After went through and researched varies of popular implementations of k-d tree,
the most different idea is how to maintain the balancing of k-d tree while in the building stage,
which can improve efficiency of all operations later on.
However, in this case which is RGG, all vertices are already distributed uniformly,
which means we don't need to consider the balancing issue.
Besides, we don't need to consider the sequence and the dimension,
which is from where and how to split the space either.
*/
void genEdgesKDT(ArrayList<Vertex> vertexs){
  float time = millis()/1000.0;
  println("K-D Tree:");
  Node root = new Node();
  root = buildKDT(vertexs, root, true, null);
  //testKDT(root);
  for(Vertex v : vertexs){
    LinkedList<Node> area = new LinkedList<Node>();
    connect(v, root, area);
    while(!area.isEmpty()){
      Node node = area.poll();
      if(node==null)continue;
      if(sqrt(sq(abs(v.x-node.v.x))+sq(abs(v.y-node.v.y)))<=r){
        v.edges.add(node.v);
        v.degree++;
        node.v.edges.add(v);
        node.v.degree++;
        strokeWeight(1);
        line(rectX+v.x,rectY+v.y,rectX+node.v.x,rectY+node.v.y);
      }
      if(node.dim==0){
        if(v.x<node.v.x&&abs(v.x-node.v.x)>r){
          area.offer(node.right);
        }else if(v.x>node.v.x&&abs(v.x-node.v.x)>r){
          area.offer(node.left);
        } //<>//
      }else{
        if(v.y<node.v.y&&abs(v.y-node.v.y)>r){
          area.offer(node.right);
        }else if(v.y>node.v.y&&abs(v.y-node.v.y)>r){
          area.offer(node.left);
        }
      }
    }
  }
  println("Consuming time: " + ((millis()/1000.0)-time) + " seconds");
}

Node buildKDT(ArrayList<Vertex> vertexs, Node node, boolean lr, Node parent){
  if(vertexs.isEmpty())return null;
  int dim;
  if(lr){
    Collections.sort(vertexs, new VertexXCmp());
    dim = 0;
  }else{
    Collections.sort(vertexs, new VertexYCmp());
    dim = 1;
  }
  int index = (vertexs.size())/2;
  node = new Node(vertexs.get(vertexs.size()/2), dim, parent);
  
  ArrayList<Vertex> lefts = new ArrayList<Vertex>();
  for(int i = 0;i<index;i++){
    lefts.add(vertexs.get(i));
  }
  ArrayList<Vertex> rights = new ArrayList<Vertex>();
  for(int i = index+1;i<vertexs.size();i++){
    rights.add(vertexs.get(i));
  }
  
  if(lefts.size()==1){
    node.left = new Node(lefts.get(0), dim, node);
  }else{
    node.left = buildKDT(lefts, node.left, !lr, node);
  }
  
  if(rights.size()==1){
    node.right = new Node(rights.get(0), dim, node);
  }else{
    node.right = buildKDT(rights, node.right, !lr, node);
  }
  return node;
}

void testKDT(Node root){
  if(root == null) return;
  print(root.v.x+" "+root.v.y+"\n");
  testKDT(root.left);
  testKDT(root.right);
}

void connect(Vertex vertex, Node root, LinkedList<Node> area){
  if(root==null) return;
  area.offer(root);
  if(root.dim==0){
    if(vertex.x<root.v.x){
      connect(vertex, root.left, area);
    }else if(vertex.x>root.v.x){
      connect(vertex, root.right, area);
    }else{
      connect(vertex, root.left, area);
      connect(vertex, root.right, area);
    }
  }else{
    if(vertex.y<root.v.y){
      connect(vertex, root.left, area);
    }else if(vertex.y>root.v.y){
      connect(vertex, root.right, area);
    }else{
      connect(vertex, root.left, area);
      connect(vertex, root.right, area);
    }
  }
}
