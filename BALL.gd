extends RigidBody2D

var rng = RandomNumberGenerator.new()

#CODE CREATED IN ENTIRETY BY MATT PHILIP
#NOT DESIGNED NOR APPROVED FOR DISTRIBUTION
#NOT DESIGNED NOR APPROVED FOR REASSIGNMENT OF OWNERSHIP

#const speed = 100
var plrScore = 0
var oppScore = 0

var gameEnd: bool = false

var initDirection
var initPos = position
var initXVEL
var initYVEL

signal _reset
signal _opponentAlert
signal _timerStart
signal _playerGoal
signal _oppGoal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	
	initDirection = _velocityInitialize()
	#var UBound = get_node("EDGES")
	#UBound.get_node("UpperBound").connect("child_entered_tree", _upperBoundHit)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(initPos)
	if Input.is_action_just_pressed("RESET_BUTTON"):
		_reInit()
		_reset.emit()
	
	#if linear_velocity.x > -1 and linear_velocity.x < 1:
	#	linear_velocity.x += speed * rng.randf_range(-5, 5)
	_opponentAlert.emit(position.y)
	#print(position.y - 600)


func _on_start_button_pressed() -> void:
	_timerStart.emit()

func _velocityInitialize() -> Vector2:
	initXVEL = 0
	initYVEL = 0
	
	while -300 < initXVEL and initXVEL < 300 :
		initXVEL = rng.randf_range(-750.0, 750.0) #* speed
		#print("initXVEL %f" % initXVEL)
	
	while -150 < initYVEL and initYVEL < 150 :
		initYVEL = rng.randf_range(-300.0, 300.0) #* speed
		#print("initYVEL %f" % initYVEL)
	
	return Vector2(initXVEL * 1.75, initYVEL)

func _reInit() -> void:
	set_process(false)
	#print("RESEEEEEEEEEEET")
	set_linear_velocity(Vector2(0.0, 0.0))
	set_global_position(initPos)

func _on_player_goal_point_scored(scoreIndex) -> void:
	#plrScore += 1
	set_linear_velocity(Vector2(0.0, 0.0))
	set_global_position(initPos)
	if (!gameEnd):
		#_oppGoal.emit()
		_timerStart.emit()

func _on_opponent_goal_point_scored(scoreIndex) -> void:
	#oppScore += 1
	set_linear_velocity(Vector2(0.0, 0.0))
	set_global_position(initPos)
	if (!gameEnd):
		#_playerGoal.emit()
		_timerStart.emit()

func _on_timer_timeout() -> void:
	if (!gameEnd):
		set_process(true)
		initDirection = _velocityInitialize()
		set_linear_velocity(initDirection)


func _on_plr_score_game_end_plr() -> void:
	gameEnd = true


func _on_opp_score_game_end_opp() -> void:
	gameEnd = true
