/* Robot
 * Author: Tharindu
 * Creation date: 12/19/2022
 */
MACHINE
       Robot
SEES
       Maze
SETS
       REPORT = {Success_Move, Internal_Wall_Collision, Maze_Boundary_Collision};
       TELEPORT_MESSAGE = {Teleport_to_Internal_Wall_Denied, Teleport_to_same_square_Denied, Success_Teleport, Cannot_Teleport_Immedietly, Teleport_Maze_Boundary_Collision};
       VISITED_OUTPUT_MESSAGE = {Yes, No,Inputs_Exceeding_Maze};
       MOVEMENT_DIRECTION = {Moved_North, Moved_South, Moved_East, Moved_West, Teleport}
DEFINITIONS
       /*
         isMovingToEmptySquare - checking the robot is moving to an empty square
         isMazeExit - checking the robot have reached the exit square
         isWithinMaze - checking the robot is within the maze boundary
         isInternalWallCollision - checking the robot is collided with a internal wall
       */
       isMovingToEmptySquare(xx, yy) == (xx |-> yy :maze_empty_square);
       isMazeExit == (robotXPos |-> robotYPos = maze_exit_square);
       isWithinMaze(xx,yy) == (xx |-> yy :maze);
       isInternalWallCollision(xx, yy) == (xx |-> yy :internal_walls)
VARIABLES
       robotXPos,
       robotYPos,
       visitedMazeSquares,
       movementHistory
       
INVARIANT
       robotXPos : maze_x_range &
       robotYPos : maze_y_range &
       robotXPos |-> robotYPos : maze_empty_square &
       visitedMazeSquares : seq(maze_empty_square) &
       movementHistory : seq(MOVEMENT_DIRECTION)
       
INITIALISATION
       /*
       projection function to get the ordered pair of the maze x and y range
       */
       robotXPos := prj1(maze_x_range, maze_y_range)(maze_initial_square) ||
       robotYPos := prj2(maze_x_range, maze_y_range)(maze_initial_square) ||
       visitedMazeSquares := [maze_initial_square] ||
       movementHistory := []
