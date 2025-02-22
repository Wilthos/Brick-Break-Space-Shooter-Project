extends Node2D

@export var game_stats: GameStats
@export var ball_speed = 50 

@onready var ship: Ship = $Ship
@onready var score_label: Label = %ScoreLabel
@onready var player_ball: PlayerBall = $PlayerBall
@onready var ball_health: BallHealth = $CanvasLayer/BallHealth
#@onready var combo_label: Label = %ComboLabel
@onready var rich_combo_label: RichComboLabel = %RichComboLabel
@onready var combo_break_shatter_animation: RichTextLabel = %ComboBreakShatterAnimation


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Define the balls max health (may need to change handling later)
	#var ball_max_health = player_ball.stats_component.health
	#print_debug("Max Ball Health: ", ball_max_health)
	# Display the Player Ball's Health
	ball_health.set_max_hearts(player_ball.stats_component.max_health)
	ball_health.update_hearts(player_ball.stats_component.health,player_ball.stats_component.max_health)
	game_stats.combo_count = 40
	game_stats.maxcombo = 40
	
	#Make ball invincble foor debug
	player_ball.hurtbox_component.is_invincible = true
	
	# Randomize the seed so no game is the same
	randomize() 
	
	# Position the ball
	player_ball.position = Vector2(80,200)
	# Make the ball move in a random direction upward
	player_ball.move_component.velocity = Vector2(randf_range(-1, 1), randf_range(-.1, -1)).normalized() * player_ball.ball_speed
	#player_ball.move_component.velocity = Vector2(0,0)
	
	# Update score label
	update_score_label(game_stats.score)
	game_stats.score_changed.connect(update_score_label)
	
	# Update combo label
	update_rich_combo_label(game_stats.combo_count,game_stats.maxcombo)
	game_stats.combo_changed.connect(update_rich_combo_label)
	
	# only show the combo label when you have a min combo
	game_stats.min_combo_reached.connect(make_combo_visible)
	
	# Remove the combo gui when the combo is broken
	game_stats.combo_broken.connect(break_rich_combo_label)
	
	# Break the combo count when the ship is hit
	#ship.hurtbox_component.hurt.connect(func():
		#game_stats.combo_count = 0
		#print_debug("Ship Hit! Combo Broken! Max Combo: ", game_stats.maxcombo)
		#)
	
	
	
	# Game Over is the ship/player is destroyed
	ship.tree_exiting.connect(func():
		await get_tree().create_timer(1.0).timeout # Quick code for a timer
		get_tree().change_scene_to_file("res://menus/game_over.tscn")
	)
	
	# Game over if the ball loses all health
	player_ball.tree_exiting.connect(func():
		await get_tree().create_timer(1.0).timeout # Quick code for a timer
		get_tree().change_scene_to_file("res://menus/game_over.tscn")
	)
	
	# Move to the next level if all portals are destroyed
	game_stats.no_more_portals.connect(func():
		await get_tree().create_timer(1.0).timeout # Quick code for a timer
		get_tree().change_scene_to_file("res://menus/level_complete.tscn")
	)
	
	# heal the ball when a ball heal item is 
	ship.hurtbox_component.ball_heal.connect(func(ball_healbox_component: BallHealboxComponent):
		player_ball.stats_component.health += ball_healbox_component.heal
		if player_ball.stats_component.health > player_ball.stats_component.max_health: player_ball.stats_component.health = player_ball.stats_component.max_health
		)
	
	# Update the Ball Health GUI when the ball's health is changed
	player_ball.stats_component.health_changed.connect(func():
		#print_debug(player_ball.stats_component.health)
		# make sure the ball's max health is never exceeded
		ball_health.update_hearts(player_ball.stats_component.health,player_ball.stats_component.max_health)
		)
	
# keep track of how much damage the ship/player takes in a level
	player_ball.hurtbox_component.hurt.connect(func(hitbox_component: HitboxComponent):
		game_stats.ball_damage_taken += hitbox_component.damage
		print_debug("Ball lost! Total Damage: ", game_stats.ball_damage_taken)
	)
	
	# Get the number of EnemyPortals in the start of the level 
	# and store that number in the game stats
	var enemy_portal_total = get_children().filter(func(n):
		return n is EnemyPortal).size()
	print_debug(enemy_portal_total)
	# Set the number of enemy portals in the game stats
	game_stats.portal_count = enemy_portal_total


# Function to update the score label in the level GUI
func update_score_label(new_score: int) -> void:
	score_label.text = "Score: " + str(new_score)

# Function to make the combo count visible once a 
func make_combo_visible() -> void:
	rich_combo_label.show()

# Function to make the combo count visible once a 
func make_combo_invisible() -> void:
	rich_combo_label.hide()

# Function to update the score label in the level GUI
func update_rich_combo_label(new_combo: int, max_combo: int) -> void:
	if new_combo >= 40:
		rich_combo_label.text = "[center][pulse][shake rate = "+str(new_combo-20)+"][rainbow freq=."+str(40/10)+" sat = 0.8 val =.5]Combo: " + str(new_combo) + " / " +str(max_combo) + "[/rainbow][/shake][/pulse][/center]"
	elif new_combo >= 20:
		rich_combo_label.text = "[center][wave amp = 100 freq="+str(10)+"][rainbow freq=."+str(new_combo/10)+" sat = 0.8 val =.5]Combo: " + str(new_combo) + " / " +str(max_combo) + "[/rainbow][/wave][/center]"
	elif new_combo >= 10:
		rich_combo_label.text = "[center][wave amp = 100 freq="+str(10)+"]Combo: " + str(new_combo) + " / " +str(max_combo) + "[/wave][/center]"
	else:
		rich_combo_label.text = "[center][wave amp = 100 freq="+str(new_combo)+"]Combo: " + str(new_combo) + " / " +str(max_combo) + "[/wave][/center]"
		#rich_combo_label.text = "[center][shake level = 5 rate="+str(new_combo)+"]Combo: " + str(new_combo) + " / " +str(max_combo) + "[/shake][/center]"
	
func break_rich_combo_label():
	combo_break_shatter_animation.text =  rich_combo_label.text
	combo_break_shatter_animation.show()
	combo_break_shatter_animation.text = "[center][shatter]" + rich_combo_label.text + "[/shatter][/center]"
	rich_combo_label.hide()

func _process(delta: float) -> void:
	if Input.is_action_pressed("Test"):
		combo_break_shatter_animation.text =  rich_combo_label.text
		combo_break_shatter_animation.show()
		combo_break_shatter_animation.text = "[center][shatter]" + rich_combo_label.text + "[/shatter][/center]"
		rich_combo_label.hide()
		
