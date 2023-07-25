class_name Troop
extends CharacterBody2D
#TROOP класс войска

signal Update_troop


# состояния: покой, выбран, прогулка, бег, атака, защита, отступление
enum State {IDLE, WALK, RUN, ATTACK, DEFENSE, RETREAT}

var state := State.IDLE
var selected := false

var speed: float = 100
var health: float = 100:
	set(x): health = clamp(x,0,100)

#ссылка на картинку - изменим Resource
@onready var sprite2d = $Sprite2D		


func change_state(new_state: State):
	state = new_state
	update_troop()


func update_troop():
	print('update troop')
	match state:
		State.IDLE:
			print('IDLE')
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

#	Events.updateTroop.emit()


func death():
	pass
	#смерть отряда, удаляем экз-р  queue_free()


