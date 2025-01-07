extends Area2D
class_name Character


signal on_health_change
signal on_die(character: Area2D)

@export var hit_particles : PackedScene
@export var combat_actions : Array[CombatAction]
@export var oponnent : Area2D
@export var is_player : bool
@export var character : Area2D
@export var current_health : int = 25
@export var max_health : int = 25
@export var attack_speed : int = 2500

var start_position : Vector2
var attack_oponent : bool
var current_combat_action : CombatAction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = global_position
	get_parent().connect("on_begin_turn", on_character_begin_turn)


func heal(p_amount : int) -> void:
	# different from the instructor, instead of using conditionals I used clamp function
	current_health = clamp(current_health + p_amount, 0, max_health)
	emit_signal("on_health_change")


func take_damage(p_amount : int) -> void:
	var hit_particles_instance : CPUParticles2D = hit_particles.instantiate()
	get_parent().add_child(hit_particles_instance)
	hit_particles_instance.position = position
	hit_particles_instance.emitting = true
	
	# different from the instructor, instead of using conditionals I used clamp function
	current_health = clamp(current_health - p_amount, 0, max_health)
	emit_signal("on_health_change")
	if current_health <= 0:
		die()


func _process(delta: float) -> void:	
	if attack_oponent:
		global_position = global_position.move_toward(oponnent.global_position, delta * attack_speed)

	if !attack_oponent:
		global_position = global_position.move_toward(start_position, delta * attack_speed * 0.75)

	if get_parent().game_over:
		return

	if attack_oponent and global_position == oponnent.global_position:
		attack_oponent = false
		oponnent.take_damage(current_combat_action.damage)
		get_parent().end_turn()


func cast_combat_action(p_combat_action : CombatAction) -> void:
	current_combat_action = p_combat_action
	if current_combat_action.damage	> 0:
		attack_oponent = true
	elif current_combat_action.projectile_scene != null:
		var projectile_instance: Sprite2D = current_combat_action.projectile_scene.instantiate()
		projectile_instance.initialize(oponnent, get_parent().end_turn)
		get_parent().add_child(projectile_instance)
		projectile_instance.position = position
		projectile_instance.position = position
	elif current_combat_action.heal_amount > 0:
		heal(current_combat_action.heal_amount)
		get_parent().end_turn()


func on_character_begin_turn(p_character : Character) -> void:
	if character == p_character and not p_character.is_player:
		determine_combat_action()


func determine_combat_action() -> void:
	var health_percentage : float = get_health_percentage()
	var want_to_heal : bool = false
	var assigned_combat_action : CombatAction
	
	if health_percentage <= 35:
		var random_int = randi() % 3
		want_to_heal =  random_int == 0

	if want_to_heal and has_combat_action_of_type(CombatAction.Type.HEAL):
		assigned_combat_action = get_combat_action_of_type(CombatAction.Type.HEAL)
	elif has_combat_action_of_type(CombatAction.Type.ATTACK):
		assigned_combat_action = get_combat_action_of_type(CombatAction.Type.ATTACK)

	if assigned_combat_action:
		cast_combat_action(assigned_combat_action)
	else:
		get_parent().end_turn()


func get_health_percentage() -> float:
	return (float(current_health) / float(max_health)) * 100


func has_combat_action_of_type(type: CombatAction.Type) -> bool:
	for i_combat_action: CombatAction in (character as Character).combat_actions:
		if i_combat_action.action_type == type:
			return true

	return false


func get_combat_action_of_type(type: CombatAction.Type) -> CombatAction:
	var available_actions = combat_actions.filter(func(ca): return ca.action_type == type)
	return available_actions[randi_range(0, available_actions.size()-1)]


func die() -> void:
	(get_parent() as TurnManager).game_over = true
	queue_free()
