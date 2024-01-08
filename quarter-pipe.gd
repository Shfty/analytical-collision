extends Area2D

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if body is RigidBody2D:
			# Find local-space position of overlapping body
			var relative = body.global_transform.origin - global_transform.origin

			# If the body center lies outside the box, skip
			# (this is specific to lower-right quarter pipes)
			if relative.x < 0 or relative.y < 0:
				continue

			# The quarter-pipe radius is the width of this area
			var radius = scale.x

			# Shrink radius to account for overlapping body radius
			var collider = body.get_node("CollisionShape2D")
			radius -= collider.shape.radius

			# If body exceeds radius, depenetrate
			if relative.length() > radius:
				# Calculate depenetrated position
				var to_pos =  global_transform.origin + relative.normalized() * radius

				# Calculate delta position
				var d = to_pos - body.global_transform.origin

				# Move body to depenetrated position
				body.global_transform.origin = to_pos

				# Adjust velocity to account for depenetration
				body.linear_velocity += d / delta
