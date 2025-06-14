-- Lua File System Example
-- Demonstrates usage of luafilesystem (lfs) library

print("=== Lua File System Example ===")

local lfs = require('lfs')

-- Get current directory
print("\n--- Current Directory Info ---")
local current_dir = lfs.currentdir()
print("Current directory:", current_dir)

-- Get directory attributes
local function print_attributes(path, name)
    local attr = lfs.attributes(path)
    if attr then
        print(string.format("%s attributes:", name or path))
        for key, value in pairs(attr) do
            if type(value) == "number" and (key == "access" or key == "modification" or key == "change") then
                -- Convert timestamp to readable format
                print(string.format("  %s: %s (%d)", key, os.date("%Y-%m-%d %H:%M:%S", value), value))
            else
                print(string.format("  %s: %s", key, tostring(value)))
            end
        end
    else
        print("Could not get attributes for:", path)
    end
end

print_attributes(current_dir, "Current Directory")

-- List directory contents
print("\n--- Directory Contents ---")
local function list_directory(path, max_items)
    max_items = max_items or 20
    local count = 0
    
    print("Contents of:", path)
    for file in lfs.dir(path) do
        if count >= max_items then
            print("  ... (showing first " .. max_items .. " items)")
            break
        end
        
        if file ~= "." and file ~= ".." then
            local file_path = path .. "/" .. file
            local attr = lfs.attributes(file_path)
            local file_type = attr and attr.mode or "unknown"
            local size = attr and attr.size or 0
            
            if file_type == "directory" then
                print(string.format("  [DIR]  %s", file))
            else
                print(string.format("  [FILE] %s (%d bytes)", file, size))
            end
            count = count + 1
        end
    end
    
    if count == 0 then
        print("  (empty or no access)")
    end
end

list_directory(current_dir, 15)

-- File operations example
print("\n--- File Operations Example ---")

-- Create a temporary file
local temp_filename = "xlua_test_file.txt"
local temp_content = [[
This is a test file created by XLua filesystem example.
Created at: ]] .. os.date("%Y-%m-%d %H:%M:%S") .. [[

This file demonstrates:
- File creation
- File writing
- File reading
- File attribute checking
- File deletion

XLua Third-Party Libraries Integration Test
]]

-- Write file
local function write_test_file()
    local file = io.open(temp_filename, "w")
    if file then
        file:write(temp_content)
        file:close()
        print("Created test file:", temp_filename)
        return true
    else
        print("Failed to create test file:", temp_filename)
        return false
    end
end

-- Read file
local function read_test_file()
    local file = io.open(temp_filename, "r")
    if file then
        local content = file:read("*all")
        file:close()
        print("Read test file content:")
        print("--- File Content Start ---")
        print(content)
        print("--- File Content End ---")
        return content
    else
        print("Failed to read test file:", temp_filename)
        return nil
    end
end

-- Clean up
local function cleanup_test_file()
    local success = os.remove(temp_filename)
    if success then
        print("Cleaned up test file:", temp_filename)
    else
        print("Failed to clean up test file:", temp_filename)
    end
    return success
end

-- Execute file operations
if write_test_file() then
    -- Check file attributes
    print_attributes(temp_filename, "Test File")
    
    -- Read the file back
    read_test_file()
    
    -- Clean up
    cleanup_test_file()
end

-- Directory traversal example
print("\n--- Directory Traversal Example ---")
local function traverse_directory(path, max_depth, current_depth)
    max_depth = max_depth or 2
    current_depth = current_depth or 0
    
    if current_depth >= max_depth then
        return
    end
    
    local indent = string.rep("  ", current_depth)
    
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local file_path = path .. "/" .. file
            local attr = lfs.attributes(file_path)
            
            if attr then
                if attr.mode == "directory" then
                    print(indent .. "[DIR] " .. file)
                    -- Recursively traverse subdirectory
                    traverse_directory(file_path, max_depth, current_depth + 1)
                else
                    print(string.format("%s[FILE] %s (%d bytes)", indent, file, attr.size or 0))
                end
            end
        end
    end
end

print("Directory tree (max depth 2):")
traverse_directory(current_dir, 2)

-- Utility functions
print("\n--- Utility Functions ---")

-- Check if path exists
local function path_exists(path)
    local attr = lfs.attributes(path)
    return attr ~= nil
end

-- Check if path is directory
local function is_directory(path)
    local attr = lfs.attributes(path)
    return attr and attr.mode == "directory"
end

-- Check if path is file
local function is_file(path)
    local attr = lfs.attributes(path)
    return attr and attr.mode == "file"
end

-- Test utility functions
local test_paths = {current_dir, temp_filename, "nonexistent_path"}
for _, path in ipairs(test_paths) do
    print(string.format("Path: %s", path))
    print(string.format("  Exists: %s", tostring(path_exists(path))))
    print(string.format("  Is Directory: %s", tostring(is_directory(path))))
    print(string.format("  Is File: %s", tostring(is_file(path))))
end

print("\n=== File System Example Complete ===")
