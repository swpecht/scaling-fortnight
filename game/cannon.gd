extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal destructable_death

var RANGE = 50
onready var attack = get_node("./attack")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	add_to_group('towers')
	set_process(true)
	

func _process(delta):
	
	var enemies = get_tree().get_nodes_in_group('enemies')
	for e in enemies:
		var d = get_global_pos().distance_to(e.get_global_pos())
		if d <= RANGE:
			attack.try_attack(e)
		
	
	return

func die():
	emit_signal('destructable_death', get_global_pos())
	queue_free()
