extends Control

func _on_touch_screen_button_2_released():
	GlobalManager.goto_scene(GlobalManager.levels["option_menu"])


func _on_touch_screen_button_3_released():
	get_tree().quit()


func _on_touch_screen_button_released():
	GlobalManager.goto_scene(GlobalManager.levels["start_game"])
	
