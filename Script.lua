```lua
local library = loadstring(game.HttpGet(game, "https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/0x"))()

local w1 = library:Window("percsploit Tower of Hell GUI") -- Text

w1:Button(
    "Teleport to Top",
    function()
        for _,v in pairs(game:GetService("Workspace").tower.finishes:GetChildren()) do
    if _ == 1 and v.Name == "Finish" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Position)
        end
    end
    end
) -- Text, Callback

w1:Slider(
    "JumpPower",
    "JP",
    50,
    300,
    function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end,
    100
) -- Text, Flag, Minimum, Maximum, Callback, Default (Optional), Flag Location (Optional)

w1:Toggle(
    "Freeze",
    "frz",
    false,
    function(toggled)
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = toggled
    end
) -- Text, Flag, Enabled, Callback, Flag Location (Optional)

w1:Button(
    "God Mode",
    function()

local CoreGui = game:getService("StarterGui")

    CoreGui:SetCore("SendNotification", {
        Title = "God Mode Enabled..",
        Text = "You've enabled god mode",
        Duration = 3
    })
        local LocalPlayer = game:GetService("Players").LocalPlayer
 
local function Invincibility()
    if LocalPlayer.Character then
        for i, v in pairs(LocalPlayer.Character:GetChildren()) do
            if v.Name == "hitbox" then
                v:Destroy()
            end
        end
    end
end
 
while wait(0.5) do
    Invincibility(LocalPlayer)
end
    end
) -- Text, Callback

w1:Button(
    "Destroy GUI",
    function()
        for i, v in pairs(game.CoreGui:GetChildren()) do
            if v:FindFirstChild("Top") then
                v:Destroy()
            end
        end
    end
) -- Text, Callback

w1:Button(
     "Copy Discord",
     function()
        print("https://discord.gg/bynm7UD6sy")
    end
) --  -- Text, Callback

w1:Label("made by percwalkk") -- Text```
