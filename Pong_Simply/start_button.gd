extends Button

#CODE CREATED IN ENTIRETY BY MATT PHILIP
#NOT DESIGNED NOR APPROVED FOR DISTRIBUTION
#NOT DESIGNED NOR APPROVED FOR REASSIGNMENT OF OWNERSHIP

func _on_pressed() -> void:
	disabled = true
	visible = false
	

func _on_ball__reset() -> void:
	disabled = false
	visible = true
	pass
