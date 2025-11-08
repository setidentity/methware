local lib = {}
lib.__index = lib

local tw = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local run = game:GetService("RunService")
local gui = game:GetService("CoreGui")

local function tween(obj, t, props)
    tw:Create(obj, TweenInfo.new(t), props):Play()
end

function lib.new(cfg)
    local s = setmetatable({}, lib)
    s.title = cfg.title or "UI"
    s.size = cfg.size or UDim2.new(0, 320, 0, 450)
    s.tabs = {}
    s.cur = nil
    s.cd = {}
    s:make()
    return s
end

function lib:make()
    self.sg = Instance.new("ScreenGui")
    self.sg.Name = "L_" .. tick()
    self.sg.ResetOnSpawn = false
    self.sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.sg.DisplayOrder = 999999
    self.sg.Parent = gui
    
    local sh = Instance.new("Frame")
    sh.Size = self.size
    sh.Position = UDim2.new(0.5, -self.size.X.Offset/2, 0.5, -self.size.Y.Offset/2)
    sh.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    sh.BackgroundTransparency = 0.5
    sh.BorderSizePixel = 0
    sh.Parent = self.sg
    
    local shc = Instance.new("UICorner")
    shc.CornerRadius = UDim.new(0, 12)
    shc.Parent = sh
    
    local m = Instance.new("Frame")
    m.Size = UDim2.new(1, -4, 1, -4)
    m.Position = UDim2.new(0, 2, 0, 2)
    m.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    m.BorderSizePixel = 0
    m.Parent = sh
    
    local mc = Instance.new("UICorner")
    mc.CornerRadius = UDim.new(0, 10)
    mc.Parent = m
    
    local gr = Instance.new("UIGradient")
    gr.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
    }
    gr.Rotation = 45
    gr.Parent = m
    
    local h = Instance.new("Frame")
    h.Size = UDim2.new(1, 0, 0, 50)
    h.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    h.BorderSizePixel = 0
    h.Parent = m
    
    local hc = Instance.new("UICorner")
    hc.CornerRadius = UDim.new(0, 10)
    hc.Parent = h
    
    local hf = Instance.new("Frame")
    hf.Size = UDim2.new(1, 0, 0, 25)
    hf.Position = UDim2.new(0, 0, 1, -25)
    hf.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    hf.BorderSizePixel = 0
    hf.Parent = h
    
    local ht = Instance.new("TextLabel")
    ht.Size = UDim2.new(1, -20, 1, 0)
    ht.Position = UDim2.new(0, 20, 0, 0)
    ht.BackgroundTransparency = 1
    ht.Text = self.title
    ht.TextColor3 = Color3.fromRGB(255, 255, 255)
    ht.Font = Enum.Font.GothamBold
    ht.TextSize = 18
    ht.TextXAlignment = Enum.TextXAlignment.Left
    ht.Parent = h
    
    local ha = Instance.new("Frame")
    ha.Size = UDim2.new(0, 4, 0, 30)
    ha.Position = UDim2.new(0, 0, 0, 10)
    ha.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    ha.BorderSizePixel = 0
    ha.Parent = h
    
    local hac = Instance.new("UICorner")
    hac.CornerRadius = UDim.new(0, 2)
    hac.Parent = ha
    
    self.sh = sh
    self.m = m
    self:drag(h, sh)
    
    self.tf = Instance.new("Frame")
    self.tf.Size = UDim2.new(1, -20, 0, 40)
    self.tf.Position = UDim2.new(0, 10, 0, 60)
    self.tf.BackgroundTransparency = 1
    self.tf.Parent = m
    
    local tl = Instance.new("UIListLayout")
    tl.FillDirection = Enum.FillDirection.Horizontal
    tl.SortOrder = Enum.SortOrder.LayoutOrder
    tl.Padding = UDim.new(0, 8)
    tl.Parent = self.tf
end

