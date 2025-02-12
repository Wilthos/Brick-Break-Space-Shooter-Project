extends TextureProgressBar

@export var ship: Ship


func _ready():
	ship.stats_component.health_changed.connect(update)
	update()
	
func update():
	value = ship.stats_component.health / ship.max_ship_health *100
	pass
