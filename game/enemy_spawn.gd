extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var enemy_scene

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	enemy_scene = preload("res://enemy.tscn")
	spawn_enemy() # spawn an initial enemy

func spawn_enemy():
	var enemy_node = enemy_scene.instance()
	var game_node = get_node('/root/game/entities')
	
	var spawn_pos = get_global_pos()
	spawn_pos += Vector2(rand_range(-50, 50), rand_range(-50, 50))
	enemy_node.set_global_pos(spawn_pos)
	
	game_node.add_child(enemy_node)


func _on_Timer_timeout():
	for i in range(rand_range(1, 10)):
		spawn_enemy()
