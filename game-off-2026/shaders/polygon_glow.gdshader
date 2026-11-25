shader_type canvas_item;
render_mode unshaded;

uniform sampler2D polygon_edges : filter_nearest;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;


vec4 get_point_number(int num) {
	int width = textureSize(polygon_edges, 0).x;
	return texelFetch(polygon_edges, ivec2(num % width, num / width), 0);
}

void fragment() {
	int total_size = textureSize(polygon_edges, 0).x * textureSize(polygon_edges, 0).y;
	
	vec2 screen_point = FRAGCOORD.xy;
	
	float total_brightness = 0.0;
	
	bool inside_polygon = false;
	int polygon_first_point_index = 0;
	bool hit_point_exactly = false;
	
	float polygon_brightness = 0.0;
	float polygon_bright_fade = 0.0;
	
	float min_distance = 99999999999999.0;
	
	for (int point = 0; point < total_size; point += 1) {
		vec4 point_1_info = get_point_number(point);
		if (point_1_info.r < -99999999999.9) {
			if (hit_point_exactly) {
				inside_polygon = !inside_polygon;
			}
			if (inside_polygon) {
				total_brightness += polygon_brightness;
			}
			else {
				total_brightness += polygon_brightness * pow(polygon_bright_fade, min_distance);
			}
			polygon_brightness = 0.0;
			polygon_bright_fade = 0.0;
			inside_polygon = false;
			hit_point_exactly = false;
			min_distance = 99999999999999.0;
		}
		if (abs(point_1_info.r) > 99999999999.9) {
			polygon_first_point_index = point + 1;
			continue;
		}
		
		polygon_brightness = point_1_info.b;
		polygon_bright_fade = point_1_info.a;
		
		vec4 point_2_info = get_point_number(point + 1);
		if (abs(point_2_info.r) > 99999999999.9) {
			point_2_info = get_point_number(polygon_first_point_index);
		}
		
		vec2 point_1 = point_1_info.rg;
		vec2 point_2 = point_2_info.rg;
		
		if (!hit_point_exactly) {
			//check x is in range
			if ((screen_point.x <= point_1.x && screen_point.x >= point_2.x) ||
				(screen_point.x >= point_1.x && screen_point.x <= point_2.x)) {
				
				float slope = (point_2.y - point_1.y) / (point_2.x - point_1.x);
				float y = point_1.y + (screen_point.x - point_1.x) * slope;
				if (y > screen_point.y) {
					
					inside_polygon = !inside_polygon;
				}
			}
		}
		
		if (point_2.x == screen_point.x) {
			hit_point_exactly = true;
		}
		
		
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
		
		//total_brightness += point_1_info.b * pow(point_1_info.a, dist);
		
		if (dist < min_distance) {
			min_distance = dist;
		}
		
	}
	
	vec4 color_below = textureLod(screen_texture, SCREEN_UV, 0.0);
	
	//float brightness = pow(light_fade_mult, min_distance);
	
	COLOR = color_below * vec4(total_brightness + 1.0, total_brightness + 1.0, total_brightness + 1.0, 1);
	//COLOR = vec4(brightness, brightness, brightness, 1);
	//COLOR = vec4(brightness, brightness, brightness, 1.0);
}
