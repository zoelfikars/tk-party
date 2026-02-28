--[[
    Custom UI Library
    A lightweight, Rayfield-like UI library for TKPartyHub.
]] local CustomUI = {}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Utility for creating instances
local function Create(className, properties)
    local inst = Instance.new(className)
    for k, v in pairs(properties) do inst[k] = v end
    return inst
end

-- Make GUI Draggable
local function MakeDraggable(topbar, frame)
    local dragging, dragInput, dragStart, startPos

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
            input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
            input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale,
                                       startPos.X.Offset + delta.X,
                                       startPos.Y.Scale,
                                       startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Helper to load Custom Icon from URL for exploit environments
local function LoadCustomIcon(url, fallback)
    local isfile = isfile or function() return false end
    local writefile = writefile or function() end
    local getcustomasset = getcustomasset or getsynasset or
                               function() return "" end

    if isfile and writefile and getcustomasset then
        local fileName = "tkparty_icon_v2.jpg"
        if not isfile(fileName) then
            local success, imgData = pcall(function()
                return game:HttpGet(url)
            end)
            if success and imgData then writefile(fileName, imgData) end
        end
        local asset = getcustomasset(fileName)
        if asset and asset ~= "" then return asset end
    end
    return fallback or "rbxassetid://0"
end

