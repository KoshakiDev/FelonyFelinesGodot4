shader_type canvas_item;

//const float PI = 3.14159;

uniform float progress : hint_range(0, 1) = 0;

void fragment(){
	vec2 point = UV - vec2(.5);
	float angle = (1. - atan(point.x, point.y) / PI) * .5;
	if (angle <= progress) {
		COLOR = texture(TEXTURE, UV);
	} else {
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	}
}