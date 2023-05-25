extends Node2D

##var Troop = preload("res://troop/troop.tscn")

func _ready():
	##var troop = Troop.instantiate()
	##add_child(troop)
	pass

func _input(event):
	
	if event.is_action_pressed("click"):
		$red_point.show()    
		$red_point.position = get_global_mouse_position()
		await get_tree().create_timer(1).timeout # ждем секунду
		$red_point.hide()
		
