#!/bin/bash
# Shell script to download third-party Lua libraries for XLua
# Run this script from the project root directory

echo "XLua Third-Party Libraries Download Script"
echo "=========================================="

# Check if git is available
if ! command -v git &> /dev/null; then
    echo "Error: Git is not installed or not in PATH. Please install Git first."
    exit 1
fi

# Create build directory if it doesn't exist
BUILD_DIR="build"
if [ ! -d "$BUILD_DIR" ]; then
    echo "Creating build directory..."
    mkdir -p "$BUILD_DIR"
fi

cd "$BUILD_DIR"

# Function to clone or update repository
get_repository() {
    local url=$1
    local name=$2
    local description=$3
    
    echo ""
    echo "Downloading $description..."
    
    if [ -d "$name" ]; then
        echo "$name already exists. Updating..."
        cd "$name"
        git pull origin main 2>/dev/null || git pull origin master 2>/dev/null
        local exit_code=$?
        cd ..
        if [ $exit_code -ne 0 ]; then
            echo "Warning: Failed to update $name"
            return 1
        fi
    else
        echo "Cloning $name..."
        git clone "$url" "$name"
        if [ $? -ne 0 ]; then
            echo "Error: Failed to clone $name"
            return 1
        fi
    fi
    
    echo "$description downloaded successfully!"
    return 0
}

# Download libraries
declare -a libraries=(
    "https://github.com/starwing/lua-protobuf.git|lua-protobuf|lua-protobuf (Protocol Buffers)"
    "https://github.com/xpol/lua-rapidjson.git|lua-rapidjson|lua-rapidjson (Fast JSON)"
    "https://github.com/lunarmodules/luafilesystem.git|luafilesystem|luafilesystem (File System Operations)"
)

success_count=0
total_count=${#libraries[@]}

for lib_info in "${libraries[@]}"; do
    IFS='|' read -r url name description <<< "$lib_info"
    if get_repository "$url" "$name" "$description"; then
        ((success_count++))
    fi
done

cd ..

echo ""
echo "=========================================="
echo "Download Summary:"
echo "Successfully downloaded: $success_count/$total_count libraries"

if [ $success_count -eq $total_count ]; then
    echo ""
    echo "All libraries downloaded successfully!"
    echo "You can now build XLua with third-party libraries support."
    echo ""
    echo "Next steps:"
    echo "1. Run the appropriate build script from the build directory"
    echo "   - Linux: ./make_linux64_lua53.sh or ./make_linux64_luajit.sh"
    echo "   - macOS: ./make_osx_lua53.sh or ./make_osx_luajit.sh"
    echo "   - Android: ./make_android_lua53.sh or ./make_android_luajit.sh"
    echo "   - iOS: ./make_ios_lua53.sh or ./make_ios_luajit.sh"
    echo "2. Use ThirdPartyLibraries.InitializeAll() in your C# code"
    echo "3. Check the examples in Assets/XLua/Examples/15_ThirdPartyLibraries/"
else
    echo ""
    echo "Warning: Some libraries failed to download. Please check the errors above."
    echo "You can manually download the missing libraries or re-run this script."
fi

echo ""
echo "For more information, see:"
echo "Assets/XLua/Doc/ThirdPartyLibraries_Integration_Guide.md"
