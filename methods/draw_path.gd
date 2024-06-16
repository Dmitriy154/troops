class_name Draw_path
extends Node2D
# рисует направление отрядов

var point1 := Vector2.ZERO
var point2 : Vector2
var width : int = 10
var color : Color = Color.CADET_BLUE
var radius: float = 20

func _init(parent):
	parent.add_child(self)
	visible = false
	

func show_update():
	point1 = get_global_mouse_position()
	point2 = Vector2.ZERO
	Main.troops_path = Vector2.ZERO
	show()


func _process(_delta):
	if not visible: return
	var mouse_position = get_global_mouse_position()  # get_viewport().get_mouse_position()
	if mouse_position != point2:
		point2 = mouse_position
		Main.troops_path = point2 - point1
		queue_redraw()

func _draw():
	if point2 != Vector2.ZERO:
		draw_line(point1, point2, color, width)
		# ограничить длину линии
	
	draw_circle(point1, radius, color)


func finish() -> Vector2:
	return point2 - point1
