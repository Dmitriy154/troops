class_name Troop
extends CharacterBody2D
#TROOP класс войска

# состояния: активно (выделено), покой, прогулка, бег, атака, защита, отступление
enum State {idle=0, walk=1, run=2, attack=3, defense=4, retreat=5}

var state = State.idle
var active: int = 0	#стадия активности, 1-клик по войску, 2-активно на след. кадр	
var speed: float = 100
var health: float = 100:
	set(x): health = clamp(x,0,100)


var target := Vector2.ZERO
#ссылка на картинку - изменим Resource
@onready var sprite2d = $Sprite2D		

func _ready():
	pass

func _physics_process(_delta):
	# если войско выделено щелчком, добавить условие - ждем второго щелчка!
	if active == 2:
		# ДВИЖЕНИЕ ПО КЛИКУ МЫШИ / если клик был внутри войска то return???
		if not target == Vector2.ZERO:
			velocity = position.direction_to(target) * speed
			if position.distance_to(target) > 5:
				move_and_slide()
			else:
				active = 0
				$fon.hide()

		
func _unhandled_input(event):
	if event.is_action_pressed("click"):
		target = get_global_mouse_position()
		if active == 1: active = 2
	

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		active = 1
		$fon.show()


func death():
	pass
	#смерть отряда, удаляем экз-р  queue_free()


