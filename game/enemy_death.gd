extends Particles2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_emitting(true)
	pass


func _on_Timer_timeout():
	queue_free()
