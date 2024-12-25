extends Node

@onready var enemy = preload("res://Scenes/first_enemy.tscn")  # Preload the enemy scene
var spawn_timer: Timer  # Timer to control spawning

func _ready():	
	spawn_timer = Timer.new()  # Create a new Timer
	add_child(spawn_timer)  # Add the timer to the current node
	spawn_timer.wait_time = 0.1  # Set the timer to trigger every 1 second
	spawn_timer.one_shot = false  # Make it loop
	spawn_timer.start()  # Start the timer
	spawn_timer.timeout.connect(self._on_spawn_timer_timeout)


func _on_spawn_timer_timeout():
	# Random position between -5 and 5 for both x and y
	var random_position = Vector2(randf_range(-5, 5), randf_range(-5, 5))
	
	# Instantiate a new enemy at the random position
	var new_enemy = enemy.instantiate()  # Create a copy of the enemy
	new_enemy.position = random_position  # Set the position of the new enemy
	
	add_child(new_enemy)  # Add the new enemy to the scene
