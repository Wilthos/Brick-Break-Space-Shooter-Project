extends Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super() # Run everything in the parent _ready() func
	move_component.velocity.x = [-20,20].pick_random()
