/// @description
if (Step == 0){
	BombData[? "BombID"] = irandom(9999999);
	while (ds_list_find_index(oController.BombList, BombData[? "BombID"])){
		BombData[? "BombID"] = irandom(100);
	}
	ds_list_add(oController.BombList, BombData[? "BombID"]);
	oController.NewBomb = BombData;
	Step ++;
}
depth = z * -1;
if (Solid == 0 && distance_to_object(oPlayer) != 0){
	Solid = 1;	
	if (BombData[? "Land"]){
		BombData[? "CanExplode"] = 1;	
	}
}

#region zAxis
	if (z > ZStart){
		Zspd --;		
	}
	if ((z + Zspd) < ZStart){
		while (z > ZStart){						
			z--;	
		}
		if (z == ZStart){
			Zspd = 0;
			
			
		}
	}		
	
	z += Zspd;				
#endregion
#region Move
	if (BombData[? "State"] == "Kick"){
		for (var i = 0; i < ds_list_size(SolidList); i ++){
			var SolidMeet = SolidList[| i];
			if (place_meetingZ(x + Hspd, y, z, SolidMeet)){
				while !(place_meetingZ(x + sign(Hspd), y, z, SolidMeet)){
					x += sign(Hspd);	
				}
				Hspd = 0;		
				BombData[? "State"] = "Normal";
			}
		}
		x += Hspd;
		for (var i = 0; i < ds_list_size(SolidList); i ++){
			var SolidMeet = SolidList[| i];
			if (place_meetingZ(x, y + Vspd, z, SolidMeet)){
				while !(place_meetingZ(x, y + sign(Vspd), z, SolidMeet)){
					y += sign(Vspd);	
				}
				Vspd = 0;	
				BombData[? "State"] = "Normal";
			}
		}
		y += Vspd;		
	}
	if (BombData[? "State"] == "Punch"){
		
		var Check = 0;
		if (z == ZStart){	
			x = round(x/16) * 16;
			y = round(y/16) * 16;
			for (var i = 0; i < ds_list_size(SolidList); i ++){
				ThisSolid = SolidList[| i];				
				var Col = collision_rectangle(bbox_left + 4, bbox_top + 4, bbox_right - 4, bbox_bottom -4, ThisSolid, 0, 1);
				if (Col && Col.z == z){
					Hspd = lengthdir_x(2, PunchDir);
					Vspd = lengthdir_y(2, PunchDir);
					Zspd = 4;					
					Check ++;
					if (place_meetingZ(x, y, z, oPlayer)){
						Solid = 0;	
						oPlayer.State = "Stun";
						oPlayer.image_index = 0;
					}
				}
			}								
			if (Check == 0){				
				Hspd = 0;
				Vspd = 0;
				Zspd = 0;		
				BombData[? "State"] = "Normal";
			}
		}
		x += Hspd;
		y += Vspd;
		
		
		
	}
	if (BombData[? "State"] == "Lift"){
		z = 32;	
	}
#endregion
if (BombData[? "Land"]){
	sprite_index = sLandBomb;	
	if (Solid && place_meetingZ(x, y, z, oPlayer)){
		BombData[? "cRoll"] = BombData[? "Rolls"];	
	}
}else
if (BombData[? "Remote"]){
	sprite_index = sRemoteBomb;
	
}else
if (BombData[? "Pierce"]){
	sprite_index = sPierceBomb;	
}
if (BombData[? "cRoll"] == BombData[? "Rolls"]){
	instance_destroy();
	oPlayer.CurrentBombs--;
	var x1 = floor(x/16) * 16;
	var y1 = floor(y/16) * 16;
	var BombPierce = BombData[? "Pierce"];
	var Center = instance_create_depth(x1 + 8, y1 + 8, depth, oExplosion);
	with(Center){
		var Bomb = instance_place(x, y, oBomb);
		if (Bomb != -4){
			Bomb.BombData[? "cRoll"] = Bomb.BombData[? "Rolls"];	
		}
		var Block = collision_rectangle(bbox_left + 7, bbox_top + 7, bbox_right - 7, bbox_bottom -7, oBlock, 0, 0);				
		if (Block){																					
			with (Block){							
				image_speed = 1;
				image_index = 0;
				z = 3;							
			}					
			if !(BombPierce){								
				sprite_index = sExplosionTail;									
				break;
			}	
		}		
		var PowerUp = collision_rectangle(bbox_left + 7, bbox_top + 7, bbox_right - 7, bbox_bottom - 7, oPowerUp, 0, 0);
		if (PowerUp){
			PowerUp.image_index = 0;
			PowerUp.sprite_index = sPowerUpDestroy;	
		}
	}
	Center.sprite_index = sExplosionCenter;	
	for (var i = 0; i < 4; i ++){
		var TempReach = BombData[? "Reach"];		
		var Dir = i * 90;
		for (var k = 0; k < TempReach; k ++){
			var xx = lengthdir_x(16 + 16 * k, Dir);
			var yy = lengthdir_y(16 + 16 * k, Dir);
			var Body= instance_create_depth(x1 + 8 + xx, y1 + 8 + yy, depth, oExplosion);				
			Body.sprite_index = sExplosionBody;
			if (k == BombData[? "Reach"] -1){				
				Body.sprite_index = sExplosionTail;	
				
			}
			Body.image_angle = Dir;
			with(Body){
				
				var Bomb = instance_place(x, y, oBomb);
				if (Bomb != -4){
					Bomb.BombData[? "cRoll"] = Bomb.BombData[? "Rolls"];	
				}
				var Block = collision_rectangle(bbox_left + 7, bbox_top + 7, bbox_right - 7, bbox_bottom -7, oBlock, 0, 0);				
				if (Block){																					
					with (Block){							
						image_speed = 1;
						image_index = 0;
						z = 3;							
					}					
					if !(BombPierce){
						TempReach = k;						
						sprite_index = sExplosionTail;									
						break;
					}	
				}
				var Rec = collision_rectangle(bbox_left + 7, bbox_top + 7, bbox_right - 7, bbox_bottom -7, oSolid, 0, 0);				
				if (Rec){
					TempReach = k;					
					instance_destroy(Body);
					break;				
				}
				var PowerUp = collision_rectangle(bbox_left + 7, bbox_top + 7, bbox_right - 7, bbox_bottom - 7, oPowerUp, 0, 0);
				if (PowerUp){
					PowerUp.image_index = 0;
					PowerUp.sprite_index = sPowerUpDestroy;	
				}
			}
		}
	}
	
}
if (bbox_left > room_width){
	x = 0;	
}
if (bbox_right < 0){
	x = room_width;	
}
		
if (bbox_top > room_height){
	y = 0;	
}
if (y < 0){
	y = room_height;	
}