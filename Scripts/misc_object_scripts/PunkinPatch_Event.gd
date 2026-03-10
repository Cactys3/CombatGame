extends Node2D
@onready var sprite: Sprite2D = $Sprite2D

const PUNKIN_PATCH_1 = preload("uid://c1ttam70tj7l")
const PUNKIN_PATCH_2 = preload("uid://6ongf47tenta")
const PUNKIN_PATCH_3 = preload("uid://c1k8laq8q61qr")
const PUNKIN_PATCH_4 = preload("uid://btuhqp45xctct")
const PUNKIN_PATCH_5 = preload("uid://csa5se5vpmqu0")
const PUNKIN_PATCH_6 = preload("uid://dwh2osi4fcm3u")


var array: Array = [PUNKIN_PATCH_1, PUNKIN_PATCH_2, PUNKIN_PATCH_3, PUNKIN_PATCH_4, PUNKIN_PATCH_5, PUNKIN_PATCH_6]

func _ready() -> void:
	sprite.texture = array[randi_range(0, array.size() - 1)]
	print("Chose Texture: ", randi_range(0, array.size()))
