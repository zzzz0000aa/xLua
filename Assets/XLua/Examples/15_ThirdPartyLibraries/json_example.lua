-- JSON Library Example
-- Demonstrates usage of RapidJSON library

print("=== JSON Library Example ===")

-- Test data
local test_data = {
    project = "XLua",
    version = "2.1.16",
    author = "Tencent",
    features = {
        "hotfix",
        "performance",
        "cross_platform",
        "lua_call_csharp",
        "csharp_call_lua"
    },
    config = {
        debug_mode = true,
        max_memory_mb = 512,
        gc_interval = 60,
        nested = {
            value1 = 3.14159,
            value2 = "nested string",
            array = {1, 2, 3, 4, 5}
        }
    },
    metadata = {
        created_at = "2024-01-01",
        updated_at = "2024-12-01",
        tags = {"lua", "unity", "game", "scripting"}
    }
}

-- Test RapidJSON
print("\n--- RapidJSON Test ---")
local rapidjson = require('rapidjson')

-- Encode to JSON
local rapidjson_encoded = rapidjson.encode(test_data)
print("RapidJSON Encoded length:", #rapidjson_encoded)
print("RapidJSON Encoded (first 100 chars):", string.sub(rapidjson_encoded, 1, 100) .. "...")

-- Decode from JSON
local rapidjson_decoded = rapidjson.decode(rapidjson_encoded)
print("RapidJSON Decoded project:", rapidjson_decoded.project)
print("RapidJSON Decoded version:", rapidjson_decoded.version)
print("RapidJSON Decoded features count:", #rapidjson_decoded.features)
print("RapidJSON Decoded config.debug_mode:", rapidjson_decoded.config.debug_mode)

-- Additional RapidJSON tests
print("\n--- Additional RapidJSON Tests ---")

-- Test with different data types
local complex_data = {
    string_value = "Hello, 世界!",
    number_value = 42.5,
    boolean_value = true,
    null_value = rapidjson.null,
    array_value = {1, "two", 3.0, false},
    empty_object = {},
    empty_array = {}
}

local complex_encoded = rapidjson.encode(complex_data)
print("Complex data encoded length:", #complex_encoded)

local complex_decoded = rapidjson.decode(complex_encoded)
print("Complex decoded string:", complex_decoded.string_value)
print("Complex decoded number:", complex_decoded.number_value)
print("Complex decoded boolean:", complex_decoded.boolean_value)
print("Complex decoded array length:", #complex_decoded.array_value)

-- Performance test
print("\n--- Performance Test ---")
local iterations = 1000

-- RapidJSON performance
local start_time = os.clock()
for i = 1, iterations do
    local encoded = rapidjson.encode(test_data)
    local decoded = rapidjson.decode(encoded)
end
local rapidjson_time = os.clock() - start_time

print(string.format("RapidJSON time for %d iterations: %.4f seconds", iterations, rapidjson_time))
print(string.format("Average per operation: %.6f seconds", rapidjson_time / iterations))

-- Error handling example
print("\n--- Error Handling ---")
local invalid_json = '{"invalid": json}'

-- RapidJSON error handling
local success, result = pcall(rapidjson.decode, invalid_json)
if not success then
    print("RapidJSON error (expected):", result)
end

-- Test circular reference handling
local circular = {}
circular.self = circular

success, result = pcall(rapidjson.encode, circular)
if not success then
    print("RapidJSON circular reference error (expected):", result)
end

-- Test pretty printing (if supported)
print("\n--- Pretty Printing ---")
local pretty_data = {
    name = "Pretty Test",
    values = {1, 2, 3},
    nested = {key = "value"}
}

-- Try to encode with pretty formatting
local pretty_json = rapidjson.encode(pretty_data)
print("Pretty JSON:")
print(pretty_json)

print("\n=== JSON Example Complete ===")
