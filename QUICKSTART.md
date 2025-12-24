# Quick Start Guide

## Opening the Project

1. Open Godot 4.5
2. Click "Import" and select the `project.godot` file
3. Click "Import & Edit"

## Running the Game

1. Press F5 or click the Play button
2. You'll start at the Main Menu
3. Click "Start Game" to begin driving, or "Garage" to see unlocks

## Controls

- **Arrow Keys / WASD**: Drive direction (point stick in direction you want to go)
- **Space**: Brake
- **ESC**: Pause (allows tile placement)
- **Mouse Click**: Place tiles when paused

## Gameplay Loop

1. **Drive** around the circuit
2. **Drift** around corners (hold direction + brake) to earn money
3. **Complete laps** to earn more money
4. **Pass traffic** or have near misses for bonus money
5. **Pause** (ESC) to place new tiles and expand your circuit
6. **Return to Garage** to spend money on unlocks
7. **Unlocks** give you new tile types to place

## First Steps

1. Start driving - you begin with a simple rectangular loop
2. Try drifting: Hold a direction key and press Space while turning
3. Complete a lap to earn your first money
4. Pause and try placing a new road tile
5. Go to Garage and unlock Nature tiles (costs 100)
6. Return to driving and place nature tiles around your track

## Tips

- Drifting is the primary money source early game
- Roads automatically connect when placed next to each other
- Time of day changes automatically, affecting lighting
- Traffic cars spawn automatically - try passing them!
- Near misses with traffic give bonus money

## Troubleshooting

- If tiles don't place: Make sure you've selected a tile in the pause menu first
- If driving feels off: Adjust the car's speed/friction in PlayerCar.gd
- If lighting doesn't work: Make sure Forward Plus renderer is enabled in project settings
