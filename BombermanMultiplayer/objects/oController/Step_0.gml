/// @description
if (Step == 0){
	switch(Type){
		case "Client":
			Socket = network_create_socket(network_socket_tcp);
			network_set_config(network_config_connect_timeout, 100);
			var Connect = network_connect(Socket, string(Ip), 3399);
			if (Connect < 0){
				show_message("Falha ao se conectar");
				game_restart();
			}
		break;
		case "Server":
			PlayerList = ds_list_create();
			var Server = network_create_server(network_socket_tcp, 3399, 3);
			UserData[? "ID"] = 0;
			ds_list_add(PlayerList, UserData);
			ds_list_mark_as_map(PlayerList, 0);
			
			var Player = instance_create_layer(pGrid[# 0, 0], pGrid[# 0, 1], "Player", oPlayer);
		break;
		
	}
	Step ++;
}else{
	if (oPlayer.Hspd != 0 || oPlayer.Vspd != 0){
		UserData[? "x"] = oPlayer.x;
		UserData[? "y"] = oPlayer.y;		
		var Buff = buffer_create(256, buffer_grow, 1);
		buffer_seek(Buff, buffer_seek_start, 0);
		buffer_write(Buff, buffer_s8, Event.SendPos);
		buffer_write(Buff, buffer_s8, UserData[? "ID"]);
		buffer_write(Buff, buffer_s16, UserData[? "x"]);
		buffer_write(Buff, buffer_s16, UserData[? "y"]);		
		
		if (Type == "Client"){
			network_send_packet(Socket, Buff, buffer_tell(Buff));	
		}else{
			for (var i = 0; i < ds_list_size(PlayerList); i ++){
				var Player = PlayerList[| i];
				if (Player[? "ID"] != UserData[? "ID"]){
					network_send_packet(Player[? "Socket"], Buff, buffer_tell(Buff));	
				}
			}
		}
		buffer_delete(Buff);
	}
	if (UserData[? "Direction"] != oPlayer.Dir){
		UserData[? "Direction"] = oPlayer.Dir;	
		var Buff = buffer_create(256, buffer_grow, 1);
		buffer_seek(Buff, buffer_seek_start, 0);
		buffer_write(Buff, buffer_s8, Event.SendDir);
		buffer_write(Buff, buffer_s8, UserData[? "ID"]);
		buffer_write(Buff, buffer_s8, UserData[? "Direction"]);
		
		if (Type == "Client"){
			network_send_packet(Socket, Buff, buffer_tell(Buff));	
		}else{
			for (var i = 0; i < ds_list_size(PlayerList); i ++){
				var Player = PlayerList[| i];
				if (Player[? "ID"] != UserData[? "ID"]){
					network_send_packet(Player[? "Socket"], Buff, buffer_tell(Buff));	
				}
			}
		}
		buffer_delete(Buff);
	}
	if (UserData[? "State"] != oPlayer.State){
		UserData[? "State"] = oPlayer.State;		
		var Buff = buffer_create(256, buffer_grow, 1);
		buffer_seek(Buff, buffer_seek_start, 0);
		buffer_write(Buff, buffer_s8, Event.SendState);
		buffer_write(Buff, buffer_s8, UserData[? "ID"]);
		buffer_write(Buff, buffer_string, UserData[? "State"]);
		
		if (Type == "Client"){
			network_send_packet(Socket, Buff, buffer_tell(Buff));	
		}else{
			for (var i = 0; i < ds_list_size(PlayerList); i ++){
				var Player = PlayerList[| i];
				if (Player[? "ID"] != UserData[? "ID"]){
					network_send_packet(Player[? "Socket"], Buff, buffer_tell(Buff));	
				}
			}
		}
		buffer_delete(Buff);
	}
	if (NewBomb != -4){		
		var Buff = buffer_create(256, buffer_grow, 1),
		xx = floor(oPlayer.x/16) * 16,
		yy = floor((oPlayer.y + 4)/16) * 16;		
		buffer_seek(Buff, buffer_seek_start, 0);
		buffer_write(Buff, buffer_s8, Event.NewBomb);
		buffer_write(Buff, buffer_s8, UserData[? "ID"]);
		buffer_write(Buff, buffer_string, json_encode(NewBomb.BombData[? "BombID"]));
		buffer_write(Buff, buffer_s16, xx);
		buffer_write(Buff, buffer_s16, yy);
		
		if (Type == "Client"){
			network_send_packet(Socket, Buff, buffer_tell(Buff));	
		}else{
			for (var i = 0; i < ds_list_size(PlayerList); i ++){
				var Player = PlayerList[| i];
				if (Player[? "ID"] != UserData[? "ID"]){
					network_send_packet(Player[? "Socket"], Buff, buffer_tell(Buff));	
				}
			}
		}
		buffer_delete(Buff);
		NewBomb = -4;
	}
}