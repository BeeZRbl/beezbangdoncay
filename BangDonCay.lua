--// SERVICES
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

--// TẠO REMOTE (nếu chưa có)
local remote = ReplicatedStorage:FindFirstChild("DonCayRemote")
if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = "DonCayRemote"
	remote.Parent = ReplicatedStorage
end

--// DATASTORE (server side xử lý)
if game:GetService("RunService"):IsServer() then
	
	local store = DataStoreService:GetDataStore("DonCayData")

	remote.OnServerEvent:Connect(function(plr, text)
		pcall(function()
			store:SetAsync(plr.UserId, text)
		end)
	end)

	Players.PlayerAdded:Connect(function(plr)
		local data
		pcall(function()
			data = store:GetAsync(plr.UserId)
		end)
		if data then
			remote:FireClient(plr, data)
		end
	end)
	
	return
end

--// ===== CLIENT GUI =====

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "DonCayGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, 140)
frame.Position = UDim2.new(0.35, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true -- KÉO THẢ

-- Bo góc
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- Mask tên
local function maskName(name)
	return string.sub(name,1,4) .. "****"
end

local nameLabel = Instance.new("TextLabel", frame)
nameLabel.Size = UDim2.new(1,0,0.35,0)
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Color3.new(1,1,1)
nameLabel.TextScaled = true
nameLabel.Font = Enum.Font.GothamBold
nameLabel.Text = "Tên : "..maskName(player.Name)

-- TextBox
local textBox = Instance.new("TextBox", frame)
textBox.Position = UDim2.new(0.05,0,0.45,0)
textBox.Size = UDim2.new(0.9,0,0.35,0)
textBox.TextScaled = true
textBox.PlaceholderText = "GHI ĐƠN CÀY VÀO ĐÂY..."
textBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
textBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", textBox).CornerRadius = UDim.new(0,8)

-- Setting Button
local settingBtn = Instance.new("TextButton", frame)
settingBtn.Position = UDim2.new(0.8,0,0.02,0)
settingBtn.Size = UDim2.new(0.18,0,0.25,0)
settingBtn.Text = "Setting"
settingBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
settingBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", settingBtn).CornerRadius = UDim.new(0,6)

-- Setting Frame
local settingFrame = Instance.new("Frame", gui)
settingFrame.Size = UDim2.new(0,200,0,100)
settingFrame.Position = UDim2.new(0.4,0,0.4,0)
settingFrame.Visible = false
settingFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
settingFrame.Active = true
settingFrame.Draggable = true
Instance.new("UICorner", settingFrame).CornerRadius = UDim.new(0,10)

-- Save Toggle
local saveToggle = Instance.new("TextButton", settingFrame)
saveToggle.Size = UDim2.new(1,0,1,0)
saveToggle.Text = "Save Text : OFF"
saveToggle.BackgroundColor3 = Color3.fromRGB(45,45,45)
saveToggle.TextColor3 = Color3.new(1,1,1)

local saved = false

settingBtn.MouseButton1Click:Connect(function()
	settingFrame.Visible = not settingFrame.Visible
end)

saveToggle.MouseButton1Click:Connect(function()
	saved = not saved
	
	if saved then
		saveToggle.Text = "Save Text : ON"
		textBox.TextEditable = false
		remote:FireServer(textBox.Text)
	else
		saveToggle.Text = "Save Text : OFF"
		textBox.TextEditable = true
	end
end)

-- Nhận dữ liệu
remote.OnClientEvent:Connect(function(data)
	if data then
		textBox.Text = data
	end
end)
