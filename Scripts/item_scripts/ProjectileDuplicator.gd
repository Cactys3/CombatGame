extends Item

## Shoots X projectiles every time your weapons fire X times

var curr_count: int = 0
var max_count: int = 20

func _ready() -> void:
	super()
