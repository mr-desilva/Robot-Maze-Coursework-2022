# Robot-Maze-Coursework-2022
## Introduction
This coursework requires you to develop a B specification of a Robot moving around a simple Maze, using the B tools Atelier B & ProB. 

Figure 1. gives the layout of the rectangular shaped maze, the Robot is represented by "•" & its starting position is the entry square (1, 1). The aim is to move the robot from the entry square through the maze using the various movement operations to get to the exit square of the maze (1, 5). 


<img src = "https://github.com/mr-desilva/Robot-Maze-Coursework-2022/blob/main/Documentation/Figure1.PNG">


Notes
- The squares of the maze form a grid of squares 7 wide by 5 high.
- The robot occupies only one square at a time & can only be in an "empty maze square", i.e. a square inside the maze and not one of the maze's internal walls. For example, the robot can be in square (5, 3), one of the maze's "path" squares, but not (4, 2) an "internal wall" square. 
- The robot starts off in the entrance square, i.e. the bottom left square (1, 1). 
- The robot can be moved around the maze by using one of four directions: North ↑, South ↓, East → and West ←; or it can "teleport" to one of the maze's "path" squares. 
- Once the robot has found the exit square it can not make any further moves.

## Structure Diagram
<img src = "https://github.com/mr-desilva/Robot-Maze-Coursework-2022/blob/main/Structure Diagram/Structure Diagram.jpeg">
