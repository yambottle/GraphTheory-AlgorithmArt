class Vertex{
  int index;
  float x;
  float y;
  boolean isRoot = false;
  boolean isMiddle = false;
  ArrayList<Vertex> edges;
  
  public Vertex(){
    this.x = 0;
    this.y = 0;
    this.edges = new ArrayList<Vertex>();
  }
  
  public Vertex(int index, float x, float y){
    this.index = index;
    this.x = x;
    this.y = y;
    this.edges = new ArrayList<Vertex>();
  }
  
  public Vertex(Vertex v){
    this.index = v.index;
    this.x = v.x;
    this.y = v.y;
    this.edges = v.edges;
  }
}
