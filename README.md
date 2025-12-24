# Route Rally - Isometric Driving Circuit Builder

A Godot 4.5 game combining incremental gameplay with isometric driving mechanics, featuring dynamic lighting with normal maps.

## Features

### Core Gameplay
- **Isometric 2D Driving**: Single-stick control system where you point in a direction and drive
- **Drift Mechanics**: Slam the stick sideways while braking to drift around corners
- **Tile-Based Circuit Building**: Place road pieces, nature, and mountains to build your circuit
- **Auto-Connecting Roads**: Roads automatically adjust and connect based on neighboring tiles

### Progression System
- **Earn Money Through**:
  - Drifting around corners
  - Completing laps
  - Near misses with traffic
  - Passing other drivers
  - Lapping other drivers
- **Garage System**: Spend money to unlock new tiles and upgrades
- **Unlock Chain**: Garage items unlock new road types and tile varieties

### Visual Features
- **Normal Map Lighting**: 2D sprites with normal maps for realistic lighting
- **Dynamic Time of Day**: Lighting changes throughout the day/night cycle
- **Directional Light**: Light direction changes based on time of day

### Game Modes
- **Driving Mode**: Drive your circuit, earn money, interact with traffic
- **Pause Mode**: Pause at any time to place new tiles on your circuit
- **Garage Mode**: Spend earned money to unlock new content

## Controls

- **Arrow Keys / WASD**: Drive direction (single stick control)
- **Space**: Brake
- **ESC**: Pause / Resume
- **Mouse**: Place tiles when paused

## Project Structure

```
/workspace/
├── scenes/
│   ├── Main.tscn              # Main menu
│   ├── GarageScene.tscn       # Garage/base for spending money
│   ├── DrivingScene.tscn      # Main driving scene
│   ├── Tiles/                 # Tile prefabs
│   └── AI/                    # AI car prefabs
├── scripts/
│   ├── GameManager.gd         # Global game state management
│   ├── PlayerData.gd          # Player progression data
│   ├── Driving/               # Driving mechanics
│   ├── Tiles/                 # Tile system
│   ├── Garage/                # Garage UI
│   ├── AI/                    # Traffic AI
│   ├── Scoring/               # Score/money system
│   └── UI/                    # UI components
├── shaders/
│   └── normal_map_lighting.gdshader  # Normal map lighting shader
└── project.godot              # Godot project configuration
```

## Getting Started

1. Open the project in Godot 4.5
2. Run the project (F5)
3. Start from the main menu
4. Go to Garage to see available unlocks
5. Start Driving to begin building your circuit

## Development Notes

- The game uses Godot 4.5's Forward Plus renderer for optimal 2D lighting
- Normal maps are applied via shader materials for dynamic lighting effects
- Tile placement uses a grid-based system with automatic road connection logic
- Driving physics are arcade-style, not simulation-based
- All progression is saved in PlayerData singleton

## Future Enhancements

- Save/load system for circuits
- More tile types and road pieces
- Additional garage upgrades
- Visual polish with proper sprites and normal maps
- Sound effects and music
- Particle effects for drifting
