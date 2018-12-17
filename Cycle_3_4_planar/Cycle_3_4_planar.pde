int rectX = 0;
int rectY = 0;
int rectW = 400;

void setup(){
  fullScreen();
  smooth();
  noLoop();
}

void draw(){
  setCanvas();
  ArrayList<Vertex> points = genGraph();
  computeCycles(points);
}

void setCanvas(){
  background(255);
  rectX = (displayWidth-rectW)/2;
  rectY = (displayHeight-rectW)/2;
  rect(rectX,rectY,rectW,rectW);
}

ArrayList<Vertex> genGraph(){
  float zoom = 13;
  ArrayList<Vertex> points = new ArrayList<Vertex>();
  Vertex va = new Vertex(0,10,10);
  points.add(va);
  Vertex vb = new Vertex(1,15,10);
  points.add(vb);
  Vertex vc = new Vertex(2,20,10);
  points.add(vc);
  Vertex vd = new Vertex(3,12.5,12.5);
  points.add(vd);
  Vertex ve = new Vertex(4,17.5,12.5);
  points.add(ve);
  Vertex vf = new Vertex(5,12.5,17.5);
  points.add(vf);
  Vertex vg = new Vertex(6,17.5,17.5);
  points.add(vg);
  Vertex vh = new Vertex(7,10,20);
  points.add(vh);
  Vertex vi = new Vertex(8,20,20);
  points.add(vi);
  
  va.edges.add(vb);
  va.edges.add(vd);
  va.edges.add(vh);
  vb.edges.add(va);
  vb.edges.add(vd);
  vb.edges.add(ve);
  vb.edges.add(vc);
  vc.edges.add(vb);
  vc.edges.add(ve);
  vc.edges.add(vi);
  vd.edges.add(va);
  vd.edges.add(vb);
  vd.edges.add(ve);
  vd.edges.add(vf);
  ve.edges.add(vb);
  ve.edges.add(vc);
  ve.edges.add(vd);
  ve.edges.add(vg);
  vf.edges.add(vh);
  vf.edges.add(vd);
  vf.edges.add(vg);
  vg.edges.add(ve);
  vg.edges.add(vf);
  vg.edges.add(vi);
  vh.edges.add(va);
  vh.edges.add(vf);
  vh.edges.add(vi);
  vi.edges.add(vh);
  vi.edges.add(vg);
  vi.edges.add(vc);
  
  for(Vertex v:points){
    stroke(0);
    strokeWeight(5);
    point(rectX+v.x*zoom,rectY+v.y*zoom);
    for(Vertex e:v.edges){
      strokeWeight(1);
      line(rectX+v.x*zoom, rectY+v.y*zoom, rectX+e.x*zoom, rectY+e.y*zoom);
    }
  }
  return points;
}

void computeCycles(ArrayList<Vertex> points){
  print("Encoding A-I from 0-8:\n");
  for(Vertex v: points){
    v.isRoot = true;
    
    //Middle level
    boolean middle[] = new boolean[points.size()];
    //leaves
    int leaves[] = new int[points.size()];
    ArrayList<ArrayList<Vertex>> parents = new ArrayList<ArrayList<Vertex>>();//leaves parents
    for(int i = 0; i<points.size();i++){//cannot use array for ArrayList
      parents.add(new ArrayList<Vertex>());//init
    }
    
    for(Vertex e:v.edges){
      if(!e.isRoot){
        e.isMiddle = true;
        middle[e.index] = true;
        for(Vertex l:e.edges){
          if(!l.isMiddle&&l.index!=v.index){
            leaves[l.index]++;
            parents.get(l.index).add(e);
          }
        }
      }
    }
    
    for(int i = 0; i<points.size();i++){
      if(middle[i]==true&&leaves[i]==1){
        print("3-cycle: ");
        print(v.index+" "+i+" "+parents.get(i).get(0).index+"\n");
      }
      if(leaves[i]==2){
        print("4-cycle: ");
        print(v.index+" "+i+" "+parents.get(i).get(0).index+" "+parents.get(i).get(1).index+"\n");
      }
    }
    
    //reset middle level
    for(Vertex e:v.edges){
      e.isMiddle = false;
    }
  }
}
