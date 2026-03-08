extends Node2D
@onready var sprite: Sprite2D = $Sprite2D

const PUNKIN_PATCH_1 = preload("uid://wnykcjnilq5o")
const PUNKIN_PATCH_2 = preload("uid://d2xg2dims8ylm")
const PUNKIN_PATCH_3 = preload("uid://i3y0vnjm7use")
const PUNKIN_PATCH_4 = preload("uid://de24oj80uqxqi")
const PUNKIN_PATCH_5 = preload("uid://28ckbfd1sll2")
const PUNKIN_PATCH_6 = preload("uid://cprm7wj7j0g6b")

var array: Array = [PUNKIN_PATCH_1, PUNKIN_PATCH_2, PUNKIN_PATCH_3, PUNKIN_PATCH_4, PUNKIN_PATCH_5, PUNKIN_PATCH_6]

func _ready() -> void:
	sprite.texture = array[randi_range(0, array.size() - 1)]
	print("Chose Texture: ", randi_range(0, array.size()))