function lib:drag(h, sh)
    local d = false
    local ds = nil
    local sp = nil
    
    h.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            d = true
            ds = Vector2.new(i.Position.X, i.Position.Y)
            sp = sh.Position
        end
    end)
    
    h.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            d = false
        end
    end)
    
    uis.InputChanged:Connect(function(i)
        if d and i.UserInputType == Enum.UserInputType.MouseMovement then
            local dt = Vector2.new(i.Position.X, i.Position.Y) - ds
            local vp = workspace.CurrentCamera.ViewportSize
            local w = sh.Size.X.Offset
            local hh = sh.Size.Y.Offset
            local nx = math.clamp(sp.X.Offset + dt.X, 0, vp.X - w)
            local ny = math.clamp(sp.Y.Offset + dt.Y, 0, vp.Y - hh)
            sh.Position = UDim2.new(0, nx, 0, ny)
        end
    end)
end

function lib:maketab(n, o)
    local tb = Instance.new("TextButton")
    tb.Size = UDim2.new(0.5, -4, 1, 0)
    tb.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    tb.BorderSizePixel = 0
    tb.Text = n
    tb.TextColor3 = Color3.fromRGB(180, 180, 180)
    tb.Font = Enum.Font.GothamBold
    tb.TextSize = 13
    tb.LayoutOrder = o
    tb.Parent = self.tf
    
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 8)
    tc.Parent = tb
    
    local ta = Instance.new("Frame")
    ta.Size = UDim2.new(0, 0, 0, 3)
    ta.Position = UDim2.new(0.5, 0, 1, -3)
    ta.AnchorPoint = Vector2.new(0.5, 0)
    ta.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    ta.BorderSizePixel = 0
    ta.Parent = tb
    
    local tac = Instance.new("UICorner")
    tac.CornerRadius = UDim.new(1, 0)
    tac.Parent = ta
    
    local sc = Instance.new("ScrollingFrame")
    sc.Size = UDim2.new(1, -30, 1, -120)
    sc.Position = UDim2.new(0, 15, 0, 110)
    sc.BackgroundTransparency = 1
    sc.BorderSizePixel = 0
    sc.ClipsDescendants = true
    sc.Visible = false
    sc.ScrollBarThickness = 4
    sc.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    sc.CanvasSize = UDim2.new(0, 0, 0, 0)
    sc.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sc.Parent = self.m
    
    local sl = Instance.new("UIListLayout")
    sl.SortOrder = Enum.SortOrder.LayoutOrder
    sl.Padding = UDim.new(0, 12)
    sl.Parent = sc
    
    local t = {n = n, b = tb, a = ta, c = sc, e = {}}
    self.tabs[n] = t
    
    if not self.cur then
        self:sw(n)
    end
    
    tb.MouseButton1Click:Connect(function()
        self:sw(n)
    end)
    
    tb.MouseEnter:Connect(function()
        if self.cur ~= n then
            tween(tb, 0.2, {BackgroundColor3 = Color3.fromRGB(50, 50, 60)})
        end
    end)
    
    tb.MouseLeave:Connect(function()
        if self.cur ~= n then
            tween(tb, 0.2, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)})
        end
    end)
    
    return t
end

lib.newtab = lib.maketab

function lib:sw(n)
    for _, t in pairs(self.tabs) do
        t.c.Visible = false
        tween(t.a, 0.3, {Size = UDim2.new(0, 0, 0, 3)})
        tween(t.b, 0.3, {TextColor3 = Color3.fromRGB(180, 180, 180)})
    end
    
    local t = self.tabs[n]
    t.c.Visible = true
    self.cur = n
    tween(t.a, 0.3, {Size = UDim2.new(0.7, 0, 0, 3)})
    tween(t.b, 0.3, {TextColor3 = Color3.fromRGB(255, 255, 255)})
end

