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
      local in_table = false
      for line in markdown_text:gmatch("[^\n]+") do
          if line:match("^#") then
              table.insert(lines, parse_header(line))
              in_table = false
            elseif line:match("^|") then
                -- Handle table rows
                if not in_table then
                    -- Start of a new table
                    in_table = true
                    table_lines = {"<table>", "<thead>", "<tr>"}
                    for column in line:gmatch("|%s*([^\n]+)%s*") do
                        table.insert(table_lines, "<th>" .. column .. "</th>")
                    end
                    table.insert(table_lines, "</tr></thead><tbody>")
                else
                    -- Table continuation
                    table.insert(table_lines, "<tr>")
                    for column in line:gmatch("|%s*([^\n]+)%s*") do
                        table.insert(table_lines, "<td>" .. column .. "</td>")
                    end
                    table.insert(table_lines, "</tr>")
                end
            else
                -- Handle paragraphs
                if in_table then
                    -- End of the current table
                    in_table = false
                    table.insert(table_lines, "</tbody></table>")
                    table.insert(lines, table.concat(table_lines))
                end
        
              -- Check for bold
              line = line:gsub("%*%*(.-)%*%*", "<strong>%1</strong>")
              -- Check for italic
              line = line:gsub("%*(.-)%*", "<em>%1</em>")
              -- Check for strikethrough
              line = line:gsub("~~(.-)~~", "<del>%1</del>")
              -- Check for blockquote
              line = line:gsub("^%s*>%s*(.*)", "<blockquote>%1</blockquote>")
              -- Check for links
              line = line:gsub("%[(.-)%]%((.-)%)", "<a href='%2'>%1</a>")
              -- Check for images
              line = line:gsub("!%[(.-)%]%((.-)%)", "<img src='%2' alt='%1'>")
              -- Check for code
              line = line:gsub("`(.-)`", "<code>%1</code>")

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