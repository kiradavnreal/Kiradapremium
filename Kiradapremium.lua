-- Add new valid keys to the validKeys table
local validKeys = {
    ["noob"] = true,
    ["kiradahub"] = true,
    ["mimi"] = true,
    ["hangay"] = true,
    ["bananahub"] = true,
    ["phucdam"] = true,
    ["ezakgaminh"] = true,
    ["test"] = true, 
    ["kiradapremiumv2"] = true,
    ["noobv5"] = true, 
}

-- Enhanced Key GUI
local function createKeyGui()
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.Name = "KeySystemGui"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false

    -- Main Frame
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 350, 0, 250)
    frame.Position = UDim2.new(0.5, -175, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true

    -- Gradient Background
    local gradient = Instance.new("UIGradient", frame)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
    })
    gradient.Rotation = 45

    -- Corner
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 12)

    -- Drop Shadow
    local shadow = Instance.new("ImageLabel", frame)
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = -1

    -- Title
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "Kirada Premium - Key System"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextTransparency = 1

    -- Text Box
    local textBox = Instance.new("TextBox", frame)
    textBox.Size = UDim2.new(0.85, 0, 0, 50)
    textBox.Position = UDim2.new(0.075, 0, 0.3, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    textBox.TextColor3 = Color3.fromRGB(200, 200, 200)
    textBox.PlaceholderText = "Enter your key here..."
    textBox.Text = ""
    textBox.TextScaled = true
    textBox.Font = Enum.Font.Gotham
    textBox.TextTransparency = 1
    textBox.BackgroundTransparency = 1

    local textBoxCorner = Instance.new("UICorner", textBox)
    textBoxCorner.CornerRadius = UDim.new(0, 8)

    local textBoxStroke = Instance.new("UIStroke", textBox)
    textBoxStroke.Color = Color3.fromRGB(80, 80, 80)
    textBoxStroke.Thickness = 1

    -- Submit Button
    local submitButton = Instance.new("TextButton", frame)
    submitButton.Size = UDim2.new(0.5, 0, 0, 50)
    submitButton.Position = UDim2.new(0.25, 0, 0.6, 0)
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.Text = "Submit"
    submitButton.TextScaled = true
    submitButton.Font = Enum.Font.GothamBold
    submitButton.TextTransparency = 1
    submitButton.BackgroundTransparency = 1

    local buttonCorner = Instance.new("UICorner", submitButton)
    buttonCorner.CornerRadius = UDim.new(0, 8)

    local buttonStroke = Instance.new("UIStroke", submitButton)
    buttonStroke.Color = Color3.fromRGB(0, 80, 150)
    buttonStroke.Thickness = 1

    -- Button Hover Effect
    submitButton.MouseEnter:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
    end)
    submitButton.MouseLeave:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 215)}):Play()
    end)

    -- Intro Animation
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    frame.Position = UDim2.new(0.5, -175, 0.5, -150)
    TweenService:Create(frame, tweenInfo, {Position = UDim2.new(0.5, -175, 0.5, -125)}):Play()
    TweenService:Create(title, tweenInfo, {TextTransparency = 0}):Play()
    TweenService:Create(textBox, tweenInfo, {TextTransparency = 0, BackgroundTransparency = 0}):Play()
    TweenService:Create(submitButton, tweenInfo, {TextTransparency = 0, BackgroundTransparency = 0}):Play()

    -- Key Validation Logic
    local keyEntered = false
    submitButton.MouseButton1Click:Connect(function()
        if validKeys[textBox.Text:lower()] then
            keyEntered = true
            StarterGui:SetCore("SendNotification", {
                Title = "Success",
                Text = "Thank you for using Kirada Premium! 😍",
                Duration = 5
            })
            -- Fade out animation
            TweenService:Create(title, tweenInfo, {TextTransparency = 1}):Play()
            TweenService:Create(textBox, tweenInfo, {TextTransparency = 1, BackgroundTransparency = 1}):Play()
            TweenService:Create(submitButton, tweenInfo, {TextTransparency = 1, BackgroundTransparency = 1}):Play()
            task.wait(0.5)
            screenGui:Destroy()
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Error",
                Text = "Invalid key! Please try again.",
                Duration = 5
            })
            textBox.Text = ""
            -- Shake animation for invalid key
            local originalPos = textBox.Position
            for i = 1, 3 do
                TweenService:Create(textBox, TweenInfo.new(0.05), {Position = originalPos + UDim2.new(0, 5, 0, 0)}):Play()
                task.wait(0.05)
                TweenService:Create(textBox, TweenInfo.new(0.05), {Position = originalPos + UDim2.new(0, -5, 0, 0)}):Play()
                task.wait(0.05)
            end
            TweenService:Create(textBox, TweenInfo.new(0.05), {Position = originalPos}):Play()
        end
    end)

    while not keyEntered do
        task.wait(0.1)
    end
end
