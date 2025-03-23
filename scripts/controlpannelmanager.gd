extends Node

@onready var floor_current: Label = $currentfloor/SubViewport/floor
@onready var time: Label = $pannel/SubViewport/MarginContainer/VBoxContainer/HBoxContainer/time
@onready var selected_floor: Label = $"pannel/SubViewport/MarginContainer/VBoxContainer/HBoxContainer2/selected floor"

@onready var main_bgm: AudioStreamPlayer = $Calmtune
@onready var floor_call_player: AudioStreamPlayer = $FloorCallPlayer
@onready var disco_party: AudioStreamPlayer = $DiscoParty
@onready var hell: AudioStreamPlayer = $Hell
@onready var police: AudioStreamPlayer = $Police
@onready var vibe: AudioStreamPlayer = $Vibe

var is_disco_active: bool = false

# Outlines
@onready var outline_20: MeshInstance3D = $"buttons/bttn_20/20/outline_20"
@onready var outline_19: MeshInstance3D = $"buttons/bttn_19/19/outline_19"
@onready var outline_18: MeshInstance3D = $"buttons/bttn_18/18/outline_18"
@onready var outline_17: MeshInstance3D = $"buttons/bttn_17/17/outline_17"
@onready var outline_16: MeshInstance3D = $"buttons/bttn_16/16/outline_16"
@onready var outline_15: MeshInstance3D = $"buttons/bttn_15/15/outline_15"
@onready var outline_14: MeshInstance3D = $"buttons/bttn_14/14/outline_14"
@onready var outline_13: MeshInstance3D = $"buttons/bttn_13/13/outline_13"
@onready var outline_12: MeshInstance3D = $"buttons/bttn_12/12/outline_12"
@onready var outline_11: MeshInstance3D = $"buttons/bttn_11/11/outline_11"
@onready var outline_10: MeshInstance3D = $"buttons/bttn_10/10/outline_10"
@onready var outline_9: MeshInstance3D = $"buttons/bttn_9/9/outline_9"
@onready var outline_8: MeshInstance3D = $"buttons/bttn_8/8/outline_8"
@onready var outline_7: MeshInstance3D = $"buttons/bttn_7/7/outline_7"
@onready var outline_6: MeshInstance3D = $"buttons/bttn_6/6/outline_6"
@onready var outline_5: MeshInstance3D = $"buttons/bttn_5/5/outline_5"
@onready var outline_4: MeshInstance3D = $"buttons/bttn_4/4/outline_4"
@onready var outline_3: MeshInstance3D = $"buttons/bttn_3/3/outline_3"
@onready var outline_2: MeshInstance3D = $"buttons/bttn_2/2/outline_2"
@onready var outline_1: MeshInstance3D = $"buttons/bttn_1/1/outline_1"
@onready var outline_bell: MeshInstance3D = $buttons/bttn_bell/bell/outline_bell
@onready var outline_sos: MeshInstance3D = $buttons/bttn_sos/sos/outline_sos
@onready var outline_open: MeshInstance3D = $buttons/bttn_open/open/outline_open
@onready var outline_close: MeshInstance3D = $buttons/bttn_close/close/outline_close

@onready var liftlight: SpotLight3D = $liftlight
var original_light_color: Color = Color(1, 1, 1)  # Default white color

var is_sos_active: bool = false
var is_bell_active: bool = false

var current_floor: int = 1
var target_floor: int = 1
var moving: bool = false
var move_delay: float = 6  # Time delay in seconds per floor
var floor_queue: Array = []  # Queue to store selected floors
var is_lift_paused: bool = false

func _ready() -> void:
	current_floor = 1
	floor_current.text = "%02d" % current_floor
	hide_all_outlines()
	process_queue()  # Start processing the queue (or pick a random floor if empty)

