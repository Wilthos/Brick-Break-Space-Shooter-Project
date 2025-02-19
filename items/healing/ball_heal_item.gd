class_name BallHealItem
extends Node2D

@onready var ball_healbox_component: BallHealboxComponent = $BallHealboxComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Have the healing item disappear when the player collects them
	ball_healbox_component.hit_hurtbox.connect(queue_free.unbind(1))
