_G.SettingsTable = {
    autofarm = false,
        farmclosestleaf = false,
        farmbubbles = false,
        autodig = false,
        farmrares = false,
        rgbui = false,
        farmflower = false,
        farmfuzzy = false,
        farmcoco = false,
        farmflame = false,
        farmclouds = false,
        killmondo = false,
        killvicious = false,
        loopspeed = false,
        loopjump = false,
        autoquest = false,
        autoboosters = false,
        autodispense = false,
        clock = false,
        freeantpass = false,
        honeystorm = false,
        autodoquest = false,
        disableseperators = false,
        npctoggle = false,
        loopfarmspeed = false,
        mobquests = false,
        traincrab = false,
        avoidmobs = false,
        farmsprouts = false,
        enabletokenblacklisting = false,
        farmunderballoons = false,
        farmsnowflakes = false,
        collectgingerbreads = false,
        collectcrosshairs = false,
        farmpuffshrooms = false,
        tptonpc = false,
        donotfarmtokens = false,
        convertballoons = false,
        autostockings = false,
        autosamovar = false,
        autoonettart = false,
        autocandles = false,
        autofeast = false,
        autoplanters = false,
        autokillmobs = false,
        autoant = false,
        killwindy = false,
        godmode = false,
        disableconversion = false,
        autodonate = false,
        autouseconvertors = false,
        honeymaskconv = false,
        resetbeeenergy = false,
        enablestatuspanel = false,
        killcrby = false,
        killmondo = false,
        killvicious = false,
        killwindy = false,
        autokillmobs = false,
        avoidmobs = false,
        autoant = false,
        RoyalJellyDispenser = true,
        BlueberryDispenser = true,
        StrawberryDispenser = true,
        TreatDispenser = true,
        CoconutDispenser = true,
        GlueDispenser = true,
        MountainTopBooster = true,
        BlueFieldBooster = true,
        RedFieldBooster = true,
}

for i,v in pairs(_G.SettingsTable) do

end
local filename = "ElevatorDark HUB/BSS.json"

function loadSettings()
    local HttpService = game:GetService("HttpService")
    if(readfile and isfile and isfile(filename)) then
    _G.SettingsTable = HttpService:JSONDecode(readfile(filename));
       for i,v in pairs(_G.SettingsTable) do
       end
    end
end

loadSettings()

function saveSettings()
    local json;
    local HttpService = game:GetService("HttpService");
    if (writefile) then
        json = HttpService:JSONEncode(_G.SettingsTable);
        writefile(filename, json);
        else
    end
end

if game:GetService("CoreGui"):FindFirstChild("     ") then
    game:GetService("CoreGui"):FindFirstChild("     "):Destroy()
end

getgenv().Star = "⭐"
getgenv().Danger = "⚠️"
getgenv().ExploitSpecific = "📜"

getgenv().api = loadstring(game:HttpGet("https://raw.githubusercontent.com/Boxking776/kocmoc/main/api.lua"))()
local bssapi = loadstring(game:HttpGet("https://raw.githubusercontent.com/Boxking776/kocmoc/main/bssapi.lua"))()

local fieldstable = {}
for _,v in next, game:GetService("Workspace").FlowerZones:GetChildren() do table.insert(fieldstable, v.Name) end
table.sort(fieldstable)

local playerstatsevent = game:GetService("ReplicatedStorage").Events.RetrievePlayerStats
local statstable = playerstatsevent:InvokeServer()
local monsterspawners = game:GetService("Workspace").MonsterSpawners
local rarename
function rtsg() tab = game.ReplicatedStorage.Events.RetrievePlayerStats:InvokeServer() return tab end
function maskequip(mask) local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = mask, ["Category"] = "Accessory"} game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2) end
local lasttouched = nil
local done = true
local hi = false
local Items = require(game:GetService("ReplicatedStorage").EggTypes).GetTypes()
local v1 = require(game.ReplicatedStorage.ClientStatCache):Get();

hives = game.Workspace.Honeycombs:GetChildren() for i = #hives, 1, -1 do  v = game.Workspace.Honeycombs:GetChildren()[i] if v.Owner.Value == nil then game.ReplicatedStorage.Events.ClaimHive:FireServer(v.HiveID.Value) end end

--repeat wait() until game.Players.LocalPlayer.Honeycomb
--local plrhive = game.Players.LocalPlayer:FindFirstChild("Honeycomb")

getgenv().temptable = {
    version = "3.2.9",
    blackfield = "Sunflower Field",
    redfields = {},
    bluefields = {},
    whitefields = {},
    shouldiconvertballoonnow = false,
    balloondetected = false,
    puffshroomdetected = false,
    magnitude = 60,
    blacklist = {
        ""
    },
    running = false,
    configname = "",
    tokenpath = game:GetService("Workspace").Collectibles,
    started = {
        vicious = false,
        mondo = false,
        windy = false,
        ant = false,
        monsters = false
    },
    detected = {
        vicious = false,
        windy = false
    },
    tokensfarm = false,
    converting = false,
    consideringautoconverting = false,
    honeystart = 0,
    grib = nil,
    gribpos = CFrame.new(0,0,0),
    honeycurrent = statstable.Totals.Honey,
    dead = false,
    float = false,
    pepsigodmode = false,
    pepsiautodig = false,
    alpha = false,
    beta = false,
    myhiveis = false,
    invis = false,
    windy = nil,
    sprouts = {
        detected = false,
        coords
    },
    cache = {
        autofarm = false,
        killmondo = false,
        vicious = false,
        windy = false
    },
    allplanters = {},
    planters = {
        planter = {},
        cframe = {},
        activeplanters = {
            type = {},
            id = {}
        }
    },
    monstertypes = {"Ladybug", "Rhino", "Spider", "Scorpion", "Mantis", "Werewolf"},
    ["stopapypa"] = function(path, part)
        local Closest
        for i,v in next, path:GetChildren() do
            if v.Name ~= "PlanterBulb" then
                if Closest == nil then
                    Closest = v.Soil
                else
                    if (part.Position - v.Soil.Position).magnitude < (Closest.Position - part.Position).magnitude then
                        Closest = v.Soil
                    end
                end
            end
        end
        return Closest
    end,
    coconuts = {},
    crosshairs = {},
    crosshair = false,
    coconut = false,
    act = 0,
    act2 = 0,
    ['touchedfunction'] = function(v)
        if lasttouched ~= v then
            if v.Parent.Name == "FlowerZones" then
                if v:FindFirstChild("ColorGroup") then
                    if tostring(v.ColorGroup.Value) == "Red" then
                        maskequip("Demon Mask")
                    elseif tostring(v.ColorGroup.Value) == "Blue" then
                        maskequip("Diamond Mask")
                    end
                else
                    maskequip("Gummy Mask")
                end
                lasttouched = v
            end
        end
    end,
    runningfor = 0,
    oldtool = rtsg()["EquippedCollector"],
    ['gacf'] = function(part, st)
        coordd = CFrame.new(part.Position.X, part.Position.Y+st, part.Position.Z)
        return coordd
    end
}
local planterst = {
    plantername = {},
    planterid = {}
}

for i,v in next, temptable.blacklist do if v == api.nickname then game.Players.LocalPlayer:Kick("You're blacklisted! Get clapped!") end end
if temptable.honeystart == 0 then temptable.honeystart = statstable.Totals.Honey end

for i,v in next, game:GetService("Workspace").MonsterSpawners:GetDescendants() do if v.Name == "TimerAttachment" then v.Name = "Attachment" end end
for i,v in next, game:GetService("Workspace").MonsterSpawners:GetChildren() do if v.Name == "RoseBush" then v.Name = "ScorpionBush" elseif v.Name == "RoseBush2" then v.Name = "ScorpionBush2" end end
for i,v in next, game:GetService("Workspace").FlowerZones:GetChildren() do if v:FindFirstChild("ColorGroup") then if v:FindFirstChild("ColorGroup").Value == "Red" then table.insert(temptable.redfields, v.Name) elseif v:FindFirstChild("ColorGroup").Value == "Blue" then table.insert(temptable.bluefields, v.Name) end else table.insert(temptable.whitefields, v.Name) end end
local flowertable = {}
for _,z in next, game:GetService("Workspace").Flowers:GetChildren() do table.insert(flowertable, z.Position) end
local masktable = {}
for _,v in next, game:GetService("ReplicatedStorage").Accessories:GetChildren() do if string.match(v.Name, "Mask") then table.insert(masktable, v.Name) end end
local collectorstable = {}
for _,v in next, getupvalues(require(game:GetService("ReplicatedStorage").Collectors).Exists) do for e,r in next, v do table.insert(collectorstable, e) end end
local fieldstable = {}
for _,v in next, game:GetService("Workspace").FlowerZones:GetChildren() do table.insert(fieldstable, v.Name) end
local toystable = {}
for _,v in next, game:GetService("Workspace").Toys:GetChildren() do table.insert(toystable, v.Name) end
local spawnerstable = {}
for _,v in next, game:GetService("Workspace").MonsterSpawners:GetChildren() do table.insert(spawnerstable, v.Name) end
local accesoriestable = {}
for _,v in next, game:GetService("ReplicatedStorage").Accessories:GetChildren() do if v.Name ~= "UpdateMeter" then table.insert(accesoriestable, v.Name) end end
for i,v in pairs(getupvalues(require(game:GetService("ReplicatedStorage").PlanterTypes).GetTypes)) do for e,z in pairs(v) do table.insert(temptable.allplanters, e) end end
local donatableItemsTable = {}
local treatsTable = {}
for i,v in pairs(Items) do
    if v.DonatableToWindShrine == true then
        table.insert(donatableItemsTable,i)
    end
end
for i,v in pairs(Items) do
    if v.TreatValue then
        table.insert(treatsTable,i)
    end
end
local buffTable = {
    ["Blue Extract"]={b=false,DecalID="2495936060"};
    ["Red Extract"]={b=false,DecalID="2495935291"};
    ["Oil"]={b=false,DecalID="2545746569"}; --?
    ["Enzymes"]={b=false,DecalID="2584584968"};
    ["Glue"]={b=false,DecalID="2504978518"};
    ["Glitter"]={b=false,DecalID="2542899798"};
    ["Tropical Drink"]={b=false,DecalID="3835877932"};
}
local AccessoryTypes = require(game:GetService("ReplicatedStorage").Accessories).GetTypes()
local MasksTable = {}
for i,v in pairs(AccessoryTypes) do
    if string.find(i,"Mask") then
        if i ~= "Honey Mask" then
        table.insert(MasksTable,i)
        end
    end
end

table.sort(fieldstable)
table.sort(accesoriestable)
table.sort(toystable)
table.sort(spawnerstable)
table.sort(masktable)
table.sort(temptable.allplanters)
table.sort(collectorstable)
table.sort(donatableItemsTable)
table.sort(buffTable)
table.sort(MasksTable)

-- float pad

local floatpad = Instance.new("Part", game:GetService("Workspace"))
floatpad.CanCollide = false
floatpad.Anchored = true
floatpad.Transparency = 1
floatpad.Name = "FloatPad"

-- cococrab

local cocopad = Instance.new("Part", game:GetService("Workspace"))
cocopad.Name = "Coconut Part"
cocopad.Anchored = true
cocopad.Transparency = 1
cocopad.Size = Vector3.new(10, 1, 10)
cocopad.Position = Vector3.new(-307.52117919922, 105.91863250732, 467.86791992188)

-- antfarm

local antpart = Instance.new("Part", workspace)
antpart.Name = "Ant Autofarm Part"
antpart.Position = Vector3.new(96, 47, 553)
antpart.Anchored = true
antpart.Size = Vector3.new(128, 1, 50)
antpart.Transparency = 1
antpart.CanCollide = false

getgenv().kocmoc = {
    rares = {},
    priority = {},
    bestfields = {
        red = "Pepper Patch",
        white = "Coconut Field",
        blue = "Stump Field"
    },
    blacklistedfields = {},
    killerkocmoc = {},
    bltokens = {},
    vars = {
        field = "Ant Field",
        convertat = 100,
        farmspeed = 60,
        prefer = "Tokens",
        walkspeed = 70,
        jumppower = 70,
        npcprefer = "All Quests",
        farmtype = "Walk",
        monstertimer = 3,
        autodigmode = "Normal",
        donoItem = "Coconut",
        donoAmount = 25,
        selectedTreat = "Treat",
        selectedTreatAmount = 0,
        autouseMode = "Just Tickets",
        autoconvertWaitTime = 10,
        defmask = "Bubble",
        resettimer = 3,
    },
    dispensesettings = {
        blub = false,
        straw = false,
        treat = false,
        coconut = false,
        glue = false,
        rj = false,
        white = false,
        red = false,
        blue = false
    }
}

local defaultkocmoc = kocmoc

getgenv().KocmocPremium = {
    
}



function statsget() local StatCache = require(game.ReplicatedStorage.ClientStatCache) local stats = StatCache:Get() return stats end
function farm(trying)
    if _G.SettingsTable.loopfarmspeed then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = kocmoc.vars.farmspeed end
    api.humanoid():MoveTo(trying.Position) 
    repeat task.wait() until (trying.Position-api.humanoidrootpart().Position).magnitude <=4 or not IsToken(trying) or not temptable.running
end

function disableall()
    if _G.SettingsTable.autofarm and not temptable.converting then
        temptable.cache.autofarm = true
        _G.SettingsTable.autofarm = false
    end
    if _G.SettingsTable.killmondo and not temptable.started.mondo then
        _G.SettingsTable.killmondo = false
        temptable.cache.killmondo = true
    end
    if _G.SettingsTable.killvicious and not temptable.started.vicious then
        _G.SettingsTable.killvicious = false
        temptable.cache.vicious = true
    end
    if _G.SettingsTable.killwindy and not temptable.started.windy then
        _G.SettingsTable.killwindy = false
        temptable.cache.windy = true
    end
end

function enableall()
    if temptable.cache.autofarm then
        _G.SettingsTable.autofarm = true
        temptable.cache.autofarm = false
    end
    if temptable.cache.killmondo then
        _G.SettingsTable.killmondo = true
        temptable.cache.killmondo = false
    end
    if temptable.cache.vicious then
        _G.SettingsTable.killvicious = true
        temptable.cache.vicious = false
    end
    if temptable.cache.windy then
        _G.SettingsTable.killwindy = true
        temptable.cache.windy = false
    end
end

function gettoken(v3)
    if not v3 then
        v3 = fieldposition
    end
    task.wait()
    for e,r in next, game:GetService("Workspace").Collectibles:GetChildren() do
        itb = false
        if r:FindFirstChildOfClass("Decal") and _G.SettingsTable.enabletokenblacklisting then
            if api.findvalue(kocmoc.bltokens, string.split(r:FindFirstChildOfClass("Decal").Texture, 'rbxassetid://')[2]) then
                itb = true
            end
        end
        if tonumber((r.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) <= temptable.magnitude/1.4 and not itb and (v3-r.Position).magnitude <= temptable.magnitude then
            farm(r)
        end
    end
end

function makesprinklers()
    sprinkler = rtsg().EquippedSprinkler
    e = 1
    if sprinkler == "Basic Sprinkler" or sprinkler == "The Supreme Saturator" then
        e = 1
    elseif sprinkler == "Silver Soakers" then
        e = 2
    elseif sprinkler == "Golden Gushers" then
        e = 3
    elseif sprinkler == "Diamond Drenchers" then
        e = 4
    end
    for i = 1, e do
        k = api.humanoid().JumpPower
        if e ~= 1 then api.humanoid().JumpPower = 70 api.humanoid().Jump = true task.wait(.2) end
        game.ReplicatedStorage.Events.PlayerActivesCommand:FireServer({["Name"] = "Sprinkler Builder"})
        if e ~= 1 then api.humanoid().JumpPower = k task.wait(1) end
    end
end

function killmobs()
    for i,v in pairs(game:GetService("Workspace").MonsterSpawners:GetChildren()) do
        if v:FindFirstChild("Territory") then
            if v.Name ~= "Commando Chick" and v.Name ~= "CoconutCrab" and v.Name ~= "StumpSnail" and v.Name ~= "TunnelBear" and v.Name ~= "King Beetle Cave" and not v.Name:match("CaveMonster") and not v:FindFirstChild("TimerLabel", true).Visible then
                if v.Name:match("Werewolf") then
                    monsterpart = game:GetService("Workspace").Territories.WerewolfPlateau.w
                elseif v.Name:match("Mushroom") then
                    monsterpart = game:GetService("Workspace").Territories.MushroomZone.Part
                else
                    monsterpart = v.Territory.Value
                end
                api.humanoidrootpart().CFrame = monsterpart.CFrame
                repeat api.humanoidrootpart().CFrame = monsterpart.CFrame avoidmob() task.wait(1) until v:FindFirstChild("TimerLabel", true).Visible
                for i = 1, 4 do gettoken(monsterpart.Position) end
            end
        end
    end
end

function IsToken(token)
    if not token then
        return false
    end
    if not token.Parent then return false end
    if token then
        if token.Orientation.Z ~= 0 then
            return false
        end
        if token:FindFirstChild("FrontDecal") then
        else
            return false
        end
        if not token.Name == "C" then
            return false
        end
        if not token:IsA("Part") then
            return false
        end
        return true
    else
        return false
    end
end

function check(ok)
    if not ok then
        return false
    end
    if not ok.Parent then return false end
    return true
end

function getplanters()
    table.clear(planterst.plantername)
    table.clear(planterst.planterid)
    for i,v in pairs(debug.getupvalues(require(game:GetService("ReplicatedStorage").LocalPlanters).LoadPlanter)[4]) do 
        if v.GrowthPercent == 1 and v.IsMine then
            table.insert(planterst.plantername, v.Type)
            table.insert(planterst.planterid, v.ActorID)
        end
    end
end

function farmant()
    antpart.CanCollide = true
    temptable.started.ant = true
    anttable = {left = true, right = false}
    temptable.oldtool = rtsg()['EquippedCollector']
    game.ReplicatedStorage.Events.ItemPackageEvent:InvokeServer("Equip",{["Mute"] = true,["Type"] = "Spark Staff",["Category"] = "Collector"})
    game.ReplicatedStorage.Events.ToyEvent:FireServer("Ant Challenge")
    _G.SettingsTable.autodig = true
    acl = CFrame.new(127, 48, 547)
    acr = CFrame.new(65, 48, 534)
    task.wait(1)
    game.ReplicatedStorage.Events.PlayerActivesCommand:FireServer({["Name"] = "Sprinkler Builder"})
    api.humanoidrootpart().CFrame = api.humanoidrootpart().CFrame + Vector3.new(0, 15, 0)
    task.wait(3)
    repeat
        task.wait()
        for i,v in next, game.Workspace.Toys["Ant Challenge"].Obstacles:GetChildren() do
            if v:FindFirstChild("Root") then
                if (v.Root.Position-api.humanoidrootpart().Position).magnitude <= 40 and anttable.left then
                    api.humanoidrootpart().CFrame = acr
                    anttable.left = false anttable.right = true
                    wait(.1)
                elseif (v.Root.Position-api.humanoidrootpart().Position).magnitude <= 40 and anttable.right then
                    api.humanoidrootpart().CFrame = acl
                    anttable.left = true anttable.right = false
                    wait(.1)
                end
            end
        end
    until game:GetService("Workspace").Toys["Ant Challenge"].Busy.Value == false
    task.wait(1)
    game.ReplicatedStorage.Events.ItemPackageEvent:InvokeServer("Equip",{["Mute"] = true,["Type"] = temptable.oldtool,["Category"] = "Collector"})
    temptable.started.ant = false
    antpart.CanCollide = false
end

function collectplanters()
    getplanters()
    for i,v in pairs(planterst.plantername) do
        if api.partwithnamepart(v, game:GetService("Workspace").Planters) and api.partwithnamepart(v, game:GetService("Workspace").Planters):FindFirstChild("Soil") then
            soil = api.partwithnamepart(v, game:GetService("Workspace").Planters).Soil
            api.humanoidrootpart().CFrame = soil.CFrame
            game:GetService("ReplicatedStorage").Events.PlanterModelCollect:FireServer(planterst.planterid[i])
            task.wait(.5)
            game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"] = v.." Planter"})
            for i = 1, 5 do gettoken(soil.Position) end
            task.wait(2)
        end
    end
end

function getprioritytokens()
    task.wait()
    if temptable.running == false then
        for e,r in next, game:GetService("Workspace").Collectibles:GetChildren() do
            if r:FindFirstChildOfClass("Decal") then
                local aaaaaaaa = string.split(r:FindFirstChildOfClass("Decal").Texture, 'rbxassetid://')[2]
                if aaaaaaaa ~= nil and api.findvalue(kocmoc.priority, aaaaaaaa) then
                    if r.Name == game.Players.LocalPlayer.Name and not r:FindFirstChild("got it") or tonumber((r.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) <= temptable.magnitude/1.4 and not r:FindFirstChild("got it") then
                        farm(r) local val = Instance.new("IntValue",r) val.Name = "got it" break
                    end
                end
            end
        end
    end
end

function gethiveballoon()
    task.wait()
    result = false
    for i,hive in next, game:GetService("Workspace").Honeycombs:GetChildren() do
        task.wait()
        if hive:FindFirstChild("Owner") and hive:FindFirstChild("SpawnPos") then
            if tostring(hive.Owner.Value) == game.Players.LocalPlayer.Name then
                for e,balloon in next, game:GetService("Workspace").Balloons.HiveBalloons:GetChildren() do
                    task.wait()
                    if balloon:FindFirstChild("BalloonRoot") then
                        if (balloon.BalloonRoot.Position-hive.SpawnPos.Value.Position).magnitude < 15 then
                            result = true
                            break
                        end
                    end
                end
            end
        end
    end
    return result
end

function converthoney()
    task.wait(0)
    if temptable.converting then
        if game.Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.TextBox.Text ~= "Stop Making Honey" and game.Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.BackgroundColor3 ~= Color3.new(201, 39, 28) or (game:GetService("Players").LocalPlayer.SpawnPos.Value.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 13 then
            api.tween(1, game:GetService("Players").LocalPlayer.SpawnPos.Value * CFrame.fromEulerAnglesXYZ(0, 110, 0) + Vector3.new(0, 0, 9))
            task.wait(.9)
            if game.Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.TextBox.Text ~= "Stop Making Honey" and game.Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.BackgroundColor3 ~= Color3.new(201, 39, 28) or (game:GetService("Players").LocalPlayer.SpawnPos.Value.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 13 then game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleHoneyMaking") end
            task.wait(.1)
        end
    end
end

function closestleaf()
    for i,v in next, game.Workspace.Flowers:GetChildren() do
        if temptable.running == false and tonumber((v.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
            farm(v)
            break
        end
    end
end

function getbubble()
    for i,v in next, game.workspace.Particles:GetChildren() do
        if string.find(v.Name, "Bubble") and temptable.running == false and tonumber((v.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
            farm(v)
            break
        end
    end
end

function getballoons()
    for i,v in next, game:GetService("Workspace").Balloons.FieldBalloons:GetChildren() do
        if v:FindFirstChild("BalloonRoot") and v:FindFirstChild("PlayerName") then
            if v:FindFirstChild("PlayerName").Value == game.Players.LocalPlayer.Name then
                if tonumber((v.BalloonRoot.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
                    api.walkTo(v.BalloonRoot.Position)
                end
            end
        end
    end
end

function getflower()
    flowerrrr = flowertable[math.random(#flowertable)]
    if tonumber((flowerrrr-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) <= temptable.magnitude/1.4 and tonumber((flowerrrr-fieldposition).magnitude) <= temptable.magnitude/1.4 then 
        if temptable.running == false then 
            if _G.SettingsTable.loopfarmspeed then 
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = kocmoc.vars.farmspeed 
            end 
            api.walkTo(flowerrrr) 
        end 
    end
end

function getcloud()
    for i,v in next, game:GetService("Workspace").Clouds:GetChildren() do
        e = v:FindFirstChild("Plane")
        if e and tonumber((e.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
            api.walkTo(e.Position)
        end
    end
end

function getcoco(v)
    if temptable.coconut then repeat task.wait() until not temptable.coconut end
    temptable.coconut = true
    api.tween(.1, v.CFrame)
    repeat task.wait() api.walkTo(v.Position) until not v.Parent
    task.wait(.1)
    temptable.coconut = false
    table.remove(temptable.coconuts, table.find(temptable.coconuts, v))
end

function getfuzzy()
    pcall(function()
        for i,v in next, game.workspace.Particles:GetChildren() do
            if v.Name == "DustBunnyInstance" and temptable.running == false and tonumber((v.Plane.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
                if v:FindFirstChild("Plane") then
                    farm(v:FindFirstChild("Plane"))
                    break
                end
            end
        end
    end)
end

function getflame()
    for i,v in next, game:GetService("Workspace").PlayerFlames:GetChildren() do
        if tonumber((v.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
            farm(v)
            break
        end
    end
end

function avoidmob()
    for i,v in next, game:GetService("Workspace").Monsters:GetChildren() do
        if v:FindFirstChild("Head") then
            if (v.Head.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude < 30 and api.humanoid():GetState() ~= Enum.HumanoidStateType.Freefall then
                game.Players.LocalPlayer.Character.Humanoid.Jump = true
            end
        end
    end
end

function getcrosshairs(v)
    if v.BrickColor ~= BrickColor.new("Lime green") and v.BrickColor ~= BrickColor.new("Flint") then
    if temptable.crosshair then repeat task.wait() until not temptable.crosshair end
    temptable.crosshair = true
    api.walkTo(v.Position)
    repeat task.wait() api.walkTo(v.Position) until not v.Parent or v.BrickColor == BrickColor.new("Forest green")
    task.wait(.1)
    temptable.crosshair = false
    table.remove(temptable.crosshairs, table.find(temptable.crosshairs, v))
    else
        table.remove(temptable.crosshairs, table.find(temptable.crosshairs, v))
    end
end

function makequests()
    for i,v in next, game:GetService("Workspace").NPCs:GetChildren() do
        if v.Name ~= "Ant Challenge Info" and v.Name ~= "Bubble Bee Man 2" and v.Name ~= "Wind Shrine" and v.Name ~= "Gummy Bear" then if v:FindFirstChild("Platform") then if v.Platform:FindFirstChild("AlertPos") then if v.Platform.AlertPos:FindFirstChild("AlertGui") then if v.Platform.AlertPos.AlertGui:FindFirstChild("ImageLabel") then
            image = v.Platform.AlertPos.AlertGui.ImageLabel
            button = game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.ActivateButton.MouseButton1Click
            if image.ImageTransparency == 0 then
                if _G.SettingsTable.tptonpc then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Platform.Position.X, v.Platform.Position.Y+3, v.Platform.Position.Z)
                    task.wait(1)
                else
                    api.tween(2,CFrame.new(v.Platform.Position.X, v.Platform.Position.Y+3, v.Platform.Position.Z))
                    task.wait(3)
                end
                for b,z in next, getconnections(button) do    z.Function()    end
                task.wait(8)
                if image.ImageTransparency == 0 then
                    for b,z in next, getconnections(button) do    z.Function()    end
                end
                task.wait(2)
            end
        end     
    end end end end end
end

getgenv().Tvk1 = {true,"💖"}

local function donateToShrine(item,qnt)
    print(qnt)
    local s,e = pcall(function()
    game:GetService("ReplicatedStorage").Events.WindShrineDonation:InvokeServer(item, qnt)
    wait(0.5)
    game.ReplicatedStorage.Events.WindShrineTrigger:FireServer()
    
    local UsePlatform = game:GetService("Workspace").NPCs["Wind Shrine"].Stage
    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = UsePlatform.CFrame + Vector3.new(0,5,0)
    
    for i = 1,120 do
    wait(0.05)
    for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
        if (v.Position-UsePlatform.Position).magnitude < 60 and v.CFrame.YVector.Y == 1 then
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
        end
    end
    end
    end)
    if not s then print(e) end
end

local function isWindshrineOnCooldown()
    local isOnCooldown = false
    local cooldown = 3600 - (require(game.ReplicatedStorage.OsTime)() - (require(game.ReplicatedStorage.StatTools).GetLastCooldownTime(v1, "WindShrine")))
    if cooldown > 0 then isOnCooldown = true end
    return isOnCooldown
end

local function getTimeSinceToyActivation(name)
    return require(game.ReplicatedStorage.OsTime)() - require(game.ReplicatedStorage.ClientStatCache):Get("ToyTimes")[name]
end

local function getTimeUntilToyAvailable(n)
    return workspace.Toys[n].Cooldown.Value - getTimeSinceToyActivation(n)
end

local function canToyBeUsed(toy)
    local timeleft = tostring(getTimeUntilToyAvailable(toy))
    local canbeUsed = false
    if string.find(timeleft,"-") then canbeUsed = true end
    return canbeUsed
end

function GetItemListWithValue()
    local StatCache = require(game.ReplicatedStorage.ClientStatCache)
    local data = StatCache.Get()
    return data.Eggs
end

local function useConvertors()
    local conv = {"Instant Converter","Instant Converter B","Instant Converter C"}
    
    local lastWithoutCooldown = nil
    
    for i,v in pairs(conv) do
        if canToyBeUsed(v) == true then
            lastWithoutCooldown = v
        end
    end
    local converted=false
    if lastWithoutCooldown ~= nil and string.find(kocmoc.vars.autouseMode,"Ticket") or string.find(kocmoc.vars.autouseMode,"All") then
        if converted == false then
        game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer(lastWithoutCooldown)
        converted=true
        end
    end
    if GetItemListWithValue()["Snowflake"] > 0 and string.find(kocmoc.vars.autouseMode,"Snowflak") or string.find(kocmoc.vars.autouseMode,"All") then
        game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"] = "Snowflake"})
    end
        if GetItemListWithValue()["Coconut"] > 0 and string.find(kocmoc.vars.autouseMode,"Coconut") or string.find(kocmoc.vars.autouseMode,"All") then
        game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"] = "Coconut"})
        end
end

local function fetchBuffTable(stats)
    local stTab = {}
    if game:GetService("Players").LocalPlayer then
        if game:GetService("Players").LocalPlayer.PlayerGui then
            if game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui then
                for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:GetChildren()) do
                    if v.Name == "TileGrid" then
                        for p,l in pairs(v:GetChildren()) do
                            if l:FindFirstChild("BG") then
                                if l:FindFirstChild("BG"):FindFirstChild("Icon") then
                                    local ic = l:FindFirstChild("BG"):FindFirstChild("Icon")
                                    for field,fdata in pairs(stats) do
                                        if fdata["DecalID"]~= nil then
                                            if string.find(ic.Image,fdata["DecalID"]) then
                                                if ic.Parent:FindFirstChild("Text") then
                                                    if ic.Parent:FindFirstChild("Text").Text == "" then
                                                        stTab[field]=1
                                                    else
                                                        local thing = ""
                                                        thing = string.gsub(ic.Parent:FindFirstChild("Text").Text,"x","")
                                                        stTab[field]=tonumber( thing + 1 )
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return stTab
end

 function TP(P)
   local Distance = (P.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude -- จุดที่จะไป Position Only
   local Speed = 300 -- ความเร็วของมึง
   tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear)
   tween = tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = P})
   tween:Play()
 end

local library = loadstring(game:GetObjects("rbxassetid://10949976777")[1].Source)()
local Wait = library.subs.Wait

local PepsisWorld = library:CreateWindow({
Name = "ElevatorDark HUB",
Themeable = {
Info = ""
}
})

local GeneralTab = PepsisWorld:CreateTab({
Name = "Farming"
})

local FarmingSection = GeneralTab:CreateSection({
Name = "Farming"
})

FarmingSection:AddDropdown({
   Name = "Select Field",
   List = fieldstable,
Callback = function(value)
    kocmoc.vars.field = value
end
})

FarmingSection:AddToggle({
Name = "Equip Honey Mask Sell",
Enabled = _G.SettingsTable.honeymaskconv,
Callback = function(value)
	_G.SettingsTable.honeymaskconv = value
	saveSettings()
end
})

FarmingSection:AddDropdown({
   Name = "Select Mask",
   List = MasksTable,
Callback = function(value)
    kocmoc.vars.defmask = value
end
})


FarmingSection:AddSlider({
  Name = "Convert At",
  Value = 100,
Min = 0,
Max = 100,
  Callback = function(value)
      kocmoc.vars.convertat = value
  end
})

FarmingSection:AddToggle({
Name = "AutoFarm",
Enabled = _G.SettingsTable.autofarm,
Callback = function(value)
	_G.SettingsTable.autofarm = value
	saveSettings()
end
})

FarmingSection:AddToggle({
Name = "AutoDig",
Enabled = _G.SettingsTable.autodig,
Callback = function(value)
	_G.SettingsTable.autodig = value
	saveSettings()
end
})

FarmingSection:AddDropdown({
   Name = "Autodig Mode",
   List = {"Normal","Collector Steal"},
Callback = function(value)
     kocmoc.vars.autodigmode = value
end
})

local Convert = GeneralTab:CreateSection({
Name = "Convert Tools",
Side = "Right"
})

Convert:AddToggle({
    Name = "Don't Convert Pollen",
    Enabled = _G.SettingsTable.disableconversion,
    Callback = function(value)
        _G.SettingsTable.disableconversion = value
        saveSettings()
    end
})

Convert:AddToggle({
    Name = "Auto Bag Reduction",
    Enabled = _G.SettingsTable.autouseconvertors,
    Callback = function(value)
        _G.SettingsTable.autouseconvertors = value
        saveSettings()
    end
})

Convert:AddDropdown({
   Name = "Bag Reduction Mode",
   List = {"Ticket Converters","Just Snowflakes","Just Coconuts","Snowflakes and Coconuts","Tickets and Snowflakes","Tickets and Coconuts","All"},
Callback = function(value)
    kocmoc.vars.autouseMode = value
end
})

Convert:AddSlider({
  Name = "Reduction Confirmation Time",
  Value = 10,
Min = 3,
Max = 20,
  Callback = function(value)
      kocmoc.vars.autoconvertWaitTime = tonumber(value)
  end
})

FarmingSection:AddToggle({
Name = "Auto Sprinkler",
Enabled = _G.SettingsTable.autosprinkler,
Callback = function(value)
	_G.SettingsTable.autosprinkler = value
	saveSettings()
end
})

FarmingSection:AddToggle({
Name = "Farm Bubbles",
Enabled = _G.SettingsTable.farmbubbles,
Callback = function(value)
	_G.SettingsTable.farmbubbles = value
	saveSettings()
end
})

FarmingSection:AddToggle({
Name = "Farm Flames",
Enabled = _G.SettingsTable.farmflame,
Callback = function(value)
	_G.SettingsTable.farmflame = value
	saveSettings()
end
})

FarmingSection:AddToggle({
Name = "Farm Coconuts",
Enabled = _G.SettingsTable.farmcoco,
Callback = function(value)
	_G.SettingsTable.farmcoco = value
	saveSettings()
end
})

FarmingSection:AddToggle({
Name = "Farm Fuzzy Bombs",
Enabled = _G.SettingsTable.farmfuzzy,
Callback = function(value)
	_G.SettingsTable.farmfuzzy = value
	saveSettings()
end
})

FarmingSection:AddToggle({
Name = "Farm Balloons",
Enabled = _G.SettingsTable.farmunderballoons,
Callback = function(value)
	_G.SettingsTable.farmunderballoons = value
	saveSettings()
end
})

FarmingSection:AddToggle({
Name = "Farm Clouds",
Enabled = _G.SettingsTable.farmclouds,
Callback = function(value)
	_G.SettingsTable.farmclouds = value
	saveSettings()
end
})

FarmingSection:AddToggle({
Name = "Auto Crosshairs",
Enabled = _G.SettingsTable.collectcrosshairs,
Callback = function(value)
	_G.SettingsTable.collectcrosshairs = value
	saveSettings()
end
})

FarmingSection:AddToggle({
Name = "Farm Leaves",
Enabled = _G.SettingsTable.farmclosestleaf,
Callback = function(value)
	_G.SettingsTable.farmclosestleaf = value
	saveSettings()
end
})

local MiscSection = GeneralTab:CreateSection({
Name = "Misc",
Side = "Right"
})

MiscSection:AddToggle({
Name = "Auto Use Dispenser",
Enabled = _G.SettingsTable.autodispense ,
Callback = function(value)
	_G.SettingsTable.autodispense  = value
	saveSettings()
end
})

MiscSection:AddToggle({
Name = "Auto Use Field Boosters",
Enabled = _G.SettingsTable.autoboosters  ,
Callback = function(value)
	_G.SettingsTable.autoboosters   = value
	saveSettings()
end
})

MiscSection:AddToggle({
Name = "Auto Use Wealth Clock",
Enabled = _G.SettingsTable.clock  ,
Callback = function(value)
	_G.SettingsTable.clock   = value
	saveSettings()
end
})

MiscSection:AddToggle({
Name = "Auto Planters",
Enabled = _G.SettingsTable.autoplanters,
Callback = function(value)
	_G.SettingsTable.autoplanters = value
	saveSettings()
end
})

MiscSection:AddToggle({
Name = "Auto Antpasses",
Enabled = _G.SettingsTable.freeantpass,
Callback = function(value)
	_G.SettingsTable.freeantpass = value
	saveSettings()
end
})

MiscSection:AddToggle({
Name = "Farm Sprouts",
Enabled = _G.SettingsTable.farmsprouts,
Callback = function(value)
	_G.SettingsTable.farmsprouts = value
	saveSettings()
end
})

MiscSection:AddToggle({
Name = "Farm Puffshrooms",
Enabled = _G.SettingsTable.farmpuffshrooms,
Callback = function(value)
	_G.SettingsTable.farmpuffshrooms = value
	saveSettings()
end
})

MiscSection:AddToggle({
Name = "Teleport To Rares",
Enabled = _G.SettingsTable.farmrares ,
Callback = function(value)
	_G.SettingsTable.farmrares  = value
	saveSettings()
end
})

MiscSection:AddToggle({
Name = "Summon Honeystorm",
Enabled = _G.SettingsTable.honeystorm ,
Callback = function(value)
	_G.SettingsTable.honeystorm  = value
	saveSettings()
end
})

local QuestsSection = GeneralTab:CreateSection({
Name = "Quests",
Side = "Right"
})

QuestsSection:AddToggle({
Name = "Auto Accept Quest",
Enabled = _G.SettingsTable.autoquest ,
Callback = function(value)
	_G.SettingsTable.autoquest  = value
	saveSettings()
end
})

QuestsSection:AddToggle({
Name = "Auto Farm Quest",
Enabled = _G.SettingsTable.autodoquest ,
Callback = function(value)
	_G.SettingsTable.autodoquest  = value
	saveSettings()
end
})

local WindShrine = GeneralTab:CreateSection({
Name = "WindShrine",
Side = "Right"
})

WindShrine:AddDropdown({
Name = "Select Item",
List = donatableItemsTable,
Callback = function(Option)
	kocmoc.vars.donoItem = Option
end
})

WindShrine:AddTextBox({
Name = "Amount",
Value = 0,
Enabled = false,
Callback = function(Option)
	kocmoc.vars.donoAmount = tonumber(Option)
end
})



WindShrine:AddButton({
Name = "Auto Donate",
Callback = function()
	donateToShrine(kocmoc.vars.donoItem,kocmoc.vars.donoAmount)
end
})

local BeeMasSection = GeneralTab:CreateSection({
Name = "BeesMas"
})

BeeMasSection:AddToggle({
Name = "Auto Gingerbread Bears",
Enabled = _G.SettingsTable.collectgingerbreads ,
Callback = function(value)
	_G.SettingsTable.collectgingerbreads  = value
	saveSettings()
end
})

BeeMasSection:AddToggle({
Name = "Auto Samovar",
Enabled = _G.SettingsTable.autosamovar ,
Callback = function(value)
	_G.SettingsTable.autosamovar  = value
	saveSettings()
end
})

BeeMasSection:AddToggle({
Name = "Auto Stockings",
Enabled = _G.SettingsTable.autostockings ,
Callback = function(value)
	_G.SettingsTable.autostockings  = value
	saveSettings()
end
})

BeeMasSection:AddToggle({
Name = "Auto Honey Candles",
Enabled = _G.SettingsTable.autocandles ,
Callback = function(value)
	_G.SettingsTable.autocandles  = value
	saveSettings()
end
})

BeeMasSection:AddToggle({
Name = "Auto Beesmas Feast",
Enabled = _G.SettingsTable.autofeast ,
Callback = function(value)
	_G.SettingsTable.autofeast  = value
	saveSettings()
end
})

BeeMasSection:AddToggle({
Name = "Auto Onett's Lid Art",
Enabled = _G.SettingsTable.autoonettart ,
Callback = function(value)
	_G.SettingsTable.autoonettart  = value
	saveSettings()
end
})

BeeMasSection:AddToggle({
Name = "Farm Snowflakes",
Enabled = _G.SettingsTable.farmsnowflakes ,
Callback = function(value)
	_G.SettingsTable.farmsnowflakes  = value
	saveSettings()
end
})

local GeneralTab = PepsisWorld:CreateTab({
Name = "Auto Kill"
})

local AutoKill = GeneralTab:CreateSection({
Name = "Auto Kill"
})

spawn(function()
   while wait() do
       if _G.WARP then
           game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
        else
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
        end
    end
end)

spawn(function()
   while wait(3) do
       if Methodnow == 1 then
        Methodnow = 2
        Method = CFrame.new(0,25,0)
        else
        Methodnow = 1
        Method = CFrame.new(0,0,25)
       end
    end
end)

AutoKill:AddToggle({
Name = "Kill Crab",
Enabled = _G.SettingsTable.killcrby,
Callback = function(value)
    _G.SettingsTable.killcrby = value
	saveSettings()
 
local cocopad = Instance.new("Part", game:GetService("Workspace"))
cocopad.Name = "Coconut Part"
cocopad.Anchored = true
cocopad.Transparency = 0
cocopad.Size = Vector3.new(10, 1, 10)
cocopad.Position = Vector3.new(-257.198761, 113.629799, 490.346893, 0.981367946, 0.178275719, 0.0716575235, -0.191967994, 0.894072175, 0.404701531, 0.00808144826, -0.410916984, 0.911636829)
 
 function TP(P)
   local Distance = (P.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude -- จุดที่จะไป Position Only
   local Speed = 100 -- ความเร็วของมึง
   tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear)
   tween = tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = P})
   tween:Play()
 end

 local L = CFrame.new(-307.52117919922, 107.91863250732, 467.86791992188)
 
 if value then
TP(L)
end
end
})

AutoKill:AddToggle({
Name = "Kill Snail",
Callback = function(value)
    function TP(P)
   local Distance = (P.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude -- จุดที่จะไป Position Only
   local Speed = 125 -- ความเร็วของมึง
   tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear)
   tween = tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = P})
   tween:Play()
    end
    fd = game.Workspace.FlowerZones['Stump Field'] 
local L = CFrame.new(fd.Position.X, fd.Position.Y-6, fd.Position.Z)
    if value then TP(L) else api.humanoidrootpart().CFrame = CFrame.new(fd.Position.X, fd.Position.Y+2, fd.Position.Z) end 
  end
})

AutoKill:AddToggle({
Name = "Kill Mondo",
Enabled = _G.SettingsTable.killmondo,
Callback = function(value)
    _G.SettingsTable.killmondo = value
    saveSettings()
 end
})

AutoKill:AddToggle({
Name = "Kill ViciousBee",
Enabled = _G.SettingsTable.killvicious,
Callback = function(value)
    _G.SettingsTable.killvicious = value
    saveSettings()
 end
})

AutoKill:AddToggle({
Name = "Auto Kill Mobs",
Enabled = _G.SettingsTable.autokillmobs,
Callback = function(value)
    _G.SettingsTable.autokillmobs = value
    saveSettings()
 end
})

AutoKill:AddToggle({
Name = "Auto Ant",
Enabled = _G.SettingsTable.autoant,
Callback = function(value)
    _G.SettingsTable.autoant = value
    saveSettings()
 end
})

AutoKill:AddToggle({
Name = "Avoid Mobs",
Enabled = _G.SettingsTable.avoidmobs,
Callback = function(value)
    _G.SettingsTable.avoidmobs = value
    saveSettings()
 end
})

AutoKill:AddToggle({
Name = "Kill WindyBee",
Enabled = _G.SettingsTable.killwindy,
Callback = function(value)
    _G.SettingsTable.killwindy = value
    saveSettings()
 end
})

local GeneralTab = PepsisWorld:CreateTab({
Name = "LocalPlayer"
})

local Teleport = GeneralTab:CreateSection({
Name = "Teleport"
})

Teleport:AddDropdown({
Name = "Field Teleports",
List = fieldstable,
Callback = function(value)
    function TP(P)
   local Distance = (P.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude -- จุดที่จะไป Position Only
   local Speed = 125 -- ความเร็วของมึง
   tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear)
   tween = tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = P})
   tween:Play()
    end
   local a = game:GetService("Workspace").FlowerZones:FindFirstChild(value).CFrame
   TP(a)
 end
})

Teleport:AddDropdown({
Name = "Monster Teleports",
List = spawnerstable,
Callback = function(value)
    function TP(P)
   local Distance = (P.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude -- จุดที่จะไป Position Only
   local Speed = 125 -- ความเร็วของมึง
   tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear)
   tween = tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = P})
   tween:Play()
    end
    d = game:GetService("Workspace").MonsterSpawners:FindFirstChild(value)
   local a = CFrame.new(d.Position.X, d.Position.Y+3, d.Position.Z)
   TP(a)
 end
})

Teleport:AddDropdown({
Name = "General Teleports",
List = toystable,
Callback = function(value)
    function TP(P)
   local Distance = (P.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude -- จุดที่จะไป Position Only
   local Speed = 125 -- ความเร็วของมึง
   tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear)
   tween = tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = P})
   tween:Play()
    end
    d = game:GetService("Workspace").Toys:FindFirstChild(value).Platform
   local a = CFrame.new(d.Position.X, d.Position.Y+3, d.Position.Z)
   TP(a)
 end
})

Teleport:AddButton({
Name = "Teleport to hive",
Callback = function(value)
    function TP(P)
   local Distance = (P.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude -- จุดที่จะไป Position Only
   local Speed = 125 -- ความเร็วของมึง
   tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear)
   tween = tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = P})
   tween:Play()
    end
   local a = game:GetService("Players").LocalPlayer.SpawnPos.Value
   TP(a)
 end
})

local Character = GeneralTab:CreateSection({
Name = "Character",
Side = "Right"
})

Character:AddToggle({
Name = "Walk Speed",
Enabled = _G.SettingsTable.loopspeed,
Callback = function(value)
    _G.SettingsTable.loopspeed = value
    saveSettings()
 end
})

Character:AddToggle({
Name = "Jump Power",
Enabled = _G.SettingsTable.loopjump,
Callback = function(value)
    _G.SettingsTable.loopjump = value
    saveSettings()
end
})

local Buffs = GeneralTab:CreateSection({
Name = "Buffs"
})
for i,v in pairs(buffTable) do
Buffs:AddButton({
Name = "Use"..i,
Callback = function(value)
    game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"]=i})
 end
})


Buffs:AddToggle({
Name = "Auto Use"..i,
Callback = function(bool)
   buffTable[i].b = bool
 end
})
end

local Accesories = GeneralTab:CreateSection({
Name = "Accesories",
Side = "Right"
})

Accesories:AddDropdown({
Name = "Equip Accesories",
List = accesoriestable,
Callback = function(Option)
    ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = Option, ["Category"] = "Accessory" } game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2)
 end
})

Accesories:AddDropdown({
Name = "Equip Masks",
List = masktable,
Callback = function(Option)
     local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = Option, ["Category"] = "Accessory" } game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2)
 end
})

Accesories:AddDropdown({
Name = "Equip Collectors",
List = collectorstable,
Callback = function(Option)
      local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = Option, ["Category"] = "Collector" } game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2)
 end
})

Accesories:AddDropdown({
Name = "Generate Amule",
List = {"Supreme Star Amulet", "Diamond Star Amulet", "Gold Star Amulet","Silver Star Amulet","Bronze Star Amulet","Moon Amulet"},
Callback = function(Option)
local A_1 = Option.." Generator" local Event = game:GetService("ReplicatedStorage").Events.ToyEvent Event:FireServer(A_1)
 end
})

local GeneralTab = PepsisWorld:CreateTab({
Name = "Bee"
})

local AutoFeed = GeneralTab:CreateSection({
Name = "Auto Feed"
})

function feedAllBees(treat,amt)
    for L = 1,5 do
        for U = 1,10 do
            game:GetService("ReplicatedStorage").Events.ConstructHiveCellFromEgg:InvokeServer(L, U, treat, amt)
        end
    end
end

AutoFeed:AddDropdown({
Name = "Select Food",
List = treatsTable,
     Callback = function(Option)
         kocmoc.vars.selectedTreat = Option
 end
})

AutoFeed:AddTextBox({
Name = "Food Amount",
Value = 10,
Enabled = false,
     Callback = function(Option)
         kocmoc.vars.selectedTreatAmount = tonumber(Option)
 end
})

AutoFeed:AddButton({
Name = "Feed All Bees",
Enabled = false,
     Callback = function(Option)
         feedAllBees(kocmoc.vars.selectedTreat,kocmoc.vars.selectedTreatAmount)
 end
})

local GeneralTab = PepsisWorld:CreateTab({
Name = "Configs"
})

local AutoFarm = GeneralTab:CreateSection({
Name = "AutoFarm Setting"
})

AutoFarm:AddTextBox({
Name = "Autofarming Walkspeed",
Value = "60",
Enabled = true,
     Callback = function(Option)
        kocmoc.vars.farmspeed = Option
 end
})

AutoFarm:AddToggle({
Name = "Loop Speed On Autofarming",
Enabled = _G.SettingsTable.loopfarmspeed,
     Callback = function(State)
        _G.SettingsTable.loopfarmspeed = State
        saveSettings()
 end
})

AutoFarm:AddToggle({
Name = "Don't Walk In Field",
Enabled = _G.SettingsTable.farmflower,
     Callback = function(State)
        _G.SettingsTable.farmflower = State
        saveSettings()
 end
})

AutoFarm:AddToggle({
Name = "Convert Hive Balloon",
Enabled = _G.SettingsTable.convertballoons,
     Callback = function(State)
        _G.SettingsTable.convertballoons = State
        saveSettings()
 end
})

AutoFarm:AddToggle({
Name = "Don't Farm Tokens",
Enabled = _G.SettingsTable.donotfarmtokens,
     Callback = function(State)
        _G.SettingsTable.donotfarmtokens = State
        saveSettings()
 end
})

AutoFarm:AddToggle({
Name = "Enable Token Blacklisting",
Enabled = _G.SettingsTable.enabletokenblacklisting,
     Callback = function(State)
        _G.SettingsTable.enabletokenblacklisting = State
        saveSettings()
 end
})

AutoFarm:AddSlider({
Name = "Walk Speed",
Value = 70,
Enabled = false,
Min = 0,
Max = 120,
     Callback = function(State)
      kocmoc.vars.walkspeed = State
 end
})

AutoFarm:AddSlider({
Name = "Jump Power",
Value = 70,
Enabled = false,
Min = 0,
Max = 120,
     Callback = function(State)
      kocmoc.vars.jumppower = Value
 end
})

local AutoFarm = GeneralTab:CreateSection({
Name = "Tokens Settings",
Side = "Right"
})

AutoFarm:AddTextBox({
Name = "Asset ID",
Enabled = false,
Value = "rbxassetid",
     Callback = function(State)
      rarename = State
 end
})

AutoFarm:AddButton({
Name = "Add Token To Rares List",
     Callback = function(State)
       table.insert(kocmoc.rares, rarename)
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Rares List D",true):Destroy()
 end
})

 AutoFarm:AddButton({
Name = "Remove Token From Rares List",
     Callback = function(Option)
       table.remove(kocmoc.rares, api.tablefind(kocmoc.rares, rarename))
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Rares List D",true):Destroy()
 end
})

AutoFarm:AddButton({
Name = "Add Token To Blacklist",
     Callback = function(Option)
       table.insert(kocmoc.bltokens, rarename)
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Tokens Blacklist D",true):Destroy()
 end
})

AutoFarm:AddButton({
Name = "Remove Token From Blacklist",
     Callback = function(Option)
       table.remove(kocmoc.bltokens, api.tablefind(kocmoc.bltokens, rarename))
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Tokens Blacklist D",true):Destroy()
 end
})

AutoFarm:AddDropdown({
Name = "Tokens Blacklist",
List = kocmoc.bltokens,
     Callback = function(Option)
       
 end
})

AutoFarm:AddDropdown({
Name = "Rares List",
List = kocmoc.rares,
     Callback = function(Option)
       
 end
})

local AutoFarm = GeneralTab:CreateSection({
Name = "Auto Dispenser & Auto Boosters Settings",
Side = "Right"
})

AutoFarm:AddToggle({
Name = "Royal Jelly Dispenser",
Enabled = _G.SettingsTable.RoyalJellyDispenser,
     Callback = function(State)
       _G.SettingsTable.RoyalJellyDispenser = State
       saveSettings()
       
       kocmoc.dispensesettings.rj = not kocmoc.dispensesettings.rj
 end
})

AutoFarm:AddToggle({
Name = "Blueberry Dispenser",
Enabled = _G.SettingsTable.BlueberryDispenser,
     Callback = function(State)
       _G.SettingsTable.BlueberryDispenser = State
       saveSettings()
       
       kocmoc.dispensesettings.blub = not kocmoc.dispensesettings.blub
 end
})

AutoFarm:AddToggle({
Name = "Strawberry Dispenser",
Enabled = _G.SettingsTable.StrawberryDispenser,
     Callback = function(State)
       _G.SettingsTable.StrawberryDispenser = State
       saveSettings()
       
       kocmoc.dispensesettings.straw = not kocmoc.dispensesettings.straw
 end
})

AutoFarm:AddToggle({
Name = "Treat Dispenser",
Enabled = _G.SettingsTable.TreatDispenser,
     Callback = function(State)
       _G.SettingsTable.TreatDispenser = State
       saveSettings()
       
       kocmoc.dispensesettings.treat = not kocmoc.dispensesettings.treat
 end
})

AutoFarm:AddToggle({
Name = "Coconut Dispenser",
Enabled = _G.SettingsTable.CoconutDispenser ,
     Callback = function(State)
       _G.SettingsTable.CoconutDispenser  = State
       saveSettings()
       
       kocmoc.dispensesettings.coconut = not kocmoc.dispensesettings.coconut
 end
})

AutoFarm:AddToggle({
Name = "Glue Dispenser",
Enabled = _G.SettingsTable.GlueDispenser,
     Callback = function(State)
       _G.SettingsTable.GlueDispenser = State
       saveSettings()
       
       kocmoc.dispensesettings.glue = not kocmoc.dispensesettings.glue
 end
})

AutoFarm:AddToggle({
Name = "Mountain Top Booster",
Enabled = _G.SettingsTable.MountainTopBooster,
     Callback = function(State)
       _G.SettingsTable.MountainTopBooster = State
       saveSettings()
       
       kocmoc.dispensesettings.white = not kocmoc.dispensesettings.white
 end
})

AutoFarm:AddToggle({
Name = "Blue Field Booster",
Enabled = _G.SettingsTable.BlueFieldBooster,
     Callback = function(State)
       _G.SettingsTable.BlueFieldBooster = State
       saveSettings()
       
       kocmoc.dispensesettings.blue = not kocmoc.dispensesettings.blue
 end
})

AutoFarm:AddToggle({
Name = "Red Field Booster",
Enabled = _G.SettingsTable.RedFieldBooster,
     Callback = function(State)
       _G.SettingsTable.RedFieldBooster = State
       saveSettings()
       
      kocmoc.dispensesettings.red = not kocmoc.dispensesettings.red
 end
})

local honeytoggleouyfyt = false
task.spawn(function()
    while wait(1) do
        if _G.SettingsTable.honeymaskconv == true then
        if temptable.converting then
            if honeytoggleouyfyt == false then
                honeytoggleouyfyt = true
                    game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer("Equip", {Mute=false;Type="Honey Mask";Category="Accessory"})
            end
        else
            if honeytoggleouyfyt == true then
                honeytoggleouyfyt = false
                game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer("Equip", {Mute=false;Type=kocmoc.vars.defmask;Category="Accessory"})
            end
        end
        end
    end
end)

task.spawn(function()
    while wait(5) do
        local buffs = fetchBuffTable(buffTable)
        for i,v in pairs(buffTable) do
            if v["b"] == true then
                local inuse = false
                for k,p in pairs(buffs) do
                    if k == i then inuse = true end
                end
                if inuse == false then
                    game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"]=i})
                end
            end
        end
    end
end)

task.spawn(function() while task.wait() do
    if _G.SettingsTable.autofarm then
        if _G.SettingsTable.farmflame then getflame() end
        if _G.SettingsTable.farmfuzzy then getfuzzy() end
    end
end end)

game.Workspace.Particles.ChildAdded:Connect(function(v)
    if not temptable.started.vicious and not temptable.started.ant then
        if v.Name == "WarningDisk" and not temptable.started.vicious and _G.SettingsTable.autofarm and not temptable.started.ant and _G.SettingsTable.farmcoco and (v.Position-api.humanoidrootpart().Position).magnitude < temptable.magnitude and not temptable.converting then
            table.insert(temptable.coconuts, v)
            getcoco(v)
            gettoken()
        elseif v.Name == "Crosshair" and v ~= nil and v.BrickColor ~= BrickColor.new("Forest green") and not temptable.started.ant and v.BrickColor ~= BrickColor.new("Flint") and (v.Position-api.humanoidrootpart().Position).magnitude < temptable.magnitude and _G.SettingsTable.autofarm and _G.SettingsTable.collectcrosshairs and not temptable.converting then
            if #temptable.crosshairs <= 3 then
                table.insert(temptable.crosshairs, v)
                getcrosshairs(v)
                gettoken()
            end
        end
    end
end)

