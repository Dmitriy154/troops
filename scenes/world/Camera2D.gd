extends Camera2D

var min_zoom = Vector2(0.4, 0.4)
var max_zoom = Vector2(4, 4)
var target_zoom := Vector2.ONE
var zoom_old: Vector2
var speed := 5
var speed_drag := 9

var drag := false
var drag_point := Vector2.ZERO # точка относительно которой делается сдвиг
var drag_zoom := Vector2.ZERO # точка сдвига камеры при zoom
var factor: float = 0
var target_position: Vector2


func _process(delta):
	# плавный сдвиг
	if drag: 
		if position.distance_to(target_position) > 1:
			position = lerp(position, target_position, delta * speed_drag)
		else:
			drag = false
	
			
	#zoom плавный
	if zoom == target_zoom: return
	if zoom.distance_to(target_zoom) > 0.002:
		zoom_old = zoom
		zoom = lerp(zoom, target_zoom, delta * speed)
		factor = (zoom.x/zoom_old.x)
		position = position + (drag_point - position)*(1-1/factor) # дергается на рабочем компе
		#Test.new('line', [drag_point, (drag_point - position)*(1-1/factor)], Color.GREEN_YELLOW, 5, '', self)
		Test.new('point', [drag_point], Color.RED, 3, '', Main.world)
		drag = false
		target_position = position
	else:
		zoom = target_zoom


func start_zoom():
	if (target_zoom * factor > max_zoom or target_zoom*factor < min_zoom): return
	target_zoom = clamp(target_zoom*factor, min_zoom, max_zoom)
	drag_zoom  = (drag_point - position)*(1-1/factor) 
