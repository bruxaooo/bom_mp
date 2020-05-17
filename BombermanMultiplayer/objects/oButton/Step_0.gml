/// @description
if (instance_position(mouse_x, mouse_y, self) && mouse_check_button_pressed(mb_left)){
	if (room != rmGame){
		room_goto(rmGame);
		var Controller = instance_create_layer(0, 0, "Controller", oController);
		Controller.Type = Text;
		if (Text == "Client"){
			Controller.Ip = oIpBox.Text;	
		}
	}
}