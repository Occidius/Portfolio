extends PathFollow3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress = progress + 30 * delta
