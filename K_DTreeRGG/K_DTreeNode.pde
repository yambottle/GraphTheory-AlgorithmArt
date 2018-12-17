//reference and edit link:https://github.com/LinarAbzaltdinov/KdTree/blob/master/src/Node.java
class Node{
  Vertex v;
  int dim;
  Node parent = null;
  Node left=null, right = null;
  
  public Node(){
    dim = -1;
  }
  
  public Node(Vertex v, int dim, Node parent){
    this.v = v;
    this.dim = dim;
    this.parent = parent;
  }
  
  public boolean isLeaf() {
    return left == null && right == null;
  }
}

Node build_kdtree(ArrayList<Vertex> vertexs, Node n){
  if(vertexs.size()==0){
    return null;
  }else{
    
    return null;
  }
  
}

class VertexXCmp implements Comparator<Vertex>{
    @Override
    public int compare(Vertex v1, Vertex v2) {
        return v1.x>=v2.x?1:-1;
    }
}

class VertexYCmp implements Comparator<Vertex>{
    @Override
    public int compare(Vertex v1, Vertex v2) {
        return v1.y>=v2.y?1:-1;
    }
}
