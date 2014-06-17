uniform vec2 iResolution;
uniform float iGlobalTime;

void main(void)
{

	float aspect = iResolution.x/iResolution.y;
	float u = (gl_FragCoord.x) / iResolution.x;
	float v = gl_FragCoord.y / iResolution.y;
	u=u*aspect-1.0+sin(iGlobalTime)*0.5;
	v-=0.5+sin(iGlobalTime)*0.3;
	vec2 uv=vec2(u, v);
	uv*=10.0;	
	uv*=uv;
	
	
	vec2 point = vec2(1.0, 1.0);
	point+=vec2(cos(iGlobalTime*10.0)*0.5, sin(iGlobalTime*10.0)*0.3);	
		
	
	float etaisyys = distance(uv, point)-(iGlobalTime);
	
	float sade = 3.;
	
	gl_FragColor = vec4(sin(etaisyys), 
						0.1+sin(iGlobalTime)*0.2+length(v), 
						sin(iGlobalTime*5.0)*0.7, 
						1.0);
}