class_name Fireball extends Sprite2D


signal hit_callback

@export var damage : int = 3
@export var speed : float = 1400

var _target : Area2D


func initialize(p_target : Area2D, p_on_hit_callback : Callable) -> void:
	_target = p_target
	hit_callback.connect(p_on_hit_callback)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not _target:
		return

	global_position = global_position.move_toward(_target.global_position, speed * delta)
	
	if global_position == _target.global_position:
		(_target as Character).take_damage(damage)
		emit_signal("hit_callback")
		queue_free()
