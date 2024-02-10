shader_type spatial;

uniform float size = 1.0;
uniform vec3 offset = vec3(0.0);
uniform vec4 light_col : hint_color = vec4(1.0);
uniform vec4 dark_col : hint_color = vec4(vec3(0.5), 1.0);
uniform vec4 border_col : hint_color = vec4(vec3(0.0), 1.0);
uniform float borderThickness = 0.05;

float len_sqrd(vec3 x){
	return dot(abs(x), vec3(1.0));
}

void fragment(){
	vec3 pos = (inverse(WORLD_MATRIX) * CAMERA_MATRIX * vec4(VERTEX, 1.0)).xyz - offset;
	vec3 block_f = abs(2.0 * fract(pos / size) - 1.0);
	float block_i = len_sqrd(floor(pos / size));
	block_i = float(int(block_i) % 2);
	
	float border = max(max(block_f.x, block_f.y), block_f.z);
	border = step(1.0 - border, borderThickness);
	vec4 col = mix(light_col, dark_col, block_i);
	col = mix(col, border_col, border);
	ALBEDO = vec3(col.rgb);
}