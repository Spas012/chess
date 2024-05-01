extends StaticBody2D

signal placed(pawn_pos)

var first_move = true
var held = false
var initial_pos

func _ready():
	pass
	
func _process(delta):
	if held:
		dragging()

func dragging():
	position = get_global_mouse_position()


func _on_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			initial_pos = position
			held = true
			
		else:
			placed.emit(position)
			held = false
			#position = initial_pos


func _on_board_tile_tile_conversion(piece_pos):
	if held:
		position = piece_pos
