# Give the component a class name so it can be instanced as a custom node
class_name BallHealboxComponent
extends Area2D

@onready var healbox_component: HealboxComponent = %HealboxComponent

# Export the damage amount this hitbox deals
@export var heal = 1.0

# Create a signal for when the hitbox hits a hurtbox
signal hit_hurtbox(hurtbox)

func _ready():
	# Connect on area entered to our hurtbox entered function
	area_entered.connect(_on_hurtbox_entered)

func _on_hurtbox_entered(hurtbox: HurtboxComponent):
	
	# For debug
	#print_debug("Hitbox Info: ",hitbox_component.get_parent().name)
	#print_debug("Hurtbox Info: ",hurtbox.get_parent().name)
	#if hurtbox.get_parent().name.contains("Brick") and (hitbox_component.get_parent().name.contains("Laser") or hitbox_component.get_parent().name.contains("Node")):
		#print_debug("Hit a Brick with the laser")
	#elif hurtbox.get_parent().name.contains("Brick"):
		#print_debug("Hit a Brick")
	#print_debug("Area Overlap info: ",get_overlapping_bodies())
	
	# Make sure the area we are overlapping is a hurtbox
	if not hurtbox is HurtboxComponent: return
	# Make sure the hurtbox isn't invincible
	if hurtbox.is_invincible: return
	# Signal out that we hit a hurtbox (this is useful for destroying projectiles when they hit something)
	hit_hurtbox.emit(hurtbox)
	
	# Added by Wilthos
	# If a laser hits a brick, ignore damage
	#if hurtbox.get_parent().name.contains("Brick") and (hitbox_component.get_parent().name.contains("Laser") or hitbox_component.get_parent().name.contains("Node")): return
	
	# Have the hurtbox signal out that it was hit
	hurtbox.ball_heal.emit(self)
	#print_debug("heal hits hurt")
