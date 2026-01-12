extends RichTextLabel
class_name PopupText

@onready var anim: AnimationPlayer = $AnimationPlayer
@export var alpha: float:
	set(value):
		modulate = Color(modulate.r, modulate.g, modulate.b, value)
		alpha = value
var curr_text: String # For use if add one character at a time
var size_scale: int # For use if increase size over time
var fontsize = 8

var stopwatch: float
var lifetime: float
var done: bool = false

# Overview: given stuff, plays 

func _ready() -> void:
	if lifetime < 1:
		lifetime += 1

func _process(delta: float) -> void:
	if done:
		pass
	
	stopwatch += delta
	if stopwatch > lifetime:
		anim.play("fade")
		done = true

func setup(new_text: String, new_fontsize: float, new_position: Vector2, new_lifetime: float, max_offsets: Vector2):
	GameManager.instance.ui_man.relative_to_game_parent.add_child(self) 
	curr_text = new_text 
	curr_text = "[center]  " + curr_text + "  [/center]"
	curr_text = "[url=https://neal.fun/]" + curr_text + "[/url]"
	curr_text = "[shake rate=20.0 level=5 connected=1]" + curr_text + "[/shake]"
	modulate = Color(randf(), randf(), randf())
	fontsize = round(new_fontsize / 4) * 4 ## Keep it a multiple of 4
	if fontsize < 4:
		fontsize = 16
	lifetime = new_lifetime
	if max_offsets != Vector2.ZERO:
		var x = randf_range(-max_offsets.x, max_offsets.x)
		var y = randf_range(-max_offsets.y, max_offsets.y)
		new_position +=  Vector2(x, y)
	add_theme_font_size_override("normal_font_size", fontsize)
	text = curr_text
	alpha = 0.9
	call_deferred("set", "global_position", new_position - Vector2(get_content_width(), get_content_height()) / 2) #offset so it's centered text (idk why this best solution)

func addtag(new_text: String, tag1: String, tag2: String):
	new_text = tag1 + new_text + tag2
