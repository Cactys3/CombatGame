extends Container
class_name DragBar


@export var parent: Control
@onready var label: Label = $Label
static var dragging_some_bar: bool = false
var mouse_hover: bool = false
var dragging: bool = false
var offset: Vector2
var offset2: Vector2

var count = 0

static var hovered: Array[DragBar]

func _ready() -> void:
	if !parent:
		parent = self
	parent.z_index = 2

func _process(delta: float) -> void:
	if visible && !(DragBar.dragging_some_bar && !dragging):
		if !mouse_hover && get_global_rect().has_point(get_global_mouse_position()):
			hovered.append(self)
			mouse_hover = true
			print("hover true")
		
		if mouse_hover && !get_global_rect().has_point(get_global_mouse_position()):
			hovered.erase(self)
			mouse_hover = false
			print("hover false")
		
		if dragging && !Input.is_action_pressed("left_click"):
			dragging = false
			dragging_some_bar = false
			parent.z_index = 3
			print("dragging false")
		
		if mouse_hover && Input.is_action_just_pressed("left_click"):
			var good: bool = true
			for bar in hovered:
				if bar != self && bar.parent.z_index > parent.z_index:
					good = false
			if good:
				dragging = true
				dragging_some_bar = true
				parent.z_index = 50
				offset = parent.global_position
				offset2 = get_global_mouse_position()
				print("dragging true")
		
		if dragging:
			parent.global_position = lerp(parent.global_position, offset + (get_global_mouse_position() - offset2), 40 * delta)
		
	else:
		if parent.z_index > 2 && DragBar.dragging_some_bar && !dragging:
			parent.z_index = 2
		if dragging:
			dragging_some_bar = false
			dragging = false

func set_label(newtext: String):
	label.text = newtext


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
