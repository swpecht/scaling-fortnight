extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal destructable_death

var is_reloading = false
var RELOAD_TIME = 1
var RANGE = 50
var cur_reload_time = RELOAD_TIME

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	
	var game_node = get_node('/root/game')
	connect('destructable_death', game_node, 'on_destructable_death')

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
	get_node('particles_fire').set_emitting(true)
	enemy.queue_free()

func reload():
	is_reloading = false
	cur_reload_time = RELOAD_TIME

func die():
	emit_signal('destructable_death', get_global_pos())
	queue_free()

