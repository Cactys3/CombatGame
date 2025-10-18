extends Handle
## overheat visual, make increase as overheat increases
@onready var overheat_visual: AnimatedSprite2D = $OverheatVisual

var overheat_level: int = 0

var curr_overheat: float = 0
## 5 seconds of default firing before overheat
var default_max_overheat: float = 5
var max_overheat: float:
	get():
		return frame.get_stat(StatsResource.DURATION) + default_max_overheat

var overheated: bool = false

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)


## When player holds down click, it positions at mouse and aims towards nearest enemy and fires
## When release mouse, it cools off to prevent an overheat 

## Attackspeed stat is high, but limited by overheat mechanic where gun only fires when holding Left Click, and has to cool off if overheated
func ProcessUnique(_delta: float) -> void:
	## Calculate Overheat Before
	if !overheated && curr_overheat > max_overheat:
		overheated = true
	
	## if firing:
	if Input.is_action_pressed("left_click") && !overheated:
			curr_overheat += _delta
			#Orbit Player Towards Mouse
			var alternating_sign: float = 1
			if (int(weapon_slot) % 2) == 0: #alternate being left of 1st weapon and right
				alternating_sign = -1
			var temp_slot_variable: float = weapon_slot
			if weapon_slot > 2:
				if (int(weapon_slot) % 2) != 0: #make distance only increase once a sword has been added on both left and right with same distance
					temp_slot_variable = (weapon_slot + 1) / 2
				else:
					temp_slot_variable = (weapon_slot + 2) / 2
			var slot_offset_value = alternating_sign * ((TAU / 30) * ((temp_slot_variable - 1)))
			frame.global_position = GetOrbitPosition((get_global_mouse_position() - player.global_position).normalized().angle() + slot_offset_value)
			#Rotate Towards Object
			var nearest_enemy: Node2D = frame.get_enemy_nearby(frame.get_stat(stats.RANGE) + StatsResource.get_default(StatsResource.RANGE))
			if nearest_enemy != null:
				RotateTowardsPosition(nearest_enemy.global_position, _delta)
				if !ready_to_fire && IsAimingAtEnemy(nearest_enemy):
					ready_to_fire = true
			else:
				RotateTowardsPosition(get_global_mouse_position(), _delta)
				ready_to_fire = false
	else:
		## if not firing, don't fire
		ready_to_fire = false
		if (curr_overheat > 0):
			if overheated:
				## if overheated, regen slower
				curr_overheat -= (_delta / 1.5)
			else:
				curr_overheat -= _delta
	## if was overheated and curr_overheat has been dropped all the way, stop overheated
	if (overheated && curr_overheat <= 0):
		overheated = false
	
	## Handle Overheat Animation
		print(max_overheat)
	if overheated:
		if overheat_level != 4:
			overheat_visual.play("4")
			overheat_level = 4
	elif curr_overheat > (max_overheat * 0.9):
		if overheat_level != 3:
			overheat_visual.play("3")
			overheat_level = 3
	elif curr_overheat > (max_overheat * 0.65):
		if overheat_level != 2:
			overheat_visual.play("2")
			overheat_level = 2
	elif curr_overheat > (max_overheat * 0.3):
		if overheat_level != 1:
			overheat_visual.play("1")
			overheat_level = 1
	else:
		if overheat_level != 0:
			overheat_visual.play("0")
		overheat_level = 0
