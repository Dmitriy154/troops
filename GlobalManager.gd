extends Node

@onready var root = get_tree().root

var levels = {
	"game_menu": "res://Game_menu.tscn",
	"option_menu": "res://Option_menu.tscn",
	"start_game": "res://world/world.tscn"
}
var current_scene = null

func _ready():
	
	current_scene = root.get_child(root.get_child_count() - 1)
	
func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)
	
	
func _deferred_goto_scene(path):
	current_scene.free()
	print(path)
	var source = load(path)
	current_scene = source.instantiate()
	root.add_child(current_scene)
