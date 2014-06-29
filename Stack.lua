-- Stack.lua
-- Another stack inplementation in lua.

local Stack = {}
Stack.__index = Stack

-- creates a new stack object
function Stack:new()
   local stack = {}
   return setmetatable(stack, Stack)
end

-- Inserts new values on top of the stack
function Stack:push(...)
   for _,v in pairs({...}) do 
      self[#self+1] = v
   end
end

-- Removes top values from the stack and 
-- return them. Return nil if the stack
-- is empty
function Stack:pop(num)
   local num = num or 1
   local ret = {}
   for i = 1, num do 
      if #self ~= 0 then 
	 ret[#ret+1] = table.remove(self)
      else
	 break
      end
   end
   return unpack(ret)
end

-- Returs the top value from the stack
-- without remove it
function Stack:peek() 
   return self[#self]
end

-- Returns the Stack class
return Stack

