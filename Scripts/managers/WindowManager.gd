extends Node
class_name WindowManager
@onready var GameWindow: Window = $"../Window640"
@onready var UiWindow: Window = $"../Window1920"
@onready var Game_Offset: Node2D = $"../Window640/Offset"
@onready var UI_Offset: Control = $"../Window1920/Offset"
var curr_size: Vector2
var player:
	get():
		return GameManager.instance.player
static var instance: WindowManager
## Game has to start in 4k or sm high resolution or else it doesn't work (can't set to resolutions higher than starting resolution)
## Automatically matches Windows' sizes to program's starting screensize. 
## Windows themselves automatically scale up according to their settings

signal ProgramSizedChanged
func _ready() -> void:
	if instance:
		printerr("ERROR, MULTIPLE WINDOW MANAGERS")
	instance = self
	## Start Windowed 1080p for Testing
	set_program_size(Vector2(1920, 1080), false)
	return ## TODO: above is only for testing
	## Get Monitor Resolution and start in that
	var main_monitor = DisplayServer.screen_get_usable_rect(0).size
	var current_monitor = DisplayServer.screen_get_usable_rect(DisplayServer.window_get_current_screen()).size
	set_program_size(current_monitor, true)
## Changes the Game's screensize to parameters and updates scene subwindows aswell
func set_program_size(size: Vector2i, fullscreen: bool):
	## Set Fullscreen/Windowed first, else it bugs out
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	## Set Size of Windows
	DisplayServer.window_set_size(size)
	GameWindow.size = size
	UiWindow.size = size
	## Center after changing size
	if !fullscreen:
		## Centers Window (gipity)
		var r := DisplayServer.screen_get_usable_rect(DisplayServer.window_get_current_screen())
		DisplayServer.window_set_position(r.position + Vector2i(int((r.size.x - DisplayServer.window_get_size().x)/2), int((r.size.y - DisplayServer.window_get_size().y)/2)))
	## Keep track of curr size
	curr_size = size
	#UI_Offset.position = Vector2(size.x / 2, 0) # If Node2D, if Control = not needed
var curr: int = 1
func _process(delta: float) -> void:
	if !instance:
		instance = self
func _on_pressed() -> void:
	#print("Changed Resolution from: " + str(curr))
	match curr:
		1:
			set_program_size(Vector2(1920, 1080), false)
			curr = 2
		2:
			set_program_size(Vector2(2560, 1440), true)
			curr = 3
		3:
			set_program_size(Vector2(1280, 720), false)
			curr = 1
	
	#print("To: " + str(get_tree().root.size.y))
func convert_small_position(position: Vector2) -> Vector2:
	# Get the content scale size of each window
	var small_size = Vector2(GameWindow.content_scale_size)  # 640x360
	var large_size = Vector2(UiWindow.content_scale_size)
	# Get the vector from player to the position
	var offset_from_player = Vector2(position) - player.global_position
	# Convert to normalized coordinates
	var normalized_offset = offset_from_player / small_size
	# Scale to large window coordinates
	var scaled_offset = normalized_offset * large_size
	# Get the center of the large window
	var large_center = large_size / 2.0
	# Spawn at the scaled offset from the center of the large window
	var pos_in_large = large_center + scaled_offset
	#print("Small->Large: position: " + str(position) + ", player_position: " + str(player.global_position) + ", small_size: " + str(small_size) + ", large_size: " + str(large_size) + ", offset_from_player: " + str(offset_from_player) + ", normalized_offset: " + str(normalized_offset) + ", scaled_offset: " + str(scaled_offset) + ", large_center: " + str(large_center) + ", pos_in_large: " + str(pos_in_large))
	return pos_in_large
func convert_large_position(position: Vector2) -> Vector2:
	# Get the content scale size of each window
	var large_size = Vector2(UiWindow.content_scale_size)
	var small_size = Vector2(GameWindow.content_scale_size)  # 640x360
	# Get the center of the large window
	var large_center = large_size / 2.0
	# Get the offset from the center of the large window
	var offset_from_center = Vector2(position) - large_center
	# Convert to normalized coordinates
	var normalized_offset = offset_from_center / large_size
	# Scale to small window coordinates
	var scaled_offset = normalized_offset * small_size
	# Apply the scaled offset from the player position
	var pos_in_small = player.global_position + scaled_offset
	#print("Large->Small: position: " + str(position) + ", player_position: " + str(player.global_position) + ", large_size: " + str(large_size) + ", small_size: " + str(small_size) + ", large_center: " + str(large_center) + ", offset_from_center: " + str(offset_from_center) + ", normalized_offset: " + str(normalized_offset) + ", scaled_offset: " + str(scaled_offset) + ", pos_in_small: " + str(pos_in_small))
	return pos_in_small
