# XLua Third-Party Libraries Integration Guide

This guide explains how to integrate common Lua utility libraries into XLua, including lua-protobuf, JSON libraries, and file system utilities.

## Overview

The following third-party libraries have been integrated:

1. **lua-protobuf** - Google Protocol Buffers support
2. **lua-rapidjson** - Fast JSON encoding/decoding based on RapidJSON
3. **luafilesystem (lfs)** - File system operations

## Prerequisites

Before building XLua with third-party libraries, you need to download the library sources.

## Download Third-Party Libraries

### 1. lua-protobuf
```bash
cd build
git clone https://github.com/starwing/lua-protobuf.git
```

### 2. lua-rapidjson
```bash
cd build
git clone https://github.com/xpol/lua-rapidjson.git
```

### 3. luafilesystem
```bash
cd build
git clone https://github.com/lunarmodules/luafilesystem.git
```

## Directory Structure

After downloading, your build directory should look like:
```
build/
├── CMakeLists.txt
├── lua-protobuf/
│   ├── pb.c
│   ├── pb.h
│   └── ...
├── lua-rapidjson/
│   ├── include/
│   ├── source/
│   │   └── rapidjson.cpp
│   └── ...
├── luafilesystem/
│   ├── src/
│   │   └── lfs.c
│   └── ...
└── ...
```

## Building

After downloading the libraries, build XLua using the standard build scripts:

### Windows
```bash
# For Lua 5.3
make_win64_lua53.bat

# For LuaJIT
make_win64_luajit.bat
```

### macOS
```bash
# For Lua 5.3
./make_osx_lua53.sh

# For LuaJIT
./make_osx_luajit.sh
```

### Linux
```bash
# For Lua 5.3
./make_linux64_lua53.sh

# For LuaJIT
./make_linux64_luajit.sh
```

### Android
```bash
# For Lua 5.3
./make_android_lua53.sh

# For LuaJIT
./make_android_luajit.sh
```

### iOS
```bash
# For Lua 5.3
./make_ios_lua53.sh

# For LuaJIT
./make_ios_luajit.sh
```

## Usage in C#

### Initialize All Libraries
```csharp
using XLua;

public class Example : MonoBehaviour
{
    private LuaEnv luaenv;
    
    void Start()
    {
        luaenv = new LuaEnv();
        
        // Initialize all third-party libraries
        ThirdPartyLibraries.InitializeAll(luaenv);
        
        // Now you can use the libraries in Lua
        luaenv.DoString(@"
            local pb = require('pb')
            local rapidjson = require('rapidjson')
            local lfs = require('lfs')
        ");
    }
}
```

### Initialize Specific Libraries
```csharp
// Initialize only essential libraries
ThirdPartyLibraries.InitializeEssentials(luaenv);

// Initialize individual libraries
ThirdPartyLibraries.InitializeProtobuf(luaenv);
ThirdPartyLibraries.InitializeRapidJson(luaenv);
ThirdPartyLibraries.InitializeLuaFileSystem(luaenv);
```

## Usage in Lua

### JSON Processing
```lua
-- Using RapidJSON
local rapidjson = require('rapidjson')
local data = {name = "XLua", version = "2.1.16"}
local json_str = rapidjson.encode(data)
local decoded = rapidjson.decode(json_str)
```

### Protocol Buffers
```lua
local pb = require('pb')

-- Define schema
local schema = [[
    syntax = "proto3";
    message Person {
        string name = 1;
        int32 id = 2;
    }
]]

-- Load schema and use
pb.load(schema)
local data = pb.encode("Person", {name = "John", id = 123})
local person = pb.decode("Person", data)
```

### File System Operations
```lua
local lfs = require('lfs')

-- Get current directory
local current_dir = lfs.currentdir()

-- List directory contents
for file in lfs.dir(current_dir) do
    print(file)
end

-- Get file attributes
local attr = lfs.attributes("somefile.txt")
if attr then
    print("Size:", attr.size)
    print("Mode:", attr.mode)
end
```

## Examples

See the example files in `Assets/XLua/Examples/15_ThirdPartyLibraries/`:

- `ThirdPartyLibrariesExample.cs` - C# integration example
- `json_example.lua` - JSON library usage
- `protobuf_example.lua` - Protocol Buffers usage
- `filesystem_example.lua` - File system operations

## Troubleshooting

### Build Issues

1. **Missing source files**: Ensure all third-party libraries are downloaded to the correct directories
2. **Compilation errors**: Check that the library versions are compatible with your Lua version
3. **Linking errors**: Verify that all required dependencies are available

### Runtime Issues

1. **Library not found**: Make sure to call the appropriate initialization function before using the library
2. **Function not available**: Some functions may not be available on all platforms (e.g., file operations on WebGL)

### Platform-Specific Notes

- **WebGL**: File system operations are limited
- **iOS**: All libraries are statically linked
- **Android**: Ensure NDK version compatibility

## Performance Considerations

- **RapidJSON**: Fast JSON processing suitable for most use cases
- **Protobuf**: More efficient than JSON for repeated serialization/deserialization
- **File System**: Use with caution on mobile platforms due to security restrictions

## Automated Download Script

For convenience, you can use the provided download script:

### Windows (PowerShell)
```powershell
# Run from the project root directory
.\Tools\download_third_party_libs.ps1
```

### Unix/Linux/macOS
```bash
# Run from the project root directory
chmod +x Tools/download_third_party_libs.sh
./Tools/download_third_party_libs.sh
```

## License Information

Each third-party library has its own license. Please review the license files in their respective repositories:

- lua-protobuf: MIT License
- lua-rapidjson: MIT License
- luafilesystem: MIT License
