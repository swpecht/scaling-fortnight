extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal destructable_death
signal attack

var is_reloading = false
export var RELOAD_TIME = 0.5
var RANGE = 50
export var DAMAGE = 10
var cur_reload_time = RELOAD_TIME

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	
	var game_node = get_node('/root/game')
	self.connect("attack", game_node, "_on_attack") 
	

func _process(delta):
	if is_reloading:
		cur_reload_time -= delta
		if cur_reload_time <= 0: reload()
	
	var enemies = get_tree().get_nodes_in_group('enemies')
	for e in enemies:
		var d = get_global_pos().distance_to(e.get_global_pos())
		if d <= RANGE and not is_reloading:
			fire(e)
		
	
	return

func fire(enemy):
	is_reloading = true
	get_node('attack_anim').set_emitting(true)
	emit_signal("attack", self, enemy)
	enemy.health -= DAMAGE

func reload():
	is_reloading = false
	cur_reload_time = RELOAD_TIME

func die():
	emit_signal('destructable_death', get_global_pos())
	queue_free()
