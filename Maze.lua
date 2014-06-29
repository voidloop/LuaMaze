-- Maze.lua
-- A maze generator module

local Stack = require("Stack")

local Maze = {}
Maze.__index = Maze

-- helper function to create the maze: given
-- a cell (x, y) this function returns its
-- neighbours table
local function unvisitedNeighbors(maze, cell)
   local neighbors = {}
   local x, y = cell.x, cell.y
   if x > 2 and maze.grid[y][x-2] == 0 then
      table.insert(neighbors, { x=x-2, y=y }) 
   end
   if x < maze.width-2 and maze.grid[y][x+2] == 0 then 
      table.insert(neighbors, { x=x+2, y=y }) 
   end
   if y > 2 and maze.grid[y-2][x] == 0 then
      table.insert(neighbors, { x=x, y=y-2 })
   end
   if y < maze.height-2 and maze.grid[y+2][x] == 0 then
      table.insert(neighbors, { x=x, y=y+2 })
   end
   return neighbors
end

-- helper function to create the maze: given
-- two cells, removes the wall between them
local function removeWall(maze, cell1, cell2)
   if cell1.x - cell2.x == 0 then
      local y = (cell1.y + cell2.y)/2 
      maze.grid[y][cell1.x] = 1
   elseif cell1.y - cell2.y == 0 then 
      local x = (cell1.x + cell2.x)/2
      maze.grid[cell1.y][x] = 1
   end
end

-- creates a new maze class
function Maze:new(width, height)
   -- init the right size
   local width = (width/2)*2 + 1
   local height = (height/2)*2 + 1
   local maze = { grid = {}, width=width, height=height }

   -- init the maze's grid
   for i = 1, height do 
      maze.grid[i] = {}
      for j = 1, width do 
	 maze.grid[i][j] = 0
      end
   end

   return setmetatable(maze, Maze)
end

-- generates the maze
function Maze:generate() 
   math.randomseed(os.time())
   stack = Stack:new()   
   -- using even cells
   stack:push({ x=2, y=2 })
   while #stack > 0 do
      local cell = stack:peek()
      -- mark cell as visited
      self.grid[cell.y][cell.x] = 1
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


