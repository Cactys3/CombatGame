extends Attachment

#TODO: what does this do

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)
	#52print(frame.stats.get_stat(StatsResource.COOLDOWN))
	#print("this: " + str(frame.stats.statsfactor.get(StatsResource.COOLDOWN)))
