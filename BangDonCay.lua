-- KEY SYSTEM
local KeyLink = "https://raw.githubusercontent.com/BeeZRbl/key.txt/refs/heads/main/key.txt"
local function getValidKeys()
    local success, result = pcall(function()
        return game:HttpGet(KeyLink)
    end)
    if success then
        local keys = {}
        for key in result:gmatch("[^\n]+") do
            keys[key:gsub("%s+", "")] = true
        end
        return keys
    end
    return {}
end
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
-- KEY GUI
local keyGui = Instance.new("ScreenGui", playerGui)
keyGui.Name = "KeySystem"
keyGui.ResetOnSpawn = false
local keyFrame = Instance.new("Frame", keyGui)
keyFrame.Size = UDim2.new(0, 350, 0, 160)
keyFrame.Position = UDim2.new(0.5, -175, 0.5, -80)
keyFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
keyFrame.BorderSizePixel = 0
Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", keyFrame)
stroke.Color = Color3.fromRGB(255, 215, 0)
stroke.Thickness = 2
local title = Instance.new("TextLabel", keyFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🔑 BeeZ Key System"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0.85, 0, 0, 35)
keyBox.Position = UDim2.new(0.075, 0, 0, 50)
keyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.PlaceholderText = "Nhập key vào đây..."
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 13
keyBox.Text = ""
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 6)
local statusLabel = Instance.new("TextLabel", keyFrame)
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0, 90)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 13
local confirmBtn = Instance.new("TextButton", keyFrame)
confirmBtn.Size = UDim2.new(0.5, 0, 0, 32)
confirmBtn.Position = UDim2.new(0.25, 0, 0, 118)
confirmBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
confirmBtn.Text = "Xác nhận"
confirmBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
confirmBtn.Font = Enum.Font.GothamBold
confirmBtn.TextSize = 14
Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 6)

confirmBtn.MouseButton1Click:Connect(function()
    local inputKey = keyBox.Text:gsub("%s+", "")
    local validKeys = getValidKeys()
    if validKeys[inputKey] then
        statusLabel.Text = "✅ Key hợp lệ! Đang load..."
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        task.wait(1)
        keyGui:Destroy()
        -- LOAD SCRIPTS
        task.spawn(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/BeeZRbl/joinjobid/refs/heads/main/joinjobid"))()
        end)
        task.spawn(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/BeeZRbl/fixlag/refs/heads/main/fixlagscript"))()
        end)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/BeeZRbl/beezbangdoncay/refs/heads/main/BangDonCay.lua"))()
    else
        statusLabel.Text = "❌ Key không hợp lệ!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end)
