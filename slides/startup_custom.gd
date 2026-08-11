extends MPFSlide

var ServerStatus = MPF.server.ServerStatus
var events_registered := false


func _ready():
	for c in [
		$CenterContainer/VBoxContainer/status_main,
		$CenterContainer/VBoxContainer/status_sub,
		$CenterContainer/VBoxContainer/error_main,
		$CenterContainer/VBoxContainer/error_sub,
	]:
		c.hide()

	MPF.server.status_changed.connect(self._on_status)

	self._on_status(MPF.server.status)


func _register_loading_events():
	if events_registered:
		return

	events_registered = true

	MPF.server.add_event_handler(
		"loading_assets",
		self._on_loading_assets
	)

	MPF.server.add_event_handler(
		"asset_loading_complete",
		self._on_asset_loading_complete
	)

	print("Startup loading event handlers registered")


func _on_status(new_status):
	var error_node = $CenterContainer/VBoxContainer/error_main
	var status_node = $CenterContainer/VBoxContainer/status_main
	var sub_node = $CenterContainer/VBoxContainer/status_sub

	var target_child: Node
	var message: String

	if new_status == ServerStatus.ERROR:
		target_child = error_node
		message = "Error: Unable to connect to MPF"
		status_node.hide()
		sub_node.hide()

	else:
		target_child = status_node
		error_node.hide()

		match new_status:
			ServerStatus.WAITING:
				message = "Waiting for MPF..."

			ServerStatus.LAUNCHING:
				message = "Launching MPF..."

			ServerStatus.CONNECTED:
				message = "Connected to MPF"

				# MPF is now connected, so register our
				# loading event handlers.
				_register_loading_events()

			ServerStatus.IDLE:
				message = ""

	target_child.text = message
	target_child.show()


func _on_loading_assets(payload: Dictionary):
	var loaded = int(payload.get("loaded", 0))
	var total = int(payload.get("total", 0))
	var remaining = int(payload.get("remaining", 0))

	print(
		"MPF ASSET PROGRESS: ",
		loaded,
		" / ",
		total,
		" remaining=",
		remaining
	)

	$CenterContainer/VBoxContainer/status_main.text = "LOADING GAME DATA"
	$CenterContainer/VBoxContainer/status_sub.text = "%d / %d" % [
		loaded,
		total
	]

	$CenterContainer/VBoxContainer/status_main.show()
	$CenterContainer/VBoxContainer/status_sub.show()


func _on_asset_loading_complete(_payload = {}):
	print("MPF ASSET LOADING COMPLETE")
