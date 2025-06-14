# XLua 跨平台编译指南

本指南说明如何为Android、iOS和macOS平台编译XLua第三方库。

## 🎯 编译状态总结

### ✅ Windows x64 - 已完成
- **状态**: 编译成功
- **文件**: `Assets/Plugins/x86_64/xlua.dll`
- **第三方库**: lua-protobuf, lua-rapidjson, luafilesystem

### ⚠️ Android - 需要解决编译器标志问题
- **问题**: Windows特定的编译器标志(/MT)被传递给Android clang编译器
- **解决方案**: 见下方Android编译部分

### 📋 iOS - 需要macOS环境
- **要求**: 需要在macOS系统上使用Xcode编译
- **脚本**: `make_ios_lua53.sh`

### 📋 macOS - 需要macOS环境  
- **要求**: 需要在macOS系统上编译
- **脚本**: `make_osx_lua53.sh`

## 🤖 Android 编译解决方案

### 问题分析
Windows环境下编译Android库时，CMake将Windows特定的编译器标志(`/MT`)传递给Android的clang编译器，导致编译失败。

### 解决方案1: 修改CMakeLists.txt (推荐)

在CMakeLists.txt开头添加Android特定处理：

```cmake
# 在project()之前添加
if(ANDROID)
    # 清除Windows特定的编译器标志
    set(CMAKE_C_FLAGS_RELEASE "" CACHE STRING "" FORCE)
    set(CMAKE_C_FLAGS_DEBUG "" CACHE STRING "" FORCE)
    set(CMAKE_CXX_FLAGS_RELEASE "" CACHE STRING "" FORCE)
    set(CMAKE_CXX_FLAGS_DEBUG "" CACHE STRING "" FORCE)
endif()
```

### 解决方案2: 使用独立的Android CMakeLists.txt

创建专门的Android构建文件：

```bash
# 创建Android专用构建目录
mkdir build_android
cd build_android

# 使用Android工具链编译
cmake -G "Ninja" \
    -DANDROID_ABI=arm64-v8a \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK/build/cmake/android.toolchain.cmake" \
    -DANDROID_NATIVE_API_LEVEL=21 \
    -DANDROID_TOOLCHAIN=clang \
    -DCMAKE_C_FLAGS="" \
    -DCMAKE_CXX_FLAGS="" \
    ..

ninja
```

### 解决方案3: 在Linux/WSL环境下编译

如果有WSL或Linux环境，可以在那里编译Android库：

```bash
# 在WSL/Linux中
export ANDROID_NDK=/path/to/android-ndk
cd build
./make_android_lua53.sh
```

## 🍎 iOS 编译指南

iOS库必须在macOS环境下编译：

### 前置要求
- macOS系统
- Xcode和Xcode Command Line Tools
- iOS SDK

### 编译步骤
```bash
cd build
chmod +x make_ios_lua53.sh
./make_ios_lua53.sh
```

### 输出文件
- `plugin_lua53/Plugins/iOS/libxlua.a`

## 🖥️ macOS 编译指南

macOS库也需要在macOS环境下编译：

### 前置要求
- macOS系统
- Xcode Command Line Tools

### 编译步骤
```bash
cd build
chmod +x make_osx_lua53.sh
./make_osx_lua53.sh
```

### 输出文件
- `plugin_lua53/Plugins/xlua.bundle` (Intel)
- `plugin_lua53/Plugins/xlua.dylib` (Apple Silicon)

## 🔧 通用编译脚本

为了简化跨平台编译，可以创建统一的编译脚本：

### Windows PowerShell脚本
```powershell
# build_all_platforms.ps1
param(
    [switch]$Windows,
    [switch]$Android,
    [switch]$All
)

if ($Windows -or $All) {
    Write-Host "Building Windows x64..."
    cmd /c "make_win64_lua53.bat"
}

if ($Android -or $All) {
    Write-Host "Building Android (requires manual fix)..."
    Write-Host "Please see CrossPlatform_Build_Guide.md for Android build instructions"
}
```

### Unix Shell脚本
```bash
#!/bin/bash
# build_all_platforms.sh

build_android() {
    echo "Building Android ARM64..."
    mkdir -p build_android_arm64
    cd build_android_arm64
    cmake -G "Ninja" \
        -DANDROID_ABI=arm64-v8a \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK/build/cmake/android.toolchain.cmake" \
        -DANDROID_NATIVE_API_LEVEL=21 \
        ..
    ninja
    cd ..
}

build_ios() {
    echo "Building iOS..."
    ./make_ios_lua53.sh
}

build_macos() {
    echo "Building macOS..."
    ./make_osx_lua53.sh
}

case "$1" in
    android) build_android ;;
    ios) build_ios ;;
    macos) build_macos ;;
    all) build_android && build_ios && build_macos ;;
    *) echo "Usage: $0 {android|ios|macos|all}" ;;
esac
```

## 📁 输出文件结构

编译完成后，文件应该放置在以下位置：

```
Assets/Plugins/
├── x86_64/
│   └── xlua.dll                 # Windows 64位
├── Android/
│   ├── arm64-v8a/
│   │   └── libxlua.so          # Android ARM64
│   └── armeabi-v7a/
│       └── libxlua.so          # Android ARM32
├── iOS/
│   └── libxlua.a               # iOS静态库
└── macOS/
    └── xlua.bundle             # macOS库
```

## 🚀 下一步行动

1. **Windows**: ✅ 已完成
2. **Android**: 需要解决编译器标志问题或在Linux环境下编译
3. **iOS**: 需要macOS环境和Xcode
4. **macOS**: 需要macOS环境

## 📞 技术支持

如果遇到编译问题：

1. 检查NDK/SDK版本兼容性
2. 确认环境变量设置正确
3. 查看具体错误信息
4. 参考XLua官方文档

---

**注意**: 跨平台编译通常需要对应的开发环境。建议在CI/CD系统中设置多平台编译流水线。
