extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var SPEED = 100
onready var target_pos = get_node('/root/game/base').get_global_pos()
var path = []
onready var nav = get_node('/root/game/nav')


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var cur_pos = get_global_pos()
	path = nav.get_simple_path(cur_pos, target_pos)
	add_to_group('enemies', true)
	set_process(true)

func inflict_damange(dmg_amount):
	# do this with health scene so can add it to others?
	pass
	
func _process(delta):
	
	if path.size() == 0: return # no where to go
	
	var cur_pos = get_global_pos()

	var distance_to_next_path = cur_pos.distance_to(path[0])
	if distance_to_next_path < 2:
		set_global_pos(path[0])
		path.remove(0)
	else:
		set_global_pos(cur_pos.linear_interpolate(path[0], (SPEED * delta)/distance_to_next_path))