extends Node3D

@onready var cube = get_node("StaticBody3D/GTextures/Cube")
@onready var sphere = get_node("StaticBody3D/GTextures/Sphere")
@onready var gravArea = get_node("Area3D")
@onready var chroma = get_node("OmniLight3D")

var charArea : Area3D
var moteData = position
signal motePos(moteData : Vector3) 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cube.rotation.y = cube.rotation.y + delta * 2.5
	cube.rotation.z = cube.rotation.z + delta * 2.5
	cube.rotation.x = cube.rotation.x + delta * 0
	while (gravArea.overlaps_area(charArea) && cube.scale.x < 2):
		cube.scale.x = move_toward(cube.scale.x, 2, delta)
		cube.scale.y = move_toward(cube.scale.y, 2, delta)
		cube.scale.z = move_toward(cube.scale.z, 2, delta)
		
		if (!gravArea.overlaps_area(charArea)):
			break
	
	motePos.emit(moteData)
	if (!gravArea.overlaps_area(charArea)):
		cube.scale.x = move_toward(cube.scale.x, 1.3, delta)
		cube.scale.y = move_toward(cube.scale.y, 1.3, delta)
		cube.scale.z = move_toward(cube.scale.z, 1.3, delta)



func _on_area_3d_area_entered(area: Area3D) -> void:
	charArea = area
	#if (gravArea.overlaps_area(charArea)):
	print(charArea)


func _on_area_3d_area_exited(area: Area3D) -> void:
	pass#print("GONER") #charArea.clear()
