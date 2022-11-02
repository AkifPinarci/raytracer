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
      color surfacecol = lights.get(0).shine(hitcolor);
      color newAmb = multColor(scaleColor(hitcolor, ambient), ka);
      color result = newAmb;
      for (Light light: this.lights){
        color diffuse;
        color specular;
        PVector Lm;
        PVector Rm;
        Lm = PVector.sub(light.position, hit.location).normalize();
        float dotDiffuse = PVector.dot(Lm, hit.normal);
        float lightScaler = dotDiffuse;
        lightScaler = 2 * lightScaler;
        dotDiffuse = dotDiffuse * kd;
        diffuse = multColor(light.shine(light.diffuse), dotDiffuse);
        Rm = PVector.mult(hit.normal, lightScaler);
        Rm = PVector.sub(Rm, Lm);
        viewer = PVector.sub(viewer, hit.location).normalize();
        float rDotV = PVector.dot(Rm, viewer);
        double power = Math.pow(rDotV, alpha);
        float nPow = (float) power;
        nPow = nPow * ks;
        specular = multColor(light.specular, nPow);
        result = addColors(result, diffuse);
        result = addColors(result, specular);
      }
      return result;
      //return hit.material.getColor(hit.u, hit.v);
    }
  
}
