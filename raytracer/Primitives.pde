class Sphere implements SceneObject
{
    PVector center;
    float radius;
    Material material;
    
    Sphere(PVector center, float radius, Material material)
    {
       this.center = center;
       this.radius = radius;
       this.material = material;
    }
    
    ArrayList<RayHit> intersect(Ray r)
    {
        ArrayList<RayHit> result = new ArrayList<RayHit>();
        PVector originToCenter = PVector.sub(this.center, r.origin);
        
        // dotProduct is the distance from origin to closest point to the center of the sphere.
        float dotProduct = PVector.dot(originToCenter, r.direction);

        // dist is smallest distance from center of the sphere to ray.
        float dist = sqrt(PVector.dot(originToCenter, originToCenter) - (dotProduct * dotProduct));
        
        // If the radius is smaller than the distance, the ray is not hitting the sphere
        if (radius > dist)
        {
        // There are entrence and exit points on the Sphere
            // Calculate the distance from closest point to radius. This is the dot product which I already calculated at the top.
            // Then calculate the distance in the sphere, this is what I alreadt calculated and stored in the dist variable
            float inSphereDist = sqrt((radius * radius) - (dist * dist));
            // Add and substract the value found in the previous step to find points in the sphere.
            float distanceToEntry = dotProduct - inSphereDist;
            float distanceToExit = dotProduct + inSphereDist;
            
            PVector entryPoint = PVector.add(r.origin, PVector.mult(r.direction, distanceToEntry));
            PVector exitPoint = PVector.add(r.origin, PVector.mult(r.direction, distanceToExit));
            // Calculate normal vectors for the hit points and normalize them
            PVector normalAtEntry = PVector.sub(entryPoint, this.center).normalize();
            
            PVector normalAtExit = PVector.sub(exitPoint, this.center).normalize();
            // Assign each value to different hits, add them to result and return it
            
            // Calculate u and v values for entry and exit hits
            
            float uE = 0.5 + (float)(Math.atan2(normalAtEntry.y, normalAtEntry.x)/(2*Math.PI));
            float vE = 0.5 - (float)(Math.asin(normalAtEntry.z)/Math.PI);
            
            float uX = 0.5 + (float)(Math.atan2(normalAtExit.y, normalAtExit.x)/(2*Math.PI));
            float vX = 0.5 - (float)(Math.asin(normalAtExit.z)/Math.PI);
            
            //
            RayHit entryHit = new RayHit();
            entryHit.t = distanceToEntry;
            entryHit.location = entryPoint;
            entryHit.normal = normalAtEntry;
            entryHit.material = this.material;
            entryHit.entry = true;
            entryHit.u = uE;
            entryHit.v = vE; 
            
            
            RayHit exitHit = new RayHit();
            exitHit.t = distanceToExit;
            exitHit.location = exitPoint;
            exitHit.normal = normalAtExit;
            exitHit.material = this.material;
            exitHit.entry = false;
            
            exitHit.u = uX;
            exitHit.v = vX;
            
            // Add RayHit objects to the resulting array add entry first than add exit

            // If entryHit.t > 0 then add it, else dont add it
            if (entryHit.t > 0){
                result.add(entryHit);
                result.add(exitHit);
            }
     
            
        }
        
        // TODO: Step 2: implement ray-sphere intersections
        return result;
    }
}

class Plane implements SceneObject
{
    PVector center;
    PVector normal;
    float scale;
    Material material;
    PVector left;
    PVector up;
    
