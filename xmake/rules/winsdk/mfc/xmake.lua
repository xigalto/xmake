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
-- @author      xigal
-- @file        xmake.lua
--

-- define rule: shared
rule("win.sdk.sharedmfc")

    -- add mfc base rule
    add_deps("win.sdk.mfc.env")

    -- after load
    after_load(function (target)

        -- apply mfc settings
        import("mfc").sharedmfc_apply(target)
    end)

-- define rule: static
rule("win.sdk.staticmfc")

    -- add mfc base rule
    add_deps("win.sdk.mfc.env")

    -- after load
    after_load(function (target)

        -- apply mfc settings
        import("mfc").staticmfc_apply(target)
    end)

-- define rule: sharedmfc.app
rule("win.sdk.sharedmfc.app")

    -- add mfc base rule
    add_deps("win.sdk.sharedmfc")

    -- after load
    after_load(function (target)

        -- set kind: binary
        target:set("kind", "binary")

        -- set entry
        target:add("ldflags", import("mfc").mfc_application_entry(target), {force = true})       
    end)

-- define rule: staticmfc.app
rule("win.sdk.staticmfc.app")

    -- add mfc base rule
    add_deps("win.sdk.staticmfc")

    -- after load
    after_load(function (target)

        -- set kind: binary
        target:set("kind", "binary")

        -- set entry
        target:add("ldflags", import("mfc").mfc_application_entry(target), {force = true})
    end)