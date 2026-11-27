shader_type canvas_item;

uniform float alpha;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	
	vec4 color_below = textureLod(screen_texture, SCREEN_UV, 0.0);
	color_below.a *= alpha;
	COLOR = color_below;
}