/// @function GetInput();

#region Movimentação
	RightKey = keyboard_check(vk_right);
	LeftKey = keyboard_check(vk_left);
	DownKey = keyboard_check(vk_down);
	UpKey = keyboard_check(vk_up);
	
	RightKeyP = keyboard_check_pressed(vk_right);
	LeftKeyP = keyboard_check_pressed(vk_left);
	DownKeyP = keyboard_check_pressed(vk_down);
	UpKeyP = keyboard_check_pressed(vk_up);
#endregion
#region Others
	BombKey = keyboard_check_pressed(ord("Z"));
	KickKey = keyboard_check_pressed(ord("X"));
	PunchKey = keyboard_check_pressed(ord("A"));
	RemoteKey = keyboard_check_pressed(ord("S"));
#endregion