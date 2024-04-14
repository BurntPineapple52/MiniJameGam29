shader_type canvas_item;
uniform sampler2D texture_name;
//uniform float width;

void vertex() {
	// Called for every vertex the material is visible on.
	//VERTEX += vec2(10.5*sin(VERTEX.y/100.0 + TIME),0.0);//vec2(10.0*sin(VERTEX.y+TIME*15.0),0);
}

void fragment() {
	// Called for every pixel the material is visible on.
	//if FRAGCOORD.)
	float width = 0.0;
	float l1 = .1*sin((1.0-UV.y)*20.0 + TIME*5.0);
	float l2 = .1*sin((UV.y)*12.0 + TIME*2.0);
	float l3 = .1*sin((1.0-UV.y)*22.0 + TIME*3.0);
	
	float line_xpos = (l1 + l2 + l3)/20.0;
	
	//get distance to edges, if distance is less than for any of them, make invis.
	
	if (UV.x > .8 + line_xpos) { //width*TEXTURE_PIXEL_SIZE.x - 10.0 * sin(UV.y + TIME)) {
		COLOR = texture(TEXTURE, UV);
		COLOR.a = 0.0;
	}
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
