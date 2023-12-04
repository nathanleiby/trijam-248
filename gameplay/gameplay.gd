extends Node2D

@onready var scoreLabel := $UI/ScoreLabel
@onready var timerLabel := $UI/TimerLabel
@onready var character := $Character
@onready var timer := $GameTimer

@export var score_offset: int = 665

func _input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		call_deferred("_pause")
		
func _pause() -> void:
	$Paused.pause()
	get_tree().paused = true

func _ready():
	timer.start()

func _process(delta) -> void:
	scoreLabel.text = "Height: %d" % ((character.position.y * -1) + score_offset)
	var minutes =  ceil(timer.time_left) / 60
	var seconds = int(ceil(timer.time_left)) % 60
	timerLabel.text = "Countdown: %d:%02d" % [minutes, seconds]
	
