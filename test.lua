function file_exists(file)
    -- Opens a file in read
   file = io.open("test.lua", "r")

-- sets the default input file as test.lua
io.input(file)

-- prints the first line of the file
print(io.read())

-- closes the open file
io.close(file)
   local f = io.open(file, "rb")
   if f then f:close() end
   return f ~= nil
 end
 
 -- get all lines from a file, returns an empty 
 -- list/table if the file does not exist
 function lines_from(file)
   if not file_exists(file) then return {} end
   local lines = {}
   for line in io.lines(file) do 
     lines[#lines + 1] = line
   end
   return lines
 end
 
 -- tests the functions above
 local file = 'test.lua'
 local lines = lines_from(file)
 
 -- print all line numbers and their contents
 for k,v in pairs(lines) do
   print('line[' .. k .. ']', v)
 end