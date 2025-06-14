# PowerShell script to download third-party Lua libraries for XLua
# Run this script from the project root directory

Write-Host "XLua Third-Party Libraries Download Script" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

# Check if git is available
try {
    git --version | Out-Null
} catch {
    Write-Error "Git is not installed or not in PATH. Please install Git first."
    exit 1
}

# Create build directory if it doesn't exist
$buildDir = "build"
if (!(Test-Path $buildDir)) {
    Write-Host "Creating build directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $buildDir
}

Set-Location $buildDir

# Function to clone or update repository
function Get-Repository {
    param(
        [string]$url,
        [string]$name,
        [string]$description
    )
    
    Write-Host "`nDownloading $description..." -ForegroundColor Cyan
    
    if (Test-Path $name) {
        Write-Host "$name already exists. Updating..." -ForegroundColor Yellow
        Set-Location $name
        git pull origin main 2>$null
        if ($LASTEXITCODE -ne 0) {
            git pull origin master 2>$null
        }
        Set-Location ..
    } else {
        Write-Host "Cloning $name..." -ForegroundColor Yellow
        git clone $url $name
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Failed to clone $name"
            return $false
        }
    }
    
    Write-Host "$description downloaded successfully!" -ForegroundColor Green
    return $true
}

# Download libraries
$libraries = @(
    @{
        url = "https://github.com/starwing/lua-protobuf.git"
        name = "lua-protobuf"
        description = "lua-protobuf (Protocol Buffers)"
    },
    @{
        url = "https://github.com/xpol/lua-rapidjson.git"
        name = "lua-rapidjson"
        description = "lua-rapidjson (Fast JSON)"
    },
    @{
        url = "https://github.com/lunarmodules/luafilesystem.git"
        name = "luafilesystem"
        description = "luafilesystem (File System Operations)"
    }
)

$successCount = 0
foreach ($lib in $libraries) {
    if (Get-Repository -url $lib.url -name $lib.name -description $lib.description) {
        $successCount++
    }
}

Set-Location ..

Write-Host "`n==========================================" -ForegroundColor Green
Write-Host "Download Summary:" -ForegroundColor Green
Write-Host "Successfully downloaded: $successCount/$($libraries.Count) libraries" -ForegroundColor Green

if ($successCount -eq $libraries.Count) {
    Write-Host "`nAll libraries downloaded successfully!" -ForegroundColor Green
    Write-Host "You can now build XLua with third-party libraries support." -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Yellow
    Write-Host "1. Run the appropriate build script from the build directory" -ForegroundColor White
    Write-Host "   - Windows: make_win64_lua53.bat or make_win64_luajit.bat" -ForegroundColor White
    Write-Host "   - Other platforms: see the build directory for platform-specific scripts" -ForegroundColor White
    Write-Host "2. Use ThirdPartyLibraries.InitializeAll() in your C# code" -ForegroundColor White
    Write-Host "3. Check the examples in Assets/XLua/Examples/15_ThirdPartyLibraries/" -ForegroundColor White
} else {
    Write-Warning "Some libraries failed to download. Please check the errors above."
    Write-Host "You can manually download the missing libraries or re-run this script." -ForegroundColor Yellow
}

Write-Host "`nFor more information, see:" -ForegroundColor Cyan
Write-Host "Assets/XLua/Doc/ThirdPartyLibraries_Integration_Guide.md" -ForegroundColor White
