# Give the component a class name so it can be instanced as a custom node
class_name StatsComponent
extends Node

##
# Actor Level
##
@export var actor_level: int = 1 :
	set(value):
		actor_level = value


###
# HP & MAX HP 
###
# Create the health variable and connect a setter
@export var health: float = 1:
	set(value):
		# Set health value
		health = value
		
		# Signal out that the health has changed
		health_changed.emit()
		
		
		# Signal out when health is at 0
		if health == 0: no_health.emit()
		# Also emit special signal if node that lost all health is an EnemyPortal
		#if health == 0 and get_parent().name.contains("EnemyPortal"): enemy_portal_no_health.emit()

@export var max_health: int = 1 :
	set(value):
		max_health = value
##
# Attack
##
@export var attack: int = 5 :
	set(value):
		attack = value
##
# Defense
##
@export var defense: int = 5 :
	set(value):
		defense = value

# Create our signals for health
signal health_changed() # Emit when the health value has changed
signal no_health() # Emit when there is no health left
