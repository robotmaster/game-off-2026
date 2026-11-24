shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	
	vec4 color_below = textureLod(screen_texture, SCREEN_UV, 0.0);
	
	float total = (1.0-COLOR.r) * color_below.r + (1.0-COLOR.g) * color_below.g + (1.0-COLOR.b) * color_below.b;
	
	total = total / 2.0;
	
	total = 0.7 - ((0.7 - total) / 6.0);
	//COLOR = vec4(total, total, total, 1);
	
	COLOR = mix(vec4(1.0, 1.0, 1.0, 1), COLOR, total);
}