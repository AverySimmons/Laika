shader_type canvas_item;

uniform vec2 size;
uniform bool boost;

const float STAR_DENSITY = .12;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec2 hash(vec2 uv) {
    return fract(sin(vec2(dot(uv, vec2(12.9898, 78.233)),
                          dot(uv, vec2(45.832, 83.132)))) * 43758.5453);
}

vec3 render_star(vec2 tile, vec2 uv, bool flickering) {
	vec3 col = vec3(0);
	vec2 h1 = hash(tile);
	vec2 h2 = hash(h1);
	
	if (h1.x > 1.-STAR_DENSITY) {
		float t = TIME * h2.x * 2. + h2.y;
		vec2 cuv = (2. + h1.y - .5)*(uv - vec2(0.5,0.5)); // centred uv (-1 to 1 instead of 0 to 1)
		cuv += vec2(-.5) + h2;

		float star = smoothstep(0, 1.0, 0.05/sin(length(cuv)));
		float flare = smoothstep(0.96,1.,.99-(abs(cuv).x*abs(cuv.y)))*(.8-length(cuv)*1.2);

		float b = 1.;
		if (flickering) b = smoothstep(0,1.,sin(t));

		col += smoothstep(0,1.,(vec3(flare) + vec3(star))*.7) * b;
	}

	return col;
}

void fragment() {
	vec3 col = vec3(0);

	//vec2 nuv = vec2(UV.x * (size.x/size.y), UV.y); // new uv where 1,1 is always square in relation to 0,0
//
	//vec2 uv1 = vec2(nuv.x, nuv.y - TIME)*8.;
	//vec2 uv2 = vec2(nuv.x, nuv.y - TIME*.5)*12.;
	//vec2 uv3 = vec2(nuv.x, nuv.y - TIME*.2)*15.;
	//vec2 uv4 = vec2(nuv.x, nuv.y - TIME*.1)*19.;
//
	//vec2 tuv1 = floor(uv1);
	//vec2 tuv2 = floor(uv2);
	//vec2 tuv3 = floor(uv3);
	//vec2 tuv4 = floor(uv4);
//
	//uv1 = fract(uv1);
	//uv2 = fract(uv2);
	//uv3 = fract(uv3);
	//uv4 = fract(uv4);
//
	//col += render_star(tuv1, uv1, false);
	//col += render_star(tuv2, uv2, true);
	//col += render_star(tuv3, uv3, true);
	//col += render_star(tuv4, uv4, true);

	//col += render_star(vec2(0),nuv);
	
	 col += vec3(0.1, 0, .1);

	COLOR.rgb = col;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
