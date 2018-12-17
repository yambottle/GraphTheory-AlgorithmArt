class Vertex{
  float x;
  float y;
  int dim;
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
}
