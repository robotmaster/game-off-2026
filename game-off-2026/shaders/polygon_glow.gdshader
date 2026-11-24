shader_type canvas_item;
render_mode unshaded;

uniform sampler2D polygon_edges : filter_nearest;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;


vec2 get_point_number(int num) {
	int width = textureSize(polygon_edges, 0).x;
	return texelFetch(polygon_edges, ivec2(num % width, num / width), 0).rg;
}

void fragment() {
	int total_size = textureSize(polygon_edges, 0).x * textureSize(polygon_edges, 0).y;
	float min_distance = 99999999.9;
	
	for (int point = 0; point < total_size; point += 2) {
		vec2 point_1 = get_point_number(point);
		vec2 point_2 = get_point_number(point + 1);
		
		vec2 screen_point = FRAGCOORD.xy;
		
		vec2 point_1_to_2 = point_2 - point_1;
		
		if (length(point_1_to_2) == 0.0) {
			continue;
		}
		
		point_1_to_2 = normalize(point_1_to_2);
		float screen_dot = dot(screen_point, point_1_to_2);
		float dist;
		if (screen_dot < dot(point_1, point_1_to_2)) {
			dist = length(point_1 - screen_point);
		}
		else if (screen_dot < dot(point_2, point_1_to_2)) {
			vec2 perpendicular = vec2(-point_1_to_2.y, point_1_to_2.x);
			dist = dot(screen_point, perpendicular) - dot(point_1, perpendicular);
			dist = abs(dist);
		}
		else {
			dist = length(point_2 - screen_point);
		}
		
		if (dist < min_distance) {
			min_distance = dist;
		}
		
	}
	
	vec4 color_below = textureLod(screen_texture, SCREEN_UV, 0.0);
	
	//float brightness = pow(light_fade_mult, min_distance);
	float brightness = 0.5;
	
	COLOR = color_below * vec4(brightness + 1.0, brightness + 1.0, brightness + 1.0, 1);
	//COLOR = vec4(brightness, brightness, brightness, 1);
	//COLOR = vec4(brightness, brightness, brightness, 1.0);
}
