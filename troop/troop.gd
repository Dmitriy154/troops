extends CharacterBody2D

@export var speed = 100

var target = Vector2.ZERO

func _ready():
	position = Vector2(100, 100)
#	target = position
#   hide()/show() - скрыть/показать текущий экземпляр

func _input(event):
	if event.is_action_pressed("click"):
		target = get_global_mouse_position()
		


func _physics_process(_delta):
			
	if Input.get_axis("ui_left", "ui_right") or Input.get_axis("ui_up", "ui_down"):
		target = Vector2.ZERO
		velocity = Vector2(
			Input.get_axis("ui_left", "ui_right"),
			Input.get_axis("ui_up", "ui_down")
			).normalized() * speed
		move_and_slide()

	if not target == Vector2.ZERO:
		velocity = position.direction_to(target) * speed
		#look_at(target)
		if position.distance_to(target) > 10:
			move_and_slide()