OPERATIONS
       /*
       moveNorth operation
       1. PRE 
              check for output message type
              check current x and y is within the maze
              Check the robot has exited the maze
       2. IF 
              Check the robot has exited the maze
              Check for internal wall collision with the moving x and y coordinates
              Check the moving coordinates are within the maze
       3. ELSE 
              Update the robotY value, add the visited maze square, update movement history
       */
       report <-- moveNorth = 
       PRE
              report : REPORT &
              not(isMazeExit) & isWithinMaze(robotXPos, robotYPos)
       THEN
              IF isInternalWallCollision(robotXPos, robotYPos + 1)
              THEN
                     report := Internal_Wall_Collision
              ELSIF not(isWithinMaze(robotXPos, robotYPos + 1))
              THEN
                     report := Maze_Boundary_Collision
              ELSE
                     robotYPos := robotYPos + 1 ||
                     visitedMazeSquares := visitedMazeSquares <- (robotXPos |-> robotYPos) ||
                     report := Success_Move ||
                     movementHistory := movementHistory <- Moved_North
              END              
       END;
       
       /*
       moveSouth operation
       1. PRE 
              check for output message type
              check current x and y is within the maze
              Check the robot has exited the maze
       2. IF 
              Check the robot has exited the maze
              Check for internal wall collision with the moving x and y coordinates
              Check the moving coordinates are within the maze
       3. ELSE 
              Update the robotY value, add the visited maze square, update movement history
       */
       report <-- moveSouth = 
       PRE
              report : REPORT &
              not(isMazeExit) & isWithinMaze(robotXPos, robotYPos)
       THEN
              IF isInternalWallCollision(robotXPos, robotYPos - 1)
              THEN
                     report := Internal_Wall_Collision
              ELSIF not(isWithinMaze(robotXPos, robotYPos - 1))
              THEN
                     report := Maze_Boundary_Collision
              ELSE
                     robotYPos := robotYPos - 1 ||
                     visitedMazeSquares := visitedMazeSquares <- (robotXPos |-> robotYPos) ||
                     report := Success_Move ||
                     movementHistory := movementHistory <- Moved_South
              END              
       END;
       
       /*
       moveEast operation
       1. PRE 
              check for output message type
              check current x and y is within the maze
              Check the robot has exited the maze
       2. IF 
              Check the robot has exited the maze
              Check for internal wall collision with the moving x and y coordinates
              Check the moving coordinates are within the maze
       3. ELSE 
              Update the robotX value, add the visited maze square, update movement history
       */
       report <-- moveEast = 
       PRE
              report : REPORT &
              not(isMazeExit) & isWithinMaze(robotXPos, robotYPos)
       THEN
              IF isInternalWallCollision(robotXPos + 1, robotYPos)
              THEN
                     report := Internal_Wall_Collision
              ELSIF not(isWithinMaze(robotXPos + 1, robotYPos))
              THEN
                     report := Maze_Boundary_Collision
              ELSE
                     robotXPos := robotXPos + 1 ||
                     visitedMazeSquares := visitedMazeSquares <- (robotXPos |-> robotYPos) ||
                     report := Success_Move ||
                     movementHistory := movementHistory <- Moved_East
              END              
       END;
       
       /*
       moveWest operation
       1. PRE 
              check for output message type
              check current x and y is within the maze
              Check the robot has exited the maze
       2. IF 
              Check the robot has exited the maze
              Check for internal wall collision with the moving x and y coordinates
              Check the moving coordinates are within the maze
       3. ELSE 
              Update the robotX value, add the visited maze square, update movement history
       */
       report <-- moveWest = 
       PRE
              report : REPORT &
              not(isMazeExit) & isWithinMaze(robotXPos, robotYPos)
       THEN
              IF isInternalWallCollision(robotXPos - 1, robotYPos)
              THEN
                     report := Internal_Wall_Collision
              ELSIF not(isWithinMaze(robotXPos - 1, robotYPos))
              THEN
                     report := Maze_Boundary_Collision
              ELSE
                     robotXPos := robotXPos - 1 ||
                     visitedMazeSquares := visitedMazeSquares <- (robotXPos |-> robotYPos) ||
                     report := Success_Move ||
                     movementHistory := movementHistory <- Moved_West
              END              
       END;
       
       // Get the current x and y values of the robot
       currentPosition <-- getPosition =
       BEGIN
              currentPosition := robotXPos |-> robotYPos
       END;
       
       // Return Yes,No for reaching the exit square
       foundExitSquare <-- foundExit = 
       PRE
              foundExitSquare : VISITED_OUTPUT_MESSAGE
       THEN
              IF
                     (isMazeExit)
              THEN
                     foundExitSquare := Yes
              ELSE
                     foundExitSquare := No
              END
       END;
       
       /*
       Check for the entered x and y value is a visited square
       1. PRE 
              check for input x and y values are within the range
              check for the current robot x and y values are within the maze
              check for output message type
       2. IF 
              Check input x and y values are within the maze
              THEN check for the input x and y value is a visited square coordinates
              Check for internal wall collision with the moving x and y coordinates
              Check the moving coordinates are within the maze
       3. ELSE
              if input for x and y is out of maze output error message       
              Return Yes,No for entering a the visited square
              
       */
       isVisitedSquare <-- visitedSquare(visitedSquareX, visitedSquareY) =
       PRE
              visitedSquareX : maze_x_range &
              visitedSquareX : NATURAL1 &
              visitedSquareY : maze_y_range &
              visitedSquareX : NATURAL1 &
              isWithinMaze(robotXPos, robotYPos) &
              isVisitedSquare : VISITED_OUTPUT_MESSAGE
       THEN
              IF (isWithinMaze(visitedSquareX, visitedSquareY))
              THEN
                     // using ran to remove the duplicates from the sequence
                     // front - discharging the last element from the sequence
                     IF
                            (visitedSquareX |-> visitedSquareY : ran(front(visitedMazeSquares)))
                     THEN
                            isVisitedSquare := Yes
                     ELSE
                            isVisitedSquare := No
                     END
              ELSE
                     isVisitedSquare := Inputs_Exceeding_Maze
              END              
       END;
       
       // Get robot visited squares details
       robotRoute <-- getRobotRoute =
       BEGIN
              robotRoute := visitedMazeSquares
       END;
       
       // reset the robot position and other history
       resetSystem =
       PRE
              isWithinMaze(robotXPos, robotYPos)
       THEN
              robotXPos := prj1(maze_x_range, maze_y_range)(maze_initial_square) ||
              robotYPos := prj1(maze_x_range, maze_y_range)(maze_initial_square) ||
              visitedMazeSquares := [maze_initial_square] ||
              movementHistory := []
       END;
       
       
      
       /*
       Check for the entered x and y value is a visited square
       1. PRE 
              check for output message type
              check current x and y is within the maze
              Check the robot has exited the maze
       2. IF 
              Check input x and y values are within the maze
              Check the robot has visited at least one square to prevent immediate teleport
              check the current robot position is equal with teleport position to prevent same position teleporting
              Check for internal wall collision with the teleporting x and y coordinates
       3. ELSE
              Update the robotX and robotY value, add the visited maze square, update movement history
              
       */
       teleportMessage <-- teleportRobot(teleportX, teleportY) = 
       PRE
              teleportMessage : TELEPORT_MESSAGE &
              not(isMazeExit) &
              isWithinMaze(robotXPos, robotYPos)&
              teleportX : maze_x_range &
              teleportY : maze_y_range
       THEN
              IF not(isWithinMaze(teleportX, teleportY))
              THEN
                     teleportMessage := Teleport_Maze_Boundary_Collision
              ELSIF (size(visitedMazeSquares) = 1)
              THEN
                     teleportMessage := Cannot_Teleport_Immedietly
              ELSIF (teleportX = robotXPos & teleportY = robotYPos)
              THEN
                     teleportMessage := Teleport_to_same_square_Denied
              ELSIF (isInternalWallCollision(teleportX, teleportY))
              THEN
                     teleportMessage := Teleport_to_Internal_Wall_Denied
              ELSE
                     robotXPos := teleportX ||
                     robotYPos := teleportY ||
                     visitedMazeSquares := visitedMazeSquares <- (robotXPos |-> robotYPos) ||
                     movementHistory := movementHistory <- Teleport ||
                     teleportMessage := Success_Teleport
              END
       END
       
END
