extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var path = []

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func get_path(from, to):
	var target_pos = get_node('entities/base').get_pos() 
	var start_pos = get_node('SpawnPosition').get_pos()
	var map_node = get_node("nav/map")
	
	var target_tile = map_node.world_to_map(target_pos)
	var start_tile = map_node.world_to_map(start_pos)
	
	var target_id = grid[target_tile]
	var start_id = grid[start_tile]
	
	var path = astar.get_point_path(start_id, target_id)
	
	for point in path:
		var pos = map_node.map_to_world(Vector2(point.x, point.y))
		draw_circle(pos, 5, Color(1, 0, 0))
	
	pass