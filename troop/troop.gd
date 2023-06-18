class_name Troop
extends CharacterBody2D
#TROOP класс войска

signal Update_troop


# состояния: покой, выбран, прогулка, бег, атака, защита, отступление
enum State {IDLE, WALK, RUN, ATTACK, DEFENSE, RETREAT}

var state := State.IDLE
var selected := false
var target: Vector2

var speed: float = 100
var health: float = 100:
	set(x): health = clamp(x,0,100)

#ссылка на картинку - изменим Resource
@onready var sprite2d = $Sprite2D		

func _ready():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING 
	#Применяется, когда нет понятия пола или потолка. Обо всех столкновениях сообщается как on_wall. 
	#В этом режиме, когда вы скользите, скорость всегда будет постоянной. Этот режим подходит для игр сверху вниз.

func _physics_process(_delta):	
	if target == Vector2.ZERO:
		pass
	else:
		velocity = position.direction_to(target) * speed
		
		if position.distance_to(target) > 5:
<<<<<<< HEAD
			wall_min_slide_angle = 0.1
			#мин. угол, на кот. тело может скользить при ударе о склон: 0.261799 (в рад. или 15град)
			
			#округление до сотых
			$Debug1.text = str("%10.2f" % get_real_velocity().length())
#			$Debug2.text = str("%10.2f" % get_position_delta().length())
#			$Debug3.text = str(get_position_delta())
			
			if move_and_slide():
#				await get_tree().create_timer(randf_range(0.1, 1.5)).timeout		
				if (get_real_velocity().length() < 0.5*speed): 
					#можно сделать паузу
					target = Vector2.ZERO
					velocity = Vector2.ZERO
					selected = false
					change_state(State.IDLE)
					print('отряд прибыл')
					
=======
			print(get_real_velocity().length())
			wall_min_slide_angle = 0.1
			#мин. угол, на кот. тело может скользить при ударе о склон: 0.261799 (в рад. или 15град)
			
			#округление до сотых
			$Debug1.text = str("%10.2f" % get_real_velocity().length())
			$Debug2.text = str("%10.2f" % get_position_delta().length())
			$Debug3.text = str(get_position_delta())
			
			if move_and_slide():
				speed -= 1


>>>>>>> 92f723af622493a914a6d7d627d4eec55f569de3
		else:
			target = Vector2.ZERO
			velocity = Vector2.ZERO
			selected = false
			change_state(State.IDLE)
			print('отряд прибыл')
			

<<<<<<< HEAD

=======
>>>>>>> 92f723af622493a914a6d7d627d4eec55f569de3
func change_state(new_state: State):
	state = new_state
	update_troop()

func update_troop():
	print('update troop')
	match state:
		State.IDLE:
			pass
		State.WALK:
			pass
		State.RUN:
			pass
		State.ATTACK:
			pass
		State.RETREAT:
			pass
		_:
			print('default')
	
	if (selected): $fon.show()
	else: $fon.hide()

	Events.updateTroop.emit()


func death():
	pass
	#смерть отряда, удаляем экз-р  queue_free()


