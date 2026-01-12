extends RigidBody2D
class_name ItemDrop
var POPUP = preload("uid://brldrnbhcexcm")
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@export var acceleration: float = 1
@export var speed: float = 0
@export var anim: AnimatedSprite2D
@export var auto_collect: bool = false
var is_collected: bool = false
var timer = 0
var is_item: bool = false
var item: ItemUI
var dead: bool = false
## Setup this item_drop as giving an item to player
func setup_item(new_item: ItemUI):
	## Play item's image as animation
	anim.sprite_frames = SpriteFrames.new()
	anim.sprite_frames.add_animation("item")
	anim.sprite_frames.add_frame("item", new_item.data.item_image)
	anim.play("item")
	item = new_item
	is_item = true
## Setup this item_drop to autocollect instead of waiting for player to be in range
func setup_autocollect(delay: float):
	await get_tree().create_timer(delay).timeout
	is_collected = true
func _process(delta: float) -> void:
	if auto_collect:
		is_collected = true
	if is_collected:
		timer += delta
		acceleration = 50
		if (speed < 1000):
			speed += delta * acceleration  ## Increment speed
		if (timer > 0.1): ## Makes it do a little jump away before coming towards player
			position = position + ((-position + player.position).normalized() * delta * speed)
func _entered(area: Area2D) -> void:
	if area.is_in_group("xp_range") && !is_collected:
		linear_velocity = (global_position - player.global_position).normalized() * 300
		is_collected = true
		#animation.pause()
		speed = 200
		acceleration = 50
func _entered_body(body: Node2D) -> void:
	if body.is_in_group("player"):
		touched_player()
		visible = false
		queue_free()
## Mean to be overriden
func touched_player():
	if dead:
		return
	dead = true
	if is_item:
		if !item:
			printerr("!item!")
			return
		## Make Popup
		var popup: PopupText = POPUP.instantiate()
		popup.setup("Added " + item.data.item_name + " to inventory!", 16, WindowManager.instance.convert_small_position(global_position + Vector2(0, -100)), 1, Vector2.ZERO)
		## Add Item
		GameManager.instance.ui_man.inventory.ui_add(item)
