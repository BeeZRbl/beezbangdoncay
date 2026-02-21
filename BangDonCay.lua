local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local store = DataStoreService:GetDataStore("DonCayData")

-- Tạo Remote
local remote = Instance.new("RemoteEvent")
remote.Name = "DonCayRemote"
remote.Parent = ReplicatedStorage

-- Lưu dữ liệu
remote.OnServerEvent:Connect(function(player, text)
	if typeof(text) == "string" then
		pcall(function()
			store:SetAsync(player.UserId, text)
		end)
	end
end)

-- Khi player vào game
Players.PlayerAdded:Connect(function(player)

	-- Tạo GUI
	local gui = Instance.new("ScreenGui")
	gui.Name = "DonCayGUI"
	gui.Parent = player:WaitForChild("PlayerGui")

	local main = Instance.new("Frame", gui)
	main.Size = UDim2.new(0, 500, 0, 150)
	main.Position = UDim2.new(0.3, 0, 0.15, 0)
	main.BackgroundColor3 = Color3.fromRGB(30,30,30)
	main.Active = true
	main.Draggable = true
	Instance.new("UICorner", main).CornerRadius = UDim.new(0,15)

	-- Tabs
	local tabNote = Instance.new("TextButton", main)
	tabNote.Size = UDim2.new(0.5,0,0.2,0)
	tabNote.Text = "Note"
	tabNote.BackgroundColor3 = Color3.fromRGB(45,45,45)
	tabNote.TextColor3 = Color3.new(1,1,1)

	local tabSetting = tabNote:Clone()
	tabSetting.Parent = main
	tabSetting.Position = UDim2.new(0.5,0,0,0)
	tabSetting.Text = "Setting"

	-- Pages
	local notePage = Instance.new("Frame", main)
	notePage.Size = UDim2.new(1,0,0.8,0)
	notePage.Position = UDim2.new(0,0,0.2,0)
	notePage.BackgroundTransparency = 1

	local settingPage = notePage:Clone()
	settingPage.Parent = main
	settingPage.Visible = false

	-- Mask tên
	local function maskName(name)
		return string.sub(name,1,4).."****"
	end

	local nameLabel = Instance.new("TextLabel", notePage)
	nameLabel.Size = UDim2.new(1,0,0.4,0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextScaled = true
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextColor3 = Color3.new(1,1,1)
	nameLabel.Text = "👤 Tên : "..maskName(player.Name)

	-- TextBox
	local textBox = Instance.new("TextBox", notePage)
	textBox.Position = UDim2.new(0.05,0,0.5,0)
	textBox.Size = UDim2.new(0.9,0,0.35,0)
	textBox.TextScaled = true
	textBox.PlaceholderText = "📌 ĐƠN : GHI ĐƠN CÀY VÀO ĐÂY"
	textBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
	textBox.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", textBox).CornerRadius = UDim.new(0,8)

	-- Save Toggle
	local saveLabel = Instance.new("TextLabel", settingPage)
	saveLabel.Size = UDim2.new(0.6,0,0.5,0)
	saveLabel.BackgroundTransparency = 1
	saveLabel.Text = "Save Text"
	saveLabel.TextScaled = true
	saveLabel.TextColor3 = Color3.new(1,1,1)

	local toggle = Instance.new("Frame", settingPage)
	toggle.Position = UDim2.new(0.65,0,0.25,0)
	toggle.Size = UDim2.new(0,60,0,30)
	toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)

	local circle = Instance.new("Frame", toggle)
	circle.Size = UDim2.new(0,26,0,26)
	circle.Position = UDim2.new(0,2,0.5,-13)
	circle.BackgroundColor3 = Color3.fromRGB(255,120,0)
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

	local saved = false

	toggle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			saved = not saved
			
			if saved then
				circle:TweenPosition(UDim2.new(1,-28,0.5,-13),"Out","Quad",0.2,true)
				textBox.TextEditable = false
				remote:FireServer(player, textBox.Text)
			else
				circle:TweenPosition(UDim2.new(0,2,0.5,-13),"Out","Quad",0.2,true)
				textBox.TextEditable = true
			end
		end
	end)

	-- Tab chuyển
	tabNote.MouseButton1Click:Connect(function()
		notePage.Visible = true
		settingPage.Visible = false
	end)

	tabSetting.MouseButton1Click:Connect(function()
		notePage.Visible = false
		settingPage.Visible = true
	end)

	-- Load Data
	local data
	pcall(function()
		data = store:GetAsync(player.UserId)
	end)
	if data then
		textBox.Text = data
	end

end)
