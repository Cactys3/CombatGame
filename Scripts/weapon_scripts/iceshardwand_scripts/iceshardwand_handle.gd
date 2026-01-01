extends Handle

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

## Remove Checking Enemy Nearby
func ProcessStaticSlot(delta: float) -> void:
	#Orbit Player In Assigned Slot
	var temp_count: float = weapon_count
	if (temp_count < 4):
		temp_count = 4
	frame.global_position = GetOrbitPosition((TAU * (weapon_slot / temp_count)))
	ready_to_fire = true
