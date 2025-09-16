extends Node
class_name Item

var connect_all: bool = false
var data: ItemData
var enabled: bool = false
var manager: GameManager:
	get():
		return GameManager.instance

func _process(_delta: float) -> void:
	pass

func _ready() -> void:
	call_deferred("_connect_signals")

func getdata() -> ItemData:
	return data

func _connect_signals():
	if connect_all:
		manager.enemy_damaged.connect(enemy_damaged)
		manager.enemy_killed.connect(enemy_killed)
		manager.player_damaged.connect(player_damaged)
		manager.player_Killed.connect(player_Killed)
		manager.RoundEnded.connect(round_ended)


## Should be overriden by extender to turn off functionality
func enable():
	enabled = true

func disable():
	enabled = false

## signals to be overriden by extender
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
