shader_type canvas_item;

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;
    float dist = length(UV - vec2(0.5));
    float alpha = smoothstep(0.5, 0.0, dist);
    COLOR = vec4(vec3(1.0), alpha) * texture(TEXTURE, UV);
}
