class_name Troop
extends CharacterBody2D
#TROOP класс войска

# состояния: покой, выбран, прогулка, бег, атака, защита, отступление
enum State {IDLE, MOVE, RUN, ATTACK, DEFENSE, RETREAT}

var state := State.IDLE
var selected := false
var target: Vector2 = Vector2.ZERO

var speed: float = 200.0
var acceleration = 10

var health: float = 90:
	set(x): health = clamp(x,0,100)


#ссылка на картинку - изменим Resource
@onready var sprite2d = $Sprite2D		
@onready var line = $Line2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var fon = $fon


func _ready():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	$Debug2.text = str(state) ### удалить
	health = 120.0


func _physics_process(delta): 
	if target == Vector2.ZERO: return
	
	navigation_agent.target_position = target
	var direction = Vector2.ZERO
	direction = navigation_agent.get_next_path_position() - global_position
	direction = direction.normalized()

	velocity = velocity.lerp(direction * speed, acceleration * delta)
	
	if position.distance_to(target) > 10:
		##округление до сотых
		#$Debug1.text = str("u=","%10.2f" % get_real_velocity().length())	#реальная скорость
		$Debug2.text = str(state)	
		#$Debug3.text = str("s=",round(position.distance_to(target)*10)/10)	#текущая позиция
		
		##рисуем линии движения отряда (первая точка совпадает с отрядом, вторую постоянно меняем)
		#if line.get_point_count() == 2:  
			#line.remove_point(1)
		#line.add_point(target-position)

		if move_and_slide():
			if (get_real_velocity().length() < 0.3*speed):	#снижена скорость, необходимо измнить направление
				stop_move() # изменить направление движения на время, а не останавливать
	else:
		stop_move()


func change_state(new_state: State):
	state = new_state
	update_troop()


func update_troop():
	match state:
		State.IDLE:
			pass
		State.MOVE:
			#print('move')
			speed = 200
		State.RUN:
			#print('run')
			speed = 500
		State.ATTACK:
			pass
		State.RETREAT:
			pass
		_:
			print('default')
	
	
	#Events.updateTroop.emit()
	$Debug2.text = str(state) ### удалить


func stop_move():
	velocity = Vector2.ZERO
	target = Vector2.ZERO
	change_state(State.IDLE)
	#print('отряд прибыл')


#клик по зоне ClickForSelect для выделения (снятия выделения) войска
func _on_click_for_select_gui_input(event):
	if event is InputEventMouseButton and event.double_click:	# двойной клик по отряду - убираем выделение других отрядов
		var arr = get_tree().get_nodes_in_group('troops_select')
		for i in arr.size():
			arr[i].remove_select()
	if event.is_action_pressed("mclick"):
		select_troop() # выделить - отменить выделение отряда


func select_troop():
	if (selected): remove_select()
	else: add_select('select_troop')


func add_select(_msg:String):
	add_to_group("troops_select")
	if not fon.visible: fon.show()
	selected = true
	Events.updateTroop.emit()
	#print('Select:', msg)


func remove_select():
	remove_from_group("troops_select")
	fon.hide()
	selected = false
	Events.updateTroop.emit()


# вынести в отдельный скрипт состояния, методы - troops_func
func call_group_click_world(): 
	pass
	#print("направляюсь к указанной точке: ", name)
