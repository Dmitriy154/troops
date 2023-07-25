extends Control


func _on_touch_screen_button_released():
	GlobalManager.goto_scene(GlobalManager.levels["game_menu"])
