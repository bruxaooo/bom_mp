/// @function instance_placez(x, y, z, object);
/// @description checa se esta havendo uma colisão com eixo X, Y e Z e retorna o id
/// @param x
/// @param y
/// @param z
/// @param object
var xx = argument0,
	yy = argument1,
	zz = argument2,
	object = argument3;
	
	
var inst = instance_place(xx, yy, object);
if (inst != -4 && inst.z == zz){
	
	return inst;	
}
return 0;
	