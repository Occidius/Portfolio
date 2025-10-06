extends Node

#CODE CREATED IN ENTIRETY BY MATT PHILIP
#NOT DESIGNED NOR APPROVED FOR DISTRIBUTION
#NOT DESIGNED NOR APPROVED FOR REASSIGNMENT OF OWNERSHIP

@onready var mainMenu = get_node("MainMenu")
@onready var startButton = get_node("StartButton")
@onready var ballNode = get_node("Ball")

@onready var difficulty = get_node("MainMenu/Difficulty")
@onready var bestOf = get_node("MainMenu/ScoreMax")

signal prepAI
signal prepMax
signal _reset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mainMenu.set_visible(true)
	startButton.set_visible(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#difficulty.get_index()
	pass


func _on_plr_score_game_end_plr() -> void:
	mainMenu.set_visible(true)
	_reset.emit()
	ballNode.set_global_position(ballNode.initPos)
	ballNode.set_process(false)
	startButton.set_visible(false)
	startButton.set_disabled(false)
	#mainMenu.set_text("Player Victory!")


func _on_opp_score_game_end_opp() -> void:
	mainMenu.set_visible(true)
	_reset.emit()
	ballNode.set_global_position(ballNode.initPos)
	ballNode.set_process(false)
	startButton.set_visible(false)
	startButton.set_disabled(false)
	#mainMenu.set_text("Computer Victory!")


func _on_setupbutton_pressed() -> void:
	if (difficulty.get_selected() == -1 or bestOf.get_selected() == -1):
		pass
	else:
		prepAI.emit(difficulty.get_selected())
		prepMax.emit(bestOf.get_selected())
		mainMenu.set_visible(false)
		startButton.set_visible(true)
		ballNode.gameEnd = false


func _on_ball__reset() -> void:
	startButton.set_visible(false)
	startButton.set_disabled(false)
	mainMenu.set_visible(true)
	ballNode.set_process(false)
	ballNode.set_global_position(ballNode.initPos)
	
