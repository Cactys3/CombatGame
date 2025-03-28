extends RichTextLabel
class_name PopupText

@onready var anim: AnimationPlayer = $AnimationPlayer
@export var alpha: float:
	set(value):
		modulate = Color(modulate.r, modulate.g, modulate.b, value)
		alpha = value

var parent: Node 
var curr_text: String # For use if add one character at a time
var size_scale: int # For use if increase size over time
var fontsize = 5

var stopwatch: float
var lifetime: float
var done: bool = false

# Overview: given stuff, plays 

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if done:
		pass
	
	stopwatch += delta
	if stopwatch > lifetime:
		anim.play("fade")
		done = true

func setup(new_text: String, new_fontsize: int, new_position: Vector2, new_lifetime: float, new_parent: Node, max_offsets: Vector2):
	curr_text = new_text
	curr_text = "[center]  " + curr_text + "  [/center]"
	curr_text = "[url=https://neal.fun/]" + curr_text + "[/url]"
	#curr_text = "[font=res://Fonts/cozette/CozetteVector.otf]" + curr_text + "[/font]"
	#curr_text = "[wave amp=50.0 freq=3.0 connected=1]" + curr_text + "[/wave]"
	#curr_text = "[tornado radius=10.0 freq=1.0 connected=1]" + curr_text + "[/tornado]"
	curr_text = "[shake rate=20.0 level=5 connected=1]" + curr_text + "[/shake]"
	#curr_text = "[fade start=1 length=4]" + curr_text + "[/fade]"
	modulate = Color(randf(), randf(), randf())
	fontsize = fontsize + (new_fontsize / 3)
	parent = new_parent
	lifetime = new_lifetime


	if max_offsets != Vector2.ZERO:
		var x = randf_range(-max_offsets.x, max_offsets.x)
		var y = randf_range(-max_offsets.y, max_offsets.y)
		new_position +=  Vector2(x, y)
	
	add_theme_font_size_override("normal_font_size", fontsize)
	text = curr_text
	alpha = 0.9
	parent.add_child(self)
	call_deferred("set", "global_position", new_position - Vector2(get_content_width(), get_content_height()) / 2) #offset so it's centered text (idk why this best solution)

func addtag(text: String, tag1: String, tag2: String):
	text = tag1 + text + tag2
