extends MPFWidget


@onready var timer_label: Label = \
	$CenterContainer/VBoxContainer/PulseHolder/PulseNode/PopupLabel


var stage2_time: int = 180


func _ready() -> void:
	_refresh_from_mpf()


func _process(_delta: float) -> void:
	_refresh_from_mpf()


func _refresh_from_mpf() -> void:

	if MPF.game.player.has("obey_obey_stage2_timer_tick"):
		stage2_time = int(
			MPF.game.player["obey_obey_stage2_timer_tick"]
		)

	timer_label.text = "TIME %d" % stage2_time
