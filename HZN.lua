
--[[
    HZN FISH IT HUB
    Version 1.0 | Purple Neon
    UI-only edition
    Floating menu, quick controls, animation speed,
    manual catch counter, hide/show menu.
    Tidak menggunakan RemoteEvent atau API Fish It palsu.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
if not player then
    warn("[HZN] Player tidak ditemukan.")
    return
end

local playerGui = player:WaitForChild("PlayerGui")

-- Hapus UI lama jika ada
local oldGui = playerGui:FindFirstChild("HZN_FishIt")
if oldGui then
    oldGui:Destroy()
end

-- Warna tema
local PURPLE = Color3.fromRGB(170, 70, 255)
local DARK = Color3.fromRGB(12, 10, 18)
local PANEL = Color3.fromRGB(31, 23, 43)
local WHITE = Color3.fromRGB(255, 255, 255)
local MUTED = Color3.fromRGB(190, 175, 205)

local animationSpeed = 1
local catches = 0
local menuVisible = true

-- Screen GUI
local gui = Instance.new("ScreenGui")
gui.Name = "HZN_FishIt"
gui.ResetOnSpawn = false
gui.DisplayOrder = 100
gui.Parent = playerGui

local function round(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = obj
end

local function stroke(obj, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or PURPLE
    s.Thickness = thickness or 1
    s.Parent = obj
end

local function createLabel(parent, text, size, color)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or WHITE
    label.TextSize = size or 13
    label.Font = Enum.Font.Gotham
    label.TextWrapped = true
    label.Parent = parent
    return label
end

-- Floating button
local floating = Instance.new("TextButton")
floating.Name = "HZN_Floating"
floating.Size = UDim2.fromOffset(58, 58)
floating.Position = UDim2.new(0, 16, 0.4, 0)
floating.BackgroundColor3 = DARK
floating.Text = "HZN"
floating.TextColor3 = WHITE
floating.TextSize = 17
floating.Font = Enum.Font.GothamBlack
floating.Parent = gui
round(floating, 18)
stroke(floating, PURPLE, 2)

-- Main panel
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(290, 390)
main.Position = UDim2.new(0.5, -145, 0.5, -195)
main.BackgroundColor3 = DARK
main.BorderSizePixel = 0
main.Parent = gui
round(main, 15)
stroke(main, PURPLE, 2)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(43, 25, 62)
header.BorderSizePixel = 0
header.Parent = main
round(header, 14)

local title = createLabel(header, "HZN | FISH IT", 16, WHITE)
title.Position = UDim2.fromOffset(12, 4)
title.Size = UDim2.new(1, -58, 0, 25)
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local subtitle = createLabel(header, "PURPLE FISHING HUB", 9, MUTED)
subtitle.Position = UDim2.fromOffset(13, 28)
subtitle.Size = UDim2.new(1, -60, 0, 15)
subtitle.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(32, 32)
close.Position = UDim2.new(1, -39, 0, 8)
close.BackgroundColor3 = PANEL
close.Text = "×"
close.TextColor3 = WHITE
close.TextSize = 23
close.Parent = header
round(close, 8)

-- Scroll area
local scroll = Instance.new("ScrollingFrame")
scroll.Position = UDim2.fromOffset(10, 58)
scroll.Size = UDim2.new(1, -20, 1, -68)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = PURPLE
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

local padding = Instance.new("UIPadding")
padding.PaddingBottom = UDim.new(0, 8)
padding.Parent = scroll

local function section(text)
    local label = createLabel(scroll, text, 12, PURPLE)
    label.Size = UDim2.new(1, 0, 0, 24)
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    return label
end

local function button(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 38)
    b.BackgroundColor3 = PANEL
    b.Text = text
    b.TextColor3 = WHITE
    b.TextSize = 12
    b.Font = Enum.Font.GothamMedium
    b.AutoButtonColor = true
    b.Parent = scroll
    round(b, 9)
    stroke(b, Color3.fromRGB(85, 57, 110), 1)

    b.Activated:Connect(callback)
    return b
end

-- Quick controls
section("QUICK CONTROLS")

local status = createLabel(
    scroll, "Status: Manual fishing", 11, MUTED
)
status.Size = UDim2.new(1, 0, 0, 22)

button("Ubah status memancing", function()
    if status.Text == "Status: Manual fishing" then
        status.Text = "Status: Paused"
    else
        status.Text = "Status: Manual fishing"
    end
end)

local stats = createLabel(
    scroll, "Catatan tangkapan: 0", 12, WHITE
)
stats.Size = UDim2.new(1, 0, 0, 23)

button("+1 Catat ikan tertangkap", function()
    catches = catches + 1
    stats.Text = "Catatan tangkapan: " .. catches
end)

button("Reset catatan tangkapan", function()
    catches = 0
    stats.Text = "Catatan tangkapan: 0"
end)

-- UI animation speed
section("ANIMATION SPEED")

local speedLabel = createLabel(
    scroll, "Kecepatan animasi UI: 1.0x", 11, WHITE
)
speedLabel.Size = UDim2.new(1, 0, 0, 22)

button("Tambah kecepatan animasi", function()
    animationSpeed = animationSpeed + 0.5
    if animationSpeed > 3 then
        animationSpeed = 0.5
    end
    speedLabel.Text = string.format(
        "Kecepatan animasi UI: %.1fx", animationSpeed
    )
end)

button("Tes animasi panel", function()
    local duration = 0.25 / animationSpeed
    TweenService:Create(
        main,
        TweenInfo.new(duration),
        {BackgroundColor3 = Color3.fromRGB(35, 17, 52)}
    ):Play()

    task.delay(duration, function()
        if main.Parent then
            TweenService:Create(
                main,
                TweenInfo.new(duration),
                {BackgroundColor3 = DARK}
            ):Play()
        end
    end)
end)

-- Location section
section("FISHING LOCATIONS")

local locationInfo = createLabel(
    scroll,
    "Daftar lokasi belum terhubung. Gunakan teleport resmi dalam game.",
    11,
    MUTED
)
locationInfo.Size = UDim2.new(1, 0, 0, 42)

button("Info teleport", function()
    locationInfo.Text =
        "Teleport otomatis memerlukan dukungan resmi dari game."
end)

-- Auto fishing section
section("AUTO FISHING")

local fishingInfo = createLabel(
    scroll,
    "Auto-catch tidak diaktifkan. Gunakan mekanisme memancing resmi.",
    11,
    MUTED
)
fishingInfo.Size = UDim2.new(1, 0, 0, 42)

button("Info memancing", function()
    fishingInfo.Text =
        "Menu ini tidak mengirim perintah ke server Fish It."
end)

-- Hide / show
floating.Activated:Connect(function()
    menuVisible = not menuVisible
    main.Visible = menuVisible
end)

close.Activated:Connect(function()
    menuVisible = false
    main.Visible = false
end)

-- Drag panel using touch or mouse
local UserInputService =
    game:GetService("UserInputService")

local dragging = false
local dragStart
local startPosition
local dragInput

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = true
        dragStart = input.Position
        startPosition = main.Position
        dragInput = input
    end
end)

header.InputEnded:Connect(function(input)
    if input == dragInput then
        dragging = false
        dragInput = nil
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then
        local delta = input.Position - dragStart

        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

print("[HZN] Fish It Hub berhasil dimuat.")
