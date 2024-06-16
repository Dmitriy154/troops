class_name Draw_area
extends Node2D
# рисует места растановки отрядов, площадка для построения

var node_parent:Node2D
var rect: Rect2
var width_rect: float
var height_rect: float
var point1 := Vector2.ZERO # начальная точка прямоугольника
var point2 : Vector2 # конечная точка прямоугольника
var point3 : Vector2 # точка находния первого отряда, для смещения позиции прямоугольника
var width : int = 6
var color : Color = Color(Color.RED, 0.3)
var alfa :float = 0.0
var speed_rotation:float = 7 # скорость поворота прямоугольника при изменении направления движения
var direction_troop: Vector2
var col: int
var col_0: int # колонн по умолчанию
var row: int
var arr: = []
var arr_size: int
var avarege_position:= Vector2.ZERO

	

func _init(parent):
	node_parent = Node2D.new()
	parent.add_child(node_parent)
	node_parent.add_child(self)
	node_parent.visible = false

func show_update():
	arr = get_tree().get_nodes_in_group('troops_select')
	if arr.size() == 0: return #если сразу отпустить, то массив будет пустым
	
	arr_size = arr.size()
	col = ceili(sqrt(arr_size))	#количество колон
	row = floori(float(arr_size)/col)	#количество заполненных рядов, округляем до низа, float убирает ошибку ...
	col_0 = col
	# находим среднюю точку для всех отрядов
	for i in arr.size():
		avarege_position += arr[i].position
	avarege_position /= arr.size()
	
	# 3а в зависимости от перп. вектора (угла) изменяется расстояние между отрядами от 1 до 1.41
	direction_troop = (get_global_mouse_position() - avarege_position).normalized()
	
	node_parent.position = get_global_mouse_position()
	node_parent.show()
	
	set_rect()
	node_parent.rotate(alfa)


func _process(delta):
	if not node_parent.visible: return
	queue_redraw()
	
	if Main.troops_path == Vector2.ZERO: return
	
	if (abs(Main.troops_path.angle() - alfa)>5.4):
		alfa = Main.troops_path.angle()
	else:
		alfa = lerpf(alfa, Main.troops_path.angle(), delta * speed_rotation)
		
	var num = floori(Main.troops_path.length() / (Main.troop_distance * 1.2))
	
	if num > (arr_size - col_0): 
		num = (arr_size - col_0)
	
	Game.add_col = num
	print(Game.add_col)
	
	set_rect()
	node_parent.rotation = alfa


func set_rect():
	# находим длину и ширину, начальную позицию и размер
	col = ceili(sqrt(arr.size())) + Game.add_col	#количество колон
	row = floori(float(arr.size())/col)	#количество заполненных рядов, округляем до низа, float убирает ошибку ...
	
	var alfa_45 = abs(wrapf(abs(alfa), 0, PI/2) - PI/4.0) / (PI/4.0) # кратно 45, прямые углы стремятся к 1, 45 к нулю	
	var dist = lerpf(1.2, 1.1, alfa_45) * Main.troop_distance # расстояние между отрядами, по диагонали увелич. до 1.3
	
	width_rect = dist*(row-1) + Main.troop_size
	height_rect = dist*(col-1) + Main.troop_size
	
	point1 = Vector2.ZERO
	point2 = Vector2(1,0) * width_rect + Vector2(0,1) * height_rect
	point3 = Vector2(1,0) * (width_rect - Main.troop_size * 0.5) + Vector2(0,1) * height_rect * 0.5
	rect = Rect2(point1, point2)

	position = point3*(-1)



func _draw():
	draw_rect(rect, color, true)	

# финиш при отжатии кнопки мыши или пальца!
func _unhandled_input(event):
	if not node_parent.visible: return
		
	if event is InputEventMouseButton and event.button_index == 1 and not event.pressed: # только для клика или тапа (без колесика) - отжата ЛКМ
		print('area_finish!')
		#await get_tree().create_timer(0.4).timeout
		node_parent.rotation = 0.0
		#fixed = false
		node_parent.hide()
		#создать независимый прямоугольик и удалить его через опр. промежуток времени
		Draw_area_dubl.new(Main.world, node_parent.position, position, rect, alfa)