function lib:toggle(t, n, iv, cb, cd)
    cd = cd or 1
    
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 45)
    f.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    f.BorderSizePixel = 0
    f.Parent = t.c
    
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 8)
    fc.Parent = f
    
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -60, 1, 0)
    l.Position = UDim2.new(0, 15, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = n
    l.TextColor3 = Color3.fromRGB(220, 220, 220)
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 40, 0, 22)
    bg.Position = UDim2.new(1, -50, 0.5, -11)
    bg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    bg.BorderSizePixel = 0
    bg.Parent = f
    
    local bgc = Instance.new("UICorner")
    bgc.CornerRadius = UDim.new(1, 0)
    bgc.Parent = bg
    
    local k = Instance.new("Frame")
    k.Size = UDim2.new(0, 18, 0, 18)
    k.Position = UDim2.new(0, 2, 0.5, -9)
    k.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    k.BorderSizePixel = 0
    k.Parent = bg
    
    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = k
    
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 1, 0)
    b.BackgroundTransparency = 1
    b.Text = ""
    b.Parent = f
    
    local function up(v)
        local p = v and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        local c1 = v and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(50, 50, 60)
        local c2 = v and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        tween(k, 0.2, {Position = p, BackgroundColor3 = c2})
        tween(bg, 0.2, {BackgroundColor3 = c1})
    end
    
    up(iv)
    
    b.MouseButton1Click:Connect(function()
        if self.cd[n] then return end
        self.cd[n] = true
        iv = not iv
        up(iv)
        cb(iv)
        task.delay(cd, function()
            self.cd[n] = nil
        end)
    end)
    
    b.MouseEnter:Connect(function()
        tween(f, 0.15, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)})
    end)
    
    b.MouseLeave:Connect(function()
        tween(f, 0.15, {BackgroundColor3 = Color3.fromRGB(35, 35, 45)})
    end)
    
    return f
end

lib.checkbox = lib.toggle

function lib:slider(t, n, mn, mx, iv, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 60)
    f.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    f.BorderSizePixel = 0
    f.Parent = t.c
    
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 8)
    fc.Parent = f
    
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 0, 20)
    l.Position = UDim2.new(0, 10, 0, 5)
    l.BackgroundTransparency = 1
    l.Text = n
    l.TextColor3 = Color3.fromRGB(220, 220, 220)
    l.Font = Enum.Font.Gotham
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    
    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(0, 50, 0, 20)
    v.Position = UDim2.new(1, -60, 0, 5)
    v.BackgroundTransparency = 1
    v.Text = tostring(iv)
    v.TextColor3 = Color3.fromRGB(100, 150, 255)
    v.Font = Enum.Font.GothamBold
    v.TextSize = 13
    v.TextXAlignment = Enum.TextXAlignment.Right
    v.Parent = f
    
    local tr = Instance.new("Frame")
    tr.Size = UDim2.new(1, -20, 0, 6)
    tr.Position = UDim2.new(0, 10, 0, 35)
    tr.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    tr.BorderSizePixel = 0
    tr.Parent = f
    
    local trc = Instance.new("UICorner")
    trc.CornerRadius = UDim.new(1, 0)
    trc.Parent = tr
    
    local fl = Instance.new("Frame")
    fl.Size = UDim2.new((iv - mn) / (mx - mn), 0, 1, 0)
    fl.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    fl.BorderSizePixel = 0
    fl.Parent = tr
    
    local flc = Instance.new("UICorner")
    flc.CornerRadius = UDim.new(1, 0)
    flc.Parent = fl
    
    local k = Instance.new("Frame")
    k.Size = UDim2.new(0, 16, 0, 16)
    k.Position = UDim2.new((iv - mn) / (mx - mn), -8, 0.5, -8)
    k.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    k.BorderSizePixel = 0
    k.Parent = tr
    
    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = k
    
    local d = false
    
    local function up(val)
        val = math.clamp(val, mn, mx)
        local p = (val - mn) / (mx - mn)
        fl.Size = UDim2.new(p, 0, 1, 0)
        k.Position = UDim2.new(p, -8, 0.5, -8)
        v.Text = tostring(math.floor(val))
        cb(val)
    end
    
    tr.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            d = true
            local p = math.clamp((i.Position.X - tr.AbsolutePosition.X) / tr.AbsoluteSize.X, 0, 1)
            up(mn + (mx - mn) * p)
        end
    end)
    
    tr.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            d = false
        end
    end)
    
    uis.InputChanged:Connect(function(i)
        if d and i.UserInputType == Enum.UserInputType.MouseMovement then
            local p = math.clamp((i.Position.X - tr.AbsolutePosition.X) / tr.AbsoluteSize.X, 0, 1)
            up(mn + (mx - mn) * p)
        end
    end)
    
    k.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            d = true
        end
    end)
    
    k.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            d = false
        end
    end)
    
    return f
end

function lib:dropdown(t, n, opts, iv, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 45)
    f.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    f.BorderSizePixel = 0
    f.Parent = t.c
    
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 8)
    fc.Parent = f
    
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -140, 1, 0)
    l.Position = UDim2.new(0, 15, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = n
    l.TextColor3 = Color3.fromRGB(220, 220, 220)
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 110, 0, 30)
    b.Position = UDim2.new(1, -120, 0.5, -15)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    b.BorderSizePixel = 0
    b.Text = ""
    b.Parent = f
    
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = b
    
    local bg = Instance.new("UIGradient")
    bg.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 60))
    }
    bg.Rotation = 90
    bg.Parent = b
    
    local bs = Instance.new("UIStroke")
    bs.Color = Color3.fromRGB(70, 70, 80)
    bs.Thickness = 1
    bs.Parent = b
    
    local bt = Instance.new("TextLabel")
    bt.Size = UDim2.new(1, -30, 1, 0)
    bt.Position = UDim2.new(0, 10, 0, 0)
    bt.BackgroundTransparency = 1
    bt.Text = iv == "HumanoidRootPart" and "RootPart" or iv
    bt.TextColor3 = Color3.fromRGB(255, 255, 255)
    bt.Font = Enum.Font.GothamMedium
    bt.TextSize = 12
    bt.TextXAlignment = Enum.TextXAlignment.Left
    bt.Parent = b
    
    local ar = Instance.new("TextLabel")
    ar.Size = UDim2.new(0, 20, 1, 0)
    ar.Position = UDim2.new(1, -20, 0, 0)
    ar.BackgroundTransparency = 1
    ar.Text = "▼"
    ar.TextColor3 = Color3.fromRGB(100, 150, 255)
    ar.Font = Enum.Font.GothamBold
    ar.TextSize = 10
    ar.Parent = b
    
    local dl = Instance.new("Frame")
    dl.Size = UDim2.new(0, 110, 0, 0)
    dl.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    dl.BorderSizePixel = 0
    dl.ZIndex = 5000
    dl.Visible = false
    dl.ClipsDescendants = true
    dl.Parent = self.sg
    
    local dlc = Instance.new("UICorner")
    dlc.CornerRadius = UDim.new(0, 8)
    dlc.Parent = dl
    
    local dls = Instance.new("UIStroke")
    dls.Color = Color3.fromRGB(100, 150, 255)
    dls.Thickness = 1.5
    dls.Transparency = 0.5
    dls.Parent = dl
    
    local dsc = Instance.new("ScrollingFrame")
    dsc.Size = UDim2.new(1, -10, 1, -16)
    dsc.Position = UDim2.new(0, 5, 0, 8)
    dsc.BackgroundTransparency = 1
    dsc.BorderSizePixel = 0
    dsc.ScrollBarThickness = 3
    dsc.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    dsc.CanvasSize = UDim2.new(0, 0, 0, 0)
    dsc.AutomaticCanvasSize = Enum.AutomaticSize.Y
    dsc.ZIndex = 5001
    dsc.Parent = dl
    
    local dll = Instance.new("UIListLayout")
    dll.SortOrder = Enum.SortOrder.LayoutOrder
    dll.Padding = UDim.new(0, 3)
    dll.Parent = dsc
    
    local open = false
    
    b.MouseButton1Click:Connect(function()
        open = not open
        dl.Visible = open
        if open then
            local p = b.AbsolutePosition
            local s = b.AbsoluteSize
            local vp = workspace.CurrentCamera.ViewportSize
            local h = math.min(#opts * 33 + 16, 200)
            local x = p.X
            local y = p.Y + s.Y + 5
            if y + h > vp.Y then
                y = p.Y - h - 5
            end
            dl.Position = UDim2.new(0, x, 0, y)
            tween(dl, 0.2, {Size = UDim2.new(0, 110, 0, h)})
        else
            tween(dl, 0.15, {Size = UDim2.new(0, 110, 0, 0)})
        end
        tween(ar, 0.3, {Rotation = open and 180 or 0})
    end)
    
    run.RenderStepped:Connect(function()
        if open then
            local p = b.AbsolutePosition
            local s = b.AbsoluteSize
            local vp = workspace.CurrentCamera.ViewportSize
            local h = dl.Size.Y.Offset
            local x = math.clamp(p.X, 0, vp.X - 110)
            local y = p.Y + s.Y + 5
            if y + h > vp.Y then
                y = p.Y - h - 5
            end
            dl.Position = UDim2.new(0, x, 0, y)
        end
    end)
    
    b.MouseEnter:Connect(function()
        tween(b, 0.2, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)})
        tween(bs, 0.2, {Color = Color3.fromRGB(100, 150, 255)})
    end)
    
    b.MouseLeave:Connect(function()
        tween(b, 0.2, {BackgroundColor3 = Color3.fromRGB(50, 50, 60)})
        tween(bs, 0.2, {Color = Color3.fromRGB(70, 70, 80)})
    end)
    
    for _, opt in ipairs(opts) do
        local ob = Instance.new("TextButton")
        ob.Size = UDim2.new(1, 0, 0, 30)
        ob.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        ob.BorderSizePixel = 0
        ob.Text = ""
        ob.ZIndex = 5002
        ob.Parent = dsc
        
        local obc = Instance.new("UICorner")
        obc.CornerRadius = UDim.new(0, 6)
        obc.Parent = ob
        
        local ot = Instance.new("TextLabel")
        ot.Size = UDim2.new(1, -20, 1, 0)
        ot.Position = UDim2.new(0, 10, 0, 0)
        ot.BackgroundTransparency = 1
        ot.Text = opt == "HumanoidRootPart" and "RootPart" or opt
        ot.TextColor3 = Color3.fromRGB(220, 220, 220)
        ot.Font = Enum.Font.Gotham
        ot.TextSize = 12
        ot.TextXAlignment = Enum.TextXAlignment.Left
        ot.ZIndex = 5003
        ot.Parent = ob
        
        if opt == iv then
            local c = Instance.new("TextLabel")
            c.Size = UDim2.new(0, 20, 1, 0)
            c.Position = UDim2.new(1, -20, 0, 0)
            c.BackgroundTransparency = 1
            c.Text = "✓"
            c.TextColor3 = Color3.fromRGB(100, 150, 255)
            c.Font = Enum.Font.GothamBold
            c.TextSize = 14
            c.ZIndex = 5003
            c.Parent = ob
        end
        
        ob.MouseButton1Click:Connect(function()
            bt.Text = opt == "HumanoidRootPart" and "RootPart" or opt
            open = false
            tween(dl, 0.15, {Size = UDim2.new(0, 110, 0, 0)})
            task.wait(0.15)
            dl.Visible = false
            tween(ar, 0.3, {Rotation = 0})
            cb(opt)
        end)
        
        ob.MouseEnter:Connect(function()
            tween(ob, 0.15, {BackgroundColor3 = Color3.fromRGB(100, 150, 255)})
            tween(ot, 0.15, {TextColor3 = Color3.fromRGB(255, 255, 255)})
        end)
        
        ob.MouseLeave:Connect(function()
            tween(ob, 0.15, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)})
            tween(ot, 0.15, {TextColor3 = Color3.fromRGB(220, 220, 220)})
        end)
    end
    
    f.MouseEnter:Connect(function()
        tween(f, 0.15, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)})
    end)
    
    f.MouseLeave:Connect(function()
        tween(f, 0.15, {BackgroundColor3 = Color3.fromRGB(35, 35, 45)})
    end)
    
    return f
