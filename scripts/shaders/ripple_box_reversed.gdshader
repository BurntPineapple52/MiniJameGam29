shader_type canvas_item;
uniform sampler2D texture_name;
//uniform float width;
const float dist = .1;

void vertex() {
	// Called for every vertex the material is visible on.
	//VERTEX += vec2(10.5*sin(VERTEX.y/100.0 + TIME),0.0);//vec2(10.0*sin(VERTEX.y+TIME*15.0),0);
}

void fragment() {
	// Called for every pixel the material is visible on.
	//if FRAGCOORD.)
	float width = 0.0;
	float l1 = .15*sin((1.0-UV.y*3.0)*20.0 - TIME*5.0);
	float l2 = .15*sin((UV.y*3.0)*12.0 - TIME*2.0);
	float l3 = .15*sin((1.0-UV.y*3.0)*22.0 - TIME*3.0);
	
	float l4 = .1*sin((1.0-UV.x)*20.0 - TIME*5.0);
	float l5 = .1*sin((UV.x)*12.0 - TIME*2.0);
	float l6 = .1*sin((1.0-UV.x)*22.0 - TIME*3.0);
	
	float line_xoff = (l1 + l2 + l3)/20.0;
	float line_yoff = (l4 + l5 + l6)/20.0;
	
	float line_off = line_xoff + line_yoff;
	//get distance to edges, if distance is less than for any of them, make invis.
	
	if (UV.x - line_off < dist || UV.x + line_off > 1.0-dist || UV.y - line_off < dist || UV.y + line_off > 1.0-dist)
	{
		COLOR = texture(TEXTURE, UV);
		COLOR.a = 0.0;
	}
	/*if (UV.x > .8 + line_xpos) { //width*TEXTURE_PIXEL_SIZE.x - 10.0 * sin(UV.y + TIME)) {
		COLOR = texture(TEXTURE, UV);
		COLOR.a = 0.0;
	}*/
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
