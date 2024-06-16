class_name Draw_rect_select
extends Node2D
# рисую прямоуольник для выделения отрядов

var point1: Vector2
var point2 : Vector2
var r1: Vector2 # начальный угол прямоугольника
var r2: Vector2 # конечный угол прямоугольника
var m: Vector2
var color : Color = Color(Color.ROYAL_BLUE, 0.5)
var radius: float = 20
var rect: Rect2

var area = Area2D.new()
var coll_shape = CollisionShape2D.new()
var flag_exit := false

func _init(parent):
	parent.add_child(self)
	visible = false
	add_child(area)
	area.add_child(coll_shape)
	coll_shape.shape = RectangleShape2D.new()
	area.monitoring = true
	area.monitorable = false
	area.collision_mask = 1
	area.body_entered.connect(sel_troop)
	area.body_exited.connect(remove_sel_troop)


func sel_troop(body): # выделяем отряды, которые находятся в рамке
	if flag_exit: return # при исчезновении рамки отряды не выделяются
	
	body.add_select('draw_rect_sel')


func remove_sel_troop(body): # снимаем выделение с отрядов, которые выходят из рамки
	if flag_exit: return # при исчезновении рамки, выделенные отряды не теяют выделение
	body.remove_select()
	

func show_update():
	r1 = Vector2.ZERO
	r2 = Vector2.ZERO
	rect = Rect2(r1,r2)
	point2 = Vector2.ZERO
	point1 = get_global_mouse_position()
	m = get_global_mouse_position()
	coll_shape.shape.size = Vector2.ZERO
	flag_exit = false
	show()


func _process(_delta):
	if not visible: return
	m = get_global_mouse_position()  # get_viewport().get_mouse_position()
	if point2 != point1: 
		point2 = m-point1
	area.position = r1 + r2 * 0.5
	coll_shape.shape.size = Vector2(r2)
	queue_redraw()
	

func _draw():
	if m == Vector2.ZERO: return

	if m.x > point1.x and m.y <= point1.y:
		r1 = Vector2(point1.x, m.y)
		r2 = Vector2(m.x - point1.x, point1.y - m.y)
	elif m.x <= point1.x and m.y > point1.y:
		r1 = Vector2(m.x, point1.y)
		r2 = Vector2(point1.x - m.x, m.y - point1.y)
	elif m.x <= point1.x and m.y <= point1.y:
		r1 = m
		r2 = point1 - m
	else:
		r1 = point1
		r2 = m - point1

	rect = Rect2(r1,r2)

	draw_rect(rect,color, true)
	draw_circle(point2+point1, radius, color)


func exit():
	print('exit')
	#Test.new('rect', [r1, r2], Color.RED, 10, '', self)
	flag_exit = true
	hide()

