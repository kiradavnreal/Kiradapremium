local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

-- Đợi game tải
repeat task.wait() until game:IsLoaded() and LocalPlayer

-- Danh sách key hợp lệ
local validKeys = {
    ["noob"] = true,
    ["namgamer"] = true,
    ["kiradavnhub"] = true,
    ["tunghub"] = true,
    ["hangay"] = true,
    ["nguyendo"] = true,
    ["chunggay"] = true,
    ["huyencute"] = true,
    ["test"] = true,
    ["lucy"] = true,
    ["soma"] = true,
    ["redzhub"] = true
}

-- Giao diện nhập key với chủ đề Minecraft cải tiến
local function createKeyGui()
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.Name = "KeySystemGui"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false

    -- Frame chính
    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 450, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(107, 142, 35) -- Xanh cỏ Minecraft
    mainFrame.BorderSizePixel = 0

    -- Bo góc
    local corner = Instance.new("UICorner", mainFrame)
    corner.CornerRadius = UDim.new(0, 12)

    -- Gradient nền
    local uiGradient = Instance.new("UIGradient", mainFrame)
    uiGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(107, 142, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(139, 69, 19))
    }
    uiGradient.Rotation = 90

    -- Texture khối cỏ Minecraft
    local texture = Instance.new("ImageLabel", mainFrame)
    texture.Size = UDim2.new(1, 0, 1, 0)
    texture.BackgroundTransparency = 1
    texture.Image = "rbxassetid://518761377" -- Texture khối cỏ Minecraft
    texture.ImageTransparency = 0.7
    texture.ZIndex = 0

    -- Tiêu đề
    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(0.9, 0, 0.2, 0)
    title.Position = UDim2.new(0.05, 0, 0.05, 0)
    title.BackgroundTransparency = 1
    title.Text = "Kirada Premium - Hệ Thống Key"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.MinecraftEvenCraft
    title.TextStrokeTransparency = 0.6
    title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

    -- Hiệu ứng phát sáng cho tiêu đề
    local uiStroke = Instance.new("UIStroke", title)
    uiStroke.Color = Color3.fromRGB(255, 215, 0)
    uiStroke.Thickness = 1.5
    uiStroke.Transparency = 0.8

    -- TextBox nhập key
    local textBox = Instance.new("TextBox", mainFrame)
    textBox.Size = UDim2.new(0.8, 0, 0.15, 0)
    textBox.Position = UDim2.new(0.1, 0, 0.35, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(150, 150, 150) -- Xám đá
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderText = "Nhập key tại đây..."
    textBox.Text = ""
    textBox.TextScaled = true
    textBox.Font = Enum.Font.MinecraftEvenCraft
    textBox.ClearTextOnFocus = false

    local textBoxCorner = Instance.new("UICorner", textBox)
    textBoxCorner.CornerRadius = UDim.new(0, 8)

    local textBoxStroke = Instance.new("UIStroke", textBox)
    textBoxStroke.Color = Color3.fromRGB(255, 255, 255)
    textBoxStroke.Thickness = 1
    textBoxStroke.Transparency = 0.5

    local textBoxGradient = Instance.new("UIGradient", textBox)
    textBoxGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(169, 169, 169)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(105, 105, 105))
    }

    -- Nút xác nhận
    local submitButton = Instance.new("TextButton", mainFrame)
    submitButton.Size = UDim2.new(0.4, 0, 0.15, 0)
    submitButton.Position = UDim2.new(0.3, 0, 0.65, 0)
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0) -- Xanh emerald
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.Text = "Xác Nhận"
    submitButton.TextScaled = true
    submitButton.Font = Enum.Font.MinecraftEvenCraft
    submitButton.TextStrokeTransparency = 0.6
    submitButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

    local buttonCorner = Instance.new("UICorner", submitButton)
    buttonCorner.CornerRadius = UDim.new(0, 8)

    local buttonStroke = Instance.new("UIStroke", submitButton)
    buttonStroke.Color = Color3.fromRGB(255, 255, 255)
    buttonStroke.Thickness = 1
    buttonStroke.Transparency = 0.5

    local buttonGradient = Instance.new("UIGradient", submitButton)
    buttonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 128, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 0))
    }

    -- Hiệu ứng hover cho nút
    submitButton.MouseEnter:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 0)}):Play()
    end)
    submitButton.MouseLeave:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 128, 0)}):Play()
    end)

    -- Biến kiểm tra key
    local keyEntered = false

    -- Xử lý khi nhấn nút xác nhận
    submitButton.MouseButton1Click:Connect(function()
        if validKeys[textBox.Text:lower()] then
            keyEntered = true
            StarterGui:SetCore("SendNotification", {
                Title = "Thành Công",
                Text = "Key hợp lệ! Đang tải menu chính...",
                Duration = 4
            })
            -- Hiệu ứng fade out
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            TweenService:Create(mainFrame, tweenInfo, {BackgroundTransparency = 1}):Play()
            TweenService:Create(title, tweenInfo, {TextTransparency = 1}):Play()
            TweenService:Create(textBox, tweenInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(submitButton, tweenInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(texture, tweenInfo, {ImageTransparency = 1}):Play()
            task.wait(0.5)
            screenGui:Destroy()
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Lỗi",
                Text = "Key không hợp lệ! Vui lòng thử lại.",
                Duration = 4
            })
            textBox.Text = ""
            -- Hiệu ứng rung nhẹ khi nhập sai
            local originalPos = mainFrame.Position
            for i = 1, 3 do
                TweenService:Create(mainFrame, TweenInfo.new(0.05), {Position = originalPos + UDim2.new(0, 5, 0, 0)}):Play()
                task.wait(0.05)
                TweenService:Create(mainFrame, TweenInfo.new(0.05), {Position = originalPos - UDim2.new(0, 5, 0, 0)}):Play()
                task.wait(0.05)
            end
            TweenService:Create(mainFrame, TweenInfo.new(0.05), {Position = originalPos}):Play()
        end
    end)

    -- Hỗ trợ nhấn Enter để xác nhận
    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            submitButton:Activate()
        end
    end)

    -- Trả về biến keyEntered để kiểm tra
    return function()
        while not keyEntered do
            task.wait(0.1)
        end
        return true
    end
