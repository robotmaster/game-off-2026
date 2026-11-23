shader_type canvas_item;
render_mode unshaded;

uniform sampler2D polygon_edges : filter_nearest;
uniform float light_fade_mult;

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
	}
	
	float brightness = pow(light_fade_mult, min_distance);
	COLOR = vec4(0, 0, 0, 1);
	//COLOR = vec4(brightness, brightness, brightness, 1.0);
}
