/*
 * Example demonstrating the use of third-party Lua libraries in XLua
 */

using UnityEngine;
using XLua;

public class ThirdPartyLibrariesExample : MonoBehaviour
{
    private LuaEnv luaenv;

    void Start()
    {
        // Initialize Lua environment
        luaenv = new LuaEnv();
        
        // Initialize all third-party libraries
        ThirdPartyLibraries.InitializeAll(luaenv);
        
        // Run examples
        TestJsonLibraries();
        TestProtobuf();
        TestFileSystem();
    }

    void TestJsonLibraries()
    {
        Debug.Log("=== Testing JSON Library ===");

        string luaScript = @"
            -- Test RapidJSON
            local rapidjson = require('rapidjson')
            local data = {
                name = 'XLua',
                version = '2.1.16',
                features = {'hotfix', 'performance', 'cross-platform'},
                config = {
                    debug = true,
                    maxMemory = 1024
                }
            }

            local json_str = rapidjson.encode(data)
            print('RapidJSON encoded:', json_str)

            local decoded = rapidjson.decode(json_str)
            print('RapidJSON decoded name:', decoded.name)
            print('RapidJSON decoded version:', decoded.version)
            print('RapidJSON decoded features count:', #decoded.features)
        ";

        luaenv.DoString(luaScript);
    }

    void TestProtobuf()
    {
        Debug.Log("=== Testing Protobuf ===");
        
        string luaScript = @"
            local pb = require('pb')
            
            -- Define a simple protobuf schema
            local schema = [[
                syntax = 'proto3';
                
                message Person {
                    string name = 1;
                    int32 id = 2;
                    string email = 3;
                }
            ]]
            
            -- Load the schema
            assert(pb.load(schema))
            
            -- Create and encode a message
            local person = {
                name = 'John Doe',
                id = 123,
                email = 'john.doe@example.com'
            }
            
            local data = pb.encode('Person', person)
            print('Protobuf encoded length:', #data)
            
            -- Decode the message
            local decoded = pb.decode('Person', data)
            print('Protobuf decoded name:', decoded.name)
            print('Protobuf decoded id:', decoded.id)
            print('Protobuf decoded email:', decoded.email)
        ";
        
        luaenv.DoString(luaScript);
    }

    void TestFileSystem()
    {
        Debug.Log("=== Testing File System ===");
        
        string luaScript = @"
            local lfs = require('lfs')
            
            -- Get current directory
            local current_dir = lfs.currentdir()
            print('Current directory:', current_dir)
            
            -- List directory contents (if possible)
            print('Directory attributes:')
            local attr = lfs.attributes(current_dir)
            if attr then
                for name, value in pairs(attr) do
                    print('  ' .. name .. ':', value)
                end
            end
        ";
        
        luaenv.DoString(luaScript);
    }

    void OnDestroy()
    {
        if (luaenv != null)
        {
            luaenv.Dispose();
        }
    }
}
