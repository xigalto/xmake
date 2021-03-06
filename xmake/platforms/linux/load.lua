--!A cross-platform build utility based on Lua
--
-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- 
-- Copyright (C) 2015 - 2018, TBOOX Open Source Group.
--
-- @author      ruki
-- @file        load.lua
--

-- imports
import("core.project.config")

-- load it
function main()

    -- cross toolchains?
    if config.get("cross") or config.get("bin") or config.get("sdk") then 

        -- init linkdirs and includedirs
        local sdkdir = config.get("sdk") 
        if sdkdir then
            _g.includedirs = {path.join(sdkdir, "include")}
            _g.linkdirs    = {path.join(sdkdir, "lib")}
        end

        -- ok
        return _g
    end

    -- init flags for architecture
    local archflags = nil
    local arch = config.get("arch")
    if arch then
        if arch == "x86_64" then archflags = "-m64"
        elseif arch == "i386" then archflags = "-m32"
        end
    end

    -- init flags for c/c++
    _g.cxflags       = { archflags, "-I/usr/local/include", "-I/usr/include" }
    _g.ldflags       = { archflags, "-L/usr/local/lib", "-L/usr/lib" }
    _g.shflags       = { archflags, "-L/usr/local/lib", "-L/usr/lib" }

    -- init flags for objc/c++  (with _g.ldflags and _g.shflags)
    _g.mxflags       = { archflags }

    -- init flags for asm
    local as = config.get("as")
    if as == "yasm" then
        _g.asflags = { "-f", arch == "x86_64" and "elf64" or "elf32" }
    else
        _g.asflags = { archflags }
    end

    -- init flags for golang
    _g["gc-ldflags"] = {}

    -- init flags for dlang
    local dc_archs = { i386 = "-m32", x86_64 = "-m64" }
    _g.dcflags       = { dc_archs[arch] or "" }
    _g["dc-shflags"] = { dc_archs[arch] or "" }
    _g["dc-ldflags"] = { dc_archs[arch] or "" }

    -- init flags for rust
    _g["rc-shflags"] = {}
    _g["rc-ldflags"] = {}

    -- init flags for cuda
    local cu_archs = { i386 = "-m32 -Xcompiler -m32", x86_64 = "-m64 -Xcompiler -m64" }
    _g.cuflags = {cu_archs[arch] or ""}
    _g["cu-shflags"] = {cu_archs[arch] or ""}
    _g["cu-ldflags"] = {cu_archs[arch] or ""}
    local cuda_dir = config.get("cuda")
    if cuda_dir then
        table.insert(_g.cuflags, "-I" .. os.args(path.join(cuda_dir, "include")))
        table.insert(_g["cu-ldflags"], "-L" .. os.args(path.join(cuda_dir, "lib")))
        table.insert(_g["cu-shflags"], "-L" .. os.args(path.join(cuda_dir, "lib")))
        table.insert(_g["cu-ldflags"], "-Xlinker -rpath=" .. os.args(path.join(cuda_dir, "lib")))
    end

    -- ok
    return _g
end

