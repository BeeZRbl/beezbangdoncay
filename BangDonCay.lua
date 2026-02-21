local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("DonCayRemote")

-- Tạo GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DonCayGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 500, 0, 150)
main.Position = UDim2.new(0.3, 0, 0.15, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Active = true
main.Draggable = true

-- TextBox
local textBox = Instance.new("TextBox", main)
textBox.Size = UDim2.new(0.9, 0, 0.4, 0)
textBox.Position = UDim2.new(0.05, 0, 0.3, 0)
textBox.PlaceholderText = "Ghi đơn vào đây"
textBox.TextScaled = true
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textBox.TextColor3 = Color3.new(1, 1, 1)

-- Save Button
local saveBtn = Instance.new("TextButton", main)
saveBtn.Size = UDim2.new(0.5, 0, 0.25, 0)
saveBtn.Position = UDim2.new(0.25, 0, 0.75, 0)
saveBtn.Text = "SAVE"
saveBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
saveBtn.TextColor3 = Color3.new(1, 1, 1)

saveBtn.MouseButton1Click:Connect(function()
	remote:FireServer(textBox.Text)
	textBox.TextEditable = false
end)

-- Nhận dữ liệu từ server
remote.OnClientEvent:Connect(function(data)
	textBox.Text = data
	textBox.TextEditable = false
end)
