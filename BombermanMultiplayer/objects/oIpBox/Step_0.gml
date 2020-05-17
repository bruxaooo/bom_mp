/// @description
if (mouse_check_button_pressed(mb_left)){
	keyboard_string = "";
	if (instance_position(mouse_x, mouse_y, self)){
		Select = 1;			
	}else{
		Select = 0;			
	}
}
if (Select){
	Text += keyboard_string;
	keyboard_string = "";
}