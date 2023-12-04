extends Node2D

@onready var scoreLabel := $UI/ScoreLabel
@onready var timerLabel := $UI/TimerLabel
@onready var character := $Character
@onready var timer := $GameTimer

var score_offset: int = 617

func _input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		call_deferred("_pause")
		
func _pause() -> void:
	$Paused.pause()
	get_tree().paused = true

func _ready():
	timer.timeout.connect(_on_timer_timeout) 
	timer.start()

func _process(delta) -> void:
	scoreLabel.text = "Height: %d" % ((character.position.y * -1) + score_offset)
	timerLabel.text = "Countdown: %d" % timer.time_left
	
func _on_timer_timeout():
	pass
