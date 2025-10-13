local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

-- Đợi game tải xong
repeat task.wait() until game:IsLoaded() and LocalPlayer

-- Danh sách key hợp lệ
local validKeys = {
    ["noob"] = nil,
    ["kiradahub"] = nil,
    ["mimi"] = nil
}

-- Tạo GUI nhập key
local function createKeyGui()
    -- Tạo ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KeySystemGui"
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = PlayerGui

    -- Tạo Frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 250)
    frame.Position = UDim2.new(0.5, -175, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    -- Tiêu đề
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Kirada Premium - Hệ Thống Key"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.Parent = frame

    -- Ô nhập key
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.85, 0, 0, 50)
    textBox.Position = UDim2.new(0.075, 0, 0.3, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderText = "Nhập key của bạn..."
    textBox.Text = ""
    textBox.TextScaled = true
    textBox.Font = Enum.Font.SourceSans
    textBox.Parent = frame

    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 8)
    textBoxCorner.Parent = textBox

    -- Nút xác nhận
    local submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.new(0.4, 0, 0, 50)
    submitButton.Position = UDim2.new(0.3, 0, 0.6, 0)
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.Text = "Xác Nhận"
    submitButton.TextScaled = true
    submitButton.Font = Enum.Font.SourceSansBold
    submitButton.Parent = frame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = submitButton

    -- Nhãn phản hồi lỗi
    local feedbackLabel = Instance.new("TextLabel")
    feedbackLabel.Size = UDim2.new(0.85, 0, 0, 30)
    feedbackLabel.Position = UDim2.new(0.075, 0, 0.8, 0)
    feedbackLabel.BackgroundTransparency = 1
    feedbackLabel.Text = ""
    feedbackLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    feedbackLabel.TextScaled = true
    feedbackLabel.Font = Enum.Font.SourceSans
    feedbackLabel.Parent = frame

    -- Hiệu ứng xuất hiện
    frame.BackgroundTransparency = 1
    textBox.BackgroundTransparency = 1
    submitButton.BackgroundTransparency = 1
    title.TextTransparency = 1
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
    TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(textBox, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(submitButton, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(title, tweenInfo, {TextTransparency = 0}):Play()

    -- Xử lý nhập key
    local keyEntered = false
    submitButton.MouseButton1Click:Connect(function()
        local enteredKey = textBox.Text:lower():gsub("%s+", "") -- Loại bỏ khoảng trắng
        if enteredKey == "" then
            feedbackLabel.Text = "Vui lòng nhập key!"
            return
        end
        if validKeys[enteredKey] then
            if validKeys[enteredKey] == nil or validKeys[enteredKey] == LocalPlayer.UserId then
                validKeys[enteredKey] = LocalPlayer.UserId -- Gán key cho UserId
                keyEntered = true
                StarterGui:SetCore("SendNotification", {
                    Title = "Thành Công",
                    Text = "Key hợp lệ! Đang tải Kirada Premium...",
                    Duration = 5
                })
                -- Hiệu ứng biến mất
                TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 1}):Play()
                TweenService:Create(textBox, tweenInfo, {BackgroundTransparency = 1}):Play()
                TweenService:Create(submitButton, tweenInfo, {BackgroundTransparency = 1}):Play()
                TweenService:Create(title, tweenInfo, {TextTransparency = 1}):Play()
                task.wait(0.5)
                screenGui:Destroy()
            else
                feedbackLabel.Text = "Key đã được sử dụng bởi người khác!"
                LocalPlayer:Kick("Key này đã được dùng. Liên hệ hỗ trợ để lấy key mới.")
            end
        else
            feedbackLabel.Text = "Key không hợp lệ! Thử lại."
            textBox.Text = ""
        end
    end)

    -- Hỗ trợ nhấn Enter để gửi
    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            submitButton:Activate()
        end
    end)

    -- Đợi key hợp lệ
    while not keyEntered do
        task.wait(0.1)
    end
end

-- Chạy GUI trong protected call
local success, errorMsg = pcall(createKeyGui)
if not success then
    StarterGui:SetCore("SendNotification", {
        Title = "Lỗi",
        Text = "Không thể tạo GUI key: " .. tostring(errorMsg),
        Duration = 5
    })
end

-- Thông báo thành công và chạy menu chính
StarterGui:SetCore("SendNotification", {
    Title = "Chào Mừng",
    Text = "Hệ thống key đã vượt qua! Đang tải menu chính...",
    Duration = 5
})
-- Thêm hàm detectGameAndAddTabs() của bạn tại đây để tải menu chính
