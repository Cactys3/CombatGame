extends Inventory

@export var drop_visual: Panel
@export var drop_text: Label
var showing_drop: bool = false
func _ready() -> void:
	drop_visual.visible = false
	super()

func _process(delta: float) -> void:
	handle_drop_visual()
	super(delta)

func handle_drop_visual():
	if !showing_drop && ItemUI.dragging_some_item:
		showing_drop = true
		if dragging_my_item:
			drop_text.text = "Drop to Delete!"
		else:
			drop_text.text = "Drop to Move!"
		drop_visual.visible = true
	
	if showing_drop && !ItemUI.dragging_some_item:
		showing_drop = false
		drop_visual.visible = false

func check_item(item: ItemUI) -> bool:
	return is_instance_valid(item) && item.data.item_type == "Attachment"

func drop(item: ItemUI) -> void:
	# TODO: if item.has_cost type shit 
	if dragging_my_item:
		print("sell")
		remove(item)
	else:
		print("move")
		move(item)
