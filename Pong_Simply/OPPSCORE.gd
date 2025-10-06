extends RichTextLabel

#CODE CREATED IN ENTIRETY BY MATT PHILIP
#NOT DESIGNED NOR APPROVED FOR DISTRIBUTION
#NOT DESIGNED NOR APPROVED FOR REASSIGNMENT OF OWNERSHIP

var score
var endgame: float
signal scorefreeze
signal gameEndOpp
@onready var prog = get_node("OppProg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_text("Computer:\n0")
	score = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_goal_point_scored(index) -> void:
	scorefreeze.emit()
	


func _on_cldwn_timer_opp_timeout() -> void:
	score += 1
	
	if (endgame == -1):
		set_text("Computer:\n%d" % (score/5))
	else:
		set_text("Computer:\n%d" % (score/5))
		prog.set_value(((score/5) / endgame) * 100)
		
	if (endgame == -1):
		pass
	elif (score/5) == endgame:
		set_text("Computer Victory!")
		gameEndOpp.emit()


func _on_arena_prep_max(index) -> void:
	if index == 0:
		endgame = 3
	elif index == 1:
		endgame = 5
	elif index == 2:
		endgame = 10
	elif index == 3:
		prog.set_value(100.0)
		endgame = -1


func _on_start_button_pressed() -> void:
	score = 0
	set_text("Computer:\n0")
	if (endgame != -1):
		prog.set_value(0.0)