end

-- Chạy giao diện key và đợi xác nhận
local checkKey = pcall(createKeyGui)
if not checkKey then
    StarterGui:SetCore("SendNotification", {
        Title = "Lỗi",
        Text = "Không thể tạo giao diện key!",
        Duration = 5
    })
    return
end
local waitForKey = checkKey()
waitForKey()

-- Chỉ chạy phần còn lại sau khi key hợp lệ
-- Preload tài nguyên
pcall(function()
    ContentProvider:PreloadAsync({
        "rbxassetid://75676578090181",
        "rbxassetid://89326205091486",
        "rbxassetid://8987546731"
    })
end)

-- Âm thanh startup
local function playStartupSound()
    local sound = Instance.new("Sound", SoundService)
    sound.SoundId = "rbxassetid://8987546731"
    sound.Volume = 1
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end
pcall(playStartupSound)

-- Intro animation
local function introAnimation()
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.IgnoreGuiInset = true
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 350, 0, 200)
    frame.Position = UDim2.new(0.5, -175, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 12)
    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Size = UDim2.new(0.9, 0, 0.5, 0)
    textLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Kirada Premium\nTác giả: Kirada VN & Habato\nNgười test: Nấm Gamer"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.MinecraftEvenCraft
    textLabel.TextStrokeTransparency = 0.6
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    local imageLabel = Instance.new("ImageLabel", frame)
    imageLabel.Size = UDim2.new(0, 120, 0, 120)
    imageLabel.Position = UDim2.new(0.5, -60, 0.55, 0)
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = "rbxassetid://75676578090181"
    imageLabel.ImageTransparency = 1
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine)
    TweenService:Create(textLabel, tweenInfo, {TextTransparency = 0}):Play()
    TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 0.2}):Play()
    TweenService:Create(imageLabel, tweenInfo, {ImageTransparency = 0}):Play()
    task.wait(2)
    TweenService:Create(textLabel, tweenInfo, {TextTransparency = 1}):Play()
    TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(imageLabel, tweenInfo, {ImageTransparency = 1}):Play()
    task.wait(1)
    screenGui:Destroy()
end
pcall(introAnimation)

