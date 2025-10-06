extends Area2D

#CODE CREATED IN ENTIRETY BY MATT PHILIP
#NOT DESIGNED NOR APPROVED FOR DISTRIBUTION
#NOT DESIGNED NOR APPROVED FOR REASSIGNMENT OF OWNERSHIP

@onready var ball = get_node("Ball")
#@onready var PGArea = get_node("PlayerGoal")
#@onready var OGArea = get_node("OpponentGoal")

signal pointScored

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_overlapping_areas() :
		print("GAAAH")
		pointScored.emit(0)
