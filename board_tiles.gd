extends TileMap

const Pawn = preload("res://pieces/pawn.tscn")

const GridSize = 8
var tile_dic = {}


signal tile_conversion(piece_pos)

func _ready():
	var color_flip = 1
	
	for x in GridSize:
		for y in GridSize:
			tile_dic[str(Vector2(x, y))] = {"piece": null}
						
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
	
	if tile_dic.has(str(tile)):
		set_cell(1, tile, 2, Vector2i(0, 0), 0)


func _on_pawn_placed(pawn_pos, initial_pos, first_move):
	var piece_pos = local_to_map(pawn_pos)
	var piece_initial_pos = local_to_map(initial_pos)

	#TODO Retreive the list of movement from the piece and replace this check 
	#by substracting the illegal moves (tile is occupied by ally piece and self checks)
	#HACK Self checks are : kind is already in check and check wasn't blocked,
	#attacker wasn't captured or king wasn't moved, or enemy bishop, queen or rook now checks the king.
	if tile_dic[str(piece_pos)].piece != null: 
		tile_conversion.emit(initial_pos)
	
	elif piece_initial_pos + Vector2i(0, -1) != piece_pos and\
	(piece_initial_pos + Vector2i(0, -2) != piece_pos or not first_move):
		tile_conversion.emit(initial_pos)
	
	else:
		tile_dic[str(piece_pos)].piece = tile_dic[str(piece_initial_pos)].piece;
		tile_dic[str(piece_initial_pos)].piece = null

		tile_conversion.emit(map_to_local(piece_pos))
			

func spawn_pawn():
	for tile in tile_dic:
		tile = str_to_var("Vector2" + tile)
		
		if tile.y == 6:
			var new_pawn = Pawn.instantiate()
			new_pawn.position = map_to_local(tile)
			add_child(new_pawn)
			tile_dic[str(tile)].piece = new_pawn
		
			new_pawn.placed.connect(_on_pawn_placed)
			self.tile_conversion.connect(new_pawn._on_board_tile_tile_conversion)
