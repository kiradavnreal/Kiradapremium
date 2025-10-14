local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local gameId = game.PlaceId

-- Đợi game tải
repeat task.wait() until game:IsLoaded() and LocalPlayer

-- Key hợp lệ với thời gian hết hạn (10 tiếng = 36000 giây)
local validKeys = {
    ["noob"] = {valid = true, expiry = os.time() + 36000},
    ["kiradahub"] = {valid = true, expiry = os.time() + 36000},
    ["mimi"] = {valid = true, expiry = os.time() + 36000},
    ["hangay"] = {valid = true, expiry = os.time() + 36000},
    ["bananahub"] = {valid = true, expiry = os.time() + 36000},
    ["phucdam"] = {valid = true, expiry = os.time() + 36000},
    ["ezakgaminh"] = {valid = true, expiry = os.time() + 36000}
}

-- Kiểm tra key hết hạn
local function isKeyValid(key)
    local keyData = validKeys[key:lower()]
    if keyData and keyData.valid then
        if os.time() < keyData.expiry then
            return true
        else
            validKeys[key:lower()] = nil -- Xóa key đã hết hạn
            return false
        end
    end
    return false
end

-- Giao diện nhập key "cute"
local function createKeyGui()
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.Name = "KeySystemGui"
    screenGui.IgnoreGuiInset = true

    -- Frame chính với màu pastel
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 350, 0, 250)
    frame.Position = UDim2.new(0.5, -175, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(255, 182, 193) -- Màu hồng phấn
    frame.BorderSizePixel = 0

    -- Góc bo tròn
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 20)

    -- Gradient nền
    local gradient = Instance.new("UIGradient", frame)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 182, 193)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 230, 230))
    })
    gradient.Rotation = 45

    -- Hiệu ứng ánh sáng nhẹ
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.5

    -- Tiêu đề
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "🌸 Kirada Premium 🌸"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.FredokaOne -- Font dễ thương
    title.TextStrokeTransparency = 0.8
    title.TextStrokeColor3 = Color3.fromRGB(100, 100, 100)

    -- TextBox nhập key
    local textBox = Instance.new("TextBox", frame)
    textBox.Size = UDim2.new(0.85, 0, 0, 50)
    textBox.Position = UDim2.new(0.075, 0, 0.3, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextColor3 = Color3.fromRGB(255, 105, 180) -- Màu hồng đậm
    textBox.PlaceholderText = "Nhập key của bạn tại đây... 💖"
    textBox.Text = ""
    textBox.TextScaled = true
    textBox.Font = Enum.Font.FredokaOne
    local textBoxCorner = Instance.new("UICorner", textBox)
    textBoxCorner.CornerRadius = UDim.new(0, 15)
    local textBoxStroke = Instance.new("UIStroke", textBox)
    textBoxStroke.Color = Color3.fromRGB(255, 182, 193)
    textBoxStroke.Thickness = 1

    -- Nút xác nhận
    local submitButton = Instance.new("TextButton", frame)
    submitButton.Size = UDim2.new(0.4, 0, 0, 50)
    submitButton.Position = UDim2.new(0.3, 0, 0.55, 0)
    submitButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180) -- Màu hồng đậm
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.Text = "Xác Nhận ✨"
    submitButton.TextScaled = true
    submitButton.Font = Enum.Font.FredokaOne
    local cornerButton = Instance.new("UICorner", submitButton)
    cornerButton.CornerRadius = UDim.new(0, 15)
    local buttonStroke = Instance.new("UIStroke", submitButton)
    buttonStroke.Color = Color3.fromRGB(255, 255, 255)
    buttonStroke.Thickness = 1
    buttonStroke.Transparency = 0.5

    -- Hiệu ứng hover cho nút
    submitButton.MouseEnter:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 150, 200)}):Play()
    end)
    submitButton.MouseLeave:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 105, 180)}):Play()
    end)

    -- Hiệu ứng nhấp nút
    submitButton.MouseButton1Down:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.1), {Size = UDim2.new(0.38, 0, 0, 45)}):Play()
    end)
    submitButton.MouseButton1Up:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.1), {Size = UDim2.new(0.4, 0, 0, 50)}):Play()
    end)

    -- Logic xử lý key
    local keyEntered = false
    submitButton.MouseButton1Click:Connect(function()
        if isKeyValid(textBox.Text) then
            keyEntered = true
            StarterGui:SetCore("SendNotification", {
                Title = "Thành Công 🌟",
                Text = "Cảm ơn bạn đã sử dụng Kirada Premium! 😍",
                Duration = 5
            })
            -- Hiệu ứng mờ dần khi thành công
            TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
            TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            TweenService:Create(textBox, TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(submitButton, TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            task.wait(0.5)
            screenGui:Destroy()
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Lỗi 😔",
                Text = "Key không đúng hoặc đã hết hạn! Vui lòng thử lại.",
                Duration = 5
            })
            textBox.Text = ""
            -- Hiệu ứng rung khi lỗi
            local originalPos = frame.Position
            for i = 1, 3 do
                frame.Position = originalPos + UDim2.new(0, 5, 0, 0)
                task.wait(0.05)
                frame.Position = originalPos + UDim2.new(0, -5, 0, 0)
                task.wait(0.05)
            end
            frame.Position = originalPos
        end
    end)

    while not keyEntered do
        task.wait(0.1)
    end
end
pcall(createKeyGui)

-- Rest of your original script remains unchanged
-- (Including the preload, startup sound, intro animation, main menu, and other functions)
