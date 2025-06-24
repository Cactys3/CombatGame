extends Handle

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/flamethrower/flamethrower_handle.tscn")

#this makes it spin in a circle for the aiming

var spinning_offset: float = 0
var spinning_speed: float = 3

func _ready() -> void:
	super()

## called in ready
func setdata():
	var descrip = "A handle that spins around the player, throwing projectiles everywhere.\nWhile it has lower damage, it can be good at keeping enemies away."
	var image = preload("res://Art/New_Weapons/flamethrower/Handle_Flamethrower.png")
	data.setdata("Flame", descrip, ItemData.HANDLE, "common", Color.CORAL, image, 5, 0.8)


func _process(delta: float) -> void:
	super(delta)
	ProcessUnique(delta)
	#ready_to_fire = true


func ProcessUnique(delta: float) -> void:
	spinning_offset += delta * spinning_speed #TODO: Have a static value between all handles used to know how many of each aim type there are?
	frame.global_position = GetOrbitPosition(spinning_offset + (TAU * (weapon_slot))) #should be used if there are multiple spinning weapons
	frame.rotation = spinning_offset + (TAU * (weapon_slot)) #face directly outward (works?)
	ready_to_fire = true
