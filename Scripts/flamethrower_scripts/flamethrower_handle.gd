extends Handle

#this makes it spin in a circle for the aiming

var spinning_offset: float = 0
var spinning_speed: float = 3

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)
	ProcessUnique(delta)


func ProcessUnique(delta: float) -> void:
	spinning_offset += delta * spinning_speed
	frame.global_position = GetOrbitPosition(spinning_offset + (TAU * (weapon_slot / weapon_count))) #should be used if there are multiple spinning weapons
	frame.rotation = spinning_offset + (TAU * (weapon_slot / weapon_count)) #face directly outward (works?)
