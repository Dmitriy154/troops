extends Node
#MAIN главный класс

var world: Node2D
var troopScene = preload("res://scenes/troop/troop.tscn")
var troop_size: int = 44		# размер стороны отряда
var troop_distance: int = 60 	#дистанция между отрядами (между центрами)
var troops_path := Vector2.ZERO

var world_max_size := Vector2(10000, 10000) 	# максимальные границы мира

var game = Game.new()	# создаем экземпляр класса Game

func start(_world):
	world = _world
	game.start_game()
