extends Node
class_name Item

var connect_all: bool = false
var data: ItemData = ItemData.new()

func _process(delta: float) -> void:
	pass

func _ready() -> void:
	call_deferred("_connect_signals")

func getdata() -> ItemData:
	return data

func _connect_signals():
	if connect_all:
		GameManager.instance.enemy_damaged.connect(enemy_damaged)
		GameManager.instance.enemy_killed.connect(enemy_killed)
		GameManager.instance.player_damaged.connect(player_damaged)
		GameManager.instance.player_Killed.connect(player_Killed)
		GameManager.instance.RoundEnded.connect(round_ended)

## meant to be overriden by extender
func setdata():
	pass
func enemy_damaged(enemy: Enemy, attack: Attack):
	pass
func enemy_killed(enemy: Enemy, attack: Attack):
	pass
func player_damaged(player: Player_Script, attack: Attack):
	pass
func player_Killed(player: Player_Script, attack: Attack):
	pass
func round_ended(round_number: int):
	pass
