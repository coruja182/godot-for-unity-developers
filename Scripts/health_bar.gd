class_name HealthBar extends Control

@onready var _progress_bar: ProgressBar = $ProgressBar
@onready var _label: Label = $ProgressBar/Label
@onready var _character: Character = $".."


func _ready() -> void:
	_character.connect("on_health_change", on_update_health)
	on_update_health()


func on_update_health() -> void:
	_progress_bar.value = _character.get_health_percentage()
	_label.text = "%s / %s" % [_character.current_health, _character.max_health]
