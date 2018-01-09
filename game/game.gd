extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var map = get_node('nav/map')
onready var astar = AStar.new()
var grid

# Tutorial: https://www.youtube.com/watch?v=KU1PslMiZ98
func _ready():
	
	set_process_input(true)
	
	make_nav_grid(astar, map)
		
	var enemy_spawn = preload('res://enemy_spawn.tscn') # will load when parsing the script
	var enemy_spawn_node = enemy_spawn.instance()
	enemy_spawn_node.set_global_pos(get_node('SpawnPosition').get_global_pos())
	add_child(enemy_spawn_node)

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
			for w_offset in [-1, 1]:
				for r_offset in [-1, 1]:
					var key = Vector2(w+w_offset, r+r_offset)
					if grid.has(key):
						astar.connect_points(center_id, grid[key])
			
	
	pass
	
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


func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON and event.pressed:
		var tile = map.world_to_map(event.pos)
		spawn_cannon(tile)
		
func spawn_cannon(tile):
	var cannon = preload('res://cannon.tscn')
	var cannon_node = cannon.instance()
	var cannon_pos = map.map_to_world(Vector2(tile.x, tile.y))
	cannon_node.set_global_pos(cannon_pos)
	cannon_node.connect('destructable_death', self, 'on_destructable_death')
	add_child(cannon_node)

func _on_attack(attacker, target):
	var target_health = target.find_node('health')
	if target_health == null: return # no action required
	target_health.health -= attacker.DAMAGE
	pass

func on_destructable_death(pos):
	# replace with ground tile
	pass