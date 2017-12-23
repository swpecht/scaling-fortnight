extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var map = get_node('nav/map')

# Tutorial: https://www.youtube.com/watch?v=KU1PslMiZ98
func _ready():
	set_process_input(true)
	
	var base = preload("res://base.tscn")
	var base_node = base.instance()
	base_node.set_global_pos(get_node('BasePosition').get_global_pos())
	add_child(base_node)
		
	var enemy_spawn = preload('res://enemy_spawn.tscn') # will load when parsing the script
	var enemy_spawn_node = enemy_spawn.instance()
	enemy_spawn_node.set_global_pos(get_node('SpawnPosition').get_global_pos())
	add_child(enemy_spawn_node)
	
func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON and event.pressed:
		var tile = map.world_to_map(event.pos)
		spawn_cannon(tile)
		
func spawn_cannon(tile):
	map.set_cell(tile.x, tile.y, 2)
	var cannon = preload('res://cannon.tscn')
	var cannon_node = cannon.instance()
	var cannon_pos = map.map_to_world(Vector2(tile.x, tile.y))
	cannon_node.set_global_pos(cannon_pos)
	add_child(cannon_node)
	
func on_destructable_death(pos):
	# replace with ground tile
	var tile = map.world_to_map(pos)
	map.set_cell(tile.x, tile.y, 0)