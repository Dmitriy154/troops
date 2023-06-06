class_name Troop
extends CharacterBody2D
#TROOP класс войска

# состояния: покой, выбран, прогулка, бег, атака, защита, отступление
enum State {IDLE, WALK, RUN, ATTACK, DEFENSE, RETREAT}

var state := State.IDLE
var selected := false
var active: int = 0		#стадия активности, 1-клик по войску, 2-активно на след. кадр	
var speed: float = 100
var health: float = 100:
	set(x): health = clamp(x,0,100)


var target := Vector2.ZERO
#ссылка на картинку - изменим Resource
@onready var sprite2d = $Sprite2D		

func _ready():
	pass
	

func change_state(new_state: State):
	state = new_state
	update_troop()

func update_troop():
	print('update troop')
	match state:
		State.IDLE:
			if(!selected): 
				$fon.hide()
			else:
				$fon.show()
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
			
	get_parent().update()


func _physics_process(_delta):
	pass


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		print('click troop')
		selected = true
		update_troop()


func death():
	pass
	#смерть отряда, удаляем экз-р  queue_free()


