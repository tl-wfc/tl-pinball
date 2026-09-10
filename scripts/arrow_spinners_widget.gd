extends MPFWidget


@onready var left_spinner_arrow: AnimatedSprite2D = $LeftSpinnerArrow
@onready var right_spinner_arrow: AnimatedSprite2D = $RightSpinnerArrow


func _ready() -> void:
	left_spinner_arrow.play("grow")
	right_spinner_arrow.play("grow")
