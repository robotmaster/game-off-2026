shader_type canvas_item;
render_mode unshaded;

uniform float alpha;
uniform vec3 channel_colors : source_color;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float circle_distance;
uniform float circle_speed;
uniform vec3 circle_color_mult : source_color;
uniform vec3 circle_color_add : source_color;
uniform float circle_radius;

uniform float time;

void fragment() {
	vec4 original_color = textureLod(screen_texture, SCREEN_UV, 0.0);
	
	float time_add = round(time / 0.03) * 0.03 * circle_speed;
	if (original_color.r > 0.5 || original_color.g > 0.5 || original_color.b > 0.5) {
		float radius_squared = pow(circle_radius, 2.0);
		
		float adjusted_x = mod(FRAGCOORD.x + time * circle_speed * 2.0, circle_distance) - circle_distance / 2.0;
		float adjusted_y = mod(FRAGCOORD.y + time * circle_speed, circle_distance) - circle_distance / 2.0;
		
		if (pow(adjusted_x, 2.0) + pow(adjusted_y, 2.0) < radius_squared) {
			original_color.rgb = original_color.rgb * circle_color_mult + circle_color_add;
		}
		
		adjusted_x = mod(FRAGCOORD.x - circle_distance / 2.0 + time * circle_speed * 2.0, circle_distance) - circle_distance / 2.0;
		adjusted_y = mod(FRAGCOORD.y - circle_distance / 2.0 + time * circle_speed, circle_distance) - circle_distance / 2.0;
		
		if (pow(adjusted_x, 2.0) + pow(adjusted_y, 2.0) < radius_squared) {
			original_color.rgb = original_color.rgb * circle_color_mult + circle_color_add;
		}
		
	}
	
	
	original_color.rgb *= channel_colors;
	
	
	original_color.a *= alpha;
	
	COLOR = original_color;
	
}
