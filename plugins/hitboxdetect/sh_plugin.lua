local PLUGIN = PLUGIN

PLUGIN.name = "Hitbox Detection"
PLUGIN.author = "Kaiden Mikami"
PLUGIN.desc = "Detects hitbox that got hit"

--Enumerator group for disserning the hitgroups from the others
HITGROUP_ENUM = {
    [0] = "Corpo-a-corpo",
    [1] = "Cabeça",
    [2] = "Peito",
    [3] = "Estomago",
    [4] = "Braço Esquerdo",
    [5] = "Braço Direito",
    [6] = "Perna Esquerda",
    [7] = "Perna Direita",
    [10] = "Cintura"
}

if (SERVER) then
    function PLUGIN:InitializedPlugins()
        print("Adding first config")
        nut.config.add("verboseDetection", false, "Shows a notification from where you took the damage. ENABLES TO ALL PLAYERS!", nil, {category = "HitboxDetection"})
        print("Adding second config")
        nut.config.add("verboseStatus_Watchdog", false, "Prints to console the status of the watchdog. ONLY SERVER!!", nil, {category = "HitboxDetection"})
        nut.config.add("HDdisableDetection", false, "Disable the system", nil, {category = "HitboxDetection"})
        print("[Hitbox Detection] LOADED")
    end

    --Function only runs once the player spawns
    function PLUGIN:PlayerSpawn(client)
        cli = client
        
        if cli:getChar() != nil then
            if cli:IsBot() then
                printWatchdogStatus(5, cli)
                return
            end
            startWatchDog(cli)
        else
            return
        end

    end

    function PLUGIN:OnReload()
        printWatchdogStatus(2)
        stopWatchDog()
        printWatchdogStatus(3, cli)
        startWatchDog(cli)
        print("[Hitbox Detection] Plugin Reloaded!")
    end


    function PLUGIN:PlayerDisconnected(client)
        removeWatchDog(client)
    end


    function printWatchdogStatus(status, client)
        client = client or cli

        STATUS_ENUM = {
            [0] = "errored. Not started.",
            [1] = "enabled. On player " .. client:GetName() .. " ID " .. client:AccountID(),
            [2] = "disabled.",
            [3] = "initializing.",
            [4] = "removing hook DisplayDamagedBone" .. client:AccountID() .. " from " .. client:GetName(),
            [5] = "ignoring " .. client:GetName()
        }

        if(nut.config.get("verboseStatus_Watchdog")) then
            print("[Hitbox Detection Watchdog] Currently is " .. STATUS_ENUM[status])
        end
    end

    function startWatchDog(client)
        if(nut.config.get("disableDetection")) then
            printWatchdogStatus(2)
            printWatchdogStatus(5)
            return
        end
        
        printWatchdogStatus(1, client)

        local cliname = client:GetName()
        local Char = client:getChar() -- get Character data from the client
        local ENT = Char:getPlayer() -- and get Player data from the character

        hook.Add("EntityTakeDamage", "DisplayDamagedBone" ..  ENT:AccountID(), function(target, dmginfo) -- Adds a hook which watches any entity damage on the server and grabs the damage info
            if (target:IsPlayer() and target:AccountID() == client:AccountID()) then --if the damage taken is from a player
                local lasthit = HITGROUP_ENUM[ENT:LastHitGroup()] -- it gets its last hit and compares it to the enumerator, to get the right hitgroup
                local simpledmg = math.Round(dmginfo:GetDamage()) -- Rounds the damage taken so it looks good.
                local truehealth = ENT:Health() - simpledmg -- Shows health in real-time. Normally if would show the health number BEFORE the damage inflicted.
                if(nut.config.get("verboseDetection")) then
                    ENT:PrintMessage(3,"DAMAGE: " .. lasthit .. " -" .. simpledmg .. " ".. truehealth .."/" .. ENT:GetMaxHealth()) --Notifies player about the damage (DEBUG ONLY)
                end
            end
        end)
    end

    function stopWatchDog()
        for k, v in pairs(Client.GetAll()) do
            hook.Remove("EntityTakeDamage", "DisplayDamagedBone" .. playerMeta:AccountID())
        end
        --nut.config.set("disableDetection", true)
        printWatchdogStatus(2)
    end

    function removeWatchDog(client)
        hook.Remove("EntityTakeDamage", "DisplayDamagedBone" .. client:AccountID())
        printWatchdogStatus(4, client)
    end
end