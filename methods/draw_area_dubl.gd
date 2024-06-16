class_name Draw_area_dubl
extends Node2D
# рисует места растановки отрядов

var node_parent:Node2D
var rect: Rect2
var width : int = 6
var color : Color = Color(Color.RED, 0.2)

var time_hide := 1.4


func _init(parent, pos1, pos2, _rect, alfa):
	node_parent = Node2D.new()
	parent.add_child(node_parent)
	rect = _rect
	node_parent.add_child(self)
	node_parent.position = pos1
	position = pos2
	node_parent.rotation = alfa
	await get_tree().create_timer(time_hide).timeout
	# сделать анимацию исчеезновения get_tree().create ////
	var tween = get_tree().create_tween()
	tween.tween_property(self, "color", Color(Color.RED, 0), 1)
	tween.tween_callback(queue_free)
	#queue_free()


func _process(_delta):
	queue_redraw()


func _draw():
	draw_rect(rect, color, true)	
