class Light
{
   PVector position;
   color diffuse;
   color specular;
   Light(PVector position, color col)
   {
     this.position = position;
     this.diffuse = col;
     this.specular = col;
   }
   
   Light(PVector position, color diffuse, color specular)
   {
     this.position = position;
     this.diffuse = diffuse;
     this.specular = specular;
   }
   
   color shine(color col)
   {
       return scaleColor(col, this.diffuse);
   }
   
   color spec(color col)
   {
       return scaleColor(col, this.specular);
   }
}

class LightingModel
{
    ArrayList<Light> lights;
    LightingModel(ArrayList<Light> lights)
    {
      this.lights = lights;
    }
    color getColor(RayHit hit, Scene sc, PVector viewer)
    {
      color hitcolor = hit.material.getColor(hit.u, hit.v);
      color surfacecol = lights.get(0).shine(hitcolor);
      PVector tolight = PVector.sub(lights.get(0).position, hit.location).normalize();
      float intensity = PVector.dot(tolight, hit.normal);
      return lerpColor(color(0), surfacecol, intensity);
    }
  
}

class PhongLightingModel extends LightingModel
{
    color ambient;
    boolean withshadow;
    PhongLightingModel(ArrayList<Light> lights, boolean withshadow, color ambient)
    {
      super(lights);
      this.withshadow = withshadow;
      this.ambient = ambient;
      
      // remove this line when you implement phong lighting
      //throw new NotImplementedException("Phong Lighting Model not implemented yet");
    }
    color getColor(RayHit hit, Scene sc, PVector viewer)
    {
      MaterialProperties material = hit.material.properties;
      float ka = material.ka;
      float kd = material.kd;
      float ks = material.ks;
      float alpha = material.alpha;
      color hitcolor = hit.material.getColor(hit.u, hit.v);
      color newAmb = multColor(scaleColor(ambient, hitcolor), ka);
      color result = newAmb;
      for (Light light: this.lights){
        // Every variable that we are planning to use is declared here
        color diffuse;
        color specular;
        PVector Lm;
        PVector Rm;
        PVector V;
        // L vector is calculated and then k_d(Lm.N)i_d is calculated and saved into diffuse
        Lm = PVector.sub(light.position, hit.location).normalize();
        float dotDiffuse = PVector.dot(Lm, hit.normal);
        dotDiffuse = dotDiffuse * kd;
        diffuse = multColor(light.shine(hitcolor), dotDiffuse);
        
        // lightScaler is the value of Lm.N, with the next 4 steps we calculated the Rm
        float lightScaler = PVector.dot(Lm, hit.normal);
        lightScaler = 2 * lightScaler;
        Rm = PVector.mult(hit.normal, lightScaler);
        Rm = PVector.sub(Rm, Lm).normalize();
        
        // Calculated and normalized the V vector
        V = PVector.sub(viewer, hit.location).normalize();
        
        // With the next 5 steps Specular light is calculated which is k_s(Rm.V)^alpha*i_s
        float rDotV = PVector.dot(Rm, V);
        double power = Math.pow(rDotV, alpha);
        float nPow = (float) power;
        nPow = nPow * ks;
        specular = multColor(light.spec(hitcolor), nPow);
        
        // Shadow implementation
        Ray hitToLight = new Ray(PVector.add(hit.location, PVector.mult(Lm, EPS)), Lm);
        ArrayList<RayHit> hitsFromImpact = sc.root.intersect(hitToLight);
        if(hitsFromImpact.size() > 0 && this.withshadow)
        {
          continue;
        }
        
        result = addColors(result, diffuse);
        result = addColors(result, specular);
      }
      return result;
      //return hit.material.getColor(hit.u, hit.v);
    }
  
}
