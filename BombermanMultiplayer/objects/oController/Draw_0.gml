/// @description
for (var i = 0; i < ds_list_size(PlayerList); i ++){
	var Player = PlayerList[| i];
	var Key = ds_map_find_first(Player);
	for (var k = 0; k < ds_map_size(Player); k ++){
		draw_text(160 * i, 16 * k, string(Key) + " :" + string(Player[? Key]));
		Key = ds_map_find_next(Player, Key);
	}
}
