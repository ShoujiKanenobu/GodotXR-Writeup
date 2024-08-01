extends MeshInstance3D

var index = 1;
# Called when the node enters the scene tree for the first time.
func _ready():
	$"../CanvasLayer2/Control/Button".pressed.connect(self._on_button_pressed)
	_setMeshByIndex()
	pass # Replace with function body.


func _on_button_pressed():
	index = index + 1
	if index > 3:
		index = 1
	_setMeshByIndex()
	pass

func _setMeshByIndex():
	var nextMesh = MeshInstance3D.new()
	match index:
		1:
			nextMesh = SphereMesh.new()
		2:
			nextMesh = BoxMesh.new()
		3:
			nextMesh = PrismMesh.new()
	$".".set_mesh(nextMesh)
	pass
