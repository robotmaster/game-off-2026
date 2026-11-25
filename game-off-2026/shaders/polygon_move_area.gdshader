shader_type canvas_item;

void fragment() {
	vec4 original_color = COLOR;
	if (original_color.r > 0.5) {
		COLOR = vec4(0.6, 0.6, 0.6, 0.5);
	}
	else {
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	}
}