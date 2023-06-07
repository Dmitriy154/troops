extends Node
#главный скрип, глобальный

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func troop_move(troop:Troop, target:Vector2):
	if not target == Vector2.ZERO:
		troop.velocity = troop.position.direction_to(target) * troop.speed
		if troop.position.distance_to(target) > 5:
			troop.wall_min_slide_angle = 0.1 
			#значение по умолчанию: 0.261799 (в радианах, эквивалентно 15градусам)
			#Это минимальный угол, на который тело может скользить при ударе о склон.
			troop.move_and_slide()
		else:
			print('отряд прибыл')
			troop.state = Troop.State.IDLE
			#troop.selected = false   #состояние покоя

func troops_move(_troop_array:Array[Troop], _position_click:Vector2):
	print('движение отрядов')
	pass



