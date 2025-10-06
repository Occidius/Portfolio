extends Node2D

#CODE CREATED IN ENTIRETY BY MATT PHILIP
#NOT DESIGNED NOR APPROVED FOR DISTRIBUTION
#NOT DESIGNED NOR APPROVED FOR REASSIGNMENT OF OWNERSHIP

var plrSpeed = 600
var direction

var initPos 
var currPos
var tempPosUp
var tempPosDown

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	initPos = position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tempPosUp = plrSpeed * delta * -1
	tempPosDown = plrSpeed * delta * 1
	#print(position.y)
	
	if Input.is_action_pressed("UP_ARROW") and (position.y) > -285 :
		#print("UUUUUUUP")
		direction = -1
		currPos += plrSpeed * delta * direction
		position.y = currPos

	if Input.is_action_pressed("DOWN_ARROW") and (position.y) < 285 :#and position.y <= get_viewport_rect().get_center():
		#print("DOOOOOOOWN")
		direction = 1
		currPos += plrSpeed * delta * direction
		position.y = currPos


func _on_ball__reset() -> void:
	#set_global_position(initPos)
	set_process(false)


func _on_start_button_pressed() -> void:
	#print("PLR AWAKENEED")
	currPos = initPos
	set_process(true)
