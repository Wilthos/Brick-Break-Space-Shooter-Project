class_name HealItem
extends Node2D

@onready var healbox_component: HealboxComponent = $HealboxComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Have the healing item disappear when the player collects them
	healbox_component.hit_hurtbox.connect(queue_free.unbind(1))
