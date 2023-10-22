local Console = {}

local TweenService = game:GetService("TweenService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

local ConsoleFrame = Instance.new("Frame")
ConsoleFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
ConsoleFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
ConsoleFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
ConsoleFrame.BorderSizePixel = 0
ConsoleFrame.Parent = ScreenGui
ConsoleFrame.BackgroundTransparency = 1
ConsoleFrame.Visible = false

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.1, 0)
Title.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Text = "Advanced Console"
Title.Font = Enum.Font.FredokaOne
Title.TextSize = 20
Title.Parent = ConsoleFrame

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(0.8, 0, 0.1, 0)
InputBox.Position = UDim2.new(0, 10, 0.85, -5)
InputBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
InputBox.TextColor3 = Color3.new(1, 1, 1)
InputBox.Text = ""
InputBox.PlaceholderText = "Enter command..."
InputBox.PlaceholderColor3 = Color3.new(0.8, 0.8, 0.8)
InputBox.Font = Enum.Font.FredokaOne
InputBox.Parent = ConsoleFrame

local EnterButton = Instance.new("TextButton")
EnterButton.Size = UDim2.new(0.18, 0, 0.1, 0)
EnterButton.Position = UDim2.new(0.82, -10, 0.85, -5)
EnterButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
EnterButton.TextColor3 = Color3.new(1, 1, 1)
EnterButton.Text = "Enter"
EnterButton.Font = Enum.Font.FredokaOne
EnterButton.BorderSizePixel = 0
EnterButton.Parent = ConsoleFrame

local MessagesContainer = Instance.new("ScrollingFrame")
MessagesContainer.Size = UDim2.new(0.98, -20, 0.7, 0)
MessagesContainer.Position = UDim2.new(0.01, 10, 0.15, 10)
MessagesContainer.BackgroundColor3 = Color3.new(0, 0, 0)
MessagesContainer.BorderSizePixel = 0
MessagesContainer.CanvasSize = UDim2.new(0, 0, 5, 0)
MessagesContainer.ScrollBarThickness = 5
MessagesContainer.Parent = ConsoleFrame

local function fadeIn(element)
    local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local fadeGoals = {BackgroundTransparency = 0}
    local fadeTween = TweenService:Create(element, fadeInfo, fadeGoals)
    fadeTween:Play()
end

local function fadeOut(element)
    local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local fadeGoals = {BackgroundTransparency = 1}
    local fadeTween = TweenService:Create(element, fadeInfo, fadeGoals)
    fadeTween:Play()
end

function Console:Hide()
    ConsoleFrame.Visible = false
end

function Console:Show()
    ConsoleFrame.Visible = true
end

local function slideIn(element)
    element.Position = UDim2.new(0, 0, #MessagesContainer:GetChildren() * 0.05 - 0.5, 0)
    local slideInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local slideGoals = {Position = UDim2.new(0, 0, #MessagesContainer:GetChildren() * 0.05, 0)}
    local slideTween = TweenService:Create(element, slideInfo, slideGoals)
    slideTween:Play()
end

EnterButton.MouseEnter:Connect(function()
    EnterButton.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
end)

EnterButton.MouseLeave:Connect(function()
    EnterButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
end)

local function createMessage(msgType, msg)
    local color = Color3.new(1, 1, 1)
    if msgType == "Output" then
        color = Color3.new(0.5, 1, 0.5)
    elseif msgType == "Warning" then
        color = Color3.new(1, 0.5, 0)
    elseif msgType == "Error" then
        color = Color3.new(1, 0.5, 0.5)
    end
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.05, 0)
    label.Position = UDim2.new(0, 0, #MessagesContainer:GetChildren() * 0.05, 0)
    label.BackgroundColor3 = color
    label.Text = "[" .. msgType .. "]: " .. msg
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.FredokaOne
    label.Parent = MessagesContainer
    slideIn(label)

    MessagesContainer.CanvasSize = UDim2.new(0, 0, #MessagesContainer:GetChildren() * 0.05, 0)
end

function Console:Output(msg)
    createMessage("Output", msg)
end

function Console:Warning(msg)
    createMessage("Warning", msg)
end

function Console:Error(msg)
    createMessage("Error", msg)
end

Console.CommandFunctions = {
    ["output"] = function(msg)
          Console:Output(msg)
  end,
    ["warning"] = function(msg) 
          Console:Warning(msg)
  end,
    ["error"] = function(msg)
          Console:Error(msg)
  end
}

function Console:AddCommand(commandName,func)
       self.CommandFunctions[commandName] = func 
end

EnterButton.MouseButton1Click:Connect(function()
    local command = InputBox.Text
    if Console.CommandFunctions[command] then
      Console.CommandFunctions[command]("This is a " .. command .. " message.") 
    else 
      Console:Output("Unknown command.")
    end 
    InputBox.Text = ""
  end)

local isDragging = false 
local dragStart
local startPoslocal
function startDrag()
  isDragging = true
  local mousePos = game.Players.LocalPlayer:GetMouse().Position
  dragStart = UDim2.new(0, mousePos.X, 0, mousePos.Y)
  startPos = ConsoleFrame.Position
  game:GetService("RunService").RenderStepped:Connect(function()
      if isDragging then
        local mousePos = game.Players.LocalPlayer:GetMouse().Position
        local diff = UDim2.new(0, mousePos.X, 0, mousePos.Y) - dragStart
        ConsoleFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + diff.X.Offset, startPos.Y.Scale, startPos.Y.Offset + diff.Y.Offset) 
      end 
    end) 
end

  local function endDrag()
  isDragging = false
end

Title.InputBegan:Connect(function(input) 
      if input.UserInputType == Enum.UserInputType.MouseButton1 then
        startDrag() 
      end 
    end)
  
  Title.InputEnded:Connect(function(input)
      if input.UserInputType == Enum.UserInputType.MouseButton1 then
          endDrag()
      end
   end)

return Console
