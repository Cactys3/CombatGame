extends Attachment

var firing_continuously: bool = false
## Percent multiplied to attackspeed
var ramping_attackspeed: float = 1
var ramping_attackspeed_delta: float = 0.1
var min_ramping_attackspeed: float = 0.5
var max_ramping_attackspeed: float = 1.5
func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)
## Add ramping attackspeed
func process_cooldown(delta: float) -> void: 
	if attacking:
		pass
	elif cooldown_timer <= get_cooldown():
		cooldown_timer += delta
	elif handle.ready_to_fire:
		firing_continuously = true
		attacking = true
		attack() 
	else:
		firing_continuously = false
		if !ramping_attackspeed >= max_ramping_attackspeed:
			## Remove attackspeed bonus at 4 times the rate as adding it
			ramping_attackspeed += (delta * ramping_attackspeed_delta * 4)
	if firing_continuously:
		if !ramping_attackspeed <= min_ramping_attackspeed:
			## Add attackspeed bonus
			ramping_attackspeed -= (delta * ramping_attackspeed_delta)

func get_cooldown() -> float:
	return super() * ramping_attackspeed
