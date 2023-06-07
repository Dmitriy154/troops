class_name World
extends Node2D

var troop: Troop
var troops_array: Array[Troop] = []
var troops_selected: Array[Troop] = []
var target_click: Vector2

@onready var troopScene = load("res://troop/troop.tscn")

func _ready():
	Events.updateTroop.connect(update)  #регистрируем слушатель, который принимает сигнал о вызове экз-ром troop метода update_troop
	#добавляем на сцену отряды
	for i in 2:
		troop = troopScene.instantiate()
		troop.position = Vector2(50, 70*i+50)
		troops_array.append(troop as Troop)
		add_child(troop)

#обновление состояний и событий в игре, клик мыши по новому месту
func update():
	#перебираем массив отрядов и ищем те, у которых состояние SELECTED
	troops_selected.clear()
	for i in troops_array.size():
		troop = troops_array[i] as Troop
		if troop.selected:
			troops_selected.append(troop)
	#print(troops_selected.size())


func _unhandled_input(event):
	if event.is_action_pressed("click") and troops_selected.size() >=1: 
		target_click = get_global_mouse_position()
		$red_point.show()    
		$red_point.position = get_global_mouse_position()

		print('clickWorld')
		
		if troops_selected.size() == 1:
			troop = troops_selected[0]
			troop.state = troop.State.WALK
			Main.troop_move(troop, target_click)
		
		await get_tree().create_timer(1).timeout # ждем секунду
		$red_point.hide()
		
		


func _physics_process(_delta):
	
	#ПЕРЕМЕЩЕНИЕ ОТРЯДА(ОВ)
	#если выделен один отряд
	if troops_selected.size() == 1:
		troop = troops_selected[0]
		if (troop.state != troop.State.IDLE): 
			Main.troop_move(troops_selected[0] as Troop, target_click)
	#если выделены несколько отрядов
	if troops_selected.size() > 1:
		Main.troops_move(troops_selected, target_click)
	