    Plane(PVector center, PVector normal, Material material, float scale)
    {
       this.center = center;
       this.normal = normal.normalize();
       this.material = material;
       this.scale = scale;
       
       // remove this line when you implement planes
    }
    
    
    ArrayList<RayHit> intersect(Ray r)
    {
        ArrayList<RayHit> result = new ArrayList<RayHit>();
        float side = PVector.dot(PVector.sub(r.direction, this.center), this.normal);
        float originToHit = PVector.dot(PVector.sub(this.center, r.origin),this.normal);
        float t = originToHit/PVector.dot(r.direction, this.normal);
        PVector location = PVector.add(r.origin, PVector.mult(r.direction, t));
        float move = PVector.dot(r.direction, this.normal);
        
        RayHit hit = new RayHit();
        hit.t = t;
        hit.location = location;
        hit.material = this.material;
        
        // The ray start in the plane
        if(side == 0)
        {
          return result;
        }
        
        // They ray starts in front of the plane
        else if (side > 0){
            if (move == 0){
                hit.t = Float.POSITIVE_INFINITY;
;
            }
            // The ray goes away to plane
            if (move > 0){
                return result;
            }
            
            
            // The ray goes towards from the plane
            else{
                hit.normal = normal;
                hit.entry = true;
            }
        }
        
        // The ray starts behind the plane
        else{
            if (move == 0){
                hit.t = Float.POSITIVE_INFINITY;
;
            }
            // The ray goes towards to plane
            if (move > 0){
                hit.normal = PVector.mult(this.normal, -1);
                hit.entry = false;
            }
            
            
            // The ray goes away from the plane
            else{
                return result;
            }
        }
        
        
        // u and v calculations completed here
        
        // Define every variable we needed to calculate u and v values
        PVector xDir = new PVector(1,0,0);
        PVector yDir = new PVector(0,1,0);
        PVector zDir = new PVector(0,0,1);
        PVector d = PVector.sub(hit.location, this.center);
        
        if(hit.normal.normalize().equals(zDir)){
          left = PVector.cross(yDir, hit.normal, this.left).normalize();
          up = PVector.cross(hit.normal, this.left, this.up).normalize();
          float x = PVector.dot(d, this.left)/this.scale;
          float y = PVector.dot(d, this.up)/this.scale;
          hit.u = -x - floor(-x);
          hit.v = y - floor(y);
        }
        else{
          left = PVector.cross(zDir, hit.normal, this.left).normalize();
          up = PVector.cross(hit.normal, this.left, this.up).normalize();
          float x = PVector.dot(d, this.left)/this.scale;
          float y = PVector.dot(d, this.up)/this.scale;
          hit.u = x - floor(x);
          hit.v = (-y) - floor(-y);
          
        }
        
        
        result.add(hit);
        return result;
          //if(side < 0)
          //{
          //  RayHit entry = new RayHit(); 
          //  entry.t = t;
          //  entry.location = location;
          //  entry.normal = normal;
          //  entry.entry = true;
          //  entry.material = this.material;
          //  result.add(entry);
          //}
          //else
          //{
          //  RayHit exit = new RayHit(); 
          //  exit.t = t;
          //  exit.location = location;
          //  exit.normal = PVector.mult(this.normal, -1);
          //  exit.entry = false;
          //  exit.material = material;
          //  result.add(exit);
            
          //}
    }
    //ArrayList<RayHit> intersect(Ray r)
    //{
    //    ArrayList<RayHit> result = new ArrayList<RayHit>();
    //    float side = PVector.dot(r.direction,this.normal);
    //    float originToHit = PVector.dot(PVector.sub(this.center, r.origin),this.normal);
    //    if(side == 0)
    //    {
    //      return result;
    //    }
    //    float t = originToHit/side;
    //    if (t < 0)
    //    {
    //      return result;
    //    }
    //    else
    //    {
    //      PVector location = PVector.add(r.origin, PVector.mult(r.direction, t));
    //      if(side < 0)
    //      {
    //        RayHit entry = new RayHit(); 
    //        entry.t = t;
    //        entry.location = location;
    //        entry.normal = normal;
    //        entry.entry = true;
    //        entry.material = this.material;
    //        result.add(entry);
    //      }
    //      else
    //      {
    //        RayHit exit = new RayHit(); 
    //        exit.t = t;
    //        exit.location = location;
    //        exit.normal = PVector.mult(this.normal, -1);
    //        exit.entry = false;
    //        exit.material = material;
    //        result.add(exit);
            
    //      }
    //    }
    //    return result;
    //}
}

class Triangle implements SceneObject
{
    PVector v1;
    PVector v2;
    PVector v3;
    PVector normal;
    PVector tex1;
    PVector tex2;
    PVector tex3;
    Material material;
    
    Triangle(PVector v1, PVector v2, PVector v3, PVector tex1, PVector tex2, PVector tex3, Material material)
    {
       this.v1 = v1;
       this.v2 = v2;
       this.v3 = v3;
       this.tex1 = tex1;
       this.tex2 = tex2;
       this.tex3 = tex3;
       this.normal = PVector.sub(v2, v1).cross(PVector.sub(v3, v1)).normalize();
       this.material = material;
       
       // remove this line when you implement triangles
       //throw new NotImplementedException("Triangles not implemented yet");
    }
    
