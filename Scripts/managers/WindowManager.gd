extends Node

@export var GameWindow: Window
@export var UiWindow: Window


var curr_size: Vector2

## Automatically matches Windows' sizes to program's starting screensize. 
## Windows themselves automatically scale up according to their settings

signal ProgramSizedChanged

func _ready() -> void:
	## Start Windowed 1080p for Testing
	set_program_size(Vector2(1920, 1080), false)
	return ## TODO: above is only for testing
	## Get Monitor Resolution and start in that
	var main_monitor = DisplayServer.screen_get_usable_rect(0).size
	var current_monitor = DisplayServer.screen_get_usable_rect(DisplayServer.window_get_current_screen()).size
	set_program_size(current_monitor, true)

## Changes the Game's screensize to parameters and updates scene subwindows aswell
func set_program_size(size: Vector2, fullscreen: bool):
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


var curr: int = 1

func _on_pressed() -> void:
	print("Changed Resolution from: " + str(curr))
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
	
	print("To: " + str(get_tree().root.size.y))
