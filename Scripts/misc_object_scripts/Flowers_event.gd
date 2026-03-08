extends Node2D
@onready var sprite: Sprite2D = $Sprite2D

const FLOWER_1 = preload("uid://b1gx8lc64rqqe")
const FLOWER_2 = preload("uid://fp8ok4me01sp")
const FLOWER_3 = preload("uid://dsgh7saqpn7gb")
const FLOWER_4 = preload("uid://o3rwqets1r6s")
var array: Array = [FLOWER_1, FLOWER_2, FLOWER_3, FLOWER_4]

func _ready() -> void:
	sprite.texture = array[randi_range(0, array.size() - 1)]
	print("Chose Texture: ", randi_range(0, array.size()))
