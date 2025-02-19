class_name GameStats

extends Resource

@export var score: int = 0 :
	set(value):
		score = value
		score_changed.emit(score)

@export var highscore: int = 0

@export var portal_count: int = 100 :
	set(value):
		portal_count = value
		if portal_count == 0:
			no_more_portals.emit()

@export var enemy_passed_count: int = 0 :
	set(value):
		enemy_passed_count = value
		
		
@export var enemy_destroyed_count: int = 0 :
	set(value):
		enemy_destroyed_count = value

@export var combo_count: int = 0 :
	set(value):
		if value == 0 and combo_count !=0: combo_broken.emit()
		combo_count = value
		combo_changed.emit(combo_count, maxcombo)
		if combo_count >= 3: min_combo_reached.emit()
		
@export var maxcombo: int = 0 :
	set(value):
		maxcombo = value

@export var damage_taken: int = 0 :
	set(value):
		damage_taken = value
		
@export var ball_damage_taken: int = 0 :
	set(value):
		ball_damage_taken = value

signal score_changed(new_score)
signal combo_changed(new_combo,maxcombo)
signal combo_broken()
signal no_more_portals()
signal min_combo_reached()
