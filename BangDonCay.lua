local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Ẩn một phần tên
local function hideName(name)
	local visibleLength = math.max(3, math.floor(#name * 0.5))
	local hiddenPart = string.rep("*", #name - visibleLength)
	return string.sub(name, 1, visibleLength) .. hiddenPart
end

-- GUI chính
local nameHub = Instance.new("ScreenGui")
nameHub.Name = "NameHub"
nameHub.ResetOnSpawn = false
nameHub.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Parent = nameHub
mainFrame.Size = UDim2.new(0.35, 0, 0.14, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.12, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Active = true
mainFrame.Draggable = true

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0.15, 0)

-- TAB BUTTONS
local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Size = UDim2.new(1, 0, 0.3, 0)
tabFrame.BackgroundTransparency = 1

local noteTab = Instance.new("TextButton", tabFrame)
noteTab.Size = UDim2.new(0.5, 0, 1, 0)
noteTab.Text = "📌 Note"
noteTab.BackgroundTransparency = 1
noteTab.TextColor3 = Color3.new(1,1,1)
noteTab.TextScaled = true
noteTab.Font = Enum.Font.GothamBold

local settingTab = noteTab:Clone()
settingTab.Parent = tabFrame
settingTab.Position = UDim2.new(0.5,0,0,0)
settingTab.Text = "⚙ Setting"

-- PAGES
local notePage = Instance.new("Frame", mainFrame)
notePage.Size = UDim2.new(1, 0, 0.7, 0)
notePage.Position = UDim2.new(0, 0, 0.3, 0)
notePage.BackgroundTransparency = 1

local settingPage = notePage:Clone()
settingPage.Parent = mainFrame
settingPage.Visible = false

-- ===== NOTE PAGE =====

local nameLabel = Instance.new("TextLabel", notePage)
nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Color3.new(1,1,1)
nameLabel.TextScaled = true
nameLabel.Font = Enum.Font.GothamBold
nameLabel.Text = "👤 Tên : " .. hideName(player.Name)

local jobFrame = Instance.new("Frame", notePage)
jobFrame.Size = UDim2.new(1, 0, 0.5, 0)
jobFrame.Position = UDim2.new(0, 0, 0.5, 0)
jobFrame.BackgroundTransparency = 1

local jobTitle = Instance.new("TextLabel", jobFrame)
jobTitle.Size = UDim2.new(0.3, 0, 1, 0)
jobTitle.BackgroundTransparency = 1
jobTitle.TextColor3 = Color3.fromRGB(255, 223, 88)
jobTitle.TextScaled = true
jobTitle.Font = Enum.Font.GothamBold
jobTitle.Text = "📌 Đơn :"

local jobBox = Instance.new("TextBox", jobFrame)
jobBox.Size = UDim2.new(0.7, 0, 1, 0)
jobBox.Position = UDim2.new(0.3, 0, 0, 0)
jobBox.BackgroundTransparency = 1
jobBox.TextColor3 = Color3.new(1,1,1)
jobBox.TextScaled = true
jobBox.Font = Enum.Font.GothamBold
jobBox.ClearTextOnFocus = false
jobBox.TextWrapped = true

-- ===== SETTING PAGE =====

local saveLabel = Instance.new("TextLabel", settingPage)
saveLabel.Size = UDim2.new(0.6,0,1,0)
saveLabel.BackgroundTransparency = 1
saveLabel.Text = "Save Text"
saveLabel.TextScaled = true
saveLabel.Font = Enum.Font.GothamBold
saveLabel.TextColor3 = Color3.new(1,1,1)

local toggle = Instance.new("Frame", settingPage)
toggle.Size = UDim2.new(0,60,0,28)
toggle.Position = UDim2.new(0.75,0,0.5,-14)
toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)

local circle = Instance.new("Frame", toggle)
circle.Size = UDim2.new(0,24,0,24)
circle.Position = UDim2.new(0,2,0.5,-12)
circle.BackgroundColor3 = Color3.fromRGB(255,140,0)
Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

local saved = false

toggle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		saved = not saved
		
		if saved then
			circle:TweenPosition(UDim2.new(1,-26,0.5,-12),"Out","Quad",0.2,true)
			jobBox.TextEditable = false
		else
			circle:TweenPosition(UDim2.new(0,2,0.5,-12),"Out","Quad",0.2,true)
			jobBox.TextEditable = true
		end
	end
end)

-- TAB SWITCH
noteTab.MouseButton1Click:Connect(function()
	notePage.Visible = true
	settingPage.Visible = false
end)

settingTab.MouseButton1Click:Connect(function()
	notePage.Visible = false
	settingPage.Visible = true
end)
