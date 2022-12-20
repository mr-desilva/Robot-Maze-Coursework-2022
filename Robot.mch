/* Robot
 * Author: andre
 * Creation date: 12/19/2022
 */
MACHINE
       Robot
SEES
       Maze
SETS
       REPORT = {Success_Move, Internal_Wall_Collision, Maze_Boundary_Collision};
       TELEPORT_MESSAGE = {Teleport_to_Internal_Wall_Denied, Teleport_to_same_square_Denied, Success_Teleport};
       BOOLEAN = {Yes, No};
       MOVEMENT_DIRECTION = {Moved_North, Moved_South, Moved_East, Moved_West, Teleport}
DEFINITIONS
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
       robotXPos := 1 ||
       robotYPos := 1 ||
       visitedMazeSquares := [maze_initial_square] ||
       movementHistory := []
OPERATIONS
       report <-- moveNorth = 
       PRE
              not(isMazeExit) & isWithinMaze(robotXPos, robotYPos)
       THEN
              IF
                     isMovingToEmptySquare(robotXPos, robotYPos + 1) & isWithinMaze(robotXPos, robotYPos + 1)
              THEN
                     robotYPos := robotYPos + 1 ||
                     visitedMazeSquares := visitedMazeSquares <- (robotXPos |-> robotYPos) ||
                     report := Success_Move ||
                     movementHistory := movementHistory <- Moved_North
              ELSIF
                     isInternalWallCollision(robotXPos, robotYPos + 1)
              THEN
                     report := Internal_Wall_Collision
              ELSE
                     report := Maze_Boundary_Collision
              END
       END;
       
       report <-- moveSouth = 
       PRE
              not(isMazeExit) & isWithinMaze(robotXPos, robotYPos)
       THEN
              IF
                     isMovingToEmptySquare(robotXPos, robotYPos - 1) & isWithinMaze(robotXPos, robotYPos - 1)
              THEN
                     robotYPos := robotYPos - 1 ||
                     visitedMazeSquares := visitedMazeSquares <- (robotXPos |-> robotYPos) ||
                     report := Success_Move ||
                     movementHistory := movementHistory <- Moved_South
              ELSIF
                     isInternalWallCollision(robotXPos, robotYPos - 1)
              THEN
                     report := Internal_Wall_Collision
              ELSE
                     report := Maze_Boundary_Collision
              END
       END;
       
       report <-- moveEast = 
       PRE
              not(isMazeExit) & isWithinMaze(robotXPos, robotYPos)
       THEN
              IF
                     isMovingToEmptySquare(robotXPos + 1, robotYPos) & isWithinMaze(robotXPos + 1, robotYPos)
              THEN
                     robotXPos := robotXPos + 1 ||
                     visitedMazeSquares := visitedMazeSquares <- (robotXPos |-> robotYPos) ||
                     report := Success_Move ||
                     movementHistory := movementHistory <- Moved_East
              ELSIF
                     isInternalWallCollision(robotXPos + 1, robotYPos)
              THEN
                     report := Internal_Wall_Collision
              ELSE
                     report := Maze_Boundary_Collision
              END
       END;
       
       report <-- moveWest = 
       PRE
              not(isMazeExit) & isWithinMaze(robotXPos, robotYPos)
       THEN
              IF
                     isMovingToEmptySquare(robotXPos - 1, robotYPos) & isWithinMaze(robotXPos - 1, robotYPos)
              THEN
                     robotXPos := robotXPos - 1 ||
                     visitedMazeSquares := visitedMazeSquares <- (robotXPos |-> robotYPos) ||
                     report := Success_Move ||
                     movementHistory := movementHistory <- Moved_West
              ELSIF
                     isInternalWallCollision(robotXPos - 1, robotYPos)
              THEN
                     report := Internal_Wall_Collision
              ELSE
                     report := Maze_Boundary_Collision
              END
       END;
       
       currentPosition <-- getPosition =
       BEGIN
              currentPosition := robotXPos |-> robotYPos
       END;
       
       foundExitSquare <-- foundExit = 
       PRE
              foundExitSquare : BOOLEAN
       THEN
              IF
                     (isMazeExit)
              THEN
                     foundExitSquare := Yes
              ELSE
                     foundExitSquare := No
              END
       END;
       
       isVisitedSquare <-- visitedSquare(robotX, robotY) =
       PRE
              robotX : maze_x_range &
              robotY : maze_y_range
       THEN
              IF
                     (robotX |-> robotY : ran(visitedMazeSquares))
              THEN
                     isVisitedSquare := Yes
              ELSE
                     isVisitedSquare := No
              END
       END;
       
       
       robotRoute <-- getRobotRoute =
       BEGIN
              robotRoute := visitedMazeSquares
       END;
       
       resetSystem =
       BEGIN
              robotXPos := 1 ||
              robotYPos := 1 ||
              visitedMazeSquares := [maze_initial_square] ||
              movementHistory := []
       END;
       
       
       // Tel Function
       
       teleportMessage <-- teleportRobot(teleportX, teleportY) = 
       PRE
              not(isMazeExit) &
              teleportX : maze_x_range &
              teleportY : maze_y_range
       THEN
              IF
                     isMovingToEmptySquare(teleportX, teleportY)
              THEN
                     IF
                            teleportX = robotXPos & teleportY = robotYPos
                     THEN
                            teleportMessage := Teleport_to_same_square_Denied
                     ELSE
                            IF
                                   not(isInternalWallCollision(teleportX, teleportY))
                            THEN
                                   robotXPos := teleportX ||
                                   robotYPos := teleportY ||
                                   visitedMazeSquares := visitedMazeSquares <- (robotXPos |-> robotYPos) ||
                                   movementHistory := movementHistory <- Teleport ||
                                   teleportMessage := Success_Teleport
                            ELSE
                                   teleportMessage := Teleport_to_Internal_Wall_Denied
                            END
                     END
              ELSE
                     teleportMessage := Teleport_to_Internal_Wall_Denied 
              END
       END
END
