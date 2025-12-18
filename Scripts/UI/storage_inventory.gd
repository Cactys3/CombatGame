extends Inventory

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

## Override
func get_type() -> String:
	#print("get type: storage")
	return STORAGE
