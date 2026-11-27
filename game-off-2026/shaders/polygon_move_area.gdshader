shader_type canvas_item;

uniform float time;
//uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float line_spacing = 12.0;
uniform float line_width = 4.0;

void fragment() {
	vec4 original_color = COLOR;
	if (original_color.r > 0.5) {
		float adjusted_time = sin(time * 1.4);
		
		COLOR = mix(vec4(0.5, 0.5, 0.5, 0.35), vec4(0.6, 0.6, 0.6, 0.45), adjusted_time);
	
		if (mod(FRAGCOORD.x + FRAGCOORD.y, line_spacing) < line_width) {
			COLOR *= vec4(1.2, 1.2, 1.2, 1.4);
		}
	}
	else {
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	}
}