-- see if the file exists
function file_exists(file)
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
      --[[local words = {}
      for word in line:gmatch("%w+") do 
        table.insert(words, word) 
        end  
    table.insert(lines, words)]]
    end
    return lines
  end
  
  -- Path: test.md
  function line_parser(v)
    -- check if the line is a header
    if v:match("^#") then
        if v:match("^##") then
            print("subheader")
        else
        print("header")
        end
    -- check for bold not nill
    elseif string.find(v, "%*%*.*%*%*") then
        i, j = string.find(v, "%*%*.*%*%*")
        print("bold", i, j)
    -- check if the line is a list
    -- elseif v:match("%*") then
    --     print("list")
    end


    end

  -- tests the functions above
  local file = 'test.md'
  local lines = lines_from(file)
  
  -- print all line numbers and their contents
  for k,v in pairs(lines) do
    -- pass a line to the parser
    line_parser(v)
    print('line[' .. k .. ']', v)
  end


