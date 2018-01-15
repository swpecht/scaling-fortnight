extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func process(delta, entity):
	if not entity.has_node('velocity'): return
	
	var velocity = entity.get_node('velocity')
	entity.set_pos(entity.get_pos() + velocity.velocity * delta)
	pass


func other():
	#
	# var distance_to_next_path = cur_pos.distance_to(path[0])
	# if distance_to_next_path < 2:
	# 	set_global_pos(path[0])
	# 	path.remove(0)
	pass