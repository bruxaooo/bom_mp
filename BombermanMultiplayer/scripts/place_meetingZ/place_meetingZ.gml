/// @function place_meetingz(x, y, z, object);
/// @description checa se esta havendo uma colisão com eixo X, Y e Z
/// @param x
/// @param y
/// @param z
/// @param object
var xx = argument0,
	yy = argument1,
	zz = argument2,
	object = argument3;
if (place_meeting(xx, yy, object) && zz == object.z){
	return 1;	
}
return 0;
	