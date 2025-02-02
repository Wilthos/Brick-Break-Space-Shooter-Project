# Give the component a class name so it can be instanced as a custom node
class_name StatsComponent
extends Node

# Create the health variable and connect a setter
@export var health: float = 1:
	set(value):
		health = value
		
		# Signal out that the health has changed
		health_changed.emit()
		
		# Signal out when health is at 0
		if health == 0: no_health.emit()
		# Also emit special signal if node that lost all health is an EnemyPortal
		if health == 0 and get_parent().name.contains("EnemyPortal"): enemy_portal_no_health.emit()
		

# Create our signals for health
signal health_changed() # Emit when the health value has changed
signal no_health() # Emit when there is no health left
signal enemy_portal_no_health() # Emite when EnemyPortal has no health left
