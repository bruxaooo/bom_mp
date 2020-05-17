/// @description
var _type = async_load[? "type"];
switch(_type){
	case network_type_connect:
		var NewPlayer = ds_map_create();
			NewPlayer[? "Socket"] = async_load[? "socket"];
			NewPlayer[? "ID"] = ds_list_size(PlayerList);
			
			ds_list_add(PlayerList, NewPlayer);
			ds_list_mark_as_map(PlayerList, ds_list_size(PlayerList) -1);
			
			var Buff = buffer_create(256, buffer_grow, 1);
			buffer_seek(Buff, buffer_seek_start, 0);
			buffer_write(Buff, buffer_s8, Event.ConnectInfo);
			buffer_write(Buff, buffer_s8, NewPlayer[? "ID"]);
			buffer_write(Buff, buffer_string, json_encode(NewPlayer));
			var Map = ds_map_create();
			ds_map_add_list(Map, "List", PlayerList);
			buffer_write(Buff, buffer_string, json_encode(Map));			
			network_send_packet(NewPlayer[? "Socket"], Buff, buffer_tell(Buff));						
	break;
	case network_type_data:
		var Buff = async_load[? "buffer"];
		buffer_seek(Buff, buffer_seek_start, 0);
		var _event = buffer_read(Buff, buffer_s8);
		switch(Type){
			case "Client":
				switch(_event){
					case Event.ConnectInfo:
						var _id = buffer_read(Buff, buffer_s8);						
						var Player = instance_create_layer(pGrid[# _id, 0], pGrid[# _id, 1], "Player", oPlayer);
						UserData = json_decode(buffer_read(Buff, buffer_string));
						UserData[? "x"] = Player.x;
						UserData[? "y"] = Player.y;						
						var Map = json_decode(buffer_read(Buff, buffer_string));
						PlayerList = Map[? "List"];
						
						PlayerList[| _id] = UserData;
						ds_list_mark_as_map(PlayerList, _id);
						
						for (var i = 0; i < ds_list_size(PlayerList); i ++){
							var nPlayer = PlayerList[| i];
							if (nPlayer[? "ID"] != UserData[? "ID"] && nPlayer[? "ID"] != _id){
								var NP = instance_create_layer(pGrid[# nPlayer[? "ID"], 0], pGrid[# nPlayer[? "ID"], 1], "Player", oOtherPlayer);		
								NP.Data = nPlayer;
							}
						}
						var nBuff = buffer_create(256, buffer_grow, 1);
						buffer_seek(nBuff, buffer_seek_start, 0);
						buffer_write(nBuff, buffer_s8, Event.ConnectInfo);
						buffer_write(nBuff, buffer_s8, UserData[? "ID"]);
						buffer_write(nBuff, buffer_string, json_encode(UserData));
						
						network_send_packet(Socket, nBuff, buffer_tell(nBuff));		
						
						
					break;
					case Event.NewPlayer:
						var NewPlayer = json_decode(buffer_read(Buff, buffer_string));
						ds_list_add(PlayerList, NewPlayer);
						ds_list_mark_as_map(PlayerList, ds_list_size(PlayerList) -1);
						
						var NP = instance_create_layer(pGrid[# NewPlayer[? "ID"], 0], pGrid[# NewPlayer[? "ID"], 1], "Player", oOtherPlayer);
						NP.Data = NewPlayer;
					break;
					case Event.SendPos:
						var _id = buffer_read(Buff, buffer_s8),
							xx = buffer_read(Buff, buffer_s16),
							yy = buffer_read(Buff, buffer_s16);
							
							with(oOtherPlayer){
								if (Data[? "ID"] == _id){
									x = xx;
									y = yy;
								}
							}
					break;
					case Event.SendDir:
						var _id = buffer_read(Buff, buffer_s8),
							_dir = buffer_read(Buff, buffer_s8);
						for (var i = 0; i < ds_list_size(PlayerList); i ++){
							var Player = PlayerList[| i];
							if (Player[? "ID"] == _id){
								Player[? "Direction"] = _dir;	
							}
						}
						with(oOtherPlayer){
							if (Data[? "ID"] == _id){
								Dir = _dir;	
							}
						}
					break;
					case Event.SendState:
						var _id = buffer_read(Buff, buffer_s8),
							_state = buffer_read(Buff, buffer_string);
						for (var i = 0; i < ds_list_size(PlayerList); i ++){
							var Player = PlayerList[| i];
							if (Player[? "ID"] == _id){
								Player[? "State"] = _state;	
							}
						}
						with(oOtherPlayer){
							if (Data[? "ID"] == _id){
								image_index = 0;
								State = _state;	
							}
						}
					break;
					case Event.NewBomb:
						var _id = buffer_read(Buff, buffer_s8),
							_bombData = json_decode(buffer_read(Buff, buffer_string));														
					break;
				}
			break;
			case "Server":
				switch(_event){
					case Event.ConnectInfo:
						var _id = buffer_read(Buff, buffer_s8),
							NewPlayer = buffer_read(Buff, buffer_string);																
						for (var i = 0; i < ds_list_size(PlayerList); i ++){
							var Player = PlayerList[| i];
							if (Player[? "ID"] == _id){
								Player = json_decode(NewPlayer);	
								break;
							}
						}
						
						var NP = instance_create_layer(pGrid[# _id, 0], pGrid[# _id, 1], "Player", oOtherPlayer);
						NP.Data = json_decode(NewPlayer);
						var nBuff = buffer_create(256, buffer_grow, 1);
						buffer_seek(nBuff, buffer_seek_start, 0);
						buffer_write(nBuff, buffer_s8, Event.NewPlayer);
						buffer_write(nBuff, buffer_string, NewPlayer);
						
						for (var i = 0; i < ds_list_size(PlayerList); i ++){
							var Player = PlayerList[| i];
							if (Player[? "ID"] != _id && Player[? "ID"] != UserData[? "ID"]){
								network_send_packet(Player[? "Socket"], nBuff, buffer_tell(nBuff));	
							}
						}
					break;
					case Event.SendPos:
						var _id = buffer_read(Buff, buffer_s8),
						xx = buffer_read(Buff, buffer_s16),
						yy = buffer_read(Buff, buffer_s16);
							
						with(oOtherPlayer){
							if (Data[? "ID"] == _id){
								x = xx;
								y = yy;
							}
						}
							
						var nBuff = buffer_create(256, buffer_grow, 1);
						buffer_seek(nBuff, buffer_seek_start, 0);
						buffer_write(nBuff, buffer_s8, Event.SendPos);
						buffer_write(nBuff, buffer_s8, _id);
						buffer_write(nBuff, buffer_s16, xx);
						buffer_write(nBuff, buffer_s16, yy);
							
						for (var i = 0; i < ds_list_size(PlayerList); i ++){
							var Player = PlayerList[| i];
							if (Player[? "ID"] != _id && Player[? "ID"] != UserData[? "ID"]){
								network_send_packet(Player[? "Socket"], nBuff, buffer_tell(nBuff));	
							}
						}							
					break;
					case Event.SendDir:
						var _id = buffer_read(Buff, buffer_s8),
							_dir = buffer_read(Buff, buffer_s8);
						
						var nBuff = buffer_create(256, buffer_grow, 1);
						buffer_seek(nBuff, buffer_seek_start, 0);
						buffer_write(nBuff, buffer_s8, Event.SendDir);
						buffer_write(nBuff, buffer_s8, _id);
						buffer_write(nBuff, buffer_s8, _dir);
						
						for (var i = 0; i < ds_list_size(PlayerList); i ++){
							var Player = PlayerList[| i];
							if (Player[? "ID"] != _id && Player[? "ID"] != UserData[? "ID"]){
								Player[? "Direction"] = _dir;
								network_send_packet(Player[? "Socket"], nBuff, buffer_tell(nBuff));	
							}
						}	
						
						with(oOtherPlayer){
							if (Data[? "ID"] == _id){
								Data[? "Direction"] = _dir;
								Dir = _dir;	
							}
						}
					break;
					case Event.SendState:
						var _id = buffer_read(Buff, buffer_s8),
							_state = buffer_read(Buff, buffer_string);
						
						var nBuff = buffer_create(256, buffer_grow, 1);
						buffer_seek(nBuff, buffer_seek_start, 0);
						buffer_write(nBuff, buffer_s8, Event.SendState);
						buffer_write(nBuff, buffer_s8, _id);
						buffer_write(nBuff, buffer_string, _state);
						
						for (var i = 0; i < ds_list_size(PlayerList); i ++){
							var Player = PlayerList[| i];
							if (Player[? "ID"] != _id && Player[? "ID"] != UserData[? "ID"]){
								Player[? "State"] = _state;
								network_send_packet(Player[? "Socket"], nBuff, buffer_tell(nBuff));	
							}
						}	
						
						with(oOtherPlayer){
							if (Data[? "ID"] == _id){
								image_index = 0;
								Data[? "State"] = _state;
								State = _state;	
							}
						}
					break;
				}
			break;
			
		}
	break;
	case network_type_disconnect:
		var socket = async_load[? "socket"];
		for (var i = 0; i < ds_list_size(PlayerList); i ++){
			var Player = PlayerList[| i];
			if (Player[? "Socket"] == socket){
				ds_list_delete(PlayerList, i);
				break;
			}
		}
	break;
}