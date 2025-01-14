class_name MoveInputComponent
extends Node

@export var move_stats: MoveStats
@export var move_component: MoveComponent # Dependent on


func _input(event: InputEvent) -> void:
	var input_axis = Input.get_axis("ui_left","ui_right")
	# returns -1, 0, or 1 for direction
	# can get fractional values for a joystick
	move_component.velocity = Vector2(input_axis * move_stats.speed,0)
