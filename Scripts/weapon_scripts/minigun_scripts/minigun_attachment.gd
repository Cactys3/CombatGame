extends Attachment

## Attackspeed starts low, but increases as long as weapon is still attacking

var curr_as_increase: float = 0

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

## Increase attackspeed towards double attackspeed
func process_cooldown(delta: float) -> void: 
	if attacking:
		curr_as_increase -= delta * (attacksperX / 3) # normal as in 3 seconds?
	elif cooldown_timer <= get_cooldown():
		cooldown_timer += delta
	elif handle.ready_to_fire:
		attacking = true
		attack() 
		curr_as_increase = attacksperX


func get_cooldown() -> float:
	return (attacksperX - curr_as_increase) / max(0.0001, frame.get_stat(StatsResource.ATTACKSPEED) + StatsResource.get_default(StatsResource.ATTACKSPEED)) #attackspeed is attacks per second so cd is 1/as
