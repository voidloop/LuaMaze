-- Maze.lua
-- A maze generator module

local Stack = require("Stack")

local Maze = {}
Maze.__index = Maze

local CELL_UNVISITED = 2
local CELL_VISITED = 3

-- helper function to create the maze: given
-- a cell (x, y) this function returns its
-- neighbours table
local function unvisitedNeighbors(maze, cell)
   local neighbors = {}
   local x, y = cell.x, cell.y
   if x > 2 and maze.mat[y][x-2] == CELL_UNVISITED then
      table.insert(neighbors, { x=x-2, y=y }) 
   end
   if x < maze.width-2 and maze.mat[y][x+2] == CELL_UNVISITED then 
      table.insert(neighbors, { x=x+2, y=y }) 
   end
   if y > 2 and maze.mat[y-2][x] == CELL_UNVISITED then
      table.insert(neighbors, { x=x, y=y-2 })
   end
   if y < maze.height-2 and maze.mat[y+2][x] == CELL_UNVISITED then
      table.insert(neighbors, { x=x, y=y+2 })
   end
   return neighbors
end

-- helper function to create the maze: given
-- two cells, removes the wall between them
local function removeWall(maze, cell1, cell2)
   if cell1.x - cell2.x == 0 then
      y = (cell1.y + cell2.y)/2
      maze.mat[y][cell1.x] = CELL_VISITED
   elseif cell1.y - cell2.y == 0 then 
      local x = (cell1.x + cell2.x)/2
      maze.mat[cell1.y][x] = CELL_VISITED
   end
end

-- creates a new maze class
function Maze:new(width, height)
   -- init maze with the right sizes
   local width = math.floor(width/2)*2 + 1
   local height = math.floor(height/2)*2 + 1
   local maze = { mat = {}, 
		  width=width, 
		  height=height }

   -- init the maze's mat
   for i = 1, height do 
      maze.mat[i] = {}
      for j = 1, width do 
	 maze.mat[i][j] = CELL_UNVISITED
      end
   end

   return setmetatable(maze, Maze)
end

-- generates the maze (using DFS algo)
function Maze:generate() 
   math.randomseed(os.time())
   stack = Stack:new()   
   -- using even cells
   stack:push({ x=2, y=2 })
   while #stack > 0 do
      local cell = stack:peek()
      -- mark cell as visited
      self.mat[cell.y][cell.x] = CELL_VISITED
      -- visit a random neighbor
      local neighbors = unvisitedNeighbors(self, cell)
      if #neighbors > 0 then
	 local randomCell = neighbors[math.random(1, #neighbors)]
	 removeWall(self, cell, randomCell)
	 stack:push(randomCell)
      else
	 -- backtrack
	 stack:pop()
      end
   end
end

-- Returns the maze class
return Maze


