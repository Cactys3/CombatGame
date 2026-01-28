extends Item

## Buffs Damage by 10%

## Code: Adds 10% to global stat?


func _process(delta: float) -> void:
	super(delta)
	#print(enabled)

func _ready() -> void:
	super()

func _connect_signals():
	super()

func enable():
	enabled = true
	manager.add_stats_item(self, stats)

func disable():
	enabled = false
	manager.remove_stats_item(self, stats)
