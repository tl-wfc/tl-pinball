extends MPFWidget

func _ready() -> void:
	if animation_player:
		animation_player.play("mode_title_pulse")
