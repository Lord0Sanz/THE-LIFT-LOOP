extends Node3D

@onready var play: Button = $MAINMENU/MarginContainer/VBoxContainer/play
@onready var ui: CanvasLayer = $player/UI
@onready var logo: TextureRect = $MAINMENU/MarginContainer/VBoxContainer/logo

@onready var time_label: Label = $controlpannelmanager/pannel/SubViewport/MarginContainer/VBoxContainer/HBoxContainer/time

var elapsed_time: float = 0.0
var timer_running: bool = false

func _ready() -> void:
	play.show()
	ui.hide()
	set_process_input(true)
	time_label.text = "00:00:00"

func _on_play_pressed() -> void:
	play.hide()
	ui.show()
	logo.hide()
	timer_running = true  # Start timer

func _process(delta: float) -> void:
	if timer_running:
		elapsed_time += delta
		update_timer_display()

func update_timer_display() -> void:
	@warning_ignore("integer_division")
	var hours = int(elapsed_time) / 3600
	@warning_ignore("integer_division")
	var minutes = (int(elapsed_time) % 3600) / 60
	var seconds = int(elapsed_time) % 60
	
	time_label.text = "%02d:%02d:%02d" % [hours, minutes, seconds]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_restart_game()

func _restart_game() -> void:
	get_tree().reload_current_scene()  # Reset the game
