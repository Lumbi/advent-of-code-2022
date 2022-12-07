root = { type = "dir" }
working_dir = "/"

function print_dir(dir, depth)
    if depth == 0 then print("- /") end
    local indent = string.rep(" ", depth + 1) .. " - "
    for name, element in pairs(dir) do
        if element.type == "dir" then
            print(indent .. name .. "/")
            print_dir(element, depth + 1)
        elseif element.type == "file" then
            print(indent .. name .. " (" .. element.size .. ")")
        end
    end
end

function split (str, del)
    local del = del or "%s"
    local tokens = {}
    for str in string.gmatch(str, "([^"..del.."]+)") do table.insert(tokens, str) end
    return tokens
end

function resolve_path(path)
    local components = split(path, "/")
    local resolved_components = {}
    for _, component in ipairs(components) do
        if component == ".." then
            table.remove(resolved_components)
        else
            table.insert(resolved_components, component)
        end
    end
    return resolved_components
end

function exec_mkdir (path)
    local components = resolve_path(path)
    local current_dir = root
    for _, component in ipairs(components) do
        if current_dir[component] == nil then
            current_dir[component] = { type = "dir" }
        end
        current_dir = current_dir[component]
    end
    return current_dir
end

function exec_cd (dir)
    local target = working_dir .. "/" .. dir
    local new_dir = exec_mkdir(target)
    working_dir = target
end

function exec_ls (files)
    local dir = exec_mkdir(working_dir)
    for name, size in pairs(files) do
        dir[name] = { type = "file", size = size }
    end
end

function load()
    io.input("input.txt")

    function begin()
        current_line = io.read("*line")
        next_line = io.read("*line")
    end

    function next()
        current_line = next_line
        next_line = io.read("*line")
    end

    function eof() return next_line == nil end

    function is_exec(line) return string.sub(line, 1, 1) == "$" end

    begin()
    while not eof() do
        if is_exec(current_line) then
            local parts = split(current_line, " ")
            local command = parts[2]

            if command == "cd" then
                local dir = parts[3]
                exec_cd(dir)
            elseif command == "ls" then
                local files = {}
                while not eof() and not is_exec(next_line) do
                    next()
                    local parts = split(current_line, " ")
                    local size = parts[1]
                    local name = parts[2]
                    if size ~= "dir" then files[name] = size end
                end
                exec_ls(files)
            end
        end
        next()
    end
end

load()

function dir_size(dir, traverse)
    local size = 0
    for key, value in pairs(dir) do
        if value.type == "file" then
            size = size + value.size
        elseif value.type == "dir" then
            size = size + dir_size(dir[key], traverse)
        end
    end
    traverse(size)
    return size
end

big_dirs_total_size = 0
function count_big_dirs(size)
    if size <= 100000 then
        big_dirs_total_size = big_dirs_total_size + size
    end
end
used_space = dir_size(root, count_big_dirs)

print("star 1: ", big_dirs_total_size)

total_space = 70000000
available_space = total_space - used_space
required_update_space = 30000000
threshold_size_for_deletion = required_update_space - available_space
min_size_for_deletion = total_space

function find_smallest_dir_for_deletion (size)
    if size > threshold_size_for_deletion and size < min_size_for_deletion then
        min_size_for_deletion = size
    end
end
dir_size(root, find_smallest_dir_for_deletion)
print("star 2: ", min_size_for_deletion)