function CustomUI:CreateWindow(config)
    local Window = {}
    local currentTab = nil

    local Name = config.Name or "TKPartyHub v2"

    -- Base URL handling for icon
    local baseUrl = _G.TKPartyHub and _G.TKPartyHub.baseUrl or ""
    local iconUrl = baseUrl .. "assets/8d37bce49bee98267796961b3e05a3a1.jpg"
    local myIconId = LoadCustomIcon(iconUrl, "rbxassetid://15264357321")

    -- Main ScreenGui
    local sg = Create("ScreenGui", {
        Name = "TKPartyCustomUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    -- Minimized Floating Icon
    local MinimizedIcon = Create("ImageButton", {
        Name = "MinimizedIcon",
        Parent = sg,
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -25, 0, 20),
        Size = UDim2.new(0, 50, 0, 50),
        Image = myIconId,
        Visible = false,
        ClipsDescendants = true
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = MinimizedIcon})
    MakeDraggable(MinimizedIcon, MinimizedIcon)

    local isMinimized = false
    MinimizedIcon.MouseButton1Click:Connect(function()
        if isMinimized then
            isMinimized = false
            MinimizedIcon.Visible = false
            -- Since MainFrame is initialized later, we reference it dynamically
            local mf = sg:FindFirstChild("MainFrame")
            if mf then mf.Visible = true end
        end
    end)

    -- Try protecting GUI
    local success = pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(sg) end
        sg.Parent = CoreGui
    end)
    if not success then
        local lp = game:GetService("Players").LocalPlayer
        if lp then sg.Parent = lp:WaitForChild("PlayerGui") end
    end

    -- Main Frame
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = sg,
        BackgroundColor3 = Color3.fromRGB(20, 20, 24),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -275, 0.5, -175),
        Size = UDim2.new(0, 550, 0, 350),
        ClipsDescendants = true
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = MainFrame})

    -- Topbar
    local Topbar = Create("Frame", {
        Name = "Topbar",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40)
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Topbar})
    Create("Frame", {
        Name = "BottomFix",
        Parent = Topbar,
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -5),
        Size = UDim2.new(1, 0, 0, 5)
    })

    MakeDraggable(Topbar, MainFrame)

    Create("TextLabel", {
        Name = "Title",
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = Name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Controls (Minimize and Close)
    local Controls = Create("Frame", {
        Name = "Controls",
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -60, 0, 5),
        Size = UDim2.new(0, 55, 1, -10)
    })

    local MinimizeBtn = Create("TextButton", {
        Name = "Minimize",
        Parent = Controls,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 25, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "-",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 18
    })

    local CloseBtn = Create("TextButton", {
        Name = "Close",
        Parent = Controls,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 30, 0, 0),
        Size = UDim2.new(0, 25, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 80, 80),
        TextSize = 16
    })

    CloseBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

    MinimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = true
        MainFrame.Visible = false
        MinimizedIcon.Visible = true
    end)

    -- Sidebar
    local Sidebar = Create("ScrollingFrame", {
        Name = "Sidebar",
        Parent = MainFrame,
        Active = true,
        BackgroundColor3 = Color3.fromRGB(15, 15, 18),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(0, 140, 1, -40),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2
    })
    local SidebarLayout = Create("UIListLayout", {
        Parent = Sidebar,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    Create("UIPadding", {
        Parent = Sidebar,
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    })

    SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
        function()
            Sidebar.CanvasSize = UDim2.new(0, 0, 0,
                                           SidebarLayout.AbsoluteContentSize.Y +
                                               20)
        end)

    -- Content Container
    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 140, 0, 40),
        Size = UDim2.new(1, -140, 1, -40)
    })

    function Window:CreateTab(tabName, icon)
        local Tab = {}

        local TabBtn = Create("TextButton", {
            Name = "TabBtn_" .. tabName,
            Parent = Sidebar,
            BackgroundColor3 = Color3.fromRGB(25, 25, 30),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 30),
            Font = Enum.Font.Gotham,
            Text = tabName,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            TextSize = 13
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabBtn})

        local ContentScroll = Create("ScrollingFrame", {
            Name = "Content_" .. tabName,
            Parent = ContentContainer,
            Active = true,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            Visible = false
        })
        local ContentLayout = Create("UIListLayout", {
            Parent = ContentScroll,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })
        Create("UIPadding", {
            Parent = ContentScroll,
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 15),
            PaddingRight = UDim.new(0, 15),
            PaddingBottom = UDim.new(0, 10)
        })

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
            function()
                ContentScroll.CanvasSize = UDim2.new(0, 0, 0,
                                                     ContentLayout.AbsoluteContentSize
                                                         .Y + 20)
            end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, c in pairs(ContentContainer:GetChildren()) do
                if c:IsA("ScrollingFrame") then c.Visible = false end
            end
            for _, b in pairs(Sidebar:GetChildren()) do
                if b:IsA("TextButton") then
                    b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
                    b.TextColor3 = Color3.fromRGB(150, 150, 150)
                end
            end
            ContentScroll.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        if not currentTab then
            currentTab = TabBtn
            ContentScroll.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        function Tab:CreateSection(secName)
            Create("TextLabel", {
                Parent = ContentScroll,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25),
                Font = Enum.Font.GothamBold,
                Text = secName,
                TextColor3 = Color3.fromRGB(180, 180, 200),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end

        function Tab:CreateParagraph(pConfig)
            local PFrame = Create("Frame", {
                Parent = ContentScroll,
                BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                Size = UDim2.new(1, 0, 0, 60)
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = PFrame})

            local PTitle = Create("TextLabel", {
                Parent = PFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 5),
                Size = UDim2.new(1, -20, 0, 20),
                Font = Enum.Font.GothamBold,
                Text = pConfig.Title or "",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local PText = Create("TextLabel", {
                Parent = PFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 25),
                Size = UDim2.new(1, -20, 1, -30),
                Font = Enum.Font.Gotham,
                Text = pConfig.Content or "",
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true
            })

            local function updateSize()
                local textObj = PText.Text
                local estLines = math.ceil(string.len(textObj) / 70)
                local newlines = 0
                for _ in string.gmatch(textObj, "\n") do
                    newlines = newlines + 1
                end
                estLines = math.max(estLines, newlines + 1)
                PFrame.Size = UDim2.new(1, 0, 0, 35 + (estLines * 16))
            end
            updateSize()

            local Paragraph = {}
            function Paragraph:Set(newConfig)
                if newConfig.Title then
                    PTitle.Text = newConfig.Title
                end
                if newConfig.Content then
                    PText.Text = newConfig.Content
                end
                updateSize()
            end
            return Paragraph
        end

        function Tab:CreateToggle(tConfig)
            local TogFrame = Create("Frame", {
                Parent = ContentScroll,
                BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                Size = UDim2.new(1, 0, 0, 35)
            })
            Create("UICorner",
                   {CornerRadius = UDim.new(0, 6), Parent = TogFrame})

            Create("TextLabel", {
                Parent = TogFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                Font = Enum.Font.Gotham,
                Text = tConfig.Name or "Toggle",
                TextColor3 = Color3.fromRGB(220, 220, 220),
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local TogBtn = Create("TextButton", {
                Parent = TogFrame,
                BackgroundColor3 = Color3.fromRGB(20, 20, 25),
                Position = UDim2.new(1, -45, 0.5, -10),
                Size = UDim2.new(0, 35, 0, 20),
                Text = ""
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = TogBtn})

            local TogCircle = Create("Frame", {
                Parent = TogBtn,
                BackgroundColor3 = Color3.fromRGB(150, 150, 150),
                Position = UDim2.new(0, 2, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16)
            })
            Create("UICorner",
                   {CornerRadius = UDim.new(1, 0), Parent = TogCircle})

            local toggled = tConfig.CurrentValue or false

            local function updateVisuals()
                if toggled then
                    TweenService:Create(TogCircle, TweenInfo.new(0.2), {
                        Position = UDim2.new(1, -18, 0.5, -8),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    }):Play()
                    TweenService:Create(TogBtn, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(70, 130, 180)
                    }):Play()
                else
                    TweenService:Create(TogCircle, TweenInfo.new(0.2), {
                        Position = UDim2.new(0, 2, 0.5, -8),
                        BackgroundColor3 = Color3.fromRGB(150, 150, 150)
                    }):Play()
                    TweenService:Create(TogBtn, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                    }):Play()
                end
            end
            updateVisuals()

            TogBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateVisuals()
                if tConfig.Callback then
                    tConfig.Callback(toggled)
                end
            end)

            local Toggle = {}
            function Toggle:Set(val)
                toggled = val
                updateVisuals()
                if tConfig.Callback then
                    tConfig.Callback(toggled)
                end
            end
            return Toggle
        end

        function Tab:CreateButton(bConfig)
            local Btn = Create("TextButton", {
                Parent = ContentScroll,
                BackgroundColor3 = Color3.fromRGB(40, 40, 48),
                Size = UDim2.new(1, 0, 0, 35),
                Font = Enum.Font.Gotham,
                Text = bConfig.Name or "Button",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 13
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Btn})

            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {
                    BackgroundColor3 = Color3.fromRGB(55, 55, 65)
                }):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.1), {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 48)
                }):Play()
                if bConfig.Callback then bConfig.Callback() end
            end)
        end

        function Tab:CreateDropdown(dConfig)
            local DropFrame = Create("Frame", {
                Parent = ContentScroll,
                BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                Size = UDim2.new(1, 0, 0, 35),
                ClipsDescendants = true
            })
            Create("UICorner",
                   {CornerRadius = UDim.new(0, 6), Parent = DropFrame})

            local DropBtn = Create("TextButton", {
                Parent = DropFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 35),
                Font = Enum.Font.Gotham,
                Text = "  " .. (dConfig.Name or "Dropdown") .. " - " ..
                    (dConfig.CurrentOption or ""),
                TextColor3 = Color3.fromRGB(220, 220, 220),
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            local Indicator = Create("TextLabel", {
                Parent = DropBtn,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -25, 0, 0),
                Size = UDim2.new(0, 20, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = "+",
                TextColor3 = Color3.fromRGB(220, 220, 220),
                TextSize = 16
            })

            local DropScroll = Create("ScrollingFrame", {
                Parent = DropFrame,
                Active = true,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 35),
                Size = UDim2.new(1, 0, 1, -35),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 2
            })
            Create("UIListLayout", {
                Parent = DropScroll,
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            local expanded = false
            local options = dConfig.Options or {}

            local function updateSize()
                local targetHeight = expanded and
                                         math.min(35 + (#options * 25), 150) or
                                         35
                TweenService:Create(DropFrame, TweenInfo.new(0.2),
                                    {Size = UDim2.new(1, 0, 0, targetHeight)})
                    :Play()
                Indicator.Text = expanded and "-" or "+"
            end

            DropBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                updateSize()
            end)

            local function renderOptions()
                for _, child in pairs(DropScroll:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                DropScroll.CanvasSize = UDim2.new(0, 0, 0, #options * 25)

                for _, opt in ipairs(options) do
                    local OptBtn = Create("TextButton", {
                        Parent = DropScroll,
                        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 25),
                        Font = Enum.Font.Gotham,
                        Text = opt,
                        TextColor3 = Color3.fromRGB(200, 200, 200),
                        TextSize = 12
                    })
                    OptBtn.MouseButton1Click:Connect(function()
                        expanded = false
                        DropBtn.Text = "  " .. (dConfig.Name or "Dropdown") ..
                                           " - " .. opt
                        updateSize()
                        if dConfig.Callback then
                            dConfig.Callback({opt})
                        end
                    end)
                end
                updateSize()
            end
            renderOptions()
            local Dropdown = {}
            function Dropdown:Refresh(newOptions, keepCurrent)
                options = newOptions
                if not keepCurrent then
                    DropBtn.Text = "  " .. (dConfig.Name or "Dropdown")
                end
                renderOptions()
            end
            return Dropdown
        end
        return Tab
    end

    -- Resize Handle
    local Resizer = Create("TextButton", {
        Name = "Resizer",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -20, 1, -20),
        Size = UDim2.new(0, 20, 0, 20),
        Font = Enum.Font.Gotham,
        Text = "◢",
        TextColor3 = Color3.fromRGB(150, 150, 150),
        TextSize = 14,
        ZIndex = 10
    })

    local resizing, resizeStart, startSize
    Resizer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
            input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = MainFrame.AbsoluteSize

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and
            (input.UserInputType == Enum.UserInputType.MouseMovement or
                input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - resizeStart
            local newWidth = math.clamp(startSize.X + delta.X, 400, 850)
            local newHeight = math.clamp(startSize.Y + delta.Y, 250, 650)
            MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)

    return Window
end

-- Notification System outside of Window to match Rayfield API (Rayfield:Notify({}))
-- Create a shared Notification Area
local NotifArea = nil
function CustomUI:Notify(notifConfig)
    if not NotifArea then
        local sg = Create("ScreenGui",
                          {Name = "TKPartyNotifs", ResetOnSpawn = false})
        pcall(function()
            if syn and syn.protect_gui then syn.protect_gui(sg) end
            sg.Parent = CoreGui
        end)
        if not sg.Parent then
            local lp = game:GetService("Players").LocalPlayer
            if lp then sg.Parent = lp:WaitForChild("PlayerGui") end
        end
        NotifArea = Create("Frame", {
            Name = "NotifArea",
            Parent = sg,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -220, 1, -20),
            Size = UDim2.new(0, 200, 1, 0),
            AnchorPoint = Vector2.new(0, 1)
        })
        Create("UIListLayout", {
            Parent = NotifArea,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            VerticalAlignment = Enum.VerticalAlignment.Bottom
        })
    end

    local Title = notifConfig.Title or "Notification"
    local Content = notifConfig.Content or ""
    local Duration = notifConfig.Duration or 5

    local NotifFrame = Create("Frame", {
        Parent = NotifArea,
        BackgroundColor3 = Color3.fromRGB(35, 35, 40),
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = NotifFrame})

    local NotifTitle = Create("TextLabel", {
        Parent = NotifFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 5),
        Size = UDim2.new(1, -20, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = Color3.fromRGB(200, 200, 255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1
    })

    local NotifText = Create("TextLabel", {
        Parent = NotifFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 25),
        Size = UDim2.new(1, -20, 1, -30),
        Font = Enum.Font.Gotham,
        Text = Content,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        TextTransparency = 1
    })

    TweenService:Create(NotifFrame, TweenInfo.new(0.3),
                        {BackgroundTransparency = 0}):Play()
    TweenService:Create(NotifTitle, TweenInfo.new(0.3), {TextTransparency = 0})
        :Play()
    TweenService:Create(NotifText, TweenInfo.new(0.3), {TextTransparency = 0})
        :Play()

    task.spawn(function()
        task.wait(Duration)
        TweenService:Create(NotifFrame, TweenInfo.new(0.3),
                            {BackgroundTransparency = 1}):Play()
        TweenService:Create(NotifTitle, TweenInfo.new(0.3),
                            {TextTransparency = 1}):Play()
        TweenService:Create(NotifText, TweenInfo.new(0.3),
                            {TextTransparency = 1}):Play()
        task.wait(0.3)
        NotifFrame:Destroy()
    end)
end

return CustomUI
