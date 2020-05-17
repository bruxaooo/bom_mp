/// @description
switch(State){
	case "Kick":
		image_index = 0;
		State = "Idle";
	break;
	case "Punch":
		image_index = 0;
		State = "Idle";
	break;
	case "Lift":
		image_index = 0;
		IsLift = 1;
	break;
	case "Throw":
		image_index = 0;
		IsLift = 0;
		State = "Idle";
	break;
	case "Stun":
		image_index = 0;
		State = "Idle";
	break;
}
