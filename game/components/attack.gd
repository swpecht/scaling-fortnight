extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal attack
export var RELOAD_TIME = 0.5
var is_reloading = false
export var DAMAGE = 10
var cur_reload_time = RELOAD_TIME


func _ready():
	var game_node = get_node('/root/game')
	self.connect("attack", game_node, "_on_attack")
	
	set_process(true)
	pass
	
func _process(delta):
	if is_reloading:
		cur_reload_time -= delta
		if cur_reload_time <= 0: reload()
	
func try_attack(target):
	if is_reloading: return
	
	is_reloading = true
	# get_node('../attack_anim').set_emitting(true)
	emit_signal("attack", self, target)

func reload():
	is_reloading = false
	cur_reload_time = RELOAD_TIME