    ArrayList<RayHit> intersect(Ray r)
    {
        
        float dist = (PVector.dot(PVector.sub(this.v2, r.origin), this.normal)/ PVector.dot(r.direction, this.normal));
        PVector p = PVector.add(r.origin, PVector.mult(r.direction, dist));
        
        ArrayList<RayHit> result = new ArrayList<RayHit>();
        PVector edge0 = PVector.sub(this.v3, this.v1);
        PVector edge1 = PVector.sub(this.v2, this.v1);
        PVector edge2 = PVector.sub(p, this.v1);
        
        float dot00 = PVector.dot(edge0, edge0);
        float dot01 = PVector.dot(edge0, edge1);
        float dot02 = PVector.dot(edge0, edge2);
        float dot11 = PVector.dot(edge1, edge1);
        float dot12 = PVector.dot(edge1, edge2);
        
        float denom = 1 / (dot00 * dot11 - dot01 * dot01);
        float u = (dot11 * dot02 - dot01 * dot12) * denom;
        float v = (dot00 * dot12 - dot01 * dot02) * denom;
        float t = 1 - (u + v);
        
        PVector t1 = PVector.mult(this.tex1, t);
        PVector t2 = PVector.mult(this.tex2, v);
        PVector t3 = PVector.mult(this.tex3, u);
        t1 = PVector.add(t1, PVector.add(t2, t3));
        
        
        if ((u >= 0) && (v >= 0) && (u + v < 1)){
            RayHit entry = new RayHit();
            //RayHit exit = new RayHit();
            
            PVector location = PVector.add(this.v1, PVector.add(PVector.mult(edge0, u), PVector.mult(edge1, v)));
            float distance = PVector.dot(PVector.sub(location, r.origin), PVector.sub(location, r.origin));
            entry.t = distance;
            entry.location = location;
            entry.normal = PVector.mult(this.normal, 1);
            entry.material = this.material;
            entry.u = t1.x;
            entry.v = t1.y;
            entry.entry = true;
            
            //exit.t = distance;
            //exit.location = location;
            //exit.normal = PVector.mult(this.normal, -1);
            //exit.material = this.material;
            //exit.u = uAndV.y;
            //exit.v = uAndV.x;
            //exit.entry = false;
            
            result.add(entry);
            //result.add(exit);
        };
        return result;
    }
}

class Cylinder implements SceneObject
{
    float radius;
    float height;
    Material material;
    float scale;
    
    Cylinder(float radius, Material mat, float scale)
    {
       this.radius = radius;
       this.height = -1;
       this.material = mat;
       this.scale = scale;
       
       // remove this line when you implement cylinders
       throw new NotImplementedException("Cylinders not implemented yet");
    }
    
    Cylinder(float radius, float height, Material mat, float scale)
    {
       this.radius = radius;
       this.height = height;
       this.material = mat;
       this.scale = scale;
    }
    
    ArrayList<RayHit> intersect(Ray r)
    {
        ArrayList<RayHit> result = new ArrayList<RayHit>();
        return result;
    }
}

class Cone implements SceneObject
{
    Material material;
    float scale;
    
    Cone(Material mat, float scale)
    {
        this.material = mat;
        this.scale = scale;
        
        // remove this line when you implement cones
       throw new NotImplementedException("Cones not implemented yet");
    }
    
    ArrayList<RayHit> intersect(Ray r)
    {
        ArrayList<RayHit> result = new ArrayList<RayHit>();
        return result;
    }
   
}

class Paraboloid implements SceneObject
{
    Material material;
    float scale;
    
    Paraboloid(Material mat, float scale)
    {
        this.material = mat;
        this.scale = scale;
        
        // remove this line when you implement paraboloids
       throw new NotImplementedException("Paraboloid not implemented yet");
    }
    
    ArrayList<RayHit> intersect(Ray r)
    {
        ArrayList<RayHit> result = new ArrayList<RayHit>();
        return result;
    }
   
}

class HyperboloidOneSheet implements SceneObject
{
    Material material;
    float scale;
    
    HyperboloidOneSheet(Material mat, float scale)
    {
        this.material = mat;
        this.scale = scale;
        
        // remove this line when you implement one-sheet hyperboloids
        throw new NotImplementedException("Hyperboloids of one sheet not implemented yet");
    }
  
    ArrayList<RayHit> intersect(Ray r)
    {
        ArrayList<RayHit> result = new ArrayList<RayHit>();
        return result;
    }
}

class HyperboloidTwoSheet implements SceneObject
{
    Material material;
    float scale;
    
    HyperboloidTwoSheet(Material mat, float scale)
    {
        this.material = mat;
        this.scale = scale;
        
        // remove this line when you implement two-sheet hyperboloids
        throw new NotImplementedException("Hyperboloids of two sheets not implemented yet");
    }
    
    ArrayList<RayHit> intersect(Ray r)
    {
        ArrayList<RayHit> result = new ArrayList<RayHit>();
        return result;
    }
}
