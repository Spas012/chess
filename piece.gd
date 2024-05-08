extends StaticBody2D

signal move_attempt(board_position, moved_postion)

#const max_bound = get_viewport_rect().size
const min_bound = Vector2(1, 1)

var piece_type : int
var held = false
var board_position

func _ready():
	pass

func _process(delta):
	if held:
		dragging()

func dragging():
	position = clamp_in_viewport(get_global_mouse_position())

	#Input.warp_mouse()

func drop():
	move_attempt.emit(board_position, position)
	held = false
	$AnimatedSprite2D.z_index = 1

func _on_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and held == true:
			drop()
			
		elif event.pressed:
			board_position = position
			held = true
			$AnimatedSprite2D.z_index = 10
			
		elif held == true:
			drop()


func _on_board_tile_tile_conversion(piece_pos):
	if held:
		position = piece_pos


func clamp_in_viewport(vector: Vector2) -> Vector2:
	vector.x = clamp(vector.x, 0+1, get_viewport_rect().size.x-1)
	vector.y = clamp(vector.y, 0+1, get_viewport_rect().size.y-1)

	return vector
	
