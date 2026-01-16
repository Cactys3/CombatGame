extends Area2D
class_name CircleActivator

@export var anim: AnimatedSprite2D 
var is_done: bool = false
var is_playing: bool = false
var anim_speed: float = 1.9
func _ready() -> void:
	anim.modulate = Color.GREEN
	anim.speed_scale = anim_speed
func reverse():
	anim.speed_scale = -anim.speed_scale
	if !anim.is_playing():
		anim.play("loop")
func entered(node: Node) -> void:
	if is_done:
		return
	if !is_playing:
		is_playing = true
		anim.play("loop")
		anim.animation_finished.connect(done)
	else:
		reverse()
func exited(node: Node2D) -> void:
	if is_done:
		return
	reverse()
func done():
	if anim.speed_scale > 0:
		is_done = true
		queue_free()
func _on_area_entered(area: Area2D) -> void:
	entered(area)
func _on_area_exited(area: Area2D) -> void:
	exited(area)
func _on_body_entered(body: Node2D) -> void:
	entered(body)
func _on_body_exited(body: Node2D) -> void:
	exited(body)
