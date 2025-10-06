extends Node2D

#CODE CREATED IN ENTIRETY BY MATT PHILIP
#NOT DESIGNED NOR APPROVED FOR DISTRIBUTION
#NOT DESIGNED NOR APPROVED FOR REASSIGNMENT OF OWNERSHIP
#@onready var ball = get_node("Ball")

var currPos
var currBallPos: float = 0.0

var direction
var oppSpeed = 150 #need listeneres to set oppSpeed based on opponent difficulty
var counter: int

var locDelta

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	locDelta = delta
	

func _on_ball__opponent_alert(ballPosY) -> void:
	currPos = position.y
	currBallPos = ballPosY - 600
	if position.y > currBallPos and position.y > -285:
		#print("UUUUUUUP")
		direction = -1
		currPos += oppSpeed * locDelta * direction
		position.y = currPos

	if position.y <= currBallPos and position.y < 285:
		#print("DOOOOWN")
		direction = 1
		currPos += oppSpeed * locDelta * direction
		position.y = currPos

	if position.y == currBallPos:
		pass
	#print(currBallPos)
	


func _on_arena_prep_ai(index) -> void:
	#print(index)
	if index == 0:
		oppSpeed = 700
	elif index == 1:
		oppSpeed = 400
	elif index == 2:
		oppSpeed = 175
