extends Timer

#CODE CREATED IN ENTIRETY BY MATT PHILIP
#NOT DESIGNED NOR APPROVED FOR DISTRIBUTION
#NOT DESIGNED NOR APPROVED FOR REASSIGNMENT OF OWNERSHIP

signal oppTimeout
signal plrTimeout

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_plr_score_scorefreeze() -> void:
	start(1)
	plrTimeout.emit()


func _on_opp_score_scorefreeze() -> void:
	start(1)
	oppTimeout.emit()
