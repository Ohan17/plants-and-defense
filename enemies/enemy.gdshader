shader_type canvas_item;

uniform float hit = 0.0;


void fragment() {
	COLOR = vec4(mix(COLOR.rgb,vec3(1.0),hit), COLOR.a);
}
