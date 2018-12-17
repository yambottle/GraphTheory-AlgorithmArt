class Vertex{
  float x,y;
  int last;
  Vertex[] edges;
  Vertex(float x, float y){
    this.x = x;
    this.y = y;
    this.edges = new Vertex[20];
  }
}
