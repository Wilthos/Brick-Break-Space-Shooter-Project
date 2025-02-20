class_name Ship
extends Node2D

@export var game_stats: GameStats

@onready var left_muzzle: Marker2D = $LeftMuzzle
@onready var right_muzzle: Marker2D = $RightMuzzle
@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var scale_component: ScaleComponent = $ScaleComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $Anchor/AnimatedSprite2D
@onready var move_component: MoveComponent = $MoveComponent
@onready var flame_animated_sprite: AnimatedSprite2D = %FlameAnimatedSprite
@onready var variable_pitch_audio_stream_player: VariablePitchAudioStreamPlayer = $VariablePitchAudioStreamPlayer
@onready var stats_component: StatsComponent = $StatsComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent

var auto_fire_on = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Make sure the actor start with full health
	stats_component.health = stats_component.max_health
	
	# keep track of how much damage the ship/player takes in a level
	hurtbox_component.hurt.connect(func(hitbox_component: HitboxComponent):
		game_stats.damage_taken += hitbox_component.damage
		#print_debug("Ship Hit! Total Damage: ", game_stats.damage_taken)
	)

func fire_lasers() -> void:
	variable_pitch_audio_stream_player.play_with_variance()
	spawner_component.spawn(right_muzzle.global_position)
	spawner_component.spawn(left_muzzle.global_position)
	scale_component.tween_scale()

func _process(delta: float) -> void:
	animate_the_ship()
	
	# This chunk of code will have the lasers 
	# fire when the button is pressed 
	# and auto fire at a predetermiend rate
	# When held
	#if Input.is_action_just_pressed("Fire"):
		#fire_lasers()
		#fire_rate_timer.start()
		#if Input.is_action_pressed("Fire"):
			#fire_rate_timer.timeout.connect(fire_lasers)
	#if Input.is_action_just_released("Fire"):
		#fire_rate_timer.stop()
		
	# This chunk of code will have the lasers only start
	# once the firebutton is pressed, and then fire at a certain
	# rate
	if Input.is_action_just_pressed("Fire") and !auto_fire_on:
		fire_lasers()
		fire_rate_timer.start()
		auto_fire_on = true
	elif Input.is_action_just_pressed("Fire") and auto_fire_on:
		#fire_lasers()
		fire_rate_timer.stop()
		auto_fire_on = false
	
	
	#fire_rate_timer.wait_time = 0.2 / (0.5 + (game_stats.maxcombo*5 * 0.01))
	fire_rate_timer.wait_time = 0.5 / (1.25 + (game_stats.maxcombo* 0.1))
	
	fire_rate_timer.timeout.connect(fire_lasers)
	
	
func animate_the_ship() -> void:
	if move_component.velocity.x < 0:
		animated_sprite_2d.play("bank_left")
		flame_animated_sprite.play("bank_left")
	elif move_component.velocity.x > 0:
		animated_sprite_2d.play("bank_right")
		flame_animated_sprite.play("bank_right")
	else:
		animated_sprite_2d.play("center")
		flame_animated_sprite.play("center")
