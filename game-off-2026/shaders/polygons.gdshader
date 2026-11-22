shader_type canvas_item;
render_mode unshaded;

uniform float alpha;
uniform vec3 channel_colors : source_color;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 original_color = textureLod(screen_texture, SCREEN_UV, 0.0);
	original_color.a *= alpha;
	
	original_color.rgb *= channel_colors;
	
	COLOR = original_color;
}
