extends StaticBody2D

signal placed(pawn_pos, initial_pos, first_move)

var first_move = true
var held = false
var initial_pos


func _ready():
	pass
	
	
func _process(delta):
	if held:
		dragging()


func dragging():
	position = vector_limit(get_global_mouse_position())

	#Input.warp_mouse()


func _on_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and held == true:
			placed.emit(position, initial_pos, first_move)
			held = false
			$AnimatedSprite2D.z_index = 1
			
		elif event.pressed:
			initial_pos = position
			held = true
			$AnimatedSprite2D.z_index = 10
			
		elif held == true:
			placed.emit(position, initial_pos, first_move)
			held = false
			$AnimatedSprite2D.z_index = 1


func _on_board_tile_tile_conversion(piece_pos):
	if held:
		position = piece_pos
	
		if piece_pos != initial_pos:
			first_move = false


func vector_limit(vector: Vector2) -> Vector2:
	if vector.x > get_viewport_rect().size.x-1:
		vector.x = get_viewport_rect().size.x-1
	
	if vector.y > get_viewport_rect().size.y-1:
		vector.y = get_viewport_rect().size.y-1
	
	if vector.x < 0+1:
		vector.x = 0+1
	
	if vector.y < 0+1:
		vector.y = 0+1
	
	return vector
	
