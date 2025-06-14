-- Protobuf Example
-- Demonstrates usage of lua-protobuf library

print("=== Protobuf Example ===")

local pb = require('pb')

-- Define protobuf schemas
local schemas = {
    -- Simple message
    person_schema = [[
        syntax = "proto3";
        
        message Person {
            string name = 1;
            int32 id = 2;
            string email = 3;
            repeated string phone_numbers = 4;
        }
    ]],
    
    -- Complex nested message
    game_data_schema = [[
        syntax = "proto3";
        
        message Vector3 {
            float x = 1;
            float y = 2;
            float z = 3;
        }
        
        message Player {
            string name = 1;
            int32 level = 2;
            int32 experience = 3;
            Vector3 position = 4;
            repeated string inventory = 5;
            map<string, int32> stats = 6;
        }
        
        message GameState {
            repeated Player players = 1;
            int64 timestamp = 2;
            string map_name = 3;
            bool is_active = 4;
        }
    ]]
}

-- Load schemas
print("\n--- Loading Schemas ---")
for name, schema in pairs(schemas) do
    local success = pb.load(schema)
    if success then
        print("Successfully loaded schema:", name)
    else
        print("Failed to load schema:", name)
    end
end

-- Test simple Person message
print("\n--- Person Message Test ---")
local person_data = {
    name = "John Doe",
    id = 12345,
    email = "john.doe@example.com",
    phone_numbers = {"+1-555-0123", "+1-555-0456"}
}

-- Encode
local person_encoded = pb.encode("Person", person_data)
print("Person encoded size:", #person_encoded, "bytes")

-- Decode
local person_decoded = pb.decode("Person", person_encoded)
print("Decoded person name:", person_decoded.name)
print("Decoded person id:", person_decoded.id)
print("Decoded person email:", person_decoded.email)
print("Decoded phone numbers:")
for i, phone in ipairs(person_decoded.phone_numbers) do
    print("  " .. i .. ":", phone)
end

-- Test complex GameState message
print("\n--- GameState Message Test ---")
local game_data = {
    players = {
        {
            name = "Player1",
            level = 25,
            experience = 15000,
            position = {x = 100.5, y = 50.0, z = 200.75},
            inventory = {"sword", "shield", "potion", "key"},
            stats = {
                strength = 18,
                dexterity = 14,
                intelligence = 12,
                health = 100
            }
        },
        {
            name = "Player2", 
            level = 30,
            experience = 22000,
            position = {x = 150.0, y = 60.5, z = 180.25},
            inventory = {"bow", "arrows", "armor", "scroll"},
            stats = {
                strength = 15,
                dexterity = 20,
                intelligence = 16,
                health = 95
            }
        }
    },
    timestamp = 1640995200, -- Unix timestamp
    map_name = "Forest_Level_1",
    is_active = true
}

-- Encode
local game_encoded = pb.encode("GameState", game_data)
print("GameState encoded size:", #game_encoded, "bytes")

-- Decode
local game_decoded = pb.decode("GameState", game_encoded)
print("Decoded map name:", game_decoded.map_name)
print("Decoded timestamp:", game_decoded.timestamp)
print("Decoded is_active:", game_decoded.is_active)
print("Decoded players count:", #game_decoded.players)

for i, player in ipairs(game_decoded.players) do
    print(string.format("Player %d: %s (Level %d)", i, player.name, player.level))
    print(string.format("  Position: (%.1f, %.1f, %.1f)", 
          player.position.x, player.position.y, player.position.z))
    print("  Inventory:", table.concat(player.inventory, ", "))
    print("  Stats:")
    for stat, value in pairs(player.stats) do
        print("    " .. stat .. ":", value)
    end
end

-- Performance test
print("\n--- Performance Test ---")
local iterations = 1000
local start_time = os.clock()

for i = 1, iterations do
    local encoded = pb.encode("GameState", game_data)
    local decoded = pb.decode("GameState", encoded)
end

local elapsed_time = os.clock() - start_time
print(string.format("Protobuf encode/decode %d iterations: %.4f seconds", iterations, elapsed_time))
print(string.format("Average per operation: %.6f seconds", elapsed_time / iterations))

-- Size comparison with JSON
print("\n--- Size Comparison ---")
local rapidjson = require('rapidjson')
local json_encoded = rapidjson.encode(game_data)
local protobuf_encoded = pb.encode("GameState", game_data)

print("JSON encoded size:", #json_encoded, "bytes")
print("Protobuf encoded size:", #protobuf_encoded, "bytes")
print("Size reduction:", string.format("%.1f%%", (1 - #protobuf_encoded / #json_encoded) * 100))

print("\n=== Protobuf Example Complete ===")
