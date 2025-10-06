extends Timer

signal dashCLD()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pcbod_jump_boost_cd() -> void:
	#print("JUMP BOOST USED")
	start(3)

func _on_pcbod_dash_cd() -> void:
	#print("DASH ENABLED")
	start(1)
	dashCLD.emit()

func _on_dashenbld_dash_cld() -> void:
	#print("DASH COOLINGDOWN")
	start(3)
