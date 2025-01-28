class_name PlayerPaddle
extends CharacterBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func get_size():
	return collision_shape_2d.shape.get_rect().size
	
func get_width():
	return get_size().x
