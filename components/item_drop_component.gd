# Give the component a class name so it can be instanced as a custom node
class_name ItemDropComponent
extends Node

# Export the actor this component will operate on
@export var actor: Node2D

# Grab access to the destroy component to know when the object is destroyed
@export var destroyed_component: DestroyedComponent

# Export and grab access to a spawner component so we can create an effect on death
@export var item_spawner_component: SpawnerComponent

func _ready() -> void:
	# Connect the the no health signal on our stats to the destroy function
	destroyed_component.actor_destroyed.connect(drop_item)

func drop_item() -> void:
	# create an effect (from the spawner component) and free the actor
	item_spawner_component.spawn(actor.global_position)
	#actor.queue_free()
	item_dropped.emit() # Emit a signal telling an item was dropped

#Create a signal to emite when something it destroyed
signal item_dropped()
