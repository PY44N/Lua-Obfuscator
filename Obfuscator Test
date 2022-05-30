local CoreGui = game:GetService("StarterGui")

CoreGui:SetCore("SendNotification", {
    Title = "Script Made By",
    Text = "GhostPlayer",
    Icon = "rbxassetid://29819383",
    Duration = 2.5,
})

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextButton = Instance.new("TextBox")


ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.new(0,0,0)
Frame.BorderColor3 = Color3.new(0,0,0)
Frame.Position = UDim2.new(0.47,0,0.02)
Frame.Size = UDim2.new(0.1,0.1,0.1)
Frame.Active = true
Frame.Draggable = false

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.new(0,0,0)
TextButton.BackgroundTransparency = 0.50
TextButton.Position = UDim2.new(0.103524067, 0, 0.200333327, 0)
TextButton.TextColor3 = Color3.new(1,1,1)
TextButton.Size = UDim2.new(0.8,0.9,0.6)
TextButton.Font = Enum.Font.SourceSansLight
TextButton.FontSize = Enum.FontSize.Size14
TextButton.Text = "Jump Speed"
TextButton.TextScaled = true
TextButton.TextSize = 8
TextButton.TextWrapped = true

local Library =
   loadstring(game:HttpGet("https://raw.githubusercontent.com/preztel/AzureLibrary/master/uilib.lua", true))()

local AutoTab = Library:CreateTab("Auto Jump", "Script Made By GhostPlayer", true)

AutoTab:CreateToggle(
   "Start Auto Jump",
   function(kd55fs)
hummy = game:GetService("Players").LocalPlayer.Character.Humanoid
pcall(function()
end)
while hummy.Parent.Parent ~= nil do
wait(TextButton.Text)
game.Players.LocalPlayer.Character.Humanoid.Jump = true
end
       end)
