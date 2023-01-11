extends KinematicBody2D

var gravity_dir = Vector2.DOWN
export var gravity_speed = 6000
export var gravity_acc = 2

var velocity = Vector2.ZERO
export var move_speed = 3000
export var move_acc = 8

export var friction_decel = 8
var last_move_dir = Vector2.ZERO

onready var move_update_vec = Vector2.ZERO
onready var gravity_update_vec = Vector2.ZERO

func _physics_process(delta):
	var move_vec = Vector2.ZERO
	
	var move_dir = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), 0)
	
	var left = -1 * Input.get_action_strength("left")
	var right = Input.get_action_strength("right")
	
	if left != 0:
		move_vec.x = left * move_speed
	if right != 0:
		move_vec.x = right * move_speed
		
	if is_move_input_held():
		last_move_dir = move_dir

	#Gravity=====
	var target_gravity_velocity = gravity_speed * gravity_dir * delta
	
	var temp_vel = gravity_dir * velocity + gravity_dir * gravity_acc
	if velocity * gravity_dir < target_gravity_velocity:
		if abs_of_vector(temp_vel) > abs_of_vector(target_gravity_velocity):
			gravity_update_vec = target_gravity_velocity
			print("HUUUUHH")
		else:
			gravity_update_vec = temp_vel
	#=============
	
	var target_move_velocity = move_speed * move_dir * delta
	var local_vel
	if is_move_input_held():
		local_vel = abs_of_vector(move_dir) * velocity + move_dir * move_acc #player moving
		if abs_of_vector(local_vel) > abs_of_vector(target_move_velocity):
			move_update_vec = target_move_velocity
		else:
			move_update_vec = local_vel
	else:
		local_vel = velocity - last_move_dir * friction_decel
		if abs_of_vector(local_vel) > abs_of_vector(target_move_velocity):
			move_update_vec = local_vel
		if last_move_dir < Vector2.ZERO:
			if local_vel > Vector2.ZERO:
				move_update_vec = target_move_velocity
		elif last_move_dir > Vector2.ZERO:
			if local_vel < Vector2.ZERO:
				move_update_vec = target_move_velocity



	print(gravity_dir * gravity_update_vec)
	print(last_move_dir * move_update_vec)
	
	
	velocity = move_and_slide(abs_of_vector(last_move_dir) * move_update_vec + gravity_dir * gravity_update_vec)
	
func abs_of_vector(vector):
	return Vector2(abs(vector.x), abs(vector.y))

func is_move_input_held():
	return Input.get_action_strength("left") != 0 or Input.get_action_strength("right") != 0
