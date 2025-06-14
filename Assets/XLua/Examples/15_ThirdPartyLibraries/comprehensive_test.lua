-- Comprehensive Test Script for XLua Third-Party Libraries
-- This script tests all integrated libraries and their functionality

print("=== XLua Third-Party Libraries Comprehensive Test ===")
print("Testing Date:", os.date("%Y-%m-%d %H:%M:%S"))
print("")

-- Test results tracking
local test_results = {
    total_tests = 0,
    passed_tests = 0,
    failed_tests = 0,
    errors = {}
}

-- Helper function to run tests safely
local function run_test(test_name, test_func)
    test_results.total_tests = test_results.total_tests + 1
    print(string.format("Running test: %s", test_name))
    
    local success, error_msg = pcall(test_func)
    if success then
        test_results.passed_tests = test_results.passed_tests + 1
        print(string.format("  ✓ PASSED: %s", test_name))
    else
        test_results.failed_tests = test_results.failed_tests + 1
        table.insert(test_results.errors, {test = test_name, error = error_msg})
        print(string.format("  ✗ FAILED: %s - %s", test_name, error_msg))
    end
    print("")
end

-- Test 1: RapidJSON Basic Operations
run_test("RapidJSON Basic Operations", function()
    local rapidjson = require('rapidjson')
    
    local test_data = {
        string_val = "test",
        number_val = 42,
        boolean_val = true,
        array_val = {1, 2, 3},
        object_val = {nested = "value"}
    }
    
    local encoded = rapidjson.encode(test_data)
    assert(type(encoded) == "string", "Encoding should return string")
    assert(#encoded > 0, "Encoded string should not be empty")
    
    local decoded = rapidjson.decode(encoded)
    assert(decoded.string_val == "test", "String value mismatch")
    assert(decoded.number_val == 42, "Number value mismatch")
    assert(decoded.boolean_val == true, "Boolean value mismatch")
    assert(#decoded.array_val == 3, "Array length mismatch")
    assert(decoded.object_val.nested == "value", "Nested object mismatch")
end)

-- Test 2: RapidJSON Advanced Operations
run_test("RapidJSON Advanced Operations", function()
    local rapidjson = require('rapidjson')

    -- Test with complex nested data
    local complex_data = {
        name = "Advanced Test",
        values = {10, 20, 30},
        config = {enabled = true},
        nested = {
            deep = {
                value = "deeply nested",
                array = {1, 2, 3, 4, 5}
            }
        },
        unicode = "Hello, 世界! 🌍",
        special_chars = "\"quotes\" and \\backslashes\\"
    }

    local encoded = rapidjson.encode(complex_data)
    assert(type(encoded) == "string", "Encoding should return string")
    assert(#encoded > 0, "Encoded string should not be empty")

    local decoded = rapidjson.decode(encoded)
    assert(decoded.name == "Advanced Test", "Name mismatch")
    assert(#decoded.values == 3, "Values array length mismatch")
    assert(decoded.config.enabled == true, "Config boolean mismatch")
    assert(decoded.nested.deep.value == "deeply nested", "Deep nested value mismatch")
    assert(decoded.unicode == "Hello, 世界! 🌍", "Unicode handling failed")
end)

-- Test 3: Protobuf Basic Operations
run_test("Protobuf Basic Operations", function()
    local pb = require('pb')
    
    local schema = [[
        syntax = "proto3";
        message TestMessage {
            string name = 1;
            int32 id = 2;
            repeated string tags = 3;
        }
    ]]
    
    assert(pb.load(schema), "Schema loading failed")
    
    local test_data = {
        name = "Protobuf Test",
        id = 12345,
        tags = {"test", "protobuf", "xlua"}
    }
    
    local encoded = pb.encode("TestMessage", test_data)
    assert(type(encoded) == "string", "Encoding should return string")
    assert(#encoded > 0, "Encoded data should not be empty")
    
    local decoded = pb.decode("TestMessage", encoded)
    assert(decoded.name == "Protobuf Test", "Name mismatch")
    assert(decoded.id == 12345, "ID mismatch")
    assert(#decoded.tags == 3, "Tags array length mismatch")
    assert(decoded.tags[1] == "test", "First tag mismatch")
end)

-- Test 4: Protobuf Complex Schema
run_test("Protobuf Complex Schema", function()
    local pb = require('pb')
    
    local complex_schema = [[
        syntax = "proto3";
        
        message Address {
            string street = 1;
            string city = 2;
            int32 zip_code = 3;
        }
        
        message Person {
            string name = 1;
            int32 age = 2;
            Address address = 3;
            repeated string hobbies = 4;
        }
    ]]
    
    assert(pb.load(complex_schema), "Complex schema loading failed")
    
    local person_data = {
        name = "John Doe",
        age = 30,
        address = {
            street = "123 Main St",
            city = "Anytown",
            zip_code = 12345
        },
        hobbies = {"reading", "gaming", "coding"}
    }
    
    local encoded = pb.encode("Person", person_data)
    local decoded = pb.decode("Person", encoded)
    
    assert(decoded.name == "John Doe", "Person name mismatch")
    assert(decoded.age == 30, "Person age mismatch")
    assert(decoded.address.street == "123 Main St", "Address street mismatch")
    assert(decoded.address.city == "Anytown", "Address city mismatch")
    assert(decoded.address.zip_code == 12345, "Address zip code mismatch")
    assert(#decoded.hobbies == 3, "Hobbies count mismatch")
end)

-- Test 5: File System Basic Operations
run_test("File System Basic Operations", function()
    local lfs = require('lfs')
    
    -- Test current directory
    local current_dir = lfs.currentdir()
    assert(type(current_dir) == "string", "Current directory should be string")
    assert(#current_dir > 0, "Current directory should not be empty")
    
    -- Test directory attributes
    local attr = lfs.attributes(current_dir)
    assert(type(attr) == "table", "Attributes should be table")
    assert(attr.mode == "directory", "Current path should be directory")
    
    -- Test directory iteration
    local file_count = 0
    for file in lfs.dir(current_dir) do
        file_count = file_count + 1
        if file_count > 100 then break end -- Prevent infinite loops
    end
    assert(file_count > 0, "Directory should contain files")
end)

-- Test 6: Performance Comparison
run_test("Performance Comparison", function()
    local rapidjson = require('rapidjson')
    local pb = require('pb')

    -- Load protobuf schema for comparison
    local perf_schema = [[
        syntax = "proto3";
        message PerfTest {
            string name = 1;
            repeated int32 numbers = 2;
            bool flag = 3;
        }
    ]]
    pb.load(perf_schema)

    local test_data = {
        name = "Performance Test",
        numbers = {},
        flag = true
    }

    -- Generate test data
    for i = 1, 100 do
        table.insert(test_data.numbers, i)
    end

    local iterations = 100

    -- Test RapidJSON performance
    local start_time = os.clock()
    for i = 1, iterations do
        local encoded = rapidjson.encode(test_data)
        local decoded = rapidjson.decode(encoded)
    end
    local rapidjson_time = os.clock() - start_time

    -- Test Protobuf performance
    start_time = os.clock()
    for i = 1, iterations do
        local encoded = pb.encode("PerfTest", test_data)
        local decoded = pb.decode("PerfTest", encoded)
    end
    local protobuf_time = os.clock() - start_time

    print(string.format("  Performance Results (%d iterations):", iterations))
    print(string.format("    RapidJSON: %.4f seconds", rapidjson_time))
    print(string.format("    Protobuf: %.4f seconds", protobuf_time))

    -- All should complete in reasonable time (less than 10 seconds)
    assert(rapidjson_time < 10, "RapidJSON performance too slow")
    assert(protobuf_time < 10, "Protobuf performance too slow")
end)

-- Test 7: Error Handling
run_test("Error Handling", function()
    local rapidjson = require('rapidjson')

    -- Test invalid JSON
    local invalid_json = '{"invalid": json}'

    local success, error = pcall(rapidjson.decode, invalid_json)
    assert(not success, "RapidJSON should fail on invalid JSON")

    -- Test circular reference (should be handled gracefully)
    local circular = {}
    circular.self = circular

    success, error = pcall(rapidjson.encode, circular)
    assert(not success, "RapidJSON should fail on circular reference")

    -- Test null values
    local null_data = {value = rapidjson.null}
    local encoded = rapidjson.encode(null_data)
    local decoded = rapidjson.decode(encoded)
    assert(decoded.value == rapidjson.null, "Null value handling failed")
end)

-- Print final results
print("=== Test Results Summary ===")
print(string.format("Total Tests: %d", test_results.total_tests))
print(string.format("Passed: %d", test_results.passed_tests))
print(string.format("Failed: %d", test_results.failed_tests))
print(string.format("Success Rate: %.1f%%", (test_results.passed_tests / test_results.total_tests) * 100))

if test_results.failed_tests > 0 then
    print("\nFailed Tests:")
    for _, error_info in ipairs(test_results.errors) do
        print(string.format("  - %s: %s", error_info.test, error_info.error))
    end
end

print("\n=== Comprehensive Test Complete ===")

-- Return results for C# integration
return test_results
