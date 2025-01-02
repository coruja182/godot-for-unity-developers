extends Control
class_name UI

# used to show / hide container
@onready var container: ColorRect = $Background/CombatActionsList

# here I did differently then the instructor
# I don't need to export a container and re-add all the 4 combat actions slots
# I can get that is already defined in the container and get the children list
@onready var combat_action_buttons_container: VBoxContainer = $Background/CombatActionsList/MarginContainer/VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect("on_begin_turn", on_begin_turn)
	get_parent().connect("on_end_turn", on_end_turn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_begin_turn(character: Area2D) -> void:
	if !character.is_player:
		return

	for i in range(combat_action_buttons_container.get_children().size()):
		if i < character.combat_actions.size():
			var combat_action_buttons = combat_action_buttons_container.get_children()
			var i_combat_action_button : Button = combat_action_buttons[i]
			var i_combat_action : CombatAction = character.combat_actions[i]
			i_combat_action_button.text = i_combat_action.display_name
			i_combat_action_button.show()
			
			if i_combat_action_button.is_connected("pressed", on_click_combat_action.bind(i_combat_action)):
				i_combat_action_button.disconnect("pressed", on_click_combat_action.bind(i_combat_action))
				
			i_combat_action_button.connect("pressed", on_click_combat_action.bind(i_combat_action))

		else:
			combat_action_buttons_container.get_children()[i].hide()

	container.show()


func on_end_turn(_character : Area2D) -> void:
	container.hide()


func on_click_combat_action(combat_action : CombatAction) -> void:
	((get_parent() as TurnManager).current_character as Character).cast_combat_action(combat_action)
