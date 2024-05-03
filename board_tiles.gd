extends TileMap

const Pawn = preload("res://pieces/pawn.tscn")

const GridSize = 8
var tile_list = []
var piece_pos

signal tile_conversion(piece_pos)

func _ready():
	var color_flip = 1
	
	for x in GridSize:
		for y in GridSize:
			tile_list.append(str(Vector2(x, y)))
						
			set_cell(0, Vector2(x, y), color_flip, Vector2i(0, 0), 0)
			
			if color_flip == 1:
				color_flip = 0
			else:
				color_flip = 1
				
		if color_flip == 1:
				color_flip = 0
			
		else:
			color_flip = 1
	
	spawn_pawn()
			

func _process(delta):
	var tile = local_to_map(get_global_mouse_position())
		
	for x in GridSize:
		for y in GridSize:
			erase_cell(1, Vector2(x, y))
	
	if tile_list.has(str(tile)):
		set_cell(1, tile, 2, Vector2i(0, 0), 0)


func _on_pawn_placed(pawn_pos):
	piece_pos = local_to_map(pawn_pos)
	piece_pos = map_to_local(piece_pos)
	
	tile_conversion.emit(piece_pos)
	

func spawn_pawn():
	for tile in tile_list:
		tile = str_to_var("Vector2" + tile)
		
		if tile.y == 6:
			var new_pawn = Pawn.instantiate()
			new_pawn.position = map_to_local(tile)
			add_child(new_pawn)
		
			new_pawn.placed.connect(_on_pawn_placed)
			self.tile_conversion.connect(new_pawn._on_board_tile_tile_conversion)
