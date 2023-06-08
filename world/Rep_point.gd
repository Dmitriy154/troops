extends Node2D

#время жизни указателя
var time: int = 2

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED #отключаем физический процесс для оптимизации
	#set_physics_process(false) #отключаем физический процесс для оптимизации
	

func _draw():
	draw_circle(Vector2(0,0), 5, Color(1, 0, 0, 1))
	#draw_line(Vector2(1.5, 1.0), Vector2(150, 400), Color.GREEN, 1.0)

func show_target(target: Vector2):
	##переделать, исчезает, года отряд доходит до точки или меняет направление
	
	show()
	position = target
	await get_tree().create_timer(time).timeout
	hide()