func hide_all_outlines() -> void:
	# Hide all outlines
	outline_20.visible = false
	outline_19.visible = false
	outline_18.visible = false
	outline_17.visible = false
	outline_16.visible = false
	outline_15.visible = false
	outline_14.visible = false
	outline_13.visible = false
	outline_12.visible = false
	outline_11.visible = false
	outline_10.visible = false
	outline_9.visible = false
	outline_8.visible = false
	outline_7.visible = false
	outline_6.visible = false
	outline_5.visible = false
	outline_4.visible = false
	outline_3.visible = false
	outline_2.visible = false
	outline_1.visible = false
	outline_bell.visible = false
	outline_sos.visible = false
	outline_open.visible = false
	outline_close.visible = false

# Function to play a floor call
@warning_ignore("shadowed_global_identifier")
func play_floor_call(floor: int) -> void:
	# Construct the file path
	var audio_path: String = "res://assets/audio/floors/floor%d.ogg" % floor

	# Load the audio file
	var audio_stream: AudioStream = load(audio_path)

	if audio_stream:
		floor_call_player.stream = audio_stream
		floor_call_player.play()
	else:
		print("Error: Audio file for floor %d not found at path: %s" % [floor, audio_path])

# Add this function to create the rainbow disco effect
func start_rainbow_disco() -> void:
	var rainbow_colors: Array[Color] = [
		Color(1, 0, 0),    # Red
		Color(1, 0.5, 0),  # Orange
		Color(1, 1, 0),    # Yellow
		Color(0, 1, 0),    # Green
		Color(0, 0, 1),    # Blue
		Color(0.5, 0, 1),  # Indigo
		Color(1, 0, 1)     # Violet
	]

	var tween = create_tween()
	for color in rainbow_colors:
		tween.tween_property(liftlight, "light_color", color, 1.0)  # Transition to each color in 1 second
	tween.tween_property(liftlight, "light_color", original_light_color, 1.0)  # Restore original color

@warning_ignore("shadowed_global_identifier")
func add_floor_to_queue(floor: int) -> void:
	if not floor in floor_queue:  # Avoid duplicate entries
		floor_queue.append(floor)
		highlight_button(floor)
		if not moving:
			process_queue()

@warning_ignore("shadowed_global_identifier")
func highlight_button(floor: int) -> void:
	match floor:
		1: outline_1.visible = true
		2: outline_2.visible = true
		3: outline_3.visible = true
		4: outline_4.visible = true
		5: outline_5.visible = true
		6: outline_6.visible = true
		7: outline_7.visible = true
		8: outline_8.visible = true
		9: outline_9.visible = true
		10: outline_10.visible = true
		11: outline_11.visible = true
		12: outline_12.visible = true
		13: outline_13.visible = true
		14: outline_14.visible = true
		15: outline_15.visible = true
		16: outline_16.visible = true
		17: outline_17.visible = true
		18: outline_18.visible = true
		19: outline_19.visible = true
		20: outline_20.visible = true

func process_queue() -> void:
	if floor_queue.size() == 0:
		# If no floors are selected, pick a random floor
		var random_floor = randi_range(1, 20)
		while random_floor == current_floor:  # Ensure the new floor is different from the current floor
			random_floor = randi_range(1, 20)
		add_floor_to_queue(random_floor)
		return

	# Process the next floor in the queue
	target_floor = floor_queue[0]
	selected_floor.text = str(target_floor)
	moving = true
	move_elevator()

