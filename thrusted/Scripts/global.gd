extends Node

var global_engine_thrust: float = 1000
var global_spin_thrust: float = 3500
enum Asteroid {LARGE, BIG, MED, SMALL, TINY}
enum GameMode {PLAYER, AGENT}
var applyVisuals_Audio: bool = true
var game_mode = GameMode.PLAYER
