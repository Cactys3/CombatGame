extends Control

@export var ProjectileImage: Sprite2D
@export var HandleImage: Sprite2D
@export var AttachmentImage: Sprite2D
@export var TextLabel: Label
@export var AttachmentLabel: Label
@export var HandleLabel: Label
@export var ProjectileLabel: Label
signal button_pressed

func _on_button_down() -> void:
	button_pressed.emit()

func set_text(title: String, handle_name: String, attachment_name: String, projectile_name: String):
	TextLabel.text = title
	ProjectileLabel.text = projectile_name
	AttachmentLabel.text = attachment_name
	HandleLabel.text = handle_name

func set_images(handle: Texture2D, attachment: Texture2D, projectile: Texture2D):
	ProjectileImage.texture = projectile
	HandleImage.texture = handle
	AttachmentImage.texture = attachment
