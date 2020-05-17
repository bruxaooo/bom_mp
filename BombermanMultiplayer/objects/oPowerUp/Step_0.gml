/// @description

if(place_meeting(x, y, oPlayer)){
	instance_destroy();
	switch(ThisPowerUp){
		case 0:
			if (oPlayer.BombPower < 10){
				oPlayer.BombPower ++;
			}
		break;
		case 1:
			oPlayer.BombPower = 10;
		break;
		case 2:
			if (oPlayer.MaxBombs < 8){
				oPlayer.MaxBombs ++;
			}
		break;
		case 3:
			if (oPlayer.Spd < 2){
				oPlayer.Spd += .25;	
			}
		break;
		case 4:
			if (oPlayer.Spd > 1){
				oPlayer.Spd -= .25;
			}
		break;
		case 5:
			oPlayer.CanKick = 1;
		break;
		case 6:
			oPlayer.CanGrab = 1;
		break;
		case 7:
			oPlayer.CanPunch = 1;
		break;
		case 8:
			oPlayer.CanPassWall = 1;
		break;
		case 9:
			oPlayer.CanPassBomb = 1;
		break;
		case 10:
			oPlayer.Indestructible = 1;
		break;
		case 11:
			if (oPlayer.Heart == 1){
				oPlayer.Heart ++;	
			}
		break;
		case 12:
			oPlayer.RemoteBomb = 1;
		break;
		case 13:
			oPlayer.BombPierce = 1;
		break;
		case 14:
			oPlayer.LandMine = 1;									
			
		break;
		
		case 15:
		
		break;
		case 16:
			oPlayer.Lives ++;
		break;
		
	}
}