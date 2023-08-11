shader_type canvas_item;

uniform float blend_value = 1.0;

void fragment() {
	COLOR = vec4(COLOR.rgb,COLOR.a*blend_value);
}
