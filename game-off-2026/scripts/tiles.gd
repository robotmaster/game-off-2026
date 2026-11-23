@tool
extends TileMapLayer

func _process(delta: float) -> void:
	var cells := get_used_cells()
	
	for cell in cells:
		set_cells_terrain_connect([cell], 0, 0)
