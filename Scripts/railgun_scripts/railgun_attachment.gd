extends Attachment

##Projects a lazar beam aiming sight for awhile until firing a lazar blast that does a fuck ton of dmg and stuff.

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	process_cooldown(delta)
	#52print(frame.stats.get_stat(StatsResource.COOLDOWN))
	#print("this: " + str(frame.stats.statsfactor.get(StatsResource.COOLDOWN)))
