extends Control
@onready var parent_parent: Control = $ParentParent
@onready var title_label: Label = $ParentParent/TitleLabel
@onready var stats_display: StatsDisplay = $ParentParent/Parent/StatsDisplay
@onready var image: Sprite2D = $ParentParent/Parent/ImageBackground/Image
@onready var image_label: Label = $ParentParent/Parent/ImageBackground/ImageLabel
@onready var accept_button: Button = $ParentParent/AcceptButton
@onready var chest_animation: AnimatedSprite2D = $ChestAnimation

signal button_pressed

func _on_button_down() -> void:
	button_pressed.emit()
func start():
	parent_parent.visible = false
	chest_animation.play("opening")
	await chest_animation.animation_finished
	chest_animation.play("open")
	parent_parent.visible = true
func set_text(new_title: String, label: String):
	title_label.text = new_title
	image_label.text = label
func set_images(new_image: Texture2D):
	image.texture = new_image
func set_stats(stats: StatsResource):
	stats_display.setup_substats(stats, stats.parent_object_name)
func remove_stats():
	stats_display.visible = false
