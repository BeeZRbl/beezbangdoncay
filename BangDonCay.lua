local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UIS = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")

local fileName = "note_save.txt"

if isfile and isfile(fileName) then
    getgenv().SavedText = readfile(fileName)
else
    getgenv().SavedText = ""
end

local function hideName(name)
    if #name <= 4 then return name end
    return string.sub(name,1,4).."****"
end

local function getSingle()
    local single = "N/A"
    pcall(function()
        if player:FindFirstChild("Data") and player.Data:FindFirstChild("Kill") then
            single = tostring(player.Data.Kill.Value)
        elseif player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Kill") then
            single = tostring(player.leaderstats.Kill.Value)
        end
    end)
    return single
end

local function getDevil()
    local devil = "None"
    pcall(function()
        if player:FindFirstChild("Data") and player.Data:FindFirstChild("Devil") then
            devil = tostring(player.Data.Devil.Value)
        elseif player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Devil") then
            devil = tostring(player.leaderstats.Devil.Value)
        end
    end)
    return devil
end

local function getGameName()
    local name = "Unknown Game"
    pcall(function()
        name = MarketplaceService:GetProductInfo(game.PlaceId).Name
    end)
    return name
end

local Images = {}
pcall(function()
    Images = require(script.Parent.id)
end)
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "BangdonUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 180)
main.Position = UDim2.new(0.5, 0, 0.4, 0)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(0,0,0)
main.BackgroundTransparency = 0.2
main.Active = true
main.Draggable = true

local MainCorner = Instance.new("UICorner", main)
MainCorner.CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", main)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.1
MainStroke.Color = Color3.fromRGB(255,215,0)

local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
titleBar.BackgroundTransparency = 0.8
local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 12)

local logo = Instance.new("ImageLabel", titleBar)
logo.Size = UDim2.new(0, 24, 0, 24)
logo.Position = UDim2.new(0, 10, 0.5, -12)
logo.BackgroundTransparency = 1
logo.Image = Images["activity"] or ""
logo.ImageColor3 = Color3.fromRGB(255, 215, 0)

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 40, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Beez Notes"
titleText.TextColor3 = Color3.fromRGB(255, 215, 0)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left

local gradient = Instance.new("UIGradient", MainStroke)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,215,0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,215,0))
})
main.BackgroundColor3 = Color3.fromRGB(0,0,0)
main.BackgroundTransparency = 0.4

local Images = {}
pcall(function()
    Images = require(script.Parent.id)
end)

local HttpService = game:GetService("HttpService")
local function sendDiscordWebhook(eventName, content)
    if not CFG.Webhook.Enabled then return end
    local url = CFG.Webhook.Url or getgenv().webhook
    if not url or url == "" then return end
    local embed = {
        title = "✨ " .. eventName,
        description = content,
        color = 0xFFD700,
        fields = {
            {name = "🎮 Game", value = getGameName(), inline = false},
            {name = "👤 Player", value = player.Name .. " (" .. player.DisplayName .. ")", inline = true},
            {name = "📊 Single", value = getSingle(), inline = true},
            {name = "🔗 JobId", value = "```" .. game.JobId .. "```", inline = false},
        },
        thumbnail = {url = Images["user"] or ""},
        footer = {text = "Beez Notes" .. os.date("%X")},
    }
    local payload = HttpService:JSONEncode({
        username = "Beez Notes",
        avatar_url = Images["activity"] or "",
        embeds = {embed}
    })
    local requestFunc = syn and syn.request or request
    if requestFunc then
        requestFunc({
            Url = url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = payload,
        })
    end
end
Players.PlayerAdded:Connect(function(p)
    local isStaff = false
    for _, name in ipairs(StaffList) do
        if p.Name:lower():find(name:lower()) then
            isStaff = true
            break
        end
    end
    
    if isStaff then
        sendDiscordWebhook("⚠️ STAFF DETECTED", "A staff member or famous player joined: **" .. p.Name .. "**")
    else
        sendDiscordWebhook("Player Joined", "Player " .. p.Name .. " joined the game")
    end
end)
Players.PlayerRemoving:Connect(function(p)
    sendDiscordWebhook("Player Left", "Player " .. p.Name .. " left the game")
end)

