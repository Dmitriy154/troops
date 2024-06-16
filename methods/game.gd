class_name Game
extends Node
# класс игры

static var vector_for_troops := Vector2.ZERO
# если пауза нажатия солюдена, то рисование вектора (1) или отбой (0), (2) - режим ожидания
static var flag_vector_troops:int = 2
static var path_vector := Vector2.ZERO
static var add_col := 0

func start_game():
	add_troops()


func add_troops():
	for i in 25:	
		var troop = Main.troopScene.instantiate()
		troop.position = Vector2(100, 50*i+40)
		Main.world.add_child(troop)
		troop.add_to_group('troops')


static func move_troops(arr, target):
	# 1. находим среднюю точку для всех отрядов
	var avarege_position:Vector2 = Vector2.ZERO
	for i in arr.size():
		avarege_position += arr[i].position
		arr[i].state = 1
		arr[i].change_state(arr[i].state)
		if arr[i].selected: arr[i].remove_select()
	avarege_position /= arr.size()
	

	# 2 найти вектор направления по умолчанию (разность ветора клика и ср. позиции)
	var direction_troop: Vector2 = (target - avarege_position).normalized()

	if path_vector != Vector2.ZERO: # если задается на карте
		direction_troop = path_vector.normalized()
		path_vector = Vector2.ZERO
		
	Test.new('line', [target, target + direction_troop*100], Color.BLUE, 5, 'path_troops', Main.world)
	# 3 перпендиклярный вектор
	var direction_troop_90: Vector2 = direction_troop.orthogonal().normalized()
	
	# 3а в зависимости от перп. вектора (угла) изменяется расстояние между отрядами от 1 до 1.41
	var alfa = direction_troop_90.angle()
	var alfa_45 = abs(wrapf(abs(alfa), 0, PI/2) - PI/4.0) / (PI/4.0) # кратно 45, прямые углы стремятся к 1, 45 к нулю	
	var dist = lerpf(1.2, 1, alfa_45) * Main.troop_distance # расстояние между отрядами, по диагонали увелич. до 1.3

	# 4. поиск всех target, присвоение для каждого отряда и подсветка точек
	var targets: Array = []
	var col:int = ceili(sqrt(arr.size())) + add_col 	#количество колон
	var row:int = floori(arr.size()/col)	#количество заполненных рядов, округляем до низа
	var rest: int = arr.size() - row * col

	var vect: Vector2
	var center_point: Vector2 # точка на оси для каждого ряда

	for i in row:
		center_point = target - direction_troop * dist * i
		
		if (col-1) % 2: 
			center_point += direction_troop_90 * (-0.5) * dist
		
		for j in col: 
			if j%2: #1 3 5
				vect = direction_troop_90 * j * dist
			else:    # 0 2 4
				if j: vect = direction_troop_90 * j *(-1) * dist
				else: vect = Vector2.ZERO # для j=0

			targets.append(center_point + vect)
			Test.new('point', [center_point + vect], Color.BLUE, 5, str(j), Main.world)
			center_point += vect
		
		
	# растановка остатка войск на последней линии
	center_point = target - direction_troop * dist * row
	if (rest-1) % 2: 
		center_point += direction_troop_90 * (-0.5) * dist


	for i in rest:
		if i%2:  vect = direction_troop_90 * i * dist
		else:    # 0 2 4
			if i: vect = direction_troop_90 * i *(-1) * dist
			else: vect = Vector2.ZERO # для i=0 
		targets.append(center_point + vect)
		Test.new('point', [center_point + vect], Color.AQUAMARINE, 5, str(i), Main.world)
		center_point += vect

	# 5. сортируем массив в зависимости от расстояний к target
	var arr_sort = arr
	var new_arr = []
		
	for i in targets.size():
		arr_sort.sort_custom(func(a,b): return targets[i].distance_to(a.position) < targets[i].distance_to(b.position))
		# убираем первый элемент массива
		# Удаляет и возвращает первый элемент массива. Возвращает значение null, если массив пуст
		new_arr.append(arr_sort.pop_front())

	for i in new_arr.size():
		new_arr[i].target = targets[i]
	
	add_col = 0
