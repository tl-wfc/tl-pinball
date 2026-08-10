extends MPFWidget

@onready var awareness_bar: ProgressBar = $CenterContainer/VBoxContainer/AwarenessBar


func _ready() -> void:
	MPF.game.player_update.connect(_on_player_update)

	# Set initial value in case the widget appears after Awareness
	# has already progressed.
	if MPF.game.player.has("awareness_percent"):
		awareness_bar.value = float(MPF.game.player["awareness_percent"])


func _on_player_update(variable_name: String, value: Variant) -> void:
	if variable_name != "awareness_percent":
		return

	awareness_bar.value = float(value)
