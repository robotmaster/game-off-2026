shader_type canvas_item;
render_mode unshaded;

uniform float alpha;
uniform vec3 channel_colors : source_color;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float flash_interval;
uniform float flash_width;
uniform float flash_speed;
uniform float flash_alpha;

uniform float time;

void fragment() {
	vec4 original_color = textureLod(screen_texture, SCREEN_UV, 0.0);
	original_color.rgb *= channel_colors;
	
	float time_add = round(time / 0.03) * 0.03 * flash_speed;
	
	original_color.a *= alpha;
	
	float closeness_number = mod(FRAGCOORD.x - FRAGCOORD.y + time_add, flash_interval * flash_speed);
	
	float closeness = 1.0 - (abs(closeness_number - flash_width / 2.0) / (flash_width / 2.0));
	
	if (closeness_number < flash_width) {
		if (original_color.r > 0.5 || original_color.g > 0.5 || original_color.b > 0.5) {
			original_color = mix(original_color, vec4(1, 1, 1, 1), flash_alpha * closeness);
		}
	}
	
	COLOR = original_color;
}
