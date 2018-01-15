extends Area2D


var SPEED = 100
onready var target_pos = get_node('/root/game/entities/base').get_global_pos()
var path = []
onready var nav = get_node('/root/game/nav')
var action_state = ACTION.Moving
var cur_target = null

onready var attack = get_node("./attack")

enum ACTION {
	Moving,
	Attacking
}

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var cur_pos = get_global_pos()
	add_to_group('enemies', true)
	set_process(true)


	
func _process(delta):

	if action_state == ACTION.Moving:
		move(delta)
	elif action_state == ACTION.Attacking:
		attack(delta)
		

func attack(delta):
	attack.try_attack(cur_target)
	pass
	
func move(delta):
	if path.size() == 0: return # no where to go
	
	var cur_pos = get_global_pos()

	var distance_to_next_path = cur_pos.distance_to(path[0])
	if distance_to_next_path < 2:
		set_global_pos(path[0])
		path.remove(0)
	else:
		set_global_pos(cur_pos.linear_interpolate(path[0], (SPEED * delta)/distance_to_next_path))


func _on_enemy_area_enter( area ):
	if area.is_in_group('towers'):
		action_state = ACTION.Attacking
		cur_target = area
	pass


func _on_enemy_area_exit( area ):
	if area.is_in_group('towers'):
		action_state = ACTION.Moving
		cur_target = null
	pass
