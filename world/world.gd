extends Node2D

var troops_array: Array[Troop] = []
@onready var troopScene = load("res://troop/troop.tscn")

func _ready():
	for i in 6:
		var troop = troopScene.instantiate()
		troop.position = Vector2(50, 70*i+50)
		troops_array.append(troop as Troop)
		add_child(troop)


func _unhandled_input(event):
	if event.is_action_pressed("click"): 
		pass
		
		$red_point.show()    
		$red_point.position = get_global_mouse_position()
		await get_tree().create_timer(1).timeout # ждем секунду
		$red_point.hide()



