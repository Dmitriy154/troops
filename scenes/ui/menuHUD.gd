extends Node2D

@onready var loadingScene = preload("res://scenes/ui/LoadingScene.tscn")

func btn_exit_pressed():
	get_tree().quit()


func btn_play_pressed():
	get_tree().change_scene_to_packed.call_deferred(loadingScene) # call_deferred чтобы не было ошибки в apk
