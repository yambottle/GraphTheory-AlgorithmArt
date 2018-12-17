class Vertex{
  float x;
  float y;
  boolean isVisit = false;
  int degree;
  
  public Vertex(){
    this.x = 0;
    this.y = 0;
    this.degree = 0;
  }
  
  public Vertex(float x, float y){
    this.x = x;
    this.y = y;
  }
}
