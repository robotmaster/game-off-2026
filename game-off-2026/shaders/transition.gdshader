shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float time;

void fragment() {
	float converted_offset = time;
	
	vec2 pos = SCREEN_UV + vec2(converted_offset, 0);
	vec4 left_color;
	if (pos.x < 0.0 || pos.x > 1.0 || pos.y < 0.0 || pos.y > 1.0) {
		left_color = vec4(0, 0, 0, 0);
	}
	else {
		left_color = textureLod(screen_texture, pos, 0.0);
	}
	
	pos = SCREEN_UV - vec2(converted_offset, 0);
	vec4 right_color;
	if (pos.x < 0.0 || pos.x > 1.0 || pos.y < 0.0 || pos.y > 1.0) {
		right_color = vec4(0, 0, 0, 0);
	}
	else {
		right_color = textureLod(screen_texture, pos, 0.0);
	}
	
	pos = SCREEN_UV - vec2(0, converted_offset);
	vec4 bottom_color;
	if (pos.x < 0.0 || pos.x > 1.0 || pos.y < 0.0 || pos.y > 1.0) {
		bottom_color = vec4(0, 0, 0, 0);
	}
	else {
		bottom_color = textureLod(screen_texture, pos, 0.0);
	}
	
	float offset_amount = 0.0;
	
	COLOR = vec4(left_color.r, right_color.g, bottom_color.b, 1);
}
