/*
 * Test script to verify third-party libraries integration
 */

using UnityEngine;
using XLua;

public class TestThirdPartyLibraries : MonoBehaviour
{
    private LuaEnv luaenv;

    void Start()
    {
        Debug.Log("=== Testing XLua Third-Party Libraries Integration ===");
        
        // Initialize Lua environment
        luaenv = new LuaEnv();
        
        // Initialize all third-party libraries
        ThirdPartyLibraries.InitializeAll(luaenv);
        
        // Test each library
        TestProtobuf();
        TestRapidJson();
        TestFileSystem();
        
        Debug.Log("=== All Tests Completed ===");
    }

    void TestProtobuf()
    {
        Debug.Log("--- Testing lua-protobuf ---");
        
        string luaScript = @"
            local pb = require('pb')
            
            -- Test basic functionality
            local schema = [[
                syntax = 'proto3';
                message TestMessage {
                    string name = 1;
                    int32 id = 2;
                }
            ]]
            
            if pb.load(schema) then
                print('✓ Protobuf schema loaded successfully')
                
                local data = {name = 'XLua Test', id = 123}
                local encoded = pb.encode('TestMessage', data)
                
                if encoded and #encoded > 0 then
                    print('✓ Protobuf encoding successful, size:', #encoded)
                    
                    local decoded = pb.decode('TestMessage', encoded)
                    if decoded and decoded.name == 'XLua Test' and decoded.id == 123 then
                        print('✓ Protobuf decoding successful')
                        print('  Name:', decoded.name)
                        print('  ID:', decoded.id)
                    else
                        print('✗ Protobuf decoding failed')
                    end
                else
                    print('✗ Protobuf encoding failed')
                end
            else
                print('✗ Protobuf schema loading failed')
            end
        ";
        
        try
        {
            luaenv.DoString(luaScript);
        }
        catch (System.Exception e)
        {
            Debug.LogError("Protobuf test failed: " + e.Message);
        }
    }

    void TestRapidJson()
    {
        Debug.Log("--- Testing lua-rapidjson ---");
        
        string luaScript = @"
            local rapidjson = require('rapidjson')
            
            -- Test basic functionality
            local data = {
                name = 'XLua RapidJSON Test',
                version = '1.0',
                features = {'fast', 'reliable', 'easy'},
                config = {
                    debug = true,
                    timeout = 30
                }
            }
            
            local encoded = rapidjson.encode(data)
            if encoded and #encoded > 0 then
                print('✓ RapidJSON encoding successful, size:', #encoded)
                print('  JSON:', string.sub(encoded, 1, 100) .. (string.len(encoded) > 100 and '...' or ''))
                
                local decoded = rapidjson.decode(encoded)
                if decoded and decoded.name == 'XLua RapidJSON Test' then
                    print('✓ RapidJSON decoding successful')
                    print('  Name:', decoded.name)
                    print('  Version:', decoded.version)
                    print('  Features count:', #decoded.features)
                    print('  Config debug:', decoded.config.debug)
                else
                    print('✗ RapidJSON decoding failed')
                end
            else
                print('✗ RapidJSON encoding failed')
            end
            
            -- Test null value
            local null_data = {value = rapidjson.null}
            local null_encoded = rapidjson.encode(null_data)
            if null_encoded then
                print('✓ RapidJSON null handling successful')
            else
                print('✗ RapidJSON null handling failed')
            end
        ";
        
        try
        {
            luaenv.DoString(luaScript);
        }
        catch (System.Exception e)
        {
            Debug.LogError("RapidJSON test failed: " + e.Message);
        }
    }

    void TestFileSystem()
    {
        Debug.Log("--- Testing luafilesystem ---");
        
        string luaScript = @"
            local lfs = require('lfs')
            
            -- Test basic functionality
            local current_dir = lfs.currentdir()
            if current_dir and #current_dir > 0 then
                print('✓ LFS currentdir successful')
                print('  Current directory:', current_dir)
                
                -- Test directory attributes
                local attr = lfs.attributes(current_dir)
                if attr and attr.mode == 'directory' then
                    print('✓ LFS attributes successful')
                    print('  Mode:', attr.mode)
                    if attr.size then
                        print('  Size:', attr.size)
                    end
                else
                    print('✗ LFS attributes failed')
                end
                
                -- Test directory iteration
                local file_count = 0
                for file in lfs.dir(current_dir) do
                    file_count = file_count + 1
                    if file_count > 5 then break end -- Just test a few files
                end
                
                if file_count > 0 then
                    print('✓ LFS directory iteration successful')
                    print('  Found', file_count, 'files/directories')
                else
                    print('✗ LFS directory iteration failed')
                end
            else
                print('✗ LFS currentdir failed')
            end
        ";
        
        try
        {
            luaenv.DoString(luaScript);
        }
        catch (System.Exception e)
        {
            Debug.LogError("FileSystem test failed: " + e.Message);
        }
    }

    void OnDestroy()
    {
        if (luaenv != null)
        {
            luaenv.Dispose();
        }
    }
}