func move_elevator() -> void:
	if is_lift_paused:
		return  # Do nothing if the lift is paused

	if current_floor == target_floor:
		# Play the floor call announcement before showing "ERROR"
		play_floor_call(current_floor)

		# Optional: Wait for the floor call audio to finish
		await get_tree().create_timer(floor_call_player.stream.get_length()).timeout

		# Check for Easter eggs based on the current floor
		match current_floor:
			1:  # Hell Mode
				await trigger_hell_easter_egg()
			9:  # Police Mode
				await trigger_police_easter_egg()
			18:  # Disco Party
				await trigger_disco_party()
			20:  # Vibe Mode
				await trigger_vibe_easter_egg()

		# Show "ERROR" when reaching the target floor
		floor_current.text = "ERROR"
		await get_tree().create_timer(2.0).timeout  # Wait 2 seconds

		# Hide the outline for the current floor
		hide_button_outline(target_floor)

		# Remove the floor from the queue
		floor_queue.pop_front()

		if floor_queue.size() > 0:
			# Process the next floor in the queue
			target_floor = floor_queue[0]
			selected_floor.text = str(target_floor)
			move_elevator()  # Continue moving
		else:
			moving = false  # Stop moving if no more floors in the queue
			process_queue()  # Pick a new random floor
		return

	# Move up/down by 1 floor at a controlled speed
	if current_floor < target_floor:
		current_floor += 1
	elif current_floor > target_floor:
		current_floor -= 1

	# Update the floor display
	floor_current.text = "%02d" % current_floor

	# Wait before moving again
	await get_tree().create_timer(move_delay).timeout
	move_elevator()  # Call again to keep moving

func trigger_hell_easter_egg() -> void:
	# Pause the lift and main BGM
	is_lift_paused = true
	main_bgm.stream_paused = true

	# Play the hell song
	hell.play()

	# Change the lift light to reddish-orange
	var tween = create_tween()
	tween.tween_property(liftlight, "light_color", Color(1, 0.3, 0), 0.5)  # Reddish-orange

	# Display the hell message
	floor_current.text = "HELL"

	# Wait for 10 seconds
	await get_tree().create_timer(10.0).timeout

	# Restore the lift light to white
	if is_instance_valid(tween):  # Ensure the tween is still valid
		tween.stop()  # Stop the tween if it's still running
	var restore_tween = create_tween()
	restore_tween.tween_property(liftlight, "light_color", original_light_color, 0.5)

	# Restore the floor display
	floor_current.text = "%02d" % current_floor

	# Resume the main BGM and lift movement
	main_bgm.stream_paused = false
	is_lift_paused = false

func trigger_police_easter_egg() -> void:
	# Pause the lift and main BGM
	is_lift_paused = true
	main_bgm.stream_paused = true

	# Play the police sound
	police.play()

	# Flash the lift light in red and blue
	var tween = create_tween()
	for _i in range(10):  # Flash 10 times (increased from 5)
		tween.tween_property(liftlight, "light_color", Color(1, 0, 0), 0.5)  # Red (increased from 0.2)
		tween.tween_property(liftlight, "light_color", Color(0, 0, 1), 0.5)  # Blue (increased from 0.2)
	tween.tween_property(liftlight, "light_color", original_light_color, 0.5)  # Restore original color (increased from 0.2)

	# Display the police message
	floor_current.text = "POLICE"

	# Wait for 10 seconds
	await get_tree().create_timer(10.0).timeout

	# Restore the floor display
	floor_current.text = "%02d" % current_floor

	# Resume the main BGM and lift movement
	main_bgm.stream_paused = false
	is_lift_paused = false

func trigger_vibe_easter_egg() -> void:
	# Pause the lift and main BGM
	is_lift_paused = true
	main_bgm.stream_paused = true

	# Play the vibe song
	vibe.play()

	# Change the lift light to light blue
	var tween = create_tween()
	tween.tween_property(liftlight, "light_color", Color(0.5, 0.7, 1), 0.5)  # Light blue

	# Display the vibe message
	floor_current.text = "CHEESE"

	# Wait for 10 seconds
	await get_tree().create_timer(10.0).timeout

	# Restore the lift light to white
	if is_instance_valid(tween):  # Ensure the tween is still valid
		tween.stop()  # Stop the tween if it's still running
	var restore_tween = create_tween()
	restore_tween.tween_property(liftlight, "light_color", original_light_color, 0.5)

	# Restore the floor display
	floor_current.text = "%02d" % current_floor

	# Resume the main BGM and lift movement
	main_bgm.stream_paused = false
	is_lift_paused = false

