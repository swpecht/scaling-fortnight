extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var astar
var map_node
var grid

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	astar = AStar.new()
	map_node = get_node('/root/game/nav/map')
	grid = make_nav_grid(astar, map_node)
	pass

func process(delta, entity):
	if not entity.has_node('destination'): return	
	
	var target_pos = entity.get_node('destination').destination
	var cur_pos = entity.get_global_pos()
	var path = get_path(cur_pos, target_pos)
	
	var velocity = entity.get_node('velocity')
	
	if path.size() > 1:
		var next_point = path[0]
		if cur_pos.distance_to(next_point) < velocity.max_speed: next_point = path[1]
		velocity.velocity =  next_point - cur_pos 
	pass
	
	
func make_nav_grid(astar, map):
	var map_size = calculate_tilemap_size(map)
	var grid = {}
	
	# Add points to astar
	for w in range(map_size['width']):
		for r in range(map_size['height']):
			var id = astar.get_available_point_id()
			grid[Vector2(r, w)] = id
			astar.add_point(id, Vector3(r, w, 0))
			pass
	
	# Connect points in astar
	for w in range(map_size['width']):
		for r in range(map_size['height']):
			var center_id = grid[Vector2(r, w)]
			for w_offset in [-1, 0, 1]:
				for r_offset in [-1, 0, 1]:
					var key = Vector2(r+r_offset, w+w_offset)
					if grid.has(key):
						var with_id = grid[key]
						if ((not astar.are_points_connected(center_id, with_id)) and
							with_id != center_id):
							 astar.connect_points(center_id, with_id)
	return grid
	
func calculate_tilemap_size(tilemap):
    # Get list of all positions where there is a tile
    var used_cells = tilemap.get_used_cells()

    # If there are none, return null result
    if used_cells.size() == 0:
        return {x=0, y=0, width=0, height=0}

    # Take first cell as reference
    var min_x = used_cells[0].x
    var min_y = used_cells[0].y
    var max_x = min_x
    var max_y = min_y

    # Find bounds
    for i in range(1, used_cells.size()):

        var pos = used_cells[i]

        if pos.x < min_x:
            min_x = pos.x
        elif pos.x > max_x:
            max_x = pos.x

        if pos.y < min_y:
            min_y = pos.y
        elif pos.y > max_y:
            max_y = pos.y

    # Return resulting bounds
    return {
        x = min_x,
        y = min_y,
        width = max_x - min_x + 1,
        height = max_y - min_y + 1
    }


func get_path(from, to):
	var target_tile = map_node.world_to_map(to)
	var start_tile = map_node.world_to_map(from)
	
	var target_id = grid[target_tile]
	var start_id = grid[start_tile]
	
	var path = astar.get_point_path(start_id, target_id)
	var path_2d = []
	
	# Convert to global coords
	for i in range(path.size()):
		path_2d.append(map_node.map_to_world(Vector2(path[i].x, path[i].y)))
	
	return path_2d