extends Control
class_name DraggableUI


@export var parent: Control
static var dragging_some_ui: bool = false
var mouse_hover: bool = false
var dragging: bool = false
var offset: Vector2
var offset2: Vector2

var count = 0

static var hovered: Array[DraggableUI]

func _ready() -> void:
	if !parent:
		parent = self
	parent.z_index = 2

func _process(delta: float) -> void:
	if !(dragging_some_ui && !dragging) && visible && parent.visible && process_mode != PROCESS_MODE_DISABLED && parent.process_mode != PROCESS_MODE_DISABLED:
		if !mouse_hover && get_global_rect().has_point(get_global_mouse_position()):
			hovered.append(self)
			mouse_hover = true
			#print("hover true")
		
		if mouse_hover && !get_global_rect().has_point(get_global_mouse_position()):
			hovered.erase(self)
			mouse_hover = false
			#print("hover false")
		
		if dragging && !Input.is_action_pressed("left_click"):
			dragging = false
			dragging_some_ui = false
			parent.z_index = 3
			#print("dragging false")
		
		if mouse_hover && Input.is_action_just_pressed("left_click") && visible:
			var good: bool = true
			for bar in hovered:
				if is_instance_valid(bar) && bar != self && bar.get_priority() > get_priority():
					good = false
			if good:
				#print(parent.name + " won dragging context with: " + str(get_priority()))
				dragging = true
				dragging_some_ui = true
				parent.z_index = 50
				offset = parent.global_position
				offset2 = get_global_mouse_position()
				#print("dragging true")
		if dragging:
			parent.global_position = lerp(parent.global_position, offset + (get_global_mouse_position() - offset2), 40 * delta)
	else:
		if parent.z_index > 2 && dragging_some_ui && !dragging:
			parent.z_index = 2
		if dragging:
			dragging_some_ui = false
			dragging = false

func set_label(newtext: String):
	if $Label:
		$Label.text = newtext

func get_priority() -> int:
	return parent.z_index

func free_draggable_ui():
	if hovered.has(self):
		hovered.erase(self)
	if dragging:
		dragging_some_ui = false
	if ItemUI.dragging_item == self:
		ItemUI.dragging_item = null
		ItemUI.dragging_some_item = false
	queue_free()

func _enter() -> void:
	#hovered.append(self)
	#mouse_hover = true
	count += 1
	#print("hover true " + str(count) + " " + str(parent.z_index) + " " + str(z_index) + " " + str(mouse_filter) + " " + str(Control.MOUSE_FILTER_STOP))

func _exit() -> void:
	#hovered.erase(self)
	#mouse_hover = false
	count += 1
	#print("hover false " + str(count) + " " + str(parent.z_index) + " " + str(z_index) + " " + str(mouse_filter) + " " + str(Control.MOUSE_FILTER_STOP))
