int N = 500;
int w = 700;
Vertex[] vertexs = new Vertex[N];
void setup() {
   size(w,w);
   noLoop();
   background(255);
}

void draw() {
   rect(0,0,w+100,w+100);
   genPoints();
   conPoints();
   findEx();
   printGraph();
}

void genPoints(){
   for(int i=0;i<N;i++){
      float x,y;
      x = random(0,w);
      y = random(0,w);
      stroke(0);
      strokeWeight(5);
      Vertex vertex = new Vertex(x,y);
      vertexs[i] = vertex;
   }
}

void conPoints(){
   for(int one=0;one<N;one++){
      for(int two=0;two<N;two++){
         bool isCon = true;
         if(vertexs[one]==vertexs[two])continue;
         int r = sqrt(sq(vertexs[one].x-vertexs[two].x)+sq(vertexs[one].y-vertexs[two].y))/2;
         int midx = (vertexs[one].x+vertexs[two].x)/2;
         int midy = (vertexs[one].y+vertexs[two].y)/2;
         for(int thr=0;thr<N;thr++){
            if(one==thr||two==thr)continue;
            int distance = sqrt(sq(vertexs[thr].x-midx)+sq(vertexs[thr].y-midy));
            if(distance<=r){
               isCon = false;
               break;
            }
         }
         if(!isCon)continue;
         vertexs[one].edges[vertexs[one].last] = vertexs[two];
         vertexs[one].last++;
         vertexs[two].edges[vertexs[two].last] = vertexs[one];
         vertexs[two].last++;
      }
   }
}

void sortByX(){
   for(int i=0;i<N;i++){
      for(int j=1;j<N-i;j++){
         if(vertexs[j-1].x>vertexs[j].x){
            Vertex temp = vertexs[j-1];
            vertexs[j-1] = vertexs[j];
            vertexs[j] = temp;
         }
      }
   }
}

void sortByY(){
   for(int i=0;i<N;i++){
      for(int j=1;j<N-i;j++){
         if(vertexs[j-1].y>vertexs[j].y){
            Vertex temp = vertexs[j-1];
            vertexs[j-1] = vertexs[j];
            vertexs[j] = temp;
         }
      }
   }
}

void findEx(){
   stroke(255,0,0);
   strokeWeight(8);
   for(int i=0;i<N;i++){
      Vertex v = vertexs[i];
      if(v.x<w/8){
         intersect( new Vertex(0,v.y),v);
      }else if(v.x>7*w/8){
         intersect( new Vertex(w,v.y),v);              
      }
      if(v.y<w/8){
         intersect( new Vertex(v.x,0),v);
      }else if(v.y>7*w/8){
         intersect( new Vertex(v.x,w),v);
      }
   }
   for(int i=0;i<N;i++){
      bool isOne = true;
      for(int e=0;e<vertexs[i].last;e++){
         if(vertexs[i].edges[e].isEx){
            isOne = false;
            break;
         }
      }
      if(isOne)vertexs[i].isEx = false;      
   }
}

void intersect(Vertex b, Vertex v){
   //point(b.x,b.y);
   if(v.isEx)return;
   for(int i=0;i<v.last;i++){
      Vertex e = v.edges[i];
      for(int sec=0;sec<e.last;sec++){
         if(e.edges[sec]==v)continue;
         if(isIntersect(b,v,e,e.edges[sec])){
            return;      
         }
      }
   }
   v.isEx = true;
   return;
}

bool isIntersect(Vertex b, Vertex v, Vertex p1, Vertex p2){
   double m = (v.x-b.x)*(p1.y-b.y)-(p1.x-b.x)*(v.y-b.y);
   double n = (v.x-b.x)*(p2.y-b.y)-(p2.x-b.x)*(v.y-b.y);
   double p = (p2.x-p1.x)*(b.y-p1.y)-(b.x-p1.x)*(p2.y-p1.y);
   double q = (p2.x-p1.x)*(v.y-p1.y)-(v.x-p1.x)*(p2.y-p1.y);
   if(m*n<=0&&p*q<=0){
      return true;
   }else{
      return false;
   }
}

void findExSweep(){// If each point has distinct Y-value, then it doesn't work
Dictionary xdic = new Dictionary(N);
sortByX();
for(int i=0;i<N;i++){
   Vertex v = vertexs[i];
   if(xdic.get(v.y)==-1){
      v.isEx = true;
      //point(v.x,v.y);
      xdic.set(v.y,v.x);
   }else{
      if(xdic.get(v.y)<v.x){
         xdic.set(v.y,v.x);
      }
   }
}
}

void printGraph(){
for(int i=0;i<N;i++){
   stroke(0);
   strokeWeight(8);
   if(vertexs[i].isEx) stroke(255,0,0);
   point(vertexs[i].x,vertexs[i].y);
   for(int e=0;e<vertexs[i].last;e++){
      stroke(0);
      strokeWeight(1);
      if(vertexs[i].isEx&&vertexs[i].edges[e].isEx){
         stroke(255,0,0);
      }else{
         stroke(0);         
      }
      line(vertexs[i].x,vertexs[i].y,vertexs[i].edges[e].x,vertexs[i].edges[e].y);
   }
}
}
