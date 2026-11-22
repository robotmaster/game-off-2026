shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	
	vec4 color_below = textureLod(screen_texture, SCREEN_UV, 0.0);
	
	if (color_below.r > 0.7 && color_below.g > 0.7 && color_below.b > 0.7) {
		COLOR.rgb *= 0.2;
	}
}