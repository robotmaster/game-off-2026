shader_type canvas_item;

uniform float time;

void fragment() {
	vec4 original_color = COLOR;
	if (original_color.r > 0.5) {
		float adjusted_time = sin(time * 1.4);
		
		COLOR = mix(vec4(0.6, 0.6, 0.6, 0.5), vec4(0.7, 0.7, 0.7, 0.6), adjusted_time);
	}
	else {
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	}
}