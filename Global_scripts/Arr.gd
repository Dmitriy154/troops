extends Node
#МАССИВЫ

var troops: Array[Troop] = []			# отряды
var tr_sel: Array[Troop] = []		# выделенные отряды
var tr_move: Array[Troop] = [] 		# движущиеся выделенные отряды ("WALK" и "RUN", "Attack", "Retreat")

#наполняем массив fill_arr_tr_sel проверяя свойство selected
func fill_tr_sel():
	tr_sel.clear()
	for i in Arr.troops.size():
		if Arr.troops[i].selected == true:
			tr_sel.append(Arr.troops[i])


#устанавливаем точку сбора для отрядов (для нескольких отрядов - разные точки!) и изменяем state
func set_target_arr(arr:Array[Troop], target:Vector2):
	for i in arr.size():
		arr[i].target = target
		arr[i].change_state(1)	#изменяем состояние на WALK (а если отряд в бою???)

