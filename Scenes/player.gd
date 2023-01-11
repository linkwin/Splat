extends KinematicBody2D


export var gravity_dir = Vector2.DOWN
export var gravity_speed = 6000
export var gravity_acc = 2

var current_influence_body
var gravity_changed = false

var velocity = Vector2.ZERO
export var move_speed = 3000
export var move_acc = 8

export var friction_decel = 8
var last_move_dir = Vector2.ZERO

onready var move_update_vec = Vector2.ZERO
onready var gravity_update_vec = Vector2.ZERO



func _physics_process(delta):
	var move_vec = Vector2.ZERO
	
	var move_dir = Vector2(gravity_dir.y, -1 * gravity_dir.x) # move dir orthogonal to gravity dir
	move_dir = (Input.get_action_strength("right") - Input.get_action_strength("left")) * move_dir
		
	if is_move_input_held() and move_dir != Vector2.ZERO:
		last_move_dir = move_dir

	#===Gravity=====
	var target_gravity_velocity = gravity_speed * gravity_dir * delta
	
	var temp_vel = abs_of_vector(gravity_dir) * velocity + gravity_dir * gravity_acc
	if abs_of_vector(velocity * gravity_dir) < abs_of_vector(target_gravity_velocity) or gravity_changed:
		gravity_changed = false
		if abs_of_vector(temp_vel) > abs_of_vector(target_gravity_velocity):
			gravity_update_vec = target_gravity_velocity
		else:
			gravity_update_vec = temp_vel
	#=============
	#===MOVE===
	var target_move_velocity = move_speed * move_dir * delta
	var local_vel
	if is_move_input_held() and move_dir != Vector2.ZERO:
		local_vel = abs_of_vector(move_dir) * velocity + move_dir * move_acc #player moving
		if abs_of_vector(local_vel) > abs_of_vector(target_move_velocity):
			move_update_vec = target_move_velocity
		else:
			move_update_vec = local_vel
	else:
		local_vel = abs_of_vector(last_move_dir) * velocity - last_move_dir * friction_decel
		if abs_of_vector(velocity * last_move_dir) > abs_of_vector(target_move_velocity):
			if abs_of_vector(local_vel) > abs_of_vector(target_move_velocity):#target move velocity is zero here
				move_update_vec = local_vel
			if last_move_dir < Vector2.ZERO and local_vel > Vector2.ZERO or \
				last_move_dir > Vector2.ZERO and local_vel < Vector2.ZERO:
					move_update_vec = target_move_velocity
	#=========
	
	
	
#	print(gravity_dir * gravity_update_vec)
#	print(last_move_dir * move_update_vec)
	
	
	velocity = move_and_slide(abs_of_vector(last_move_dir) * move_update_vec + abs_of_vector(gravity_dir) * gravity_update_vec)
	
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if "Planet" in collision.collider.name:
			current_influence_body = collision.collider
			
	if current_influence_body != null:
		gravity_dir = (current_influence_body.global_position - global_position).normalized()
		gravity_changed = true		

	if Input.is_action_just_pressed("space"):
		gravity_dir *= Vector2(-1,-1)
		gravity_changed = true
func abs_of_vector(vector):
	return Vector2(abs(vector.x), abs(vector.y))

func is_move_input_held():
	return Input.get_action_strength("left") != 0 or Input.get_action_strength("right") != 0
	
