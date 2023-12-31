extends Node2D

@onready var scoreLabel := $UI/VBoxContainer/ScoreLabel
@onready var maxHeightLabel := $UI/VBoxContainer/MaxHeightLabel
@onready var timerLabel := $UI/VBoxContainer2/TimerLabel
@onready var platformsRemainingLabel := $UI/VBoxContainer3/PlatformsRemainingLabel
@onready var character := $Character
@onready var timer: Timer = $GameTimer


@export var score_offset: int = 665

var highest_platform_height = INF:
	set(val):
		highest_platform_height = val
		$MaxHeight.position.y = highest_platform_height
		$MaxHeight2.position.y = highest_platform_height
		maxHeightLabel.text = "Max Platform Height: %d" % (-highest_platform_height + score_offset)

func _input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		call_deferred("_pause")

func _pause() -> void:
	$Paused.pause()
	get_tree().paused = true

func _ready():
	timer.start()
	Sound.play_music($Music) # TODO: No audio file added yet

	Events.connect("time_collected", _on_time_collected)
	Events.connect("platform_number_set", _on_platform_number_set)

func _process(delta) -> void:
	scoreLabel.text = "Height: %d" % ((character.position.y * -1) + score_offset)

	var minutes =  ceil(timer.time_left) / 60
	var seconds = int(ceil(timer.time_left)) % 60
	timerLabel.text = "%d:%02d" % [minutes, seconds]

func _on_timer_timeout():
	pass


func _on_character_platform_created(height) -> void:
	if height < highest_platform_height:
		highest_platform_height = height
		Sound.play_sfx($NewMaxHeightSfx)

func _on_time_collected(seconds: float):
	Sound.play_sfx($Sfx/Collectible)
	timer.wait_time += seconds
	timer.start() # required to reset timer to new wait_time

func _on_platform_number_set(platforms_remaining: int):
	platformsRemainingLabel.text = "Platforms = " + str(platforms_remaining)
