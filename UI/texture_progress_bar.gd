extends TextureProgressBar

@export var ship: Ship


func _ready():
	ship.stats_component.health_changed.connect(update)
	update()
	
func update():
	if ship.stats_component.health >  ship.stats_component.max_health: 
		ship.stats_component.health = ship.stats_component.max_health
	value = ship.stats_component.health / ship.stats_component.max_health *100
	
	pass
