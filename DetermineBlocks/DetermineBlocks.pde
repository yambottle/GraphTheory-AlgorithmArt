import java.io.*; 
import java.util.*; 
import java.util.LinkedList; 

int rectX = 0;
int rectY = 0;
int rectW = 400;

// Reference: The code finding cutpoints is contributed by Aakash Hasija 
// https://www.geeksforgeeks.org/articulation-points-or-cut-vertices-in-a-graph/
// I implement showGraph(), countBlocks() and relative methods in Graph class, and add Vertex class to help
void setup(){
  fullScreen();
  smooth();
  noLoop();
}

void draw(){
  setCanvas();

  System.out.println("Articulation points in Third graph "); 
  Graph g3 = new Graph(7); 
  g3.addEdge(0, 1); 
  g3.addEdge(1, 2); 
  g3.addEdge(2, 0); 
  g3.addEdge(1, 3); 
  g3.addEdge(1, 4); 
  g3.addEdge(1, 6); 
  g3.addEdge(3, 5); 
  g3.addEdge(4, 5); 
  g3.AP();
  g3.showGraph();
  print("\nBlocks are: "+g3.countBlocks());
}

void setCanvas(){
  background(255);
  rectX = (displayWidth-rectW)/2;
  rectY = (displayHeight-rectW)/2;
  rect(rectX,rectY,rectW,rectW);
}

class Graph { 
  private int V; // No. of vertices 

  // Array of lists for Adjacency List Representation 
  private LinkedList<Integer> adj[];
  private Vertex points[];
  private boolean ap[] = new boolean[V];
  int time = 0; 
  static final int NIL = -1; 

  // Constructor 
  Graph(int v) { 
    V = v; 
    adj = new LinkedList[v]; 
    points = new Vertex[v];
    for (int i=0; i<v; ++i) {
      adj[i] = new LinkedList(); 
      points[i] = new Vertex(random(0,rectW-5),random(0,rectW-5));
    }
  } 

  void showGraph(){
    for (int i=0; i<this.V; ++i) {
      stroke(0);
      strokeWeight(5);
      point(rectX+points[i].x,rectY+points[i].y);
      for(int con : adj[i]){
        strokeWeight(1);
        line(rectX+points[i].x,rectY+points[i].y,rectX+points[con].x,rectY+points[con].y);
      }
    }
  }
  
  int countBlocks(){
    //remove each cut point and count how many component remain, then sum the counts
    for(int i=0;i<this.V;i++){
      if(this.ap[i]){
        stroke(255,0,0);
        strokeWeight(10);
        point(rectX+points[i].x,rectY+points[i].y);
        
        for(int j = 0;j<adj[i].size();j++){
          if(isAllVisit(this.points)) return j;
          dfs(adj[i].get(j));
        }
        removeAP(i);
      }
    }
    return this.V;
  }
  
  void dfs(int e){
    if(points[e].isVisit)return;
    if(this.ap[e])return;
    if(adj[e].isEmpty()||adj[e]==null)return;
    points[e].isVisit = true;
    for(int i:adj[e]){
      dfs(i);
    }
  }
  
  void removeAP(int V){
    for(int e:adj[V]){
      adj[e].remove(V);
    }
    adj[V] = null;
    points[V] = null;
  }
  
  
  
  boolean isAllVisit(Vertex[] points){
    boolean is= true;
    for(Vertex v: points){
      if(v==null)continue;
      if(!v.isVisit){
        is = !is;
      }
    }
    return is;
  }

  //Function to add an edge into the graph 
  void addEdge(int v, int w) { 
    adj[v].add(w); // Add w to v's list. 
    adj[w].add(v); //Add v to w's list 
  } 

  // A recursive function that find articulation points using DFS 
  // u --> The vertex to be visited next 
  // visited[] --> keeps tract of visited vertices 
  // disc[] --> Stores discovery times of visited vertices 
  // parent[] --> Stores parent vertices in DFS tree 
  // ap[] --> Store articulation points 
  void APUtil(int u, boolean visited[], int disc[], 
        int low[], int parent[], boolean ap[]) { 

    // Count of children in DFS Tree 
    int children = 0; 

    // Mark the current node as visited 
    visited[u] = true; 

    // Initialize discovery time and low value 
    disc[u] = low[u] = ++time; 

    // Go through all vertices aadjacent to this 
    Iterator<Integer> i = adj[u].iterator(); 
    while (i.hasNext()) { 
      int v = i.next(); // v is current adjacent of u 

      // If v is not visited yet, then make it a child of u 
      // in DFS tree and recur for it 
      if (!visited[v]) { 
        children++; 
        parent[v] = u; 
        APUtil(v, visited, disc, low, parent, ap); 

        // Check if the subtree rooted with v has a connection to 
        // one of the ancestors of u 
        low[u] = Math.min(low[u], low[v]); 

        // u is an articulation point in following cases 

        // (1) u is root of DFS tree and has two or more chilren. 
        if (parent[u] == NIL && children > 1) 
          ap[u] = true; 

        // (2) If u is not root and low value of one of its child 
        // is more than discovery value of u. 
        if (parent[u] != NIL && low[v] >= disc[u]) 
          ap[u] = true; 
      } 

      // Update low value of u for parent function calls. 
      else if (v != parent[u]) 
        low[u] = Math.min(low[u], disc[v]); 
    } 
  } 

  // The function to do DFS traversal. It uses recursive function APUtil() 
  boolean[] AP() { 
    // Mark all the vertices as not visited 
    boolean visited[] = new boolean[V]; 
    int disc[] = new int[V]; 
    int low[] = new int[V]; 
    int parent[] = new int[V]; 
    boolean ap[] = new boolean[V]; // To store articulation points 

    // Initialize parent and visited, and ap(articulation point) 
    // arrays 
    for (int i = 0; i < V; i++) { 
      parent[i] = NIL; 
      visited[i] = false; 
      ap[i] = false; 
    } 

    // Call the recursive helper function to find articulation 
    // points in DFS tree rooted with vertex 'i' 
    for (int i = 0; i < V; i++) 
      if (visited[i] == false) 
        APUtil(i, visited, disc, low, parent, ap); 

    // Now ap[] contains articulation points, print them 
    for (int i = 0; i < V; i++) 
      if (ap[i] == true) 
        System.out.print(i+" "); 

    this.ap = ap;
    return ap;
  } 
} 
