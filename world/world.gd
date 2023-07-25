class_name World
extends Node2D

var troop: Troop
var troops_array: Array[Troop] = []
var troops_selected: Array[Troop] = []
var target_click: Vector2
var old_target_click: Vector2

@onready var troopScene = load("res://troop/troop.tscn")

func _ready():
	Main.screen_size = get_viewport_rect().size
#	Events.updateTroop.connect(update)  #регистрируем слушатель, который принимает сигнал о вызове экз-ром troop метода update_troop
	
	#добавляем на сцену отряды
	for i in 2:
		troop = troopScene.instantiate()
		troop.position = Vector2(50, 70*i+50)
		troops_array.append(troop as Troop)
		add_child(troop)
		#поместить отряды в разные группы: my_troops enemy_troops

#обновление состояний и событий в игре, клик мыши по новому месту
func update():
	#перебираем массив отрядов и ищем те, у которых состояние SELECTED
	troops_selected.clear()
	for i in troops_array.size():
		troop = troops_array[i] as Troop
		if troop.selected:
			troops_selected.append(troop)
	print('update World')


func _unhandled_input(event):
	
	#клик по карте при выделенных войсках - вызов метода перемещения
	if event.is_action_pressed("click") and troops_selected.size():
		target_click = get_global_mouse_position()
		$red_point.show_target(target_click)    
	#изменяем состояния войск .....................
	if troops_selected.size() == 1:
		troop = troops_selected[0]
		troop.change_state(troop.State.WALK)
		
		update()	#? нужно ли вызывать



func _physics_process(_delta):
	
	#ПЕРЕМЕЩЕНИЕ ОТРЯДА(ОВ)
	#если выделен один отряд
	if troops_selected.size() == 1:
		troop = troops_selected[0]
		if (troop.state != troop.State.IDLE): 
			Main.troop_move(troop, target_click)
	#если выделены несколько отрядов
	elif troops_selected.size() > 1:
		Main.troops_move(troops_selected, target_click)
	