func trigger_disco_party() -> void:
	# Pause the lift and main BGM
	is_lift_paused = true
	main_bgm.stream_paused = true

	# Start the disco party
	is_disco_active = true
	disco_party.play()

	# Start the rainbow disco effect
	start_rainbow_disco()

	# Wait for 10 seconds
	await get_tree().create_timer(10.0).timeout

	# Restore the lift light to white
	var tween = create_tween()
	tween.tween_property(liftlight, "light_color", original_light_color, 0.5)

	# Restore the floor display
	floor_current.text = "%02d" % current_floor

	# Stop the disco party and resume the main BGM
	disco_party.stop()
	main_bgm.stream_paused = false
	is_disco_active = false
	is_lift_paused = false

@warning_ignore("shadowed_global_identifier")
func hide_button_outline(floor: int) -> void:
	match floor:
		1: outline_1.visible = false
		2: outline_2.visible = false
		3: outline_3.visible = false
		4: outline_4.visible = false
		5: outline_5.visible = false
		6: outline_6.visible = false
		7: outline_7.visible = false
		8: outline_8.visible = false
		9: outline_9.visible = false
		10: outline_10.visible = false
		11: outline_11.visible = false
		12: outline_12.visible = false
		13: outline_13.visible = false
		14: outline_14.visible = false
		15: outline_15.visible = false
		16: outline_16.visible = false
		17: outline_17.visible = false
		18: outline_18.visible = false
		19: outline_19.visible = false
		20: outline_20.visible = false

# Button input event functions
func _on_bttn_20_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(20)

func _on_bttn_19_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(19)

func _on_bttn_18_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(18)

func _on_bttn_17_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(17)

func _on_bttn_16_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(16)

func _on_bttn_15_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(15)

func _on_bttn_14_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(14)

func _on_bttn_13_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(13)

func _on_bttn_12_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(12)

func _on_bttn_11_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(11)

func _on_bttn_10_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(10)

func _on_bttn_9_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(9)

func _on_bttn_8_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(8)

func _on_bttn_7_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(7)

func _on_bttn_6_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(6)

func _on_bttn_5_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(5)

func _on_bttn_4_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(4)

func _on_bttn_3_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(3)

func _on_bttn_2_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(2)

func _on_bttn_1_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		add_floor_to_queue(1)

# Add these functions to handle the special buttons
func _on_bttn_open_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and not is_sos_active and not is_bell_active:
		outline_open.visible = true
		await get_tree().create_timer(2.0).timeout
		outline_open.visible = false

func _on_bttn_close_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and not is_sos_active and not is_bell_active:
		outline_close.visible = true
		await get_tree().create_timer(2.0).timeout
		outline_close.visible = false

# Function to handle the SOS button (16 seconds)
func _on_bttn_sos_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and not is_sos_active and not is_bell_active:
		is_sos_active = true
		floor_current.text = "S.O.S"
		liftlight.visible = false  # Turn off the lift light
		outline_sos.visible = true
		await get_tree().create_timer(16.0).timeout  # Wait for 16 seconds
		floor_current.text = "%02d" % current_floor  # Restore the floor display
		liftlight.visible = true  # Turn on the lift light
		outline_sos.visible = false
		is_sos_active = false

# Function to handle the Bell button (16 seconds)
func _on_bttn_bell_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and not is_sos_active and not is_bell_active:
		is_bell_active = true
		floor_current.text = "404"
		liftlight.visible = false  # Turn off the lift light
		outline_bell.visible = true
		await get_tree().create_timer(16.0).timeout  # Wait for 16 seconds
		floor_current.text = "%02d" % current_floor  # Restore the floor display
		liftlight.visible = true  # Turn on the lift light
		outline_bell.visible = false
		is_bell_active = false
