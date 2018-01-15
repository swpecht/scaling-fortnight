extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var velocity = Vector2(-10, 0) setget set_velocity
export var max_speed = 20


func set_velocity(v):
	if v.length() > max_speed: v = v / v.length() * max_speed
	velocity = v
	pass

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
