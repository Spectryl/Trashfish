shader_type canvas_item;


uniform vec4 u_color_key : source_color = vec4(1.0);
uniform vec4 u_replacement_color : source_color = vec4(1.0);
uniform float u_tolerance : hint_range(0.0, 1.0) = 1;

void fragment() {
	
	vec4 original_color = texture(TEXTURE, UV); //original color
	vec3 color_rgb = original_color.rgb; // RGB values
	
	vec3 diff3 = color_rgb - u_color_key.rgb; // Difference between the new value and the original
	float m = max(max(abs(diff3.r), abs(diff3.g)), abs(diff3.b)); // The max between each rgb value
	float brightness = length(color_rgb);
	color_rgb = mix(color_rgb, u_replacement_color.rgb * brightness, step(m, u_tolerance)); 
	COLOR = vec4(color_rgb.rgb, original_color.a);
}