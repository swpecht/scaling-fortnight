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

	