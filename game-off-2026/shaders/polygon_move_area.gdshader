shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 original_color = textureLod(screen_texture, SCREEN_UV, 0.0);
	if (original_color.r > 0.5) {
		COLOR = vec4(0.7, 0.7, 0.7, 0.3);
	}
	else {
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	}
}