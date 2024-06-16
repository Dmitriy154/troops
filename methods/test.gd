class_name Test
extends Node2D

var obj = 'line'	# circle, string ....
var color := Color.RED
var width := 10
var text := ''
var pos_arr: Array = []
var _font = ThemeDB.fallback_font
var _font_size = ThemeDB.fallback_font_size

func _init(object: String, pos: Array, col: Color, _width: int, txt: String, parent: Node2D):
	obj = object
	pos_arr = pos
	color = col
	width =  _width
	text = txt
	parent.add_child(self)
	
func set_font(font, size):
	if font != '': _font = font
	_font_size = size

func _draw():
	if obj == "line":
		draw_line(pos_arr[0], pos_arr[1], color, width)
		if text != '':
			var pos = 0.5*(pos_arr[0]+pos_arr[1]) - Vector2(0, width + 30)
			var rot = (pos_arr[1]-pos_arr[0]).angle()
			create_label(pos, rot)
			#draw_string(_font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, _font_size)	
	elif obj == 'point':
		draw_circle(pos_arr[0], width, color)
		if text != '':
			create_label(pos_arr[0] - Vector2(3*width, 3*width), 0)
	elif obj == "rect":
		var rect = Rect2(pos_arr[0],pos_arr[1])
		draw_rect(rect, color, false, width)		

	await get_tree().create_timer(5).timeout
	queue_free()


func create_label(pos: Vector2, rot: float):
	var label = Label.new()
	label.position = pos
	label.rotation = rot
	label.text = text
	add_child(label)




