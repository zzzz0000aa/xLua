# Third-Party Libraries Example

This example demonstrates the integration and usage of common third-party Lua libraries in XLua.

## Included Libraries

1. **lua-protobuf** - Google Protocol Buffers support for efficient binary serialization
2. **lua-rapidjson** - Fast JSON encoding/decoding based on RapidJSON C++ library
3. **luafilesystem (lfs)** - File system operations and directory traversal

## Files

- `ThirdPartyLibrariesExample.cs` - Main C# script demonstrating library initialization and usage
- `json_example.lua` - Comprehensive JSON libraries usage examples
- `protobuf_example.lua` - Protocol Buffers serialization examples
- `filesystem_example.lua` - File system operations examples

## Setup Instructions

1. **Download Libraries**: Run the download script from the project root:
   ```bash
   # Windows
   .\Tools\download_third_party_libs.ps1
   
   # Unix/Linux/macOS
   ./Tools/download_third_party_libs.sh
   ```

2. **Build XLua**: Run the appropriate build script for your platform from the `build` directory:
   ```bash
   # Windows
   make_win64_lua53.bat
   
   # macOS
   ./make_osx_lua53.sh
   
   # Linux
   ./make_linux64_lua53.sh
   ```

3. **Run Example**: 
   - Create a new Unity scene
   - Add an empty GameObject
   - Attach the `ThirdPartyLibrariesExample` script
   - Run the scene and check the Console for output

## Usage Patterns

### Basic Initialization
```csharp
var luaenv = new LuaEnv();
ThirdPartyLibraries.InitializeAll(luaenv);
```

### Selective Initialization
```csharp
// Only essential libraries
ThirdPartyLibraries.InitializeEssentials(luaenv);

// Individual libraries
ThirdPartyLibraries.InitializeProtobuf(luaenv);
ThirdPartyLibraries.InitializeRapidJson(luaenv);
ThirdPartyLibraries.InitializeLuaFileSystem(luaenv);
```

### Lua Usage
```lua
-- JSON processing
local rapidjson = require('rapidjson')
local data = {name = "XLua", version = "2.1.16"}
local json_str = rapidjson.encode(data)

-- Protocol Buffers
local pb = require('pb')
pb.load(schema)
local encoded = pb.encode("MessageType", data)

-- File system
local lfs = require('lfs')
local current_dir = lfs.currentdir()
```

## Performance Notes

- **RapidJSON** provides fast JSON processing suitable for most use cases
- **Protobuf** is more efficient than JSON for repeated serialization
- **File system** operations should be used carefully on mobile platforms

## Platform Support

- **Windows**: Full support
- **macOS**: Full support  
- **Linux**: Full support
- **Android**: Full support (file system operations limited)
- **iOS**: Full support (file system operations limited)
- **WebGL**: Limited support (no file system operations)

## Troubleshooting

1. **Build errors**: Ensure all third-party libraries are downloaded correctly
2. **Runtime errors**: Check that libraries are initialized before use
3. **Missing functions**: Some functions may not be available on all platforms

For detailed information, see `Assets/XLua/Doc/ThirdPartyLibraries_Integration_Guide.md`
