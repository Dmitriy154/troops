extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _draw():
	draw_circle(Vector2(0,0), 5, Color(1, 0, 0, 1))
	#draw_line(Vector2(1.5, 1.0), Vector2(150, 400), Color.GREEN, 1.0)



