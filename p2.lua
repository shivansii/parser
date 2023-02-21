-- Define a function to trim leading and trailing white space characters from a string
local function trim(s)
    return s:match'^%s*(.*%S)' or ''
  end
  
  -- Define a function to convert a Markdown header to HTML
  local function parse_header(line)
      local level = 0
      while line:sub(1, 1) == "#" do
          level = level + 1
          line = line:sub(2)
      end
      return "<h" .. level .. ">" .. trim(line) .. "</h" .. level .. ">"
  end
  
  -- Define a function to convert Markdown text to HTML
  local function parse_markdown(markdown_text)
      local lines = {}
      for line in markdown_text:gmatch("[^\n]+") do
          if line:match("^#") then
              table.insert(lines, parse_header(line))
          else
              -- Add more rules here for other Markdown syntax
              table.insert(lines, "<p>" .. trim(line) .. "</p>")
          end
      end
      return table.concat(lines, "\n")
  end
  
  -- Read in the Markdown text from a file
  local markdown_text = io.open("test.md"):read("*all")
  
  -- Convert the Markdown text to HTML
  local html_text = parse_markdown(markdown_text)
  
  -- Write the resulting HTML to a file
  io.open("output.html", "w"):write(html_text)