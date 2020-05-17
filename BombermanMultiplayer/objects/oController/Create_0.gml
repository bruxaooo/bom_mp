/// @description
Type = "";
Step = 0;
Ip = "";
UserData = ds_map_create();
PlayerList = ds_list_create();
enum Event{
	ConnectInfo,
	NewPlayer,
	
	SendPos,
	SendDir,
	SendState,
	
	NewBomb
}

pGrid = ds_grid_create(4, 2);
pGrid[# 0, 0] = 24;
pGrid[# 0, 1] = 28;

pGrid[# 1, 0] = 216;
pGrid[# 1, 1] = 28;

pGrid[# 2, 0] = 24;
pGrid[# 2, 1] = 176;

pGrid[# 3, 0] = 216;
pGrid[# 3, 1] = 176;

BombList = ds_list_create();

NewBomb = -4;