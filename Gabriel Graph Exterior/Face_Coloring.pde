void setup() {
   size(screen.height, screen.width);
}

void draw() {
   background(255, 255, 255);
   Vertex va,vb,vc,vd,ve,vf,vg;
   va = new Vertex(200,100);
   vb = new Vertex(350,100);
   vc = new Vertex(500,100);
   ve = new Vertex(200,250);
   vf = new Vertex(350,250);
   vg = new Vertex(500,250);
   vd = new Vertex(350,400);

   linkVertices(va,vb);
   linkVertices(vb,vc);
   linkVertices(va,ve);
   linkVertices(ve,vf);
   linkVertices(vb,vf);
   linkVertices(vf,vg);
   linkVertices(vc,vg);
   linkVertices(vf,vc);
   linkVertices(ve,vd);
   linkVertices(vg,vd);

   printVertex(va, "A");
   printVertex(vb, "B");
   printVertex(vc, "C");
   printVertex(ve, "E");
   printVertex(vf, "F");
   printVertex(vg, "G");
   printVertex(vd, "D");

   printColorLable("R1",color(255,0,0), 600, 175);
   printColorLable("G2",color(0,255,0), 275, 175);
   printColorLable("B3",color(0,0,255), 375, 175);
   printColorLable("G2",color(0,255,0), 450, 175);
   printColorLable("Y4",color(255,200,0), 350, 325);

   stroke(0);
   fill(0);

   triangle(va.x/2+vb.x/2,va.y/2+vb.y/2,
				va.x/2+vb.x/2+15,va.y/2+vb.y/2-7,
			   va.x/2+vb.x/2+15,va.y/2+vb.y/2+7);
   triangle(vb.x/2+vc.x/2,vb.y/2+vc.y/2,
				vb.x/2+vc.x/2+15,vb.y/2+vc.y/2-7,
			   vb.x/2+vc.x/2+15,vb.y/2+vc.y/2+7);
   triangle(ve.x/2+vf.x/2,ve.y/2+vf.y/2,
				ve.x/2+vf.x/2+15,ve.y/2+vf.y/2-7,
			   ve.x/2+vf.x/2+15,ve.y/2+vf.y/2+7);
   triangle(vf.x/2+vg.x/2,vf.y/2+vg.y/2,
				vf.x/2+vg.x/2+15,vf.y/2+vg.y/2-7,
			   vf.x/2+vg.x/2+15,vf.y/2+vg.y/2+7);//horizontal

   triangle(va.x/2+ve.x/2,va.y/2+ve.y/2,
				va.x/2+ve.x/2-7,va.y/2+ve.y/2-15,
			   va.x/2+ve.x/2+7,va.y/2+ve.y/2-15);
   triangle(vb.x/2+vf.x/2,vb.y/2+vf.y/2,
				vb.x/2+vf.x/2-7,vb.y/2+vf.y/2-15,
			   vb.x/2+vf.x/2+7,vb.y/2+vf.y/2-15);
   triangle(vc.x/2+vg.x/2,vc.y/2+vg.y/2,
				vc.x/2+vg.x/2-7,vc.y/2+vg.y/2+15,
			   vc.x/2+vg.x/2+7,vc.y/2+vg.y/2+15);//vertical

   triangle(vc.x/2+vf.x/2,vc.y/2+vf.y/2,
				vc.x/2+vf.x/2-15,vc.y/2+vf.y/2+7,
			   vc.x/2+vf.x/2-7,vc.y/2+vf.y/2+15);
   triangle(vd.x/2+vg.x/2,vd.y/2+vg.y/2,
				vd.x/2+vg.x/2-15,vd.y/2+vg.y/2+7,
			   vd.x/2+vg.x/2-7,vd.y/2+vg.y/2+15);
   triangle(vd.x/2+ve.x/2,vd.y/2+ve.y/2,
				vd.x/2+ve.x/2-7,vd.y/2+ve.y/2-15,
			   vd.x/2+ve.x/2-15,vd.y/2+ve.y/2-7);//45 degree
	
	printWeight(va,vb,1);
	printWeight(vb,vc,2);
	printWeight(va,ve,1);
	printWeight(vc,vg,1);
	printWeight(vb,vf,1);
	printWeight(vc,vf,1);
	printWeight(ve,vf,2);
	printWeight(vg,vf,2);
	printWeight(vd,ve,3);
	printWeight(vd,vg,3);
}

void printVertex(Vertex v, String s){
   fill(0);
   ellipse(v.x,v.y,50,50);
   textSize(26);
   fill(255);   
   text(s,v.x-8,v.y+5);
}

void linkVertices(Vertex v1, Vertex v2){
   stroke(0);
   strokeWeight(3);
   line(v1.x,v1.y,v2.x,v2.y);
}

void printColorLable(String s, color c, int x, int y){
   fill(c);
   text(s, x, y);
}

void printWeight(Vertex v1, Vertex v2, String s){
   textSize(26);
   fill(color(0,150,255));   
   text(s,v1.x/2+v2.x/2,v1.y/2+v2.y/2);
}
