@tool
extends TileMapLayer
 
@export_tool_button("Retile Cells", "Callable") var button = retile_cells

func _process(delta: float) -> void:
	retile_cells()

func retile_cells() -> void:
	if not Engine.is_editor_hint():
		return
	var cells := get_used_cells()
	
	var sides := [
		Vector2i.UP,
		Vector2i.DOWN,
		Vector2i.LEFT,
		Vector2i.RIGHT
	]
	for cell in cells:
		var wanted_neighbors : Dictionary[Vector2i, bool] = {}
		
		for side in sides:
			var data := get_cell_tile_data(cell + side)
			if data != null and data.terrain_set == 0 and data.terrain == 0:
				wanted_neighbors[side] = true
			else:
				wanted_neighbors[side] = false
		
		set_cell(cell, tile_set.get_source_id(0), find_tile_with_neighbors(wanted_neighbors))


func find_tile_with_neighbors(neighbors: Dictionary[Vector2i, bool]) -> Vector2i:
	var tile_atlas : TileSetAtlasSource = tile_set.get_source(0)
	
	for tile_index in tile_atlas.get_tiles_count():
		var tile_coords := tile_atlas.get_tile_id(tile_index)
		
		var tile_data := tile_atlas.get_tile_data(tile_coords, 0)
		var sides := [
			[Vector2i.UP, TileSet.CELL_NEIGHBOR_TOP_SIDE],
			[Vector2i.DOWN, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE],
			[Vector2i.LEFT, TileSet.CELL_NEIGHBOR_LEFT_SIDE],
			[Vector2i.RIGHT, TileSet.CELL_NEIGHBOR_RIGHT_SIDE]
		]
		
		var is_correct_tile := true
		for side_info in sides:
			var side := tile_data.get_terrain_peering_bit(side_info[1])
			
			var side_exists := side != -1
			if side_exists != neighbors[side_info[0]]:
				is_correct_tile = false
				break
			
		if is_correct_tile:
			return tile_coords
	return Vector2i(-1, -1)
