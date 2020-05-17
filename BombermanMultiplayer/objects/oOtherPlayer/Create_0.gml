/// @description
Data = ds_map_create();
z = 0;
Dir = 0;
Sprite = ds_map_create();
	var Idle = ds_list_create();
	ds_list_add(Idle, sPlayerIdleRight, sPlayerIdleUp, sPlayerIdleLeft, sPlayerIdleDown);
	ds_map_add_list(Sprite, "Idle", Idle);
	
	var Walk = ds_list_create();
	ds_list_add(Walk, sPlayerWalkRight, sPlayerWalkUp, sPlayerWalkLeft, sPlayerWalkDown);
	ds_map_add_list(Sprite, "Walk", Walk);
	
	var Kick = ds_list_create();
	ds_list_add(Kick, sPlayerKickRight, sPlayerKickUp, sPlayerKickLeft, sPlayerKickDown)
	ds_map_add_list(Sprite, "Kick", Kick);
	
	var Punch = ds_list_create();
	ds_list_add(Punch, sPlayerPunchRight, sPlayerPunchUp, sPlayerPunchLeft, sPlayerPunchDown)
	ds_map_add_list(Sprite, "Punch", Punch);
	
	var Lift = ds_list_create();
	ds_list_add(Lift, sPlayerLiftRight, sPlayerLiftUp, sPlayerLiftLeft, sPlayerLiftDown);
	ds_map_add_list(Sprite, "Lift", Lift);
	
	var IdleHold = ds_list_create();
	ds_list_add(IdleHold, sPlayerIdleHoldRight, sPlayerIdleHoldUp, sPlayerIdleHoldLeft, sPlayerIdleHoldDown);
	ds_map_add_list(Sprite, "IdleHold", IdleHold);
	
	var WalkHold = ds_list_create();
	ds_list_add(WalkHold, sPlayerWalkHoldRight, sPlayerWalkHoldUp, sPlayerWalkHoldLeft, sPlayerWalkHoldDown);
	ds_map_add_list(Sprite, "WalkHold", WalkHold);
	
	var Throw = ds_list_create();
	ds_list_add(Throw, sPlayerThrowRight, sPlayerThrowUp, sPlayerThrowLeft, sPlayerThrowDown);
	ds_map_add_list(Sprite, "Throw", Throw);
	
	var Stun = ds_list_create();
	ds_list_add(Stun, sPlayerStun, sPlayerStun, sPlayerStun, sPlayerStun);
	ds_map_add_list(Sprite, "Stun", Stun);
	
	State = "Idle";
	var Spr = Sprite[? State];
	sprite_index = Spr[| 0];