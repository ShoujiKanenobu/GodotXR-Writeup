# Resources
# https://docs.godotengine.org/en/stable/classes/class_webxrinterface.html#description
# https://www.snopekgames.com/tutorial/2023/how-make-vr-game-webxr-godot-4

extends Node3D

var webxr_interface
@onready var environment : Environment = $WorldEnvironment.environment

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/Button.pressed.connect(self._on_button_pressed)
	webxr_interface = XRServer.find_interface("WebXR")
	
	if webxr_interface:
		webxr_interface.session_supported.connect(self._webxr_session_supported)
		webxr_interface.session_started.connect(self._webxr_session_started)
		webxr_interface.session_ended.connect(self._webxr_session_ended)
		webxr_interface.session_failed.connect(self._webxr_session_failed)
		
		webxr_interface.is_session_supported("immersive-ar")

func _webxr_session_supported(session_mode: String, supported: bool) -> void:
	if session_mode == 'immersive-ar':
		if supported:
			$CanvasLayer.visible = true
			$CanvasLayer2.visible = false
		else:
			OS.alert("Your Browser doesn't support AR")

func _on_button_pressed() -> void:
	webxr_interface.session_mode = 'immersive-ar'
	webxr_interface.requested_reference_space_types = 'bounded-floor, local-floor, local'
	webxr_interface.required_features = 'local-floor'
	webxr_interface.optional_features = 'bounded-floor'
	if not webxr_interface.initialize():
		OS.alert("Failed to initialize WebXR")
		return
		
func _webxr_session_started() -> void:
	$CanvasLayer/Button.visible = false
	$CanvasLayer2.visible = true
	get_viewport().use_xr = true
	get_viewport().transparent_bg = true
	enable_passthrough()
	
	
func _webxr_session_ended() -> void:
	$CanvasLayer/Button.visible = true
	$CanvasLayer2.visible = false
	get_viewport().use_xr = false
	# There is a bug here where cleanup isn't properly done, so if you try to re enter xr mode it
	# is just a black screen
	
func _webxr_session_failed(message: String) -> void:
	OS.alert("Failed to initialize: " + message)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func enable_passthrough() -> bool:
	var xr_interface: XRInterface = XRServer.primary_interface
	if xr_interface and xr_interface.is_passthrough_supported():
		if !xr_interface.start_passthrough():
			return false
	else:
		var modes = xr_interface.get_supported_environment_blend_modes()
		if xr_interface.XR_ENV_BLEND_MODE_ALPHA_BLEND in modes:
			xr_interface.set_environment_blend_mode(xr_interface.XR_ENV_BLEND_MODE_ALPHA_BLEND)
		else:
			return false
	get_viewport().transparent_bg = true
	return true
