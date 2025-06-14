-- Simple integration test script
-- This script can be run directly to test the third-party libraries

print("=== XLua Third-Party Libraries Integration Test ===")

-- Test 1: lua-protobuf
print("\n1. Testing lua-protobuf...")
local pb_success, pb_error = pcall(function()
    local pb = require('pb')
    
    local schema = [[
        syntax = "proto3";
        message Person {
            string name = 1;
            int32 age = 2;
        }
    ]]
    
    assert(pb.load(schema), "Failed to load protobuf schema")
    
    local person = {name = "John Doe", age = 30}
    local data = pb.encode("Person", person)
    assert(data and #data > 0, "Failed to encode protobuf data")
    
    local decoded = pb.decode("Person", data)
    assert(decoded.name == "John Doe", "Name mismatch in protobuf")
    assert(decoded.age == 30, "Age mismatch in protobuf")
    
    print("  ✓ lua-protobuf working correctly")
end)

if not pb_success then
    print("  ✗ lua-protobuf failed:", pb_error)
end

-- Test 2: lua-rapidjson
print("\n2. Testing lua-rapidjson...")
local json_success, json_error = pcall(function()
    local rapidjson = require('rapidjson')
    
    local data = {
        name = "Test Object",
        numbers = {1, 2, 3, 4, 5},
        config = {
            enabled = true,
            timeout = 30
        }
    }
    
    local json_str = rapidjson.encode(data)
    assert(json_str and #json_str > 0, "Failed to encode JSON")
    
    local decoded = rapidjson.decode(json_str)
    assert(decoded.name == "Test Object", "Name mismatch in JSON")
    assert(#decoded.numbers == 5, "Numbers array length mismatch")
    assert(decoded.config.enabled == true, "Config boolean mismatch")
    
    print("  ✓ lua-rapidjson working correctly")
end)

if not json_success then
    print("  ✗ lua-rapidjson failed:", json_error)
end

-- Test 3: luafilesystem
print("\n3. Testing luafilesystem...")
local lfs_success, lfs_error = pcall(function()
    local lfs = require('lfs')
    
    local current_dir = lfs.currentdir()
    assert(current_dir and #current_dir > 0, "Failed to get current directory")
    
    local attr = lfs.attributes(current_dir)
    assert(attr and attr.mode == "directory", "Failed to get directory attributes")
    
    local file_count = 0
    for file in lfs.dir(current_dir) do
        file_count = file_count + 1
        if file_count > 10 then break end -- Limit iteration
    end
    assert(file_count > 0, "Failed to iterate directory")
    
    print("  ✓ luafilesystem working correctly")
end)

if not lfs_success then
    print("  ✗ luafilesystem failed:", lfs_error)
end

-- Summary
print("\n=== Test Summary ===")
local total_tests = 3
local passed_tests = 0

if pb_success then passed_tests = passed_tests + 1 end
if json_success then passed_tests = passed_tests + 1 end
if lfs_success then passed_tests = passed_tests + 1 end

print(string.format("Passed: %d/%d tests", passed_tests, total_tests))

if passed_tests == total_tests then
    print("🎉 All third-party libraries are working correctly!")
else
    print("⚠️  Some libraries failed. Check the errors above.")
end

print("\n=== Integration Test Complete ===")

-- Return results for C# integration
return {
    protobuf = pb_success,
    rapidjson = json_success,
    luafilesystem = lfs_success,
    total = total_tests,
    passed = passed_tests
}
