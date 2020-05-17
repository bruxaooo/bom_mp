/// @description
if (BombData[? "State"] == "Normal" && !BombData[? "Remote"] && !BombData[? "Land"]){
	BombData[? "cRoll"] ++;
}else if (BombData[? "Land"]){
	image_speed = 0;
	image_index = 4;
}