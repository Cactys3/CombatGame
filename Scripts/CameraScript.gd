extends Camera2D

## Follow Player

var target             
@export var box_size = Vector2(200, 120) 
@export var follow_speed = 3.0
@export var circle_radius := 100.0

func _process(delta):
	if !target:
		target = get_tree().get_first_node_in_group("player")
		
	
	global_position = target.global_position
	
	return 
	
	var offsett = global_position - target.global_position
	if offsett.length() > circle_radius:
		var desired = target.global_position + offsett.normalized() * circle_radius
		global_position = desired#global_position.move_toward(desired, follow_speed * delta)
	
	return
	
	# half‐extents of the box
	var half = box_size * 0.5
	# vector from target to camera
	var offset = global_position - target.global_position
	var new_pos = global_position
	# horizontal check
	if offset.x > half.x:
		# camera is too far to the right → clamp to right edge
		new_pos.x = target.global_position.x + half.x
	elif offset.x < -half.x:
		# camera is too far to the left → clamp to left edge
		new_pos.x = target.global_position.x - half.x
	# vertical check
	if offset.y > half.y:
		# too far down → clamp to bottom edge
		new_pos.y = target.global_position.y + half.y
	elif offset.y < -half.y:
		# too far up → clamp to top edge
		new_pos.y = target.global_position.y - half.y
	global_position = global_position.move_toward(new_pos, follow_speed * delta)
