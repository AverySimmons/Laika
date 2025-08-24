shader_type canvas_item;

uniform float thickness = 0.;
uniform vec3 color: source_color = vec3(1);
uniform float alpha = 1.;

const vec2 DIRS[] = {
	vec2(1,0),
	vec2(-1,0),
	vec2(0,1),
	vec2(0,-1),
	vec2(0.707,0.707),
	vec2(-0.707,0.707),
	vec2(0.707,-0.707),
	vec2(-0.707,-0.707)
};

void fragment() 
{
	float real_thickness = thickness + sin(TIME*20.) * thickness / 4.;
	
	float is_sprite = step(0.5, COLOR.a);
	float is_edge = 0.;
	for (int i = 0; i < 8; i++) {
		float a = texture(TEXTURE, UV + real_thickness * DIRS[i]).a;
		is_edge = max(is_edge, step(0.5, a));
	}
	
	float mask = is_edge * (1. - is_sprite);
	if (mask > 0.) {
		if (UV.y < 0.43) {COLOR.rgb = vec3(0,1,0);}
		else {COLOR.rgb = color*0.5;}
		COLOR.a = 1. * alpha;
	}
}

