extends Control
@onready var handle_goal: Control = $Control2/Control/HandleGoal
@onready var attachment_goal: Control = $Control2/Control/AttachmentGoal
@onready var projectile_goal: Control = $Control2/Control/ProjectileGoal
@onready var projectile_parent: Sprite2D = $Control2/Control/ProjectileParent
@onready var projectile_image: Sprite2D = $Control2/Control/ProjectileParent/ProjectileImage
@onready var projectile_label: Label = $Control2/Control/ProjectileParent/ProjectileLabel
@onready var attachment_parent: Sprite2D = $Control2/Control/AttachmentParent
@onready var attachment_image: Sprite2D = $Control2/Control/AttachmentParent/AttachmentImage
@onready var attachment_label: Label = $Control2/Control/AttachmentParent/AttachmentLabel
@onready var handle_parent: Sprite2D = $Control2/Control/HandleParent
@onready var handle_image: Sprite2D = $Control2/Control/HandleParent/HandleImage
@onready var handle_label: Label = $Control2/Control/HandleParent/HandleLabel
@onready var weapon_parent: Sprite2D = $Control2/Control/WeaponParent
@onready var weapon_image: Sprite2D = $Control2/Control/WeaponParent/WeaponImage
@onready var weapon_label: Label = $Control2/Control/WeaponParent/WeaponLabel
@onready var total_parent: Control = $Control2
@onready var stats_display: StatsDisplay = $Control2/Control/StatsDisplay
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var offset: Vector2 = Vector2(0, 0)
var hovering: bool = false
var anim_speed: float = 600
signal button_pressed

func _process(delta: float) -> void:
	if hovering:
		movetowards(delta)
	else:
		moveaway(delta)
func _on_button_down() -> void:
	button_pressed.emit()
func start():
	total_parent.visible = false
	anim.play("opening")
	await anim.animation_finished
	anim.play("open")
	total_parent.visible = true
func set_text(weapon_name: String, handle_name: String, attachment_name: String, projectile_name: String):
	weapon_label.text = weapon_name
	projectile_label.text = projectile_name
	attachment_label.text = attachment_name
	handle_label.text = handle_name
func set_images(handle: Texture2D, attachment: Texture2D, projectile: Texture2D, weapon: Texture2D):
	projectile_image.texture = projectile
	handle_image.texture = handle
	attachment_image.texture = attachment
	weapon_image.texture = weapon
func set_stats(stats: StatsResource):
	stats_display.setup_substats(stats, stats.parent_object_name)
func movetowards(delta: float):
	projectile_parent.global_position = projectile_parent.global_position.move_toward(offset + projectile_goal.global_position, delta * anim_speed)
	attachment_parent.global_position = attachment_parent.global_position.move_toward(offset + attachment_goal.global_position, delta * anim_speed)
	handle_parent.global_position = handle_parent.global_position.move_toward(offset + handle_goal.global_position, delta * anim_speed)
func moveaway(delta: float):
	projectile_parent.global_position = projectile_parent.global_position.move_toward(weapon_parent.global_position, delta * anim_speed * 2)
	attachment_parent.global_position = attachment_parent.global_position.move_toward(weapon_parent.global_position, delta * anim_speed * 2)
	handle_parent.global_position = handle_parent.global_position.move_toward(weapon_parent.global_position, delta * anim_speed * 2)
func _mouse_enter() -> void:
	hovering = true
func _mouse_exit() -> void:
	hovering = false
