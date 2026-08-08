extends MPFWidget

@onready var award_video: MPFVideoPlayer = $WidgetLayout/AwardVideo


func action_update(settings: Dictionary, kwargs: Dictionary = {}) -> void:
	# Preserve GMC's normal update behavior.
	# This keeps PopupLabel working with award_text.
	super.action_update(settings, kwargs)

	var tokens: Dictionary = settings.get("tokens", {})
	var video_name: String = str(tokens.get("award_video", ""))

	# If this popup has no video token, leave the video blank.
	if video_name.is_empty():
		award_video.stop()
		award_video.stream = null
		return

	var video_path := "res://videos/%s.ogv" % video_name

	if not ResourceLoader.exists(video_path):
		push_warning("Award popup video not found: %s" % video_path)
		award_video.stop()
		award_video.stream = null
		return

	award_video.stream = load(video_path)
	award_video.play()
