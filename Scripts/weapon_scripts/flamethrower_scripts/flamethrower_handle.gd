extends Handle

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/flamethrower/flamethrower_handle.tscn")

#this makes it spin in a circle for the aiming

var spinning_offset: float = 0
var spinning_speed: float = 3

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)
	ProcessUnique(delta)
	#ready_to_fire = true


func ProcessUnique(delta: float) -> void:
	spinning_offset += delta * spinning_speed #TODO: Have a static value between all handles used to know how many of each aim type there are?
	frame.global_position = GetOrbitPosition(spinning_offset + (TAU * (weapon_slot))) #should be used if there are multiple spinning weapons
	frame.rotation = spinning_offset + (TAU * (weapon_slot)) #face directly outward (works?)
	ready_to_fire = true
