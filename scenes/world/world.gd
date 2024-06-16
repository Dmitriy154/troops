extends Node2D
# WORLD

@export var btn_tool: bool = false: # при использовании @tool
	set = _set_test_tool

var touch_points: Dictionary = {} # массив позиций точек касания пальцев
var target_click: Vector2
var gr_troops_select: Array # массив выделенных отрядов

var show_pass: Vector2	# показать направление построния
var drag_map = false
var draw_path # рисованиенаправление для построения отрядов
var draw_area	# рисование площадки построения отряда
var draw_rect_select = Draw_rect_select.new(self) # прямоугольник для выделения отрядов

var timer: Timer = Timer.new()
var timer_flag: int = 0 # 0 - не установлен; 1 - рисование пути; 2 - рисование прямоугольника выделения

@onready var tilemap = $NavigationRegion2D2/TileMap
@onready var camera_2d = $Camera2D
@onready var area_sel_all = $Area_sel_all
@onready var log_1 = $Menu/R_menu/log1


func _ready():
	Main.start(self)
	Events.updateTroop.connect(update)
	timer.one_shot = true
	timer.timeout.connect(draw_elem)
	add_child(timer)
	draw_area = Draw_area.new(self)
	draw_path = Draw_path.new(self)
	area_sel_all.body_entered.connect(sel_all_troops)
	#print(OS.get_name())
	# Test.new('line', [Vector2(100,10), Vector2(300, 300)], Color.GREEN_YELLOW, 15, 'test154', self)
	# Test.new('point', [Vector2(80, 50)], Color.RED, 10, '12345678', self)


# срабатывает при выделении (снятии) отряда(ов)
func update():
	gr_troops_select = get_tree().get_nodes_in_group('troops_select') # массив выделенных отрядов

var temp_arr = [] # промежуточный массив для сохранения только что отправленных отрядов
var d_click:= false


func _unhandled_input(event):	
	get_tree().create_timer(15).timeout.connect(func(): log_1.text = '') # очистка тестового поля
	
	## сдвиг карты
	if event is InputEventMouseMotion and Input.is_action_pressed("mclick"):
		if event.relative.length() > 2.2 and not draw_path.visible and not draw_rect_select.visible:
			p('сдвиг')
			camera_2d.target_position -= (event.relative/camera_2d.zoom.x) * 1.2 # экспериментальный коэффициент для скольжения
			camera_2d.drag = true
			drag_map = true
			timer.stop()

	# клик по карте с выделенными отрядами
	if Input.is_action_just_released("mclick") and gr_troops_select and not drag_map \
	and not draw_rect_select.visible:
		p('клик по карте с выделенными отрядами')

		if event is InputEventScreenTouch and not event.is_pressed(): return # для исключения доп. клика пальцем
		
		if draw_path.visible: # если нарисован путь
			Game.path_vector = draw_path.finish() 
			target_click = draw_path.point1
		else:
			target_click = get_global_mouse_position()

		temp_arr = gr_troops_select.duplicate()
		Game.move_troops(gr_troops_select, target_click)

		d_click = true # возможность перехватить двоной клик
		await get_tree().create_timer(0.3).timeout
		d_click = false


	if event is InputEventMouseButton and event.button_index == 1: # только для клика или тапа (без колесика)
		if event.double_click:
			if d_click:
				p('двойной клик при выделенных отрядах - начать бег')
				for i in temp_arr.size(): 
					temp_arr[i].state = 2 # устанавливаем состояние бега
					temp_arr[i].change_state(temp_arr[i].state)
			else: 
				p('двойной клик без отрядов. Выделить все отряды на экране')
				
				if not area_sel_all.get_parent(): 
					add_child(area_sel_all)
					
				area_sel_all.get_child(0).shape.size = get_viewport_rect().size / camera_2d.zoom    # размеры collisionshape
				area_sel_all.position = camera_2d.get_screen_center_position() 
				drag_map = true # для запрета клика
		
		elif event.pressed: #нажата ЛКМ
			if gr_troops_select.size() > 1:
				p('нажата ЛКМ при кол-ве отрядов более 1')
				if not drag_map:
					print('t1')
					timer.start(0.3)
					timer_flag = 1

			if gr_troops_select.size() == 0: 
				p('нажата ЛКМ и не выделены отряды') # для выделения прямоугольником
				timer.start(0.3)
				timer_flag = 2
				print('t2')

		else: 	# отжата ЛКМ
			p('отжата ЛКМ')	
			#get_tree().physics_frame.connect(func(): drag_map = false)
			#get_tree().create_timer(0.1).timeout.connect(func(): drag_map = false)
			drag_map = false
			
			if timer_flag > 0 : 
				timer.stop()
				timer_flag = 0
				print('t0')
			
			draw_path.hide()
			draw_rect_select.exit() # именно тут а не в экземпляре, чтобы клик был раньше

			if area_sel_all.get_parent(): 
				remove_child(area_sel_all)
			area_sel_all.get_child(0).position = Vector2.ZERO
			area_sel_all.get_child(0).shape.size = Vector2.ZERO  # чтобы при повторном дв. клике выделялись все отряды
		print('-----------------------------------')

	# zoom camera
	if (Input.is_action_just_pressed("wheel_up") or Input.is_action_just_pressed("wheel_down") or \
	event is InputEventMagnifyGesture):

		if event is InputEventMagnifyGesture:
			if touch_points.size() == 2:
				camera_2d.factor = event.factor
				camera_2d.drag_point = (touch_points[0] + touch_points[1]) * 0.5 /(camera_2d.zoom.x*camera_2d.factor) + camera_2d.position
		else:
			if event.button_mask == 0: return # чтобы не дублирвалось на mask =8
			
			if Input.is_action_just_pressed("wheel_up"): camera_2d.factor = 1.3
			elif Input.is_action_just_pressed("wheel_down"): camera_2d.factor = 0.7
			camera_2d.drag_point = get_global_mouse_position()
		
		camera_2d.start_zoom()
		$Menu/R_menu/L_cam_zoom.text = str(round(camera_2d.zoom*100)/100)
	
	
	
	if event is InputEventScreenTouch:
		handle_touch(event)


func p(obj):
	print(obj)

func draw_elem():
	if touch_points.size() == 2: 
		return
	if timer_flag == 1:
		print('рисуем путь')
		draw_path.show_update()
		draw_area.show_update()
	elif timer_flag == 2:
		print('рисуем рамку')
		draw_rect_select.show_update()


func sel_all_troops(body):
	if area_sel_all.visible:
		body.add_select('world-sel_all_troops')
		#вот тут баг, иногда не все выделяются


func handle_touch(event: InputEventScreenTouch):	
	if event.pressed:
		touch_points[event.index] = event.position
		#print(event.position/zoom.x + camera_2d.position)
		Test.new('point', [get_global_mouse_position()], Color.CORAL, 7, '', self)
	else:
		touch_points.erase(event.index) # удаляем свойство из словаря

func _set_test_tool(_val: bool) -> void:
	btn_tool = false
	print('test')

