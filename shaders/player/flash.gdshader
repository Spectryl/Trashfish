shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec4 flash_color: source_color = vec4(1.0);
uniform float flash_modifier : hint_range(0.0, 1.0) = 1;

void fragment() {
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	color.rgb = mix(color.rgb, flash_color.rgb, flash_modifier);
	COLOR = color;

}


