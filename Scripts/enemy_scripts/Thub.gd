extends Enemy

@export var acceleration: float
@export var anim: AnimatedSprite2D

func _ready() -> void:
	super()
	anim.animation_finished.connect(done_break)

func _process(_delta: float) -> void:
	super(_delta)

func _physics_process(_delta: float) -> void:
	super(_delta)

func movement_process(_delta: float) ->void:
	if linear_velocity.dot((player.global_position - global_position).normalized()) > 0:
		linear_velocity += (player.global_position - global_position).normalized() * acceleration * _delta
	else:
		linear_velocity = (player.global_position - global_position).normalized()
		anim.play("Break")

func done_break():
	anim.play("Moving")
