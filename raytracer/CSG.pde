import java.util.Comparator;

class HitCompare implements Comparator<RayHit>
{
  int compare(RayHit a, RayHit b)
  {
     if (a.t < b.t) return -1;
     if (a.t > b.t) return 1;
     if (a.entry) return -1;
     if (b.entry) return 1;
     return 0;
  }
}

class Union implements SceneObject
{
  SceneObject[] children;
  Union(SceneObject[] children)
  {
    this.children = children;
  }

  ArrayList<RayHit> intersect(Ray r)
  {

     ArrayList<RayHit> hits = new ArrayList<RayHit>();
     ArrayList<RayHit> trueHits = new ArrayList<RayHit>();
     int entries = 0;

     for (SceneObject object : children)
     {
       hits.addAll(object.intersect(r));
     }

     if (hits.isEmpty()) {
       return hits;
     }

     hits.sort(new HitCompare());

     for (RayHit hit: hits) {
       if (hit.entry && entries < 1) {
         entries++;
         trueHits.add(hit);
       }
       else if (!hit.entry && entries < 1) {
         trueHits.add(hit);
       } else if (hit.entry) {
         entries++;
       } else if (!hit.entry && entries == 1) {
         trueHits.add(hit);
         entries--;
       }
       else {
         entries--;
       }
     }

     if (alternates(trueHits)) {
       return trueHits;
     }
     return hits;
  }

  Boolean alternates(ArrayList<RayHit> hits) {
    if (hits.isEmpty()) {
     return true;
   }
    Boolean previous = hits.get(0).entry;
    for (int i = 1; i < hits.size(); i++) {
      if (hits.get(i).entry == previous) {
        return false;
      } else {
        previous = !previous;
      }
    }
    return true;
  }
}
class Intersection implements SceneObject
{
  SceneObject[] elements;
  Intersection(SceneObject[] elements)
  {
    this.elements = elements;
  }


  ArrayList<RayHit> intersect(Ray r)
  {
     ArrayList<RayHit> hits = new ArrayList<RayHit>();
     ArrayList<RayHit> temp = new ArrayList<RayHit>();
     int elems = 0;
     int in = 0;
     for (SceneObject sc : elements)
     {
       temp.addAll(sc.intersect(r));
       elems ++;
     }

     if (temp.isEmpty()) {
       return hits;
     }

     temp.sort(new HitCompare());

     for (RayHit rh: temp){
         if (rh.entry){
             in++;
         }
         else {
             in--;
         }
         if (in == (elems) && rh.entry){
             hits.add(rh);
         }
         else if (in == (elems - 1) && !rh.entry){
             hits.add(rh);
         }
     }

     if (alternates(hits)) {
       return hits;
     }

     return temp;
 }
 
 Boolean alternates(ArrayList<RayHit> hits) {
   if (hits.isEmpty()) {
     return true;
   }
   Boolean previous = hits.get(0).entry;
   for (int i = 1; i < hits.size(); i++) {
     if (hits.get(i).entry == previous) {
       return false;
     } else {
       previous = !previous;
     }
   }
   return true;
  }
}

class Difference implements SceneObject
{
  SceneObject a;
  SceneObject b;
  Difference(SceneObject a, SceneObject b)
  {
    this.a = a;
    this.b = b;
    
    // remove this line when you implement difference
    //throw new NotImplementedException("CSG Operation: Difference not implemented yet");
  }
  
  ArrayList<RayHit> intersect(Ray r)
  {

     ArrayList<RayHit> hits = new ArrayList<RayHit>();
     ArrayList<RayHit> hitsOfA = new ArrayList<RayHit>();
     ArrayList<RayHit> hitsOfB = new ArrayList<RayHit>();
     RayHit rh = new RayHit();
     boolean inA = false;
     boolean inB = false;
     boolean comesFrom = false;
     hitsOfA.addAll(a.intersect(r));
     hitsOfB.addAll(b.intersect(r));
     int trackA = 0;
     int trackB = 0;
     
     while (trackA < hitsOfA.size() && trackB < hitsOfB.size()) {
         if (hitsOfA.get(trackA).t <= hitsOfB.get(trackB).t){
             rh = hitsOfA.get(trackA);
             comesFrom = true;
             trackA ++;
             if (rh.entry) {
                inA = true; 
             }
             else {
                 inA = false;
             }
         }
         else{
             rh = hitsOfB.get(trackB);
             comesFrom = false;
             trackB ++;
             if (rh.entry){
                 inB = true;
             }
             else{
                 inB = false;
             }
         }
         if (inA && !inB){
             if (comesFrom){
                 hits.add(rh);
             }
             else {
                 rh.entry = !rh.entry;
                 rh.normal = PVector.mult(rh.normal, -1);
                 hits.add(rh);
             }
         }
     }
     while (trackA < hitsOfA.size()) {
         
         rh = hitsOfA.get(trackA);
         comesFrom = true;
         trackA ++;
         if (rh.entry) {
            inA = true; 
         }
         else {
             inA = false;
         }
         if (inA && !inB){
             if (comesFrom){
                 hits.add(rh);
             }
             else {
                 rh.entry = !rh.entry;
                 rh.normal = PVector.mult(rh.normal, -1);
                 hits.add(rh);
             }
         }
     }
     while (trackB < hitsOfB.size()) {
         
         rh = hitsOfB.get(trackB);
         comesFrom = false;
         trackB ++;
         if (rh.entry) {
            inB = true; 
         }
         else {
             inB = false;
         }
         if (inA && !inB){
             if (comesFrom){
                 hits.add(rh);
             }
             else {
                 rh.entry = !rh.entry;
                 rh.normal = PVector.mult(rh.normal, -1);
                 hits.add(rh);
             }
         }
     }
     return hits;
  }
  
}
