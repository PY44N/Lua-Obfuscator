local isrbxactive = isrbxactive or nil
local keypress = keypress or nil

assert(isrbxactive, "[Narwhal] Your Exploit Doesn't Support isrbxactive")
assert(keypress, "[Narwhal] Your Exploit Doesn't Support keypress")

function ChatThread()
	while _G.Toggle do
		if isrbxactive then
			keypress(0xBF)
			wait(0.1)
			keyrelease(0xBF)
			wait(0.1)
			keypress(0x11)
			wait(0.1)
			keypress(0x56)
			wait(0.1)
			keyrelease(0x11)
			wait(0.1)
			keyrelease(0x56)
			wait(0.1)
			keypress(0x0D)
			wait(0.1)
			keyrelease(0x0D)
			wait(_G.Delay)		
		end
		wait(0.1)
	end	
end

spawn(ChatThread)

local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)