int N = 500;
Vertex[] vertexs = new Vertex[N];
void setup() {
   fullScreen();
   noLoop();
   background(255);
}
void draw() {
   rect(0,0,displayWidth,displayWidth);
   //genPoints();
   //conPoints();
   //printGraph();
}
void genPoints(){
   for(int i=0;i<N;i++){
      float x,y;
      x = random(0,displayWidth);
      y = random(0,displayWidth);
      stroke(0);
      strokeWeight(5);
      Vertex vertex = new Vertex(x,y);
      vertexs[i] = vertex;
      point(vertexs[i].x,vertexs[i].y);
   }
}
void conPoints(){
   for(int one=0;one<N;one++){
      for(int two=0;two<N;two++){
         if(vertexs[one]==vertexs[two])continue;
         float r = sqrt(sq(vertexs[one].x-vertexs[two].x)+sq(vertexs[one].y-vertexs[two].y));
         float midx = (vertexs[one].x+vertexs[two].x)/2;
         float midy = (vertexs[one].y+vertexs[two].y)/2;
         for(int thr=0;thr<N;thr++){
            float distance = sqrt(sq(vertexs[thr].x-midx)+sq(vertexs[thr].y-midy));
            if(distance<=r)continue;
         }
         //connected or Gabriel Neighbour
         vertexs[one].edges[vertexs[one].last] = vertexs[two];
         vertexs[one].last++;
         vertexs[two].edges[vertexs[two].last] = vertexs[one];
         vertexs[two].last++;
      }
   }
}
void printGraph(){
   for(int i=0;i<N;i++){
      stroke(0);
      strokeWeight(5);
      point(vertexs[i].x,vertexs[i].y);
      //for(int e=0;e<vertexs[i].last;e++){
         //line(vertexs[i].x,vertexs[i].y,vertexs[i].edges[e].x,vertexs[i].edges[e].y);
      //}
   }
}
