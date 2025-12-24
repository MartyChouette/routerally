shader_type canvas_item;

uniform float time_of_day : hint_range(0.0, 1.0) = 0.5;
uniform vec2 light_direction : hint_default(vec2(0.5, -0.5));
uniform float light_intensity : hint_range(0.0, 2.0) = 1.0;
uniform vec3 light_color : hint_color = vec3(1.0, 1.0, 0.9);
uniform sampler2D normal_texture : hint_normal;

varying vec2 world_position;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	vec4 base_color = texture(TEXTURE, UV);
	
	// Sample normal map if provided
	vec3 normal = vec3(0.5, 0.5, 1.0);  // Default flat normal
	if (normal_texture != null) {
		vec4 normal_map = texture(normal_texture, UV);
		// Convert normal map from [0,1] to [-1,1]
		normal = normalize(normal_map.rgb * 2.0 - 1.0);
	}
	
	// Calculate light direction in tangent space
	vec2 light_dir_normalized = normalize(light_direction);
	
	// Calculate dot product for lighting
	float light_factor = dot(normal.xy, light_dir_normalized);
	light_factor = max(0.0, light_factor);
	
	// Apply time of day color tinting
	vec3 time_color = mix(
		vec3(0.3, 0.3, 0.5),  // Night (blue)
		mix(
			vec3(1.0, 0.7, 0.5),  // Dawn/Dusk (orange)
			vec3(1.0, 1.0, 0.9),  // Day (warm white)
			smoothstep(0.25, 0.5, time_of_day) * smoothstep(0.75, 0.5, time_of_day)
		),
		smoothstep(0.0, 0.3, time_of_day) * smoothstep(1.0, 0.7, time_of_day)
	);
	
	// Combine lighting
	vec3 final_color = base_color.rgb * light_color * time_color * (0.3 + light_factor * light_intensity);
	
	COLOR = vec4(final_color, base_color.a);
}
