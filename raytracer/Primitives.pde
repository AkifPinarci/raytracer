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
       
       // remove this line when you implement spheres
       //throw new NotImplementedException("Spheres not implemented yet");
    }
    
    ArrayList<RayHit> intersect(Ray r)
    {
        ArrayList<RayHit> result = new ArrayList<RayHit>();
        PVector originToCenter = PVector.sub(this.center, r.origin);
        
        // dotProduct is the distance from origin to closest point to the center of the sphere.
        float dotProduct = PVector.dot(originToCenter, r.direction);
        if (dotProduct < 0){
            return result;
        }
        else{
            // dist is smallest distance from center of the sphere to ray.
            float dist = sqrt(PVector.dot(originToCenter, originToCenter) - (dotProduct * dotProduct));
            
            // If this distance is greater than radius, ray is not hitting the sphere
            if (this.radius < dist){
                return result;
            }
            // If distance is equal to radius, the ray touches the sphere, and there is only one intersection
            else if (this.radius == dist){
                
                // Intersection is the vector from origin to intersection point, I add the distance from origin to (distance * ray diraction).
                // This is also the point where the ray touches the sphere. 
                PVector intersection = PVector.add(r.origin, PVector.mult(r.direction, dotProduct));
                
                // Len
                float len = dotProduct;
                
                // Not sure if this is entry or not in the touching cases.
                boolean isEntry = true;
                
                // What I do here is, I draw a vector from center of sphere to intersection point. Then I normalize the normal vector.
                PVector normal = PVector.sub(intersection, this.center);
                normal = PVector.div(normal, this.radius);
                
                RayHit singleHit = new RayHit();
                singleHit.t = len;
                singleHit.location = intersection;
                singleHit.normal = normal;
                singleHit.entry = isEntry;
                result.add(singleHit);
            }
            
            // else(if the radius os greater than the dist, the ray goes through the sphere)
            else{
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
                PVector normalAtEntry = PVector.sub(entryPoint, this.center);
                normalAtEntry = PVector.div(normalAtEntry, this.radius);
                
                PVector normalAtExit = PVector.sub(exitPoint, this.center);
                normalAtExit = PVector.div(normalAtExit, this.radius);
                // Assign each value to different hits, add them to result and return it
                
                RayHit entryHit = new RayHit();
                entryHit.t = distanceToEntry;
                entryHit.location = entryPoint;
                entryHit.normal = normalAtEntry;
                entryHit.entry = true;
                
                
                RayHit exitHit = new RayHit();
                exitHit.t = distanceToExit;
                exitHit.location = exitPoint;
                exitHit.normal = normalAtExit;
                exitHit.entry = false;
                
                // Add RayHit objects to the resulting array add entry first than add exit
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
       throw new NotImplementedException("Planes not implemented yet");
    }
    
    ArrayList<RayHit> intersect(Ray r)
    {
        ArrayList<RayHit> result = new ArrayList<RayHit>();
        return result;
    }
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
       throw new NotImplementedException("Triangles not implemented yet");
    }
    
    ArrayList<RayHit> intersect(Ray r)
    {
        ArrayList<RayHit> result = new ArrayList<RayHit>();
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
