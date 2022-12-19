/* Robot
 * Author: Tharindu
 * Creation date: 12/19/2022
 */
MACHINE
       Robot
SETS
       REPORT = {Exceeding_Maze_Boundary, Maze_Wall_Collision,
              Moved_North, Moved_East, Moved_South, Moved_West,
       Cannot_Teleport_Immediately, Cannot_Teleport_To_The_Same_Square, Teleported, Yes, No}
VARIABLES
       robotXPos, robotYPos, CurrentPos, VisitedSquares
INVARIANT
       robotXPos : x_axis_range &
       robotYPos : y_axis_range &
       currentPosition : maze &
       visitedSquare : seq(maze)
INITIALISATION
       robotXPos := 1||
       robotYPos := 1||
       currentPosition := ( 1 |-> 1 ) ||
       visitedSquares := [( 1 |-> 1 )]
OPERATIONS
       /*moveNorth*/
END
