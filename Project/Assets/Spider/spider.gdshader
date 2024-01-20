shader_type spatial;

render_mode ambient_light_disabled;

uniform float bend;
uniform float rim_cutoff;
uniform float rim_amt;
uniform sampler2D gradient;

void vertex(){
	vec4 n = MODELVIEW_MATRIX * vec4(NORMAL, 0.0);
	n += vec4(0.0, 0.0, bend, 0.0);
	n = normalize(n);
	n = inverse(MODELVIEW_MATRIX) * n;
	NORMAL = n.xyz;
}

void fragment(){
	ALBEDO = vec3(1.0);
}

const float PI = 3.141592;

void light(){
	vec3 l = texture(gradient, vec2((0.5 * dot(NORMAL, LIGHT) + 0.5) * ATTENUATION.r / PI)).rgb * LIGHT_COLOR;
	vec2 light_angle_2d = normalize(LIGHT.xy);
	float rim_fac = clamp(dot(NORMAL.xy, light_angle_2d), 0.0, pow(1.0 - NORMAL.z, 3.0));
	if(rim_fac > rim_cutoff)
		l *= rim_amt;
//	if(l.r > rim && l.r < rim + 0.1)
//		DIFFUSE_LIGHT = vec3(1.0);
	DIFFUSE_LIGHT = l;
}