extends TileMap

enum PieceType {King, Queen, Bishop, Knight, Rook, Pawn}

const move_rules = [
	'king_move',
	'queen_move',
	'bishop_move',
	'kight_move',
	'rook_move',
	'pawn_move'
]

const Pawn = preload("res://pieces/pawn.tscn")

const GridSize = 8
var tile_dic = {}

var selected_tile = Vector2i(0, 0)

signal tile_conversion(piece_pos)
signal move_attempt_denied
signal move_attempt_confirmed

func _ready():
	var color_flip = 1
	
	for x in GridSize:
		for y in GridSize:
			tile_dic[str(Vector2(x, y))] = {"piece": null}

			set_cell(0, Vector2(x, y), color_flip, Vector2i(0, 0), 0)

			color_flip = 0 if color_flip == 1 else 1

		color_flip = 0 if color_flip == 1 else 1

	spawn_pawn()

func _process(delta):
	erase_cell(1, selected_tile)
	selected_tile = local_to_map(get_global_mouse_position())
	set_cell(1, selected_tile, 2, Vector2i(0, 0), 0)

func _on_move_attempt(board_position, moved_position):
	var piece_moved_position = local_to_map(moved_position)
	var piece_board_position = local_to_map(board_position)
	var piece = tile_dic[str(piece_board_position)].piece
	
	#TODO Retreive the list of movement from the piece and replace this check 
	#by substracting the illegal moves (tile is occupied by ally piece and self checks)
	#HACK Self checks are : kind is already in check and check wasn't blocked,
	#attacker wasn't captured or king wasn't moved, or enemy bishop, queen or rook now checks the king.
	if tile_dic[str(piece_moved_position)].piece != null: 
		tile_conversion.emit(board_position)
		
	elif call(move_rules[piece.piece_type], piece_board_position, piece_moved_position) == false:
		tile_conversion.emit(board_position)
	
	else:
		tile_dic[str(piece_moved_position)].piece = piece;
		tile_dic[str(piece_board_position)].piece = null
		tile_conversion.emit(map_to_local(piece_moved_position))
			

func spawn_pawn():
	for tile in tile_dic:
		tile = str_to_var("Vector2" + tile)
		
		if tile.y == 6:
			var new_pawn = Pawn.instantiate()
			new_pawn.position = map_to_local(tile)
			new_pawn.piece_type = PieceType.Pawn
			add_child(new_pawn)
			tile_dic[str(tile)].piece = new_pawn
		
			new_pawn.move_attempt.connect(_on_move_attempt)
			self.tile_conversion.connect(new_pawn._on_board_tile_tile_conversion)

func pawn_move(piece_board_position, piece_moved_position):
	var move = piece_moved_position - piece_board_position
	return ((move == Vector2i(0, -1)) or (move == Vector2i(0, -2) and piece_board_position.y == 6));
  
