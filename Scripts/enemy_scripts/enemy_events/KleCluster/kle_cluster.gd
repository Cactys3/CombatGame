extends Node2D
const UNDERLING = preload("uid://cnk048qngcjvd")
var level: float = -1
var underlings: Array = []
var direction: Vector2 
var speed: float
var is_setup: bool = false
var min_lifetime: float = 10
var stopwatch: float = 0
var event: GameInstance.EnemyEventSpawn
func _ready() -> void:
	visible = false
	await get_tree().create_timer(0.1).timeout
	visible = true
## Have same method as enemy for setup so this can be interchangable with enemy
func initialize(new_level: float, player_pos: Vector2, new_event: GameInstance.EnemyEventSpawn):
	event = new_event
	name = "Klee_Cluster" + str(randf())
	level = new_level
	var num_of_underlings: int = 5 + roundi(level / 5)
	direction = ((player_pos - global_position).normalized() + Vector2(randf_range(-0.005, 0.005), randf_range(-0.005, 0.005))).normalized()
	speed = 90
	
	var angle_step = TAU / num_of_underlings
	for i in num_of_underlings:
		## Not using offset:
		var offset = Vector2(cos((i - 1) * angle_step), sin((i - 1) * angle_step)) * num_of_underlings
		var underling: Node2D = UNDERLING.instantiate()
		add_child(underling)
		underling.global_position = global_position + Vector2(randf_range(-(float(num_of_underlings) / 2 + 6), float(num_of_underlings) / 2 + 6), randf_range(-(float(num_of_underlings) / 2 + 6), float(num_of_underlings) / 2 + 6)) #offset
		underlings.append(underling)
		underling.setup_individual(direction, speed)
	is_setup = true

func _process(delta: float) -> void:
	position += direction * speed * delta
	stopwatch += delta
	if is_setup && stopwatch > min_lifetime && GameManager.instance && GameManager.instance.player.global_position.distance_to(global_position) > 500:
		die()

func die():
	if event:
		event.curr_spawns -= 1
	GameInstance.instance.enemy_event_killed()
	for underling in underlings:
		if underling: ## Underlings are queue_free() by other things sometimes
			GameInstance.instance.remove_enemy(underling)
	queue_free()
