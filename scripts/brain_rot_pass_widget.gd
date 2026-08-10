extends MPFWidget

func _ready() -> void:
	if animation_player:
		animation_player.play("pass_shiver")
