/// @description
#region Create
	if (Step == 0){
		
		Step ++;
	}
#endregion
#region Update
	else{
		#region Variaveis
			GetInput();
		#endregion
		
		#region Movimentação	
			#region Axis
				xAxis = RightKey - LeftKey;
				yAxis = DownKey - UpKey;
			#endregion			
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
			if (State != "Kick" && State != "Punch" && State != "Stun"){
				
				#region Horizontal
					Hspd = xAxis * Spd;				
					for (var i = 0; i < ds_list_size(SolidList); i ++){
						if (SolidList[| i] == oBomb){
							var Solid = instance_placeZ(x + Hspd, y, z, oBomb);
							if (Solid && Solid.Solid && !CanPassBomb && !Solid.Land){
								while !(place_meetingZ(x + sign(Hspd), y, z, Solid)){
									x += sign(Hspd);
								}
								Hspd = 0;
							}
							
						
						}else if (SolidList[| i] == oBlock){
							var Solid = instance_placeZ(x + Hspd, y, z, oBlock);
							if (Solid && !CanPassWall){
								while !(place_meetingZ(x + sign(Hspd), y, z, Solid)){
									x += sign(Hspd);
								}
								Hspd = 0;
							}
						}else{
							if (place_meetingZ(x + Hspd, y, z, SolidList[| i])){
								while !(place_meetingZ(x + sign(Hspd), y, z, SolidList[| i])){
									x += sign(Hspd);	
								}
								Hspd = 0;
							}					
						}
					}
					x += Hspd;
				#endregion
				#region Vertical
					Vspd = yAxis * Spd;
					for (var i = 0; i < ds_list_size(SolidList); i ++){
						if (SolidList[| i] == oBomb){
							var Solid = instance_placeZ(x, y + Vspd, z, oBomb);
							if (Solid && Solid.Solid && !CanPassBomb && !Solid.Land){
								while !(place_meetingZ(x, y + sign(Vspd), z, Solid)){
									y += sign(Vspd);
								}
								Vspd = 0;
							}
						}else if (SolidList[| i] == oBlock){
							var Solid = instance_placeZ(x, y + Vspd, z, oBlock);
							if (Solid && !CanPassWall){
								while !(place_meetingZ(x, y + sign(Vspd), z, Solid)){
									y += sign(Vspd);
								}
								Vspd = 0;
							}
						}else{												
							if (place_meetingZ(x, y + Vspd, z, SolidList[| i])){
								while !(place_meetingZ(x, y + sign(Vspd), z, SolidList[| i])){
									y += sign(Vspd);	
								}
								Vspd = 0;
							}						
						}
					}
					y += Vspd;
				#endregion								
				#region Direção
				if (Hspd != 0 || Vspd != 0){
					Dir = floor(point_direction(0 ,0, sign(Hspd), sign(Vspd))/90);	
				}
				if (RightKeyP || LeftKeyP || DownKeyP || UpKeyP){
					Dir = floor(point_direction(0 ,0, RightKeyP - LeftKeyP, DownKeyP - UpKeyP)/90);	
				}
			#endregion			
				
			}
		#endregion
		
		#region PutBomb
			if (GrabedBomb != -4){
				GrabedBomb.x = x - 8;
				GrabedBomb.y = y;
			}
			if (BombKey){
				var HoverBomb = collision_rectangle(bbox_left + 4, bbox_top + 4, bbox_right - 4, bbox_bottom -4, oBomb, 0, 0); 
				
				if (HoverBomb && !IsLift && State != "Lift" && CanGrab && !HoverBomb.BombData[? "Land"]){					
					State = "Lift";
					HoverBomb.BombData[? "State"] = "Lift";		
					GrabedBomb = HoverBomb;
					image_index = 0;
				}else if (!IsLift && State != "Lift" && !(place_meeting(x, y, oBomb)) && !(place_meeting(x, y, oBlock))){
					var xx = floor(x/16) * 16,
						yy = floor((y + 4)/16) * 16;								
					if (CurrentBombs < MaxBombs){
						var Bomb = instance_create_layer(xx, yy, "Bombs", oBomb);				
						Bomb.BombData[? "Reach"] = BombPower;	
						Bomb.BombData[? "Pierce"] = BombPierce;						
						
						Bomb.BombData[? "Remote"] = RemoteBomb;
						Bomb.BombData[? "Number"] = CurrentBombs;
						if (CurrentBombs == 0){
							Bomb.BombData[? "Land"] = LandMine;							
						}						
						CurrentBombs ++;
					}
				}else if (IsLift && State != "Throw"){								
					image_index = 0;
					State = "Throw";					
					GrabedBomb.Hspd = lengthdir_x(4, Dir * 90);
					GrabedBomb.Vspd = lengthdir_y(4, Dir * 90);
					GrabedBomb.Zspd = 4;
					GrabedBomb.ZStart = 0;
					GrabedBomb.PunchDir = Dir * 90;	
					GrabedBomb.BombData[? "State"] = "Punch";
					GrabedBomb = -4;
				}
			}
		#endregion
		#region Kick
			if (CanKick && KickKey && State != "Kick" && State != "Punch" && State != "IdleHold" && State != "WalkHold" && State != "Throw"){
				image_index = 0;
				State = "Kick";		
				var xx = (floor(x/16) * 16) -1;
				var yy = (floor(y/16) * 16) -1;
				var x1 = lengthdir_x(16, Dir * 90);
				var y1 = lengthdir_y(16, Dir * 90);
				var KickBox = collision_rectangle(xx + x1, yy + y1, xx + x1 + 16,yy + y1 + 16, oBomb, 0, 0);
				if (KickBox && KickBox.BombData[? "Land"] == 0){
					KickBox.Hspd = lengthdir_x(4, Dir * 90);
					KickBox.Vspd = lengthdir_y(4, Dir * 90);
					
					KickBox.BombData[? "State"] = "Kick";
				}
			}
		#endregion
		#region Punch
			if (CanPunch && PunchKey && State != "Punch" && State != "Kick" && State != "IdleHold" && State != "WalkHold" && State != "Throw"){
				image_index = 0;
				State = "Punch";
				var xx = (floor(x/16) * 16) -1;
				var yy = (floor(y/16) * 16) -1;
				var x1 = lengthdir_x(16, Dir * 90);
				var y1 = lengthdir_y(16, Dir * 90);
				var PunchBox = collision_rectangle(xx + x1, yy + y1, xx + x1 + 16,yy + y1 + 16, oBomb, 0, 0);
				if (PunchBox && PunchBox.BombData[? "Land"] == 0){
					var x1 = PunchBox.x;
					PunchBox.x = floor(x1/16) * 16;
					var y1 = PunchBox.y;
					PunchBox.y = floor(y1/16) * 16;
					PunchBox.Hspd = lengthdir_x(4, Dir * 90);
					PunchBox.Vspd = lengthdir_y(4, Dir * 90);
					PunchBox.Zspd = 4;
					PunchBox.ZStart = PunchBox.z;
					PunchBox.PunchDir = Dir * 90;	
					PunchBox.BombData[? "State"] = "Punch";
				}
			}
		#endregion		
		#region RemoteBomb
			if (RemoteKey){		
				var bombGrid = ds_grid_create(2, 0);
				
				with(oBomb){
					if (BombData[? "Remote"] && !BombData[? "Land"]){
						var h = ds_grid_height(bombGrid);
						ds_grid_resize(bombGrid, 2, h + 1);
						ds_grid_add(bombGrid, 0, h, id);
						ds_grid_add(bombGrid, 1, h, BombData[? "Number"]);
					}
				}				
				ds_grid_sort(bombGrid, 1, 1);
				if (ds_grid_height(bombGrid) > 0){
					var gBomb = bombGrid[# 0, 0];
					gBomb.BombData[? "cRoll"] = gBomb.BombData[? "Rolls"];
					ds_grid_destroy(bombGrid);
				}
				
			}
		#endregion
		#region Animação
			if (State != "Throw"){
				if (State != "Kick" && State != "Punch" && State != "Lift" && !IsLift && State != "Stun"){
					if (Hspd == 0 && Vspd == 0){
						State = "Idle";	
					}else{
						State = "Walk";	
					}			
				}else if (IsLift){
					if (Hspd == 0 && Vspd == 0){
						State = "IdleHold";	
					}else{
						State = "WalkHold";	
					}	
				}
			}
			var Spr = Sprite[? State];			
			sprite_index = Spr[| Dir];			
		#endregion
	}
#endregion
depth = (z + 100) * -1;