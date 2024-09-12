extends Control

# Function to restart the game when the button is pressed
func _on_restart_button_pressed() -> void:
	restart_game()

# Function to handle input (space or enter)
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):  # ui_accept is usually space or enter
		restart_game()

# Function to restart the game
func restart_game() -> void:
	# Change the current scene back to the game scene
	Global.is_game_over = 0
	Global.scroll_speed = 60
	get_tree().reload_current_scene()

