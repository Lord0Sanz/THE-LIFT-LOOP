extends Node3D

@onready var cam: Camera3D = $Camera3D
@onready var player: Node3D = $"."
@onready var rotate_left: Button = $UI/MarginContainer/HBoxContainer/left
@onready var rotate_right: Button = $UI/MarginContainer/HBoxContainer/right

@export var sensitivity: float = 0.1  # Adjusts the strength of the effect

var original_rotation: Vector3

func _ready():
	original_rotation = cam.rotation  # Store the camera's initial rotation
	update_buttons_state()  # Initialize button states

func update_buttons_state():
	# Disable left button if rotation is at or exceeds +60 degrees
	rotate_left.disabled = player.rotation_degrees.y >= 30
	# Disable right button if rotation is at or below -60 degrees
	rotate_right.disabled = player.rotation_degrees.y <= -30

@warning_ignore("unused_parameter")
func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport_size = get_viewport().get_visible_rect().size

	var offset_x = (mouse_pos.x - viewport_size.x / 2) / viewport_size.x
	var offset_y = (mouse_pos.y - viewport_size.y / 2) / viewport_size.y

	cam.rotation_degrees.x = original_rotation.x + offset_y * sensitivity * -90
	cam.rotation_degrees.y = original_rotation.y + offset_x * sensitivity * -90


func _on_left_pressed() -> void:
	player.rotation_degrees.y += 90
	update_buttons_state()  # Update both buttons after rotation


func _on_right_pressed() -> void:
	player.rotation_degrees.y -= 90
	update_buttons_state()  # Update both buttons after rotation
