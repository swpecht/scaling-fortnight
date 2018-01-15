extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var systems = []
onready var map = get_node('nav/map')

# Tutorial: https://www.youtube.com/watch?v=KU1PslMiZ98
func _ready():
	
	# setup systems
	add_system('res://systems/movement.tscn')
	add_system('res://systems/navigation.tscn')
	
	set_process_input(true)
	set_process(true)
		
	var enemy_spawn = preload('res://enemy_spawn.tscn') # will load when parsing the script
	var enemy_spawn_node = enemy_spawn.instance()
	enemy_spawn_node.set_global_pos(get_node('SpawnPosition').get_global_pos())
	add_child(enemy_spawn_node)
	

func add_system(path):
	var s = load(path).instance()
	add_child(s)
	systems.append(s)

func _process(delta):
	
	# Run all systems
	for s in systems:
		for e in get_node('entities').get_children():
			s.process(delta, e)

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
	
	
