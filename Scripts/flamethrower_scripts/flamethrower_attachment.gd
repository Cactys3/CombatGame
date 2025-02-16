extends Attachment

#TODO: what does this do

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	process_cooldown(delta)
