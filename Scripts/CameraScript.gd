extends Camera2D

var target             

var x: float = 0
var y: float = 0
func _process(delta):
	if !target:
		target = get_tree().get_first_node_in_group("player")
	
	
	#global_position = target.global_position.round() #- Vector2(640/6, 360/6)
	
	#print(str(position) + " and " + str(global_position))
	#global_position = global_position.round()
	

func _physics_process(delta: float) -> void:
	global_position = global_position.round()
	
	handle_moving()
	
	global_position += Vector2(x, y).round()


func handle_moving() -> void:
	var directionX := Input.get_axis("left", "right")
	if directionX:
		x = round(directionX) * 2
	else:
		x = 0
	var directionY := Input.get_axis("up", "down")
	if directionY:
		y = round(directionY) * 2
	else:
		y = 0
	
	#print(str(x) + " "+ str(y))
