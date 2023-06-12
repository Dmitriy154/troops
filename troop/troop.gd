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

func _physics_process(delta):
	if target == Vector2.ZERO:
		pass
	else:
		velocity = position.direction_to(target) * speed
		if position.distance_to(target) > 5:
			wall_min_slide_angle = 0.1 
			#значение по умолчанию: 0.261799 (в радианах, эквивалентно 15градусам)
			#Это минимальный угол, на который тело может скользить при ударе о склон.
			move_and_slide()
			
			## оптимизировать!!!
			if velocity.length() < speed/5: 
				target = Vector2.ZERO
				velocity = Vector2.ZERO
				selected = false
				change_state(State.IDLE)
				print('отряд прибыл')

		else:
			target = Vector2.ZERO
			velocity = Vector2.ZERO
			selected = false
			change_state(State.IDLE)
			print('отряд прибыл')
			




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


