extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_oob_area_entered(area: Area3D) -> void:
	#print("ANIMATION HEARD PING")
	play("PLAYER/RESPAWNBLCKOUT")
	await get_tree().create_timer(1).timeout
	play_backwards("PLAYER/RESPAWNBLCKOUT")
