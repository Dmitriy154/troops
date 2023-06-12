class_name World
extends Node2D

var troop: Troop
var target_click: Vector2

@onready var troopScene = load("res://troop/troop.tscn")

func _ready():
	Main.screen_size = get_viewport_rect().size
	Events.updateTroop.connect(update)  #регистрируем слушатель, который принимает сигнал о вызове экз-ром troop метода update_troop

	#добавляем на сцену отряды
	for i in 2:
		troop = troopScene.instantiate()
		troop.position = Vector2(50, 70*i+50)
		Arr.troops.append(troop as Troop)
		add_child(troop)
		#поместить отряды в разные группы: my_troops enemy_troops

#обновление состояний и событий в игре, клик мыши по новому месту
func update():
	# заполняем массив tr_sel выделенными отрядами
	Arr.fill_tr_sel()
	print('update World')


func _unhandled_input(event):
	
	#клик по карте при выделенных войсках - вызов метода перемещения
	if event.is_action_pressed("click") and Arr.tr_sel.size():
		print('click to world')
		target_click = get_global_mouse_position()
		$red_point.show_target(target_click) 
		
		#переделать в методы которые изменяют target состояния отрядов
		Arr.set_target_arr(Arr.tr_sel, target_click)