local sendBtn = Instance.new("TextButton", main)
sendBtn.Size = UDim2.new(0, 100, 0, 30)
sendBtn.Position = UDim2.new(1, -110, 1, -40)
sendBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
sendBtn.Text = "  Report"
sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sendBtn.Font = Enum.Font.Gotham
sendBtn.TextSize = 12
local btnCorner = Instance.new("UICorner", sendBtn)
btnCorner.CornerRadius = UDim.new(0, 6)
local btnStroke = Instance.new("UIStroke", sendBtn)
btnStroke.Color = Color3.fromRGB(255,215,0)
btnStroke.Thickness = 1.5
btnStroke.Transparency = 0.5

local reportIcon = Instance.new("ImageLabel", sendBtn)
reportIcon.Size = UDim2.new(0, 16, 0, 16)
reportIcon.Position = UDim2.new(0, 8, 0.5, -8)
reportIcon.BackgroundTransparency = 1
reportIcon.Image = Images["alerttriangle"] or ""
reportIcon.ImageColor3 = Color3.fromRGB(255,215,0)

sendBtn.MouseButton1Click:Connect(function()
    sendDiscordWebhook("Bangdon Report", "Player " .. player.Name .. " is using Bangdon UI")
end)

local bar = Instance.new("Frame", main)
bar.Size = UDim2.new(1, 0, 0, 30)
bar.Position = UDim2.new(0, 0, 0, 35)
bar.BackgroundTransparency = 1

local tabs = {"Note", "Status", "Setting"}
local tabIcons = {"book", "activity", "settings"}
local pages = {}
local buttons = {}

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -20, 1, -80)
container.Position = UDim2.new(0, 10, 0, 65)
container.BackgroundTransparency = 1

for i,v in ipairs(tabs) do
    local b = Instance.new("TextButton", bar)
    b.Size = UDim2.new(1/3,0,1,0)
    b.Position = UDim2.new((i-1)/3,0,0,0)
    b.Text = "  " .. v
    b.BackgroundTransparency = 1
    b.TextColor3 = Color3.fromRGB(180, 180, 180)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12

    local icon = Instance.new("ImageLabel", b)
    icon.Size = UDim2.new(0, 14, 0, 14)
    icon.Position = UDim2.new(0.5, -35, 0.5, -7)
    icon.BackgroundTransparency = 1
    icon.Image = Images[tabIcons[i]] or ""
    icon.ImageColor3 = Color3.fromRGB(180, 180, 180)

    local p = Instance.new("Frame", container)
    p.Size = UDim2.new(1,0,1,0)
    p.Visible = false
    p.BackgroundTransparency = 1

    buttons[i] = b
    pages[i] = p
end

local nameLabel = Instance.new("TextLabel", pages[1])
nameLabel.Size = UDim2.new(1,0,0.5,0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = "👤 Tên : "..player.Name
nameLabel.TextColor3 = Color3.new(1,1,1)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 16

local input = Instance.new("TextBox", pages[1])
input.Position = UDim2.new(0,0,0.5,0)
input.Size = UDim2.new(1,0,0.5,0)
input.BackgroundTransparency = 1
input.PlaceholderText = "GHI DON VAO DAY"
input.Text = getgenv().SavedText
input.TextColor3 = Color3.new(1,1,1)
input.Font = Enum.Font.GothamBold
input.TextSize = 15
input.ClearTextOnFocus = false

input.FocusLost:Connect(function()
    getgenv().SavedText = input.Text
    if writefile then
        writefile(fileName, input.Text)
    end
end)

local status = Instance.new("TextLabel", pages[2])
status.Size = UDim2.new(1,0,1,0)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.new(1,1,1)
status.Font = Enum.Font.GothamBold
status.TextSize = 14

RunService.RenderStepped:Connect(function()
    status.Text = "PlaceId: "..game.PlaceId..
        "\nPlayers: "..#game:GetService("Players"):GetPlayers()..
        "\nJobId: "..game.JobId
    nameLabel.Text = "👤 Tên : "..player.Name
end)

local setting = Instance.new("TextLabel", pages[3])
setting.Size = UDim2.new(1,0,0.5,0)
setting.BackgroundTransparency = 1
setting.Text = "💾 Auto Save: FILE"
setting.TextColor3 = Color3.fromRGB(120,255,120)
setting.Font = Enum.Font.GothamBold
setting.TextSize = 14

local copyJob = Instance.new("TextButton", pages[3])
copyJob.Size = UDim2.new(0, 150, 0, 30)
copyJob.Position = UDim2.new(0.5, -75, 0.6, 0)
copyJob.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
copyJob.Text = "📋 Copy JobId"
copyJob.TextColor3 = Color3.fromRGB(255, 215, 0)
copyJob.Font = Enum.Font.GothamBold
copyJob.TextSize = 14
Instance.new("UICorner", copyJob).CornerRadius = UDim.new(0, 6)
local jobStroke = Instance.new("UIStroke", copyJob)
jobStroke.Color = Color3.fromRGB(255, 215, 0)

copyJob.MouseButton1Click:Connect(function()
    setclipboard(game.JobId)
    copyJob.Text = "✅ Copied!"
    task.wait(2)
    copyJob.Text = "📋 Copy JobId"
end)

local function switch(i)
    for k,v in ipairs(pages) do
        v.Visible = false
        buttons[k].TextColor3 = Color3.fromRGB(200,200,200)
    end
    pages[i].Visible = true
    buttons[i].TextColor3 = Color3.fromRGB(255, 215, 0)
    if buttons[i]:FindFirstChildOfClass("ImageLabel") then
        buttons[i]:FindFirstChildOfClass("ImageLabel").ImageColor3 = Color3.fromRGB(255, 215, 0)
    end
end

for i,b in ipairs(buttons) do
    b.MouseButton1Click:Connect(function()
        switch(i)
    end)
end

switch(1)

local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0, 60, 0, 60)
toggle.Position = UDim2.new(1, -80, 1, -80)
toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggle.Text = ""
Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
local toggleStroke = Instance.new("UIStroke", toggle)
toggleStroke.Color = Color3.fromRGB(255, 215, 0)
toggleStroke.Thickness = 2

