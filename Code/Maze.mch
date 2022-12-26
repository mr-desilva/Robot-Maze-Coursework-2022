/* Maze
 * Author: Tharindu
 * Creation date: 12/19/2022
 */
MACHINE
    Maze
CONSTANTS
    maze_x_range,
    maze_y_range,
    maze,
    internal_walls,
    maze_initial_square,
    maze_exit_square,
    maze_empty_square
    
PROPERTIES
    // Maze x and y axis ranges
    maze_x_range <: NATURAL1 & maze_x_range = 1..7 & 
    maze_y_range <: NATURAL1 & maze_y_range = 1..5 &
    
    /* 
    Maze and internal walls are relation of maze x and y ranges
    Maze is the product of maze x and y range
    */
    maze : maze_x_range <-> maze_y_range &
    maze = maze_x_range * maze_y_range &

    internal_walls : maze_x_range <-> maze_y_range &
    internal_walls = {
        (2 |-> 1), (6 |-> 1), (4 |-> 2), (6 |-> 2), (1 |-> 3), (2 |-> 3), (3 |-> 3), (4 |-> 3), (4 |-> 4), (6 |-> 4), (7 |-> 4), (2 |-> 5)
    } &
    
    /*
    Maze empty square is a subset or equal to maze
    Maze empty square cannot be a internal square
    Union of Maze empty square and internal walls represent the maze
    */
    maze_empty_square <: maze &
    maze_empty_square /\ internal_walls = {} &
    maze_empty_square \/ internal_walls = maze &
    
    /*
    maze initial square should be a element of maze empty square
    */
    maze_initial_square : maze_empty_square &
    maze_initial_square = 1 |-> 1 &
       
    maze_exit_square : maze_empty_square &
    maze_exit_square = 1 |-> 5
   
    
END