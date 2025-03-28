shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec2 light_position;
uniform float light_radius;

void fragment() {
    vec2 frag_coord = SCREEN_UV * SCREEN_PIXEL_SIZE; 
    float dist = distance(frag_coord, light_position);

    if (dist < light_radius) {
        COLOR = texture(SCREEN_TEXTURE, SCREEN_UV); 
    } else {
        COLOR = vec4(0.0, 0.0, 0.0, dist/light_radius);
    }
}