extends MPFWidget


@onready var left_progress_bar: ProgressBar = \
	$CenterContainer/VBoxContainer/SpinnersHBox/LeftVBox/LeftProgressBar

@onready var right_progress_bar: ProgressBar = \
	$CenterContainer/VBoxContainer/SpinnersHBox/RightVBox/RightProgressBar

@onready var left_progress_text: Label = \
	$CenterContainer/VBoxContainer/SpinnersHBox/LeftVBox/LeftProgressBar/LeftProgressText

@onready var right_progress_text: Label = \
	$CenterContainer/VBoxContainer/SpinnersHBox/RightVBox/RightProgressBar/RightProgressText

@onready var timer_label: Label = \
	$CenterContainer/VBoxContainer/TimerLabel


var left_spins: int = 0
var right_spins: int = 0
var spinner_goal: int = 25
var stage1_time: int = 0


func _ready() -> void:
	_refresh_from_mpf()


func _process(_delta: float) -> void:
	_refresh_from_mpf()


func _refresh_from_mpf() -> void:

	if MPF.game.player.has("obey_spinner_goal"):
		spinner_goal = int(
			MPF.game.player["obey_spinner_goal"]
		)

	if MPF.game.player.has("obey_left_spins"):
		left_spins = int(
			MPF.game.player["obey_left_spins"]
		)

	if MPF.game.player.has("obey_right_spins"):
		right_spins = int(
			MPF.game.player["obey_right_spins"]
		)

	if MPF.game.player.has("obey_obey_stage1_timer_tick"):
		stage1_time = int(
			MPF.game.player["obey_obey_stage1_timer_tick"]
		)


	# ------------------------------------------------------
	# BAR LIMITS
	# ------------------------------------------------------

	left_progress_bar.min_value = 0
	right_progress_bar.min_value = 0

	left_progress_bar.max_value = spinner_goal
	right_progress_bar.max_value = spinner_goal


	# ------------------------------------------------------
	# BAR VALUES
	# ------------------------------------------------------

	left_progress_bar.value = min(
		left_spins,
		spinner_goal
	)

	right_progress_bar.value = min(
		right_spins,
		spinner_goal
	)


	# ------------------------------------------------------
	# LEFT DISPLAY
	# ------------------------------------------------------

	if left_spins >= spinner_goal:
		left_progress_text.text = "COMPLETE"
	else:
		left_progress_text.text = "%d / %d" % [
			left_spins,
			spinner_goal
		]


	# ------------------------------------------------------
	# RIGHT DISPLAY
	# ------------------------------------------------------

	if right_spins >= spinner_goal:
		right_progress_text.text = "COMPLETE"
	else:
		right_progress_text.text = "%d / %d" % [
			right_spins,
			spinner_goal
		]


	# ------------------------------------------------------
	# TIMER DISPLAY
	# ------------------------------------------------------

	timer_label.text = "TIME %d" % stage1_time