-- Tải UI Redz V2
pcall(function()
    local success, result = pcall(loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua")))
    if not success then
        StarterGui:SetCore("SendNotification", {
            Title = "Lỗi",
            Text = "Không thể tải UI: " .. tostring(result),
            Duration = 10
        })
        return
    end
end)

-- Tạo menu chính
local window = MakeWindow({
    Hub = {Title = "Kirada Premium", Animation = "YouTube: Kirada VN"},
    Key = {KeySystem = false, Title = "Hệ Thống Key", Notifi = {Notifications = true, CorrectKey = "Đang chạy script...", Incorrectkey = "Key không đúng", CopyKeyLink = "Đã sao chép vào clipboard"}}
})
MinimizeButton({
    Image = "rbxassetid://89326205091486",
    Size = {60, 60},
    Color = Color3.fromRGB(10, 10, 10),
    Corner = true,
    Stroke = false,
    StrokeColor = Color3.fromRGB(255, 0, 0)
})

-- Hàm thêm nút sao chép
local function addButton(tab, name, url)
    AddButton(tab, {
        Name = name,
        Callback = function()
            pcall(function()
                setclipboard(url)
                StarterGui:SetCore("SendNotification", {
                    Title = "Thông Báo",
                    Text = "Đã sao chép link " .. name .. "!",
                    Duration = 5
                })
            end)
        end
    })
end

-- Hàm thêm nút chạy script
local function addScriptButton(tab, name, url)
    AddButton(tab, {
        Name = name,
        Callback = function()
            pcall(function()
                loadstring(game:HttpGet(url))()
                StarterGui:SetCore("SendNotification", {
                    Title = "Thông Báo",
                    Text = "Đã chạy script " .. name .. "!",
                    Duration = 5
                })
            end)
        end
    })
end

-- Hàm phát hiện admin
local function checkAdmin()
    local adminIds = {[912348] = true, [120173604] = true}
    for _, player in pairs(Players:GetPlayers()) do
        if adminIds[player.UserId] or player:GetRoleInGroup(game.CreatorId) == "Admin" then
            StarterGui:SetCore("SendNotification", {
                Title = "Cảnh Báo",
                Text = "Phát hiện admin trong server!",
                Duration = 5
            })
        end
    end
    Players.PlayerAdded:Connect(function(player)
        if adminIds[player.UserId] or player:GetRoleInGroup(game.CreatorId) == "Admin" then
            StarterGui:SetCore("SendNotification", {
                Title = "Cảnh Báo",
                Text = "Phát hiện admin tham gia server!",
                Duration = 5
            })
        end
    end)
end
pcall(checkAdmin)

-- Thêm tất cả tab
local function detectGameAndAddTabs()
    -- Tab Blox Fruits
    local tab1 = MakeTab({Name = "Blox Fruits"})
    addScriptButton(tab1, "W-AZURE", "https://api.luarmor.net/files/v3/loaders/85e904ae1ff30824c1aa007fc7324f8f.lua")
    addScriptButton(tab1, "Quantum Hub", "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua")
    addScriptButton(tab1, "OMG HUB Server VIP Free", "https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua")
    addScriptButton(tab1, "Giảm Lag", "https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua")
    addScriptButton(tab1, "Maru Premium Fake", "https://raw.githubusercontent.com/hnc-roblox/Free/refs/heads/main/MaruHubPremiumFake.HNC%20Roblox.lua")
    addScriptButton(tab1, "Gravity Hub", "https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua")
    addScriptButton(tab1, "Server VIP Free (NoKey)", "https://raw.githubusercontent.com/JoshzzAlteregooo/FreePrivateServer/refs/heads/main/UniversalFreePrivateServerByJoshzz")

    -- Tab 99 Đêm
    local tab3 = MakeTab({Name = "99 Đêm"})
    addScriptButton(tab3, "NATHUB", "https://get.nathub.xyz/loader")
    addScriptButton(tab3, "H4X", "https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua")
    addScriptButton(tab3, "Speed Hub", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua")
    addScriptButton(tab3, "Hack Farm Kim Cương", "https://raw.githubusercontent.com/sleepyvill/script/refs/heads/main/99nights.lua")
    addScriptButton(tab3, "Skibidi", "https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/FoxnameHub.lua")
    addScriptButton(tab3, "Ringta", "https://raw.githubusercontent.com/wefwef127382/99daysloader.github.io/refs/heads/main/ringta.lua")

    -- Tab Hệ Thống Key
    local tabKey = MakeTab({Name = "Hệ Thống Key"})
    addButton(tabKey, "Sao Chép Key Speed Hub", "KfHLmNFnuaRmvbkQRwZGXDROXkxhdYAE")

    StarterGui:SetCore("SendNotification", {
        Title = "Thông Báo",
        Text = "Đã load tất cả tab!",
        Duration = 5
    })
end

-- Chạy tab sau khi key hợp lệ
task.wait(0.1)
detectGameAndAddTabs()
