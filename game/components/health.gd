extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var health = 10 setget set_health
const scn_death_animation = preload('res://enemy_death.tscn')

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func set_health(new_health):
	health = new_health
	if health <= 0:
		var death_anim = scn_death_animation.instance()
		death_anim.set_pos(get_parent().get_pos())
		var game_node = get_node('/root/game')
		game_node.add_child(death_anim)
		get_parent().queue_free()