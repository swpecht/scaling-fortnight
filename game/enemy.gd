extends Area2D



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
	
	get_node('destination').destination = get_node('/root/game/entities/base').get_global_pos()
	
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
	pass


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
