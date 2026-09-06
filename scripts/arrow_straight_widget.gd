extends MPFWidget

@onready var arrow_animation: AnimatedSprite2D = $ArrowAnimation


var arrow_positions := {
	"red_drop_target": {
		"x": 400.0,
		"y": 1000.0,
		"rotation": -50.0,
		"scale": 1.0
	},

	"left_lock": {
		"x": 525.0,
		"y": 375.0,
		"rotation": -30.0,
		"scale": 1.0
	},

	"left_spinner": {
		"x": 525.0,
		"y": 500.0,
		"rotation": -17.0,
		"scale": 1.0
	},

	"standup_4": {
		"x": 1011.0,
		"y": 600.0,
		"rotation": 15.0,
		"scale": 1.0
	},

	"right_spinner": {
		"x": 1150.0,
		"y": 875.0,
		"rotation": 17.0,
		"scale": 1.0
	},

	"varitarget": {
		"x": 1360.0,
		"y": 1700.0,
		"rotation": 23.0,
		"scale": 1.0
	},

	"right_orbit": {
		"x": 1260.0,
		"y": 1700.0,
		"rotation": 45.0,
		"scale": 1.0
	}
}


func action_update(settings: Dictionary, kwargs: Dictionary = {}) -> void:
	super.action_update(settings, kwargs)

	var tokens: Dictionary = settings.get("tokens", {})
	var arrow_position_name: String = str(tokens.get("arrow_position", ""))

	if arrow_positions.has(arrow_position_name):
		var preset: Dictionary = arrow_positions[arrow_position_name]

		arrow_animation.position = Vector2(
			preset["x"],
			preset["y"]
		)

		arrow_animation.rotation_degrees = preset["rotation"]

		var scale_value: float = preset["scale"]
		arrow_animation.scale = Vector2(scale_value, scale_value)

	arrow_animation.play()
