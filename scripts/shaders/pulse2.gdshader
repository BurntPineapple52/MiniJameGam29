shader_type canvas_item;

const float len = 0.3;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	float adj = UV.x-.5;//abs(UV.x - .5);//(1.0-UV.x) + abs(UV.x - .5);
	float opp = UV.y-.5;//abs(UV.y - .5);//(1.0-UV.y) + abs(UV.y - .5);//abs(1.0 - UV.y);
	float ang = atan(opp,adj);
	float hyp = opp/sin(ang);
	
	float m1 = 0.0;//.01*sin(1.3*ang+TIME);
	float m2 = 0.0;//.01*sin(-1.3*ang+TIME);//0.0;//.02*sin(ang*2.0+TIME);
	float m3 = 0.0;//.01*sin(-2.0*ang*4.0+TIME);//0.0;//.02*sin(-ang*4.0+TIME);
	float m4 = 0.0;//.01*sin(2.0*ang*4.0+TIME);//0.0;//.02*sin(-ang*6.0-TIME);
	float t = .008*sin(TIME*2.0)+.008;
	
	if (hyp > (len/2.0 + t)) {//m1 + m2+m3+m4)) {
		COLOR = texture(TEXTURE, UV);
		COLOR.a = 0.0;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
