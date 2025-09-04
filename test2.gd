extends SubViewportContainer

@onready var sub_vp: SubViewport = $SubViewport
@export var render_resolution: Vector2
var t = 0
var T = 5

func _ready() -> void:
	pass
	t = 0
	stretch = true
	stretch_shrink = 1
	_update_subviewport_size()
	get_tree().root.connect("size_changed", Callable(self, "_update_subviewport_size"))
	#get_tree().root.size_changed.connect(_update_subviewport_size)

func _process(delta: float) -> void:
	pass
	t += delta
	if t > T:
		t = 0
		_update_subviewport_size()

func _update_subviewport_size() -> void:
	size = get_tree().root.size
	stretch_shrink = (size.x / render_resolution.x) + 1
	if size > Vector2(640, 360):
		size = Vector2(640, 360)
	if size > Vector2(1280, 720):
		size = Vector2(1280, 720)
	if size > Vector2(1920, 1080):
		size = Vector2(1920, 1080)
	if size > Vector2(2560, 1440):
		size = Vector2(2560, 1440)
