extends Node2D
@export var can_damage: bool = false
@export var cooldown: float = 5
@export var damage: float = 10
@export var stun: float = 0
@export var slow: float = 0
@export var knockback: float = 0
@export var buildup: float = 0
@export var status: StatusEffectDictionary = StatusEffectDictionary.new()
@export var foreground: Array[AnimatedSprite2D]
@export var background: Array[AnimatedSprite2D]

var stopwatch: float = 100

func _init() -> void:
	visible = false
func _ready() -> void:
	flash()
func flash():
	await get_tree().create_timer(0.1).timeout
	visible = true

func _process(delta: float) -> void:
	if can_damage && stopwatch <= cooldown:
		stopwatch += delta

func setup(new_time: int, new_level: int):
	if foreground:
		for animation in foreground:
			var global_pos: Vector2 = animation.global_position
			animation.reparent(GameInstance.instance.event_foreground_parent)
			animation.global_position = global_pos
	if background:
		for animation in background:
			var global_pos: Vector2 = animation.global_position
			animation.reparent(GameInstance.instance.event_background_parent)
			animation.global_position = global_pos

func _on_damage_area_body_entered(body: Node2D) -> void:
	if can_damage && stopwatch >= cooldown:
		stopwatch = 0
		GameManager.instance.player.damage(Attack.new(damage, global_position, buildup, status, self, stun, slow, knockback))