local toggleIcon = Instance.new("ImageLabel", toggle)
toggleIcon.Size = UDim2.new(0, 40, 0, 40)
toggleIcon.Position = UDim2.new(0.5, -20, 0.5, -20)
toggleIcon.BackgroundTransparency = 1
toggleIcon.Image = Images["activity"] or ""
toggleIcon.ImageColor3 = Color3.fromRGB(0, 0, 0)

local dragging=false
local startPos, startFramePos

toggle.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging=true
        startPos=i.Position
        startFramePos=toggle.Position
    end
end)

UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta=i.Position-startPos
        toggle.Position=UDim2.new(
            startFramePos.X.Scale,
            startFramePos.X.Offset+delta.X,
            startFramePos.Y.Scale,
            startFramePos.Y.Offset+delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging=false
    end
end)

local visible=true
toggle.MouseButton1Click:Connect(function()
    visible = not visible
    main.Visible = visible
end)

local statsLabel = Instance.new("TextLabel", gui)
statsLabel.Position = UDim2.new(0,10,0,60)
statsLabel.Size = UDim2.new(0,150,0,50)
statsLabel.BackgroundTransparency = 1
statsLabel.Font = Enum.Font.GothamBold
statsLabel.TextSize = 16 

local frames = {}
local smoothPing = 0
local fps = 60
local hue = 0

RunService.RenderStepped:Connect(function(dt)
    table.insert(frames, dt)
    if #frames > 50 then table.remove(frames,1) end
end)

task.spawn(function()
    while true do
        local sum=0
        for _,v in ipairs(frames) do sum+=v end
        if #frames>0 then fps=math.floor(1/(sum/#frames)) end

        local raw = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        smoothPing = smoothPing + (raw - smoothPing)*0.05

        hue = (hue + 0.02) % 1
        statsLabel.TextColor3 = Color3.fromHSV(hue,1,1)

        statsLabel.Text = "FPS: "..fps.."\nPing: "..math.floor(smoothPing).." ms"

        task.wait(0.5)
    end
end)

local BloxFruits_IDs = {
    [27539155] = true, [2753915549] = true, [85211729168715] = true,
    [4442272187] = true, [4442272183] = true, [79091703265657] = true,
    [7449423635] = true, [100117331123089] = true
}

local MainScriptLink = "https://raw.githubusercontent.com/letrungkien2k10/LoL/refs/heads/main/Notify"

if BloxFruits_IDs[game.PlaceId] then
    print("Blox Fruits Detected! Loading main script...")
    
    task.spawn(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet(MainScriptLink))()
        end)
        
        if not success then
            warn("Loi khi load script: " .. tostring(err))
        end
    end)
end
