--Name Protect Script by 3dsboy08

local Config =
{
    ProtectedName = "NameProtect", --What the protected name should be called.
    OtherPlayers = true, --If other players should also have protected names.
    OtherPlayersTemplate = "NameProtect", --Template for other players protected name (ex: "NamedProtect" will turn into "NameProtect1" for first player and so on)
    RenameTextBoxes = true, --If TextBoxes should be renamed. (could cause issues with admin guis/etc)
    UseFilterPadding = false, --If filtered name should be the same size as a regular name.
    FilterPad = " ", --Character used to filter pad.
    UseMetatableHook = false, --Use metatable hook to increase chance of filtering. (is not supported on wrappers like bleu)
    UseAggressiveFiltering = true --Use aggressive property renaming filter. (renames a lot more but at the cost of lag)
}

local ProtectedNames = {}
local Counter = 1
if Config.OtherPlayers then
    for I, V in pairs(game:GetService("Players"):GetPlayers()) do
        local Filter = Config.OtherPlayersTemplate .. tostring(Counter)
        if Config.UseFilterPadding then
            if string.len(Filter) > string.len(V.Name) then
                Filter = string.sub(Filter, 1, string.len(V.Name))
            elseif string.len(Filter) < string.len(V.Name) then
                local Add = string.len(V.Name) - string.len(Filter)
                for I=1,Add do
                    Filter = Filter .. Config.FilterPad
                end
            end
        end
        ProtectedNames[V.DisplayName] = Filter
        ProtectedNames[V.Name] = Filter
        Counter = Counter + 1
    end

    game:GetService("Players").PlayerAdded:Connect(function(Player)
        local Filter = Config.OtherPlayersTemplate .. tostring(Counter)
        if Config.UseFilterPadding then
            if string.len(Filter) > string.len(V.Name) then
                Filter = string.sub(Filter, 1, string.len(V.Name))
            elseif string.len(Filter) < string.len(V.Name) then
                local Add = string.len(V.Name) - string.len(Filter)
                for I=1,Add do
                    Filter = Filter .. Config.FilterPad
                end
            end
        end
        ProtectedNames[Player.DisplayName] = Filter
        ProtectedNames[Player.Name] = Filter
        Counter = Counter + 1
    end)
end

local LPName = game:GetService("Players").LocalPlayer.Name
local IsA = game.IsA

if Config.UseFilterPadding then
    if string.len(Config.ProtectedName) > string.len(LPName) then
        Config.ProtectedName = string.sub(Config.ProtectedName, 1, string.len(LPName))
    elseif string.len(Config.ProtectedName) < string.len(LPName) then
        local Add = string.len(LPName) - string.len(Config.ProtectedName)
        for I=1,Add do
            Config.ProtectedName = Config.ProtectedName .. Config.FilterPad
        end
    end
end

local function FilterString(S)
    local RS = S
    if Config.OtherPlayers then
        for I, V in pairs(ProtectedNames) do
            RS = string.gsub(RS, I, V)
        end
    end
    RS = string.gsub(RS, LPName, Config.ProtectedName)
    if S ~= RS then
        print(RS)
    end
    return RS
end

for I, V in pairs(game:GetDescendants()) do
    if Config.RenameTextBoxes then
        if IsA(V, "TextLabel") or IsA(V, "TextButton") or IsA(V, "TextBox") then
            V.Text = FilterString(V.Text)

            if Config.UseAggressiveFiltering then
                V:GetPropertyChangedSignal("Text"):connect(function()
                    V.Text = FilterString(V.Text)
                end)
            end
        end
    end
end

if Config.UseAggressiveFiltering then
    game.DescendantAdded:Connect(function(V)
        if Config.RenameTextBoxes then
            if IsA(V, "TextLabel") or IsA(V, "TextButton") or IsA(V, "TextBox") then
                V.Text = FilterString(V.Text)
                V:GetPropertyChangedSignal("Text"):connect(function()
                    V.Text = FilterString(V.Text)
                end)
            end
        end
    end)
end
