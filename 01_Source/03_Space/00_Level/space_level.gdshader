shader_type canvas_item;
uniform vec2 size;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 nuv = vec2(UV.x * (size.x/size.y), UV.y);

	vec3 col = vec3(0);
	vec2 cuv = 2.*(nuv - vec2(0.5,0.5));
	cuv.y += TIME*.1;

	float star = smoothstep(0, 1.0, 0.05/sin(length(cuv)));
	float flare = smoothstep(0.4,1.,1.0-(abs(cuv).x+abs(cuv.y)));


	col += smoothstep(0,1.,(vec3(flare) + vec3(star))*.7);

	COLOR.rgb = col;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