end

function lib:panel(t, txt)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 50)
    f.BackgroundColor3 = Color3.fromRGB(40, 80, 120)
    f.BorderSizePixel = 0
    f.Parent = t.c
    
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 8)
    fc.Parent = f
    
    local fg = Instance.new("UIGradient")
    fg.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 100, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 80, 120))
    }
    fg.Rotation = 45
    fg.Parent = f
    
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 1, -10)
    l.Position = UDim2.new(0, 10, 0, 5)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    l.TextWrapped = true
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Parent = f
    
    return f
end

function lib:keybind(t, n, defk, acts, defa, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 45)
    f.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    f.BorderSizePixel = 0
    f.Parent = t.c
    
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 8)
    fc.Parent = f
    
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -200, 1, 0)
    l.Position = UDim2.new(0, 15, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = n
    l.TextColor3 = Color3.fromRGB(220, 220, 220)
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    
    local ab = Instance.new("TextButton")
    ab.Size = UDim2.new(0, 70, 0, 28)
    ab.Position = UDim2.new(1, -180, 0.5, -14)
    ab.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ab.BorderSizePixel = 0
    ab.Text = defa or "Toggle"
    ab.TextColor3 = Color3.fromRGB(220, 220, 220)
    ab.Font = Enum.Font.Gotham
    ab.TextSize = 11
    ab.Parent = f
    
    local abc = Instance.new("UICorner")
    abc.CornerRadius = UDim.new(0, 6)
    abc.Parent = ab
    
    local abs = Instance.new("UIStroke")
    abs.Color = Color3.fromRGB(70, 70, 80)
    abs.Thickness = 1
    abs.Parent = ab
    
    local kb = Instance.new("TextButton")
    kb.Size = UDim2.new(0, 90, 0, 28)
    kb.Position = UDim2.new(1, -100, 0.5, -14)
    kb.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    kb.BorderSizePixel = 0
    kb.Text = defk or "None"
    kb.TextColor3 = Color3.fromRGB(220, 220, 220)
    kb.Font = Enum.Font.GothamBold
    kb.TextSize = 11
    kb.Parent = f
    
    local kbc = Instance.new("UICorner")
    kbc.CornerRadius = UDim.new(0, 6)
    kbc.Parent = kb
    
    local kbs = Instance.new("UIStroke")
    kbs.Color = Color3.fromRGB(70, 70, 80)
    kbs.Thickness = 1
    kbs.Parent = kb
    
    local lst = false
    local ck = defk
    local ca = defa or (acts and acts[1]) or "Toggle"
    
    local al = nil
    if acts then
        al = Instance.new("Frame")
        al.Size = UDim2.new(0, 70, 0, 0)
        al.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        al.BorderSizePixel = 0
        al.ZIndex = 5000
        al.Visible = false
        al.ClipsDescendants = true
        al.Parent = self.sg
        
        local alc = Instance.new("UICorner")
        alc.CornerRadius = UDim.new(0, 6)
        alc.Parent = al
        
        local als = Instance.new("UIStroke")
        als.Color = Color3.fromRGB(100, 150, 255)
        als.Thickness = 1
        als.Transparency = 0.5
        als.Parent = al
        
        local asc = Instance.new("ScrollingFrame")
        asc.Size = UDim2.new(1, -10, 1, -10)
        asc.Position = UDim2.new(0, 5, 0, 5)
        asc.BackgroundTransparency = 1
        asc.BorderSizePixel = 0
        asc.ScrollBarThickness = 3
        asc.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
        asc.CanvasSize = UDim2.new(0, 0, 0, 0)
        asc.AutomaticCanvasSize = Enum.AutomaticSize.Y
        asc.ZIndex = 5001
        asc.Parent = al
        
        local all = Instance.new("UIListLayout")
        all.SortOrder = Enum.SortOrder.LayoutOrder
        all.Padding = UDim.new(0, 2)
        all.Parent = asc
        
        local aopen = false
        
        for _, act in ipairs(acts) do
            local aob = Instance.new("TextButton")
            aob.Size = UDim2.new(1, 0, 0, 24)
            aob.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            aob.BorderSizePixel = 0
            aob.Text = act
            aob.TextColor3 = Color3.fromRGB(220, 220, 220)
            aob.Font = Enum.Font.Gotham
            aob.TextSize = 11
            aob.ZIndex = 5002
            aob.Parent = asc
            
            local aobc = Instance.new("UICorner")
            aobc.CornerRadius = UDim.new(0, 5)
            aobc.Parent = aob
            
            aob.MouseButton1Click:Connect(function()
                ca = act
                ab.Text = act
                aopen = false
                tween(al, 0.15, {Size = UDim2.new(0, 70, 0, 0)})
                task.wait(0.15)
                al.Visible = false
            end)
            
            aob.MouseEnter:Connect(function()
                tween(aob, 0.15, {BackgroundColor3 = Color3.fromRGB(100, 150, 255)})
            end)
            
            aob.MouseLeave:Connect(function()
                tween(aob, 0.15, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)})
            end)
        end
        
        ab.MouseButton1Click:Connect(function()
            aopen = not aopen
            al.Visible = aopen
            if aopen then
                local p = ab.AbsolutePosition
                local s = ab.AbsoluteSize
                local vp = workspace.CurrentCamera.ViewportSize
                local h = math.min(#acts * 26 + 10, 150)
                local x = p.X
                local y = p.Y + s.Y + 5
                if y + h > vp.Y then
                    y = p.Y - h - 5
                end
                al.Position = UDim2.new(0, x, 0, y)
                tween(al, 0.2, {Size = UDim2.new(0, 70, 0, h)})
            else
                tween(al, 0.15, {Size = UDim2.new(0, 70, 0, 0)})
            end
        end)
        
        run.RenderStepped:Connect(function()
            if aopen then
                local p = ab.AbsolutePosition
                local s = ab.AbsoluteSize
                local vp = workspace.CurrentCamera.ViewportSize
                local h = al.Size.Y.Offset
                local x = math.clamp(p.X, 0, vp.X - 70)
                local y = p.Y + s.Y + 5
                if y + h > vp.Y then
                    y = p.Y - h - 5
                end
                al.Position = UDim2.new(0, x, 0, y)
            end
        end)
        
        ab.MouseEnter:Connect(function()
            tween(ab, 0.2, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)})
            tween(abs, 0.2, {Color = Color3.fromRGB(100, 150, 255)})
        end)
        
        ab.MouseLeave:Connect(function()
            tween(ab, 0.2, {BackgroundColor3 = Color3.fromRGB(50, 50, 60)})
            tween(abs, 0.2, {Color = Color3.fromRGB(70, 70, 80)})
        end)
    end
    
    kb.MouseButton1Click:Connect(function()
        if lst then return end
        lst = true
        kb.Text = "..."
        kb.TextColor3 = Color3.fromRGB(100, 150, 255)
        tween(kbs, 0.2, {Color = Color3.fromRGB(100, 150, 255)})
    end)
    
    kb.MouseEnter:Connect(function()
        if not lst then
            tween(kb, 0.2, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)})
            tween(kbs, 0.2, {Color = Color3.fromRGB(100, 150, 255)})
        end
    end)
    
    kb.MouseLeave:Connect(function()
        if not lst then
            tween(kb, 0.2, {BackgroundColor3 = Color3.fromRGB(50, 50, 60)})
            tween(kbs, 0.2, {Color = Color3.fromRGB(70, 70, 80)})
        end
    end)
    
    f.MouseEnter:Connect(function()
        tween(f, 0.15, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)})
    end)
    
    f.MouseLeave:Connect(function()
        tween(f, 0.15, {BackgroundColor3 = Color3.fromRGB(35, 35, 45)})
    end)
    
    uis.InputBegan:Connect(function(i, p)
        if not lst then return end
        if p then return end
        
        local kn = "None"
        
        if i.UserInputType == Enum.UserInputType.Keyboard then
            kn = i.KeyCode.Name
        elseif i.UserInputType == Enum.UserInputType.MouseButton1 then
            kn = "MB1"
        elseif i.UserInputType == Enum.UserInputType.MouseButton2 then
            kn = "MB2"
        elseif i.UserInputType == Enum.UserInputType.MouseButton3 then
            kn = "MB3"
        end
        
        ck = kn
        kb.Text = kn
        kb.TextColor3 = Color3.fromRGB(220, 220, 220)
        lst = false
        tween(kbs, 0.2, {Color = Color3.fromRGB(70, 70, 80)})
    end)
    
    uis.InputBegan:Connect(function(i, p)
        if p then return end
        if lst then return end
        
        local ok = false
        
        if i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode.Name == ck then
            ok = true
        elseif i.UserInputType == Enum.UserInputType.MouseButton1 and ck == "MB1" then
            ok = true
        elseif i.UserInputType == Enum.UserInputType.MouseButton2 and ck == "MB2" then
            ok = true
        elseif i.UserInputType == Enum.UserInputType.MouseButton3 and ck == "MB3" then
            ok = true
        end
        
        if ok then
            cb(ca, ck)
        end
    end)
    
    return f
end

function lib:destroy()
    if self.sg then
        self.sg:Destroy()
    end
end

return lib
