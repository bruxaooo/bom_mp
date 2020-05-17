/// @description
#region Self
	draw_self();
#endregion
#region PowerUp
	if (sprite_index != sPowerUpDestroy){
		draw_sprite(sPowerUpIcon, ThisPowerUp, x, y);
	}
#endregion