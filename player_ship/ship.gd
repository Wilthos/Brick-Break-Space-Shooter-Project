class_name Ship
extends Node2D

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

var max_ship_health_flag = true
var max_ship_health = 0 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#fire_rate_timer.timeout.connect(fire_lasers)
	if max_ship_health_flag:
		max_ship_health = stats_component.health
		max_ship_health_flag = false
	pass
	

func fire_lasers() -> void:
	variable_pitch_audio_stream_player.play_with_variance()
	spawner_component.spawn(right_muzzle.global_position)
	spawner_component.spawn(left_muzzle.global_position)
	scale_component.tween_scale()

func _process(delta: float) -> void:
	animate_the_ship()
	if Input.is_action_just_pressed("Fire"):
		fire_lasers()
		fire_rate_timer.start()
		if Input.is_action_pressed("Fire"):
			fire_rate_timer.timeout.connect(fire_lasers)
	if Input.is_action_just_released("Fire"):
		fire_rate_timer.stop()
		#if fire_rate_timer.is_stopped():
			#fire_lasers()
			#fire_rate_timer.start()
		
		
	
	
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
