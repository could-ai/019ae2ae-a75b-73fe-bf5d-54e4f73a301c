# Aviator Game (Flutter)

This is a Flutter implementation of a simple "Aviator" style crash game, based on the Python logic provided.

## How to Play

1.  **Enter Bet**: Input your bet amount in the text field.
2.  **Start Game**: Click "START GAME" to launch the plane.
3.  **Watch Multiplier**: The multiplier increases over time.
4.  **Cash Out**: Click "CASH OUT" before the plane crashes to win your bet multiplied by the current value.
5.  **Crash**: If the plane crashes before you cash out, you lose your bet.

## Logic

-   **Multiplier Increase**: Randomly between 1.01x and 1.10x every 0.5 seconds.
-   **Crash Chance**: Increases as the multiplier grows, capped at 10% per tick.
