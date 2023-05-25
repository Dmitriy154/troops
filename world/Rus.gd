extends CharacterBody2D

const speed = 300.0

var target = Vector2.ZERO

func _input(event):
	if event.is_action_pressed("click"):
		target = get_global_mouse_position()

func _physics_process(_delta):
	velocity = position.direction_to(target) * speed
	if position.distance_to(target) > 10:
		move_and_slide()


