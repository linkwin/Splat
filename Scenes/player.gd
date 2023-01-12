extends KinematicBody2D

export var gravity_dir = Vector2.DOWN
export var gravity_speed = 6000
export var gravity_acc = 2

var gravity_changed = false
var last_gravity_dir = gravity_dir

var velocity = Vector2.ZERO
export var move_speed = 3000
export var move_acc = 8

export var friction_decel = 8
var last_move_dir = Vector2.ZERO

onready var move_update_vec = Vector2.ZERO
onready var gravity_update_vec = Vector2.ZERO

func _physics_process(delta):
	var move_vec = Vector2.ZERO
	
	var move_dir = Vector2( -1 * gravity_dir.y,gravity_dir.x) # move dir orthogonal to gravity dir
	if gravity_dir.y < 0:
		move_dir = Vector2( -1 * gravity_dir.y,gravity_dir.x)
	move_dir = (Input.get_action_strength("right") - Input.get_action_strength("left")) * move_dir
		
	if is_move_input_held() and move_dir != Vector2.ZERO:
		last_move_dir = move_dir

	#===Gravity=====
	var target_gravity_velocity = gravity_speed * gravity_dir * delta
	
	var temp_vel = abs_of_vector(gravity_dir) * velocity + gravity_dir * gravity_acc
	if abs_of_vector(velocity * gravity_dir) < abs_of_vector(target_gravity_velocity) or gravity_changed:
		if gravity_changed:
			print("yes")
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
		if abs_of_vector(velocity * last_move_dir) > abs_of_vector(target_move_velocity) or gravity_changed:
			
			if abs_of_vector(local_vel) > abs_of_vector(target_move_velocity):#target move velocity is zero here
				move_update_vec = local_vel
			if last_move_dir < Vector2.ZERO and local_vel > Vector2.ZERO or \
				last_move_dir > Vector2.ZERO and local_vel < Vector2.ZERO:
					move_update_vec = target_move_velocity
	#=========
	if gravity_changed:
		gravity_changed = false
	
	print(gravity_dir * gravity_update_vec)
	print(last_move_dir * move_update_vec)
	
	
	velocity = move_and_slide(abs_of_vector(last_move_dir) * move_update_vec + abs_of_vector(gravity_dir) * gravity_update_vec)
	last_gravity_dir = gravity_dir
	if Input.is_action_just_pressed("gravity_up"):
		gravity_dir = Vector2.UP
		gravity_changed = true
	if Input.is_action_just_pressed("gravity_down"):
		gravity_dir = Vector2.DOWN
		gravity_changed = true		
	if Input.is_action_just_pressed("gravity_left"):
		gravity_dir = Vector2.LEFT
		gravity_changed = true		
	if Input.is_action_just_pressed("gravity_right"):
		gravity_dir = Vector2.RIGHT
		gravity_changed = true		
		
	if Input.is_action_just_pressed("space"):
		gravity_dir *= Vector2(-1,-1)
		gravity_changed = true
		
	if gravity_changed:
		if last_gravity_dir.dot(gravity_dir) == 0:
			last_move_dir = Vector2(last_move_dir.y, -1 * last_move_dir.x)
			velocity = (velocity * last_gravity_dir).length() * gravity_dir
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if "MazeWalls" in collision.collider.name:
			get_tree().reload_current_scene()
	
func abs_of_vector(vector):
	return Vector2(abs(vector.x), abs(vector.y))

func is_move_input_held():
	return Input.get_action_strength("left") != 0 or Input.get_action_strength("right") != 0
	
