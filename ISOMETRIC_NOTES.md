# Isometric Implementation Notes

## Art Style
All placeholder art is now drawn in isometric perspective:
- **Tiles**: Diamond/rhombus shapes (64x64) with isometric perspective
- **Cars**: Top-down isometric view showing the car from above at an angle
- **Normal Maps**: Matching isometric shapes for proper lighting

## Grid System
- Uses regular orthogonal grid system for simplicity
- Tiles are diamond-shaped sprites arranged on the grid
- The isometric effect comes from the sprite art, not coordinate transformation
- This matches games like Loop Hero where tiles are isometric but grid is regular

## Tile Shapes
All tiles use the standard isometric diamond shape:
- Points: (32,8) - (56,32) - (32,56) - (8,32)
- This creates a 2:1 isometric ratio (standard for isometric games)

## Car Sprites
- Cars are drawn in isometric top-down perspective
- Diamond/rhombus shape showing car from above
- Wheels are ellipses rotated to match isometric perspective

## Future Improvements
- Could implement true isometric coordinate system if needed
- Could add depth sorting for overlapping tiles
- Could add isometric shadows for more depth
