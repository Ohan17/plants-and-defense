shader_type canvas_item;

uniform float hit;

vec3 screen(vec3 base, vec3 blend){
	return 1.0 - (1.0 - base) * (1.0 - blend);
}


void fragment() {
	COLOR = vec4(screen(COLOR.rgb,vec3(hit)), COLOR.a);
}