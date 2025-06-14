/*
 * Third-party Lua libraries integration for XLua
 * This file provides easy initialization of common Lua utility libraries
 */

using System;
using XLua.LuaDLL;

namespace XLua
{
    /// <summary>
    /// Helper class for initializing third-party Lua libraries
    /// </summary>
    public static class ThirdPartyLibraries
    {
        /// <summary>
        /// Initialize all available third-party libraries
        /// </summary>
        /// <param name="luaenv">The LuaEnv instance to register libraries with</param>
        public static void InitializeAll(LuaEnv luaenv)
        {
            InitializeProtobuf(luaenv);
            InitializeRapidJson(luaenv);
            InitializeLuaFileSystem(luaenv);
        }

        /// <summary>
        /// Initialize lua-protobuf library for Protocol Buffers support
        /// </summary>
        /// <param name="luaenv">The LuaEnv instance</param>
        public static void InitializeProtobuf(LuaEnv luaenv)
        {
            luaenv.AddBuildin("pb", Lua.LoadProtobuf);
        }

        /// <summary>
        /// Initialize lua-rapidjson library for fast JSON processing
        /// </summary>
        /// <param name="luaenv">The LuaEnv instance</param>
        public static void InitializeRapidJson(LuaEnv luaenv)
        {
            luaenv.AddBuildin("rapidjson", Lua.LoadRapidJson);
        }



        /// <summary>
        /// Initialize luafilesystem library for file system operations
        /// </summary>
        /// <param name="luaenv">The LuaEnv instance</param>
        public static void InitializeLuaFileSystem(LuaEnv luaenv)
        {
            luaenv.AddBuildin("lfs", Lua.LoadLuaFileSystem);
        }

        /// <summary>
        /// Initialize essential libraries (protobuf, rapidjson, filesystem)
        /// </summary>
        /// <param name="luaenv">The LuaEnv instance</param>
        public static void InitializeEssentials(LuaEnv luaenv)
        {
            InitializeProtobuf(luaenv);
            InitializeRapidJson(luaenv);
            InitializeLuaFileSystem(luaenv);
        }
    }
}