task.spawn(function() while task.wait() do
        temptable.magnitude = 50
        if game.Players.LocalPlayer.Character:FindFirstChild("ProgressLabel",true) then
        local pollenprglbl = game.Players.LocalPlayer.Character:FindFirstChild("ProgressLabel",true)
        maxpollen = tonumber(pollenprglbl.Text:match("%d+$"))
        local pollencount = game.Players.LocalPlayer.CoreStats.Pollen.Value
        pollenpercentage = pollencount/maxpollen*100
        fieldselected = game:GetService("Workspace").FlowerZones[kocmoc.vars.field]
        
        if _G.SettingsTable.autouseconvertors == true then
        if tonumber(pollenpercentage) >= (kocmoc.vars.convertat - (kocmoc.vars.autoconvertWaitTime)) then
                if not temptable.consideringautoconverting then
                temptable.consideringautoconverting = true
                spawn(function()
                    wait(kocmoc.vars.autoconvertWaitTime)
                    if tonumber(pollenpercentage) >= (kocmoc.vars.convertat - (kocmoc.vars.autoconvertWaitTime)) then
                        useConvertors()
                    end
                    temptable.consideringautoconverting = false
                end)
                end
            end
        end
        
        if _G.SettingsTable.autofarm then
        if _G.SettingsTable.autodoquest and game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.Menus.Children.Quests.Content:FindFirstChild("Frame") then
            for i,v in next, game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.Menus.Children.Quests:GetDescendants() do
                if v.Name == "Description" then
                    if string.match(v.Parent.Parent.TitleBar.Text, kocmoc.vars.npcprefer) or kocmoc.vars.npcprefer == "All Quests" and not string.find(v.Text, "Puffshroom") then
                        pollentypes = {'White Pollen', "Red Pollen", "Blue Pollen", "Blue Flowers", "Red Flowers", "White Flowers"}
                        text = v.Text
                        if api.returnvalue(fieldstable, text) and not string.find(v.Text, "Complete!") and not api.findvalue(kocmoc.blacklistedfields, api.returnvalue(fieldstable, text)) then
                            d = api.returnvalue(fieldstable, text)
                            fieldselected = game:GetService("Workspace").FlowerZones[d]
                            break
                        elseif api.returnvalue(pollentypes, text) and not string.find(v.Text, 'Complete!') then
                            d = api.returnvalue(pollentypes, text)
                            if d == "Blue Flowers" or d == "Blue Pollen" then
                                fieldselected = game:GetService("Workspace").FlowerZones[kocmoc.bestfields.blue]
                                break
                            elseif d == "White Flowers" or d == "White Pollen" then
                                fieldselected = game:GetService("Workspace").FlowerZones[kocmoc.bestfields.white]
                                break
                            elseif d == "Red Flowers" or d == "Red Pollen" then
                                fieldselected = game:GetService("Workspace").FlowerZones[kocmoc.bestfields.red]
                                break
                            end
                        end
                    end
                end
            end
        else
            fieldselected = game:GetService("Workspace").FlowerZones[kocmoc.vars.field]
        end
        fieldpos = CFrame.new(fieldselected.Position.X, fieldselected.Position.Y+3, fieldselected.Position.Z)
        fieldposition = fieldselected.Position
        if temptable.sprouts.detected and temptable.sprouts.coords and _G.SettingsTable.farmsprouts then
            fieldposition = temptable.sprouts.coords.Position
            fieldpos = temptable.sprouts.coords
        end
        if _G.SettingsTable.farmpuffshrooms and game.Workspace.Happenings.Puffshrooms:FindFirstChildOfClass("Model") then 
            if api.partwithnamepart("Mythic", game.Workspace.Happenings.Puffshrooms) then
                temptable.magnitude = 25 
                fieldpos = api.partwithnamepart("Mythic", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
                fieldposition = fieldpos.Position
            elseif api.partwithnamepart("Legendary", game.Workspace.Happenings.Puffshrooms) then
                temptable.magnitude = 25 
                fieldpos = api.partwithnamepart("Legendary", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
                fieldposition = fieldpos.Position
            elseif api.partwithnamepart("Epic", game.Workspace.Happenings.Puffshrooms) then
                temptable.magnitude = 25 
                fieldpos = api.partwithnamepart("Epic", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
                fieldposition = fieldpos.Position
            elseif api.partwithnamepart("Rare", game.Workspace.Happenings.Puffshrooms) then
                temptable.magnitude = 25 
                fieldpos = api.partwithnamepart("Rare", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
                fieldposition = fieldpos.Position
            else
                temptable.magnitude = 25 
                fieldpos = api.getbiggestmodel(game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
                fieldposition = fieldpos.Position
            end
        end
        
        if (tonumber(pollenpercentage) < tonumber(kocmoc.vars.convertat)) or (_G.SettingsTable.disableconversion == true) then
            if not temptable.tokensfarm then
                api.tween(2, fieldpos)
                task.wait(2)
                temptable.tokensfarm = true
                if _G.SettingsTable.autosprinkler then makesprinklers() end
            else
                if _G.SettingsTable.killmondo then
                    while _G.SettingsTable.killmondo and game.Workspace.Monsters:FindFirstChild("Mondo Chick (Lvl 8)") and not temptable.started.vicious and not temptable.started.monsters do
                        temptable.started.mondo = true
                        while game.Workspace.Monsters:FindFirstChild("Mondo Chick (Lvl 8)") do
                            disableall()
                            game:GetService("Workspace").Map.Ground.HighBlock.CanCollide = false 
                            mondopition = game.Workspace.Monsters["Mondo Chick (Lvl 8)"].Head.Position
                            api.tween(1, CFrame.new(mondopition.x, mondopition.y - 60, mondopition.z))
                            task.wait(1)
                            temptable.float = true
                        end
                        task.wait(.5) game:GetService("Workspace").Map.Ground.HighBlock.CanCollide = true temptable.float = false api.tween(.5, CFrame.new(73.2, 176.35, -167)) task.wait(1)
                        for i = 0, 50 do 
                            gettoken(CFrame.new(73.2, 176.35, -167).Position) 
                        end 
                        enableall() 
                        api.tween(2, fieldpos) 
                        temptable.started.mondo = false
                    end
                end
                if (fieldposition-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > temptable.magnitude then
                    api.tween(0.1, fieldpos)
                    task.wait(2)
                    if _G.SettingsTable.autosprinkler then makesprinklers() end
                end
                getprioritytokens()
                if _G.SettingsTable.avoidmobs then avoidmob() end
                if _G.SettingsTable.farmclosestleaf then closestleaf() end
                if _G.SettingsTable.farmbubbles then getbubble() end
                if _G.SettingsTable.farmclouds then getcloud() end
                if _G.SettingsTable.farmunderballoons then getballoons() end
                if not _G.SettingsTable.donotfarmtokens and done then gettoken() end
                if not _G.SettingsTable.farmflower then getflower() end
            end
        elseif tonumber(pollenpercentage) >= tonumber(kocmoc.vars.convertat) then
            if not _G.SettingsTable.disableconversion then
            temptable.tokensfarm = false
            api.tween(2, game:GetService("Players").LocalPlayer.SpawnPos.Value * CFrame.fromEulerAnglesXYZ(0, 110, 0) + Vector3.new(0, 0, 9))
            task.wait(2)
            temptable.converting = true
            repeat
                converthoney()
            until game.Players.LocalPlayer.CoreStats.Pollen.Value == 0
            if _G.SettingsTable.convertballoons and gethiveballoon() then
                task.wait(6)
                repeat
                    task.wait()
                    converthoney()
                until gethiveballoon() == false or not _G.SettingsTable.convertballoons
            end
            temptable.converting = false
            temptable.act = temptable.act + 1
            task.wait(6)
            if _G.SettingsTable.autoant and not game:GetService("Workspace").Toys["Ant Challenge"].Busy.Value and rtsg().Eggs.AntPass > 0 then farmant() end
            if _G.SettingsTable.autoquest then makequests() end
            if _G.SettingsTable.autoplanters then collectplanters() end
            if _G.SettingsTable.autokillmobs then 
                if temptable.act >= kocmoc.vars.monstertimer then
                    temptable.started.monsters = true
                    temptable.act = 0
                    killmobs() 
                    temptable.started.monsters = false
                end
            end
            if kocmoc.vars.resetbeeenergy then
            --rconsoleprint("Act2:-"..tostring(temptable.act2))
            if temptable.act2 >= kocmoc.vars.resettimer then
                temptable.started.monsters = true
                temptable.act2 = 0
                repeat wait() until workspace:FindFirstChild(game.Players.LocalPlayer.Name) and workspace:FindFirstChild(game.Players.LocalPlayer.Name):FindFirstChild("Humanoid") and workspace:FindFirstChild(game.Players.LocalPlayer.Name):FindFirstChild("Humanoid").Health > 0
                workspace:FindFirstChild(game.Players.LocalPlayer.Name):BreakJoints()
                wait(6.5)
                repeat wait() until workspace:FindFirstChild(game.Players.LocalPlayer.Name)
                workspace:FindFirstChild(game.Players.LocalPlayer.Name):BreakJoints()
                wait(6.5)
                repeat wait() until workspace:FindFirstChild(game.Players.LocalPlayer.Name)
                temptable.started.monsters = false
            end
        end
        end
    end
end end end end)

task.spawn(function()
    while task.wait(1) do
		if _G.SettingsTable.killvicious and temptable.detected.vicious and temptable.converting == false and not temptable.started.monsters then
            temptable.started.vicious = true
            disableall()
			local vichumanoid = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
			for i,v in next, game.workspace.Particles:GetChildren() do
				for x in string.gmatch(v.Name, "Vicious") do
					if string.find(v.Name, "Vicious") then
						api.tween(1,CFrame.new(v.Position.x, v.Position.y, v.Position.z)) task.wait(1)
						api.tween(0.5, CFrame.new(v.Position.x, v.Position.y, v.Position.z)) task.wait(.5)
					end
				end
			end
			for i,v in next, game.workspace.Particles:GetChildren() do
				for x in string.gmatch(v.Name, "Vicious") do
                    while _G.SettingsTable.killvicious and temptable.detected.vicious do task.wait() if string.find(v.Name, "Vicious") then
                        for i=1, 4 do temptable.float = true vichumanoid.CFrame = CFrame.new(v.Position.x+10, v.Position.y, v.Position.z) task.wait(.3)
                        end
                    end end
                end
			end
            enableall()
			task.wait(1)
			temptable.float = false
            temptable.started.vicious = false
		end
	end
end)

task.spawn(function() while task.wait() do
    if _G.SettingsTable.killwindy and temptable.detected.windy and not temptable.converting and not temptable.started.vicious and not temptable.started.mondo and not temptable.started.monsters then
        temptable.started.windy = true
        wlvl = "" aw = false awb = false -- some variable for autowindy, yk?
        disableall()
        while _G.SettingsTable.killwindy and temptable.detected.windy do
            if not aw then
                for i,v in pairs(workspace.Monsters:GetChildren()) do
                    if string.find(v.Name, "Windy") then wlvl = v.Name aw = true -- we found windy!
                    end
                end
            end
            if aw then
                for i,v in pairs(workspace.Monsters:GetChildren()) do
                    if string.find(v.Name, "Windy") then
                        if v.Name ~= wlvl then
                            temptable.float = false task.wait(5) for i =1, 5 do gettoken(api.humanoidrootpart().Position) end -- collect tokens :yessir:
                            wlvl = v.Name
                        end
                    end
                end
            end
            if not awb then api.tween(1,temptable.gacf(temptable.windy, 5)) task.wait(1) awb = true end
            if awb and temptable.windy.Name == "Windy" then
                api.humanoidrootpart().CFrame = temptable.gacf(temptable.windy, 25) temptable.float = true task.wait()
            end
        end 
        enableall()
        temptable.float = false
        temptable.started.windy = false
    end
end end)

local function collectorSteal()
    if kocmoc.vars.autodigmode == "Collector Steal" then
        for i,v in pairs(game.Players:GetChildren()) do
            if v.Name ~= game.Players.LocalPlayer.Name then
                if v then
                    if v.Character then
                        if v.Character:FindFirstChildWhichIsA("Tool") then
                            if v.Character:FindFirstChildWhichIsA("Tool"):FindFirstChild("ClickEvent") then
                    v.Character:FindFirstChildWhichIsA("Tool").ClickEvent:FireServer()
                end
            end
        end
        end
        end
        end
    end
end

task.spawn(function() while task.wait(0.001) do
    if _G.SettingsTable.traincrab then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-259, 111.8, 496.4) * CFrame.fromEulerAnglesXYZ(0, 110, 90) temptable.float = true temptable.float = false end
    if _G.SettingsTable.farmrares then for k,v in next, game.workspace.Collectibles:GetChildren() do if v.CFrame.YVector.Y == 1 then if v.Transparency == 0 then decal = v:FindFirstChildOfClass("Decal") for e,r in next, kocmoc.rares do if decal.Texture == r or decal.Texture == "rbxassetid://"..r then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame break end end end end end end
    if _G.SettingsTable.autodig then 
	if game.Players.LocalPlayer then 
		if game.Players.LocalPlayer.Character then 
			if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then 
				if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild("ClickEvent", true) then 
				tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") or nil 
				end 
			end 
		end 
	if tool then getsenv(tool.ClientScriptMouse).collectStart(game:GetService("Players").LocalPlayer:GetMouse()) end end collectorSteal() workspace.NPCs.Onett.Onett["Porcelain Dipper"].ClickEvent:FireServer() end
end end)

game:GetService("Workspace").Particles.Folder2.ChildAdded:Connect(function(child)
    if child.Name == "Sprout" then
        temptable.sprouts.detected = true
        temptable.sprouts.coords = child.CFrame
    end
end)
game:GetService("Workspace").Particles.Folder2.ChildRemoved:Connect(function(child)
    if child.Name == "Sprout" then
        task.wait(30)
        temptable.sprouts.detected = false
        temptable.sprouts.coords = ""
    end
end)

Workspace.Particles.ChildAdded:Connect(function(instance)
    if string.find(instance.Name, "Vicious") then
        temptable.detected.vicious = true
    end
end)
Workspace.Particles.ChildRemoved:Connect(function(instance)
    if string.find(instance.Name, "Vicious") then
        temptable.detected.vicious = false
    end
end)
game:GetService("Workspace").NPCBees.ChildAdded:Connect(function(v)
    if v.Name == "Windy" then
        task.wait(3) temptable.windy = v temptable.detected.windy = true
    end
end)
game:GetService("Workspace").NPCBees.ChildRemoved:Connect(function(v)
    if v.Name == "Windy" then
        task.wait(3) temptable.windy = nil temptable.detected.windy = false
    end
end)

task.spawn(function() while task.wait(0.1) do
    if not temptable.converting then
        if _G.SettingsTable.autosamovar then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Samovar")
            platformm = game:GetService("Workspace").Toys.Samovar.Platform
            for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                    api.humanoidrootpart().CFrame = v.CFrame
                end
            end
        end
        if _G.SettingsTable.autostockings then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Stockings")
            platformm = game:GetService("Workspace").Toys.Stockings.Platform
            for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                    api.humanoidrootpart().CFrame = v.CFrame
                end
            end
        end
        if _G.SettingsTable.autoonettart then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Onett's Lid Art")
            platformm = game:GetService("Workspace").Toys["Onett's Lid Art"].Platform
            for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                    api.humanoidrootpart().CFrame = v.CFrame
                end
            end
        end
        if _G.SettingsTable.autocandles then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Honeyday Candles")
            platformm = game:GetService("Workspace").Toys["Honeyday Candles"].Platform
            for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                    api.humanoidrootpart().CFrame = v.CFrame
                end
            end
        end
        if _G.SettingsTable.autofeast then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Beesmas Feast")
            platformm = game:GetService("Workspace").Toys["Beesmas Feast"].Platform
            for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                    api.humanoidrootpart().CFrame = v.CFrame
                end
            end
        end
        if _G.SettingsTable.autodonate then
            if isWindshrineOnCooldown() == false then
            donateToShrine(kocmoc.vars.donoItem,kocmoc.vars.donoAmount)
            end
        end
    end
end end)

task.spawn(function() while task.wait(1) do
    temptable.runningfor = temptable.runningfor + 1
    temptable.honeycurrent = statsget().Totals.Honey
    if _G.SettingsTable.honeystorm then game.ReplicatedStorage.Events.ToyEvent:FireServer("Honeystorm") end
    if _G.SettingsTable.collectgingerbreads then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Gingerbread House") end
    if _G.SettingsTable.autodispense then
        if kocmoc.dispensesettings.rj then local A_1 = "Free Royal Jelly Dispenser" local Event = game:GetService("ReplicatedStorage").Events.ToyEvent Event:FireServer(A_1) end
        if kocmoc.dispensesettings.blub then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Blueberry Dispenser") end
        if kocmoc.dispensesettings.straw then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Strawberry Dispenser") end
        if kocmoc.dispensesettings.treat then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Treat Dispenser") end
        if kocmoc.dispensesettings.coconut then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Coconut Dispenser") end
        if kocmoc.dispensesettings.glue then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Glue Dispenser") end
    end
    if _G.SettingsTable.autoboosters then 
        if kocmoc.dispensesettings.white then game.ReplicatedStorage.Events.ToyEvent:FireServer("Field Booster") end
        if kocmoc.dispensesettings.red then game.ReplicatedStorage.Events.ToyEvent:FireServer("Red Field Booster") end
        if kocmoc.dispensesettings.blue then game.ReplicatedStorage.Events.ToyEvent:FireServer("Blue Field Booster") end
    end
    if _G.SettingsTable.clock then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Wealth Clock") end
    if _G.SettingsTable.freeantpass then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Free Ant Pass Dispenser") end
    gainedhoneylabel:UpdateText("Gained Honey: "..api.suffixstring(temptable.honeycurrent - temptable.honeystart))
end end)

game:GetService('RunService').Heartbeat:connect(function() 
    if _G.SettingsTable.autoquest then firesignal(game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.NPC.ButtonOverlay.MouseButton1Click) end
    if _G.SettingsTable.loopspeed then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = kocmoc.vars.walkspeed end
    if _G.SettingsTable.loopjump then game.Players.LocalPlayer.Character.Humanoid.JumpPower = kocmoc.vars.jumppower end
end)

game:GetService('RunService').Heartbeat:connect(function()
    for i,v in next, game.Players.LocalPlayer.PlayerGui.ScreenGui:WaitForChild("MinigameLayer"):GetChildren() do for k,q in next, v:WaitForChild("GuiGrid"):GetDescendants() do if q.Name == "ObjContent" or q.Name == "ObjImage" then q.Visible = true end end end
end)

game:GetService('RunService').Heartbeat:connect(function() 
    if temptable.float then game.Players.LocalPlayer.Character.Humanoid.BodyTypeScale.Value = 0 floatpad.CanCollide = true floatpad.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y-3.75, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z) task.wait(0)  else floatpad.CanCollide = false end
end)

local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function() vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)task.wait(1)vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

task.spawn(function()while task.wait() do
    if _G.SettingsTable.farmsnowflakes then
        task.wait(3)
        for i,v in next, temptable.tokenpath:GetChildren() do
            if v:FindFirstChildOfClass("Decal") and v:FindFirstChildOfClass("Decal").Texture == "rbxassetid://6087969886" and v.Transparency == 0 then
                api.humanoidrootpart().CFrame = CFrame.new(v.Position.X, v.Position.Y+3, v.Position.Z)
                break
            end
        end
    end
end end)

game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        if _G.SettingsTable.autofarm then
            temptable.dead = true
            _G.SettingsTable.autofarm = false
            temptable.converting = false
            temptable.farmtoken = false
        end
        if temptable.dead then
            task.wait(25)
            temptable.dead = false
            _G.SettingsTable.autofarm = true local player = game.Players.LocalPlayer
            temptable.converting = false
            temptable.tokensfarm = true
        end
    end)
end)

for _,v in next, game.workspace.Collectibles:GetChildren() do
    if string.find(v.Name,"") then
        v:Destroy()
    end
end 

task.spawn(function() while task.wait() do
    pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    task.wait(0.00001)
    currentSpeed = (pos-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
    if currentSpeed > 0 then
        temptable.running = true
    else
        temptable.running = false
    end
end end)

loadingLoops:UpdateText("Loaded Loops")

local function getMonsterName(name)
    local newName = nil
    local keywords = {
        ["Mushroom"]="Ladybug";
        ["Rhino"]="Rhino Beetle";
        ["Spider"]="Spider";
        ["Ladybug"]="Ladybug";
        ["Scorpion"]="Scorpion";
        ["Mantis"]="Mantis";
        ["Beetle"]="Rhino Beetle";
        ["Tunnel"]="Tunnel Bear";
        ["Coco"]="Coconut Crab";
        ["King"]="King Beetle";
        ["Stump"]="Stump Snail";
        ["Were"]="Werewolf"
    }
    for i,v in pairs(keywords) do
        if string.find(string.upper(name),string.upper(i)) then
            newName = v
        end
    end
    if newName == nil then newName = name end
    return newName
end

local function getNearestField(part)
    local resultingFieldPos
    local lowestMag = math.huge
    for i,v in pairs(game:GetService("Workspace").FlowerZones:GetChildren()) do
        if (v.Position - part.Position).magnitude < lowestMag then
            lowestMag = (v.Position - part.Position).magnitude
            resultingFieldPos = v.Position
        end
    end
    if lowestMag > 100 then resultingFieldPos = part.Position + Vector3.new(0,0,10) end
    if string.find(part.Name,"Tunnel") then resultingFieldPos = part.Position + Vector3.new(20,-70,0) end
    return resultingFieldPos
end

local function fetchVisualMonsterString(v)
    local mobText = nil
            if v:FindFirstChild("Attachment") then
            if v:FindFirstChild("Attachment"):FindFirstChild("TimerGui") then
                if v:FindFirstChild("Attachment"):FindFirstChild("TimerGui"):FindFirstChild("TimerLabel") then
                    if v:FindFirstChild("Attachment"):FindFirstChild("TimerGui"):FindFirstChild("TimerLabel").Visible == true then
                        local splitTimer = string.split(v:FindFirstChild("Attachment"):FindFirstChild("TimerGui"):FindFirstChild("TimerLabel").Text," ")
                        if splitTimer[3] ~= nil then
                            mobText = getMonsterName(v.Name) .. ": " .. splitTimer[3]
                        elseif splitTimer[2] ~= nil then
                            mobText = getMonsterName(v.Name) .. ": " .. splitTimer[2]
                        else
                            mobText = getMonsterName(v.Name) .. ": " .. splitTimer[1]
                        end
                    else
                        mobText = getMonsterName(v.Name) .. ": Ready"
                    end
                end
            end
        end
    return mobText
end

local function getToyCooldown(toy)
local c = require(game.ReplicatedStorage.ClientStatCache):Get()
local name = toy
local t = workspace.OsTime.Value - c.ToyTimes[name]
local cooldown = workspace.Toys[name].Cooldown.Value
local u = cooldown - t
local canBeUsed = false
if string.find(tostring(u),"-") then canBeUsed = true end
return u,canBeUsed
end

task.spawn(function()
    pcall(function()
    loadingInfo:CreateLabel("")
    loadingInfo:CreateLabel("Script loaded!")
    wait(2)
    pcall(function()
    for i,v in pairs(game.CoreGui:GetDescendants()) do
        if v.Name == "Startup S" then
            v.Parent.Parent.RightSide["Information S"].Parent = v.Parent
            v:Destroy()
        end
    end
    end)
    local panel = hometab:CreateSection("Mob Panel")
    local statusTable = {}
    for i,v in pairs(game:GetService("Workspace").MonsterSpawners:GetChildren()) do
        if not string.find(v.Name,"CaveMonster") then
        local mobText = nil
        mobText = fetchVisualMonsterString(v)
        if mobText ~= nil then
            local mob = panel:CreateButton(mobText,function()
                api.tween(1,CFrame.new(getNearestField(v)))
            end)
            table.insert(statusTable,{mob,v})
        end
        end
    end
    local mob2 = panel:CreateButton("Mondo Chick: 00:00",function() api.tween(1,game:GetService("Workspace").FlowerZones["Mountain Top Field"].CFrame) end)
    local panel2 = hometab:CreateSection("Utility Panel")
    local windUpd = panel2:CreateButton("Wind Shrine: 00:00",function() api.tween(1,CFrame.new(game:GetService("Workspace").NPCs["Wind Shrine"].Circle.Position + Vector3.new(0,5,0))) end)
    local rfbUpd = panel2:CreateButton("Red Field Booster: 00:00",function() api.tween(1,CFrame.new(game:GetService("Workspace").Toys["Red Field Booster"].Platform.Position + Vector3.new(0,5,0))) end)
    local bfbUpd = panel2:CreateButton("Blue Field Booster: 00:00",function() api.tween(1,CFrame.new(game:GetService("Workspace").Toys["Blue Field Booster"].Platform.Position + Vector3.new(0,5,0))) end)
    local wfbUpd = panel2:CreateButton("White Field Booster: 00:00",function() api.tween(1,CFrame.new(game:GetService("Workspace").Toys["Field Booster"].Platform.Position + Vector3.new(0,5,0))) end)
    local cocoDispUpd = panel2:CreateButton("Coconut Dispenser: 00:00",function() api.tween(1,CFrame.new(game:GetService("Workspace").Toys["Coconut Dispenser"].Platform.Position + Vector3.new(0,5,0))) end)
    local ic1 = panel2:CreateButton("Instant Converter A: 00:00",function() api.tween(1,CFrame.new(game:GetService("Workspace").Toys["Instant Converter"].Platform.Position + Vector3.new(0,5,0))) end)
    local ic2 = panel2:CreateButton("Instant Converter B: 00:00",function() api.tween(1,CFrame.new(game:GetService("Workspace").Toys["Instant Converter B"].Platform.Position + Vector3.new(0,5,0))) end)
    local ic3 = panel2:CreateButton("Instant Converter C: 00:00",function() api.tween(1,CFrame.new(game:GetService("Workspace").Toys["Instant Converter C"].Platform.Position + Vector3.new(0,5,0))) end)
    local wcUpd = panel2:CreateButton("Wealth Clock: 00:00",function() api.tween(1,CFrame.new(game:GetService("Workspace").Toys["Wealth Clock"].Platform.Position + Vector3.new(0,5,0))) end)
    local mmsUpd = panel2:CreateButton("Mythic Meteor Shower: 00:00",function() api.tween(1,CFrame.new(game:GetService("Workspace").Toys["Mythic Meteor Shower"].Platform.Position + Vector3.new(0,5,0))) end)
    local utilities = {
        ["Red Field Booster"]=rfbUpd;
        ["Blue Field Booster"]=bfbUpd;
        ["Field Booster"]=wfbUpd;
        ["Coconut Dispenser"]=cocoDispUpd;
        ["Instant Converter"]=ic1;
        ["Instant Converter B"]=ic2;
        ["Instant Converter C"]=ic3;
        ["Wealth Clock"]=wcUpd;
        ["Mythic Meteor Shower"]=mmsUpd;
    }
    while wait(1) do
        if _G.SettingsTable.enablestatuspanel == true then
        for i,v in pairs(statusTable) do
            if v[1] and v[2] then
                v[1]:UpdateText(
                fetchVisualMonsterString(
                v[2]
                ))
            end
        end
        if workspace:FindFirstChild("Clock") then if workspace.Clock:FindFirstChild("SurfaceGui") then if workspace.Clock.SurfaceGui:FindFirstChild("TextLabel") then
            if workspace.Clock.SurfaceGui:FindFirstChild("TextLabel").Text == "! ! !" then
                mob2:UpdateText("Mondo Chick: Ready")
            else
                mob2:UpdateText("Mondo Chick: " .. string.gsub(
                string.gsub(workspace.Clock.SurfaceGui:FindFirstChild("TextLabel").Text,"\n","")
                ,"Mondo Chick:",""))
            end
        end 
        end end
        local cooldown = require(game.ReplicatedStorage.TimeString)(3600 - (require(game.ReplicatedStorage.OsTime)() - (require(game.ReplicatedStorage.StatTools).GetLastCooldownTime(v1, "WindShrine") or 0)))
        if cooldown == "" then windUpd:UpdateText("Wind Shrine: Ready") else windUpd:UpdateText("Wind Shrine: " .. cooldown) end
        for i,v in pairs(utilities) do
            local cooldown,isUsable = getToyCooldown(i)
            if cooldown ~= nil and isUsable ~= nil then
                if isUsable then
                    v:UpdateText(i..": Ready")
                else
                    v:UpdateText(i..": "..require(game.ReplicatedStorage.TimeString)(cooldown))
                end
            end
        end
        end
    end
    end)
end)
