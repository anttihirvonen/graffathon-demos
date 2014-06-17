uniform vec2 iResolution;
uniform float iGlobalTime;
uniform sampler2D iChannel0;

vec2 twist(vec2 uv){
	uv.x*=abs(sin(iGlobalTime*0.5));
	uv.y*=cos(iGlobalTime*0.25);
	
	return uv;

}


void main(void)
{
	vec2 uv = gl_FragCoord.xy / iResolution.xy;	
	uv.y=-uv.y;	
	
	uv=twist(uv);
	
	vec4 kuva = vec4(texture2D(iChannel0, uv));

	kuva*=kuva;
	
	
	
	gl_FragColor = kuva;
}