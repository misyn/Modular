--// idc to obfusc this its lit nothing

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local _Modular = {}
_Modular.__index = _Modular

_Modular.Config = {
	LoadTime = 7,
	PreFade = 3,
	LetterSpeed = 0.12,
	MHold = 0.8,
	FadeTime = 2,
	SoundUrl = "https://github.com/misyn/assets/raw/refs/heads/main/sounds/intro.mp3",
	SoundFile = "intro.mp3"
}

function _Modular.new()
	if getgenv()._ModularActive then return end
	getgenv()._ModularActive = true

	local self = setmetatable({}, _Modular)
	self.Tweens = {}

	self:Cleanup()
	self:LoadSound()
	self:BuildUI()

	return self
end

function _Modular:Cleanup()
	local gui = CoreGui:FindFirstChild("ModularLoadingScreen")
	if gui then gui:Destroy() end

	local snd = CoreGui:FindFirstChild("ModularIntroSound")
	if snd then snd:Destroy() end
end

function _Modular:LoadSound()
	local cfg = self.Config

	pcall(function()
		if not isfile(cfg.SoundFile) then
			writefile(cfg.SoundFile, game:HttpGet(cfg.SoundUrl))
		end

		local sound = Instance.new("Sound")
		sound.Name = "ModularIntroSound"
		sound.SoundId = getcustomasset(cfg.SoundFile)
		sound.Volume = 1
		sound.Looped = false
		sound.Parent = CoreGui
		sound:Play()

		self.Sound = sound
	end)
end

function _Modular:Tween(obj, info, props)
	local tween = TweenService:Create(obj, info, props)
	tween:Play()
	return tween
end

function _Modular:BuildUI()
	local gui = Instance.new("ScreenGui")
	gui.Name = "ModularLoadingScreen"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local ok = pcall(function()
		gui.Parent = CoreGui
	end)
	if not ok then
		gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end

	local background = Instance.new("Frame")
	background.Name = "Background"
	background.Size = UDim2.fromScale(1, 1)
	background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	background.BorderSizePixel = 0
	background.Parent = gui

	local container = Instance.new("Frame")
	container.Name = "Container"
	container.AnchorPoint = Vector2.new(0.5, 0.5)
	container.Position = UDim2.fromScale(0.5, 0.5)
	container.Size = UDim2.fromScale(0, 0.35)
	container.BackgroundTransparency = 1
	container.Parent = background

	local aspect = Instance.new("UIAspectRatioConstraint")
	aspect.AspectRatio = 2.2
	aspect.DominantAxis = Enum.DominantAxis.Height
	aspect.Parent = container

	local limit = Instance.new("UISizeConstraint")
	limit.MinSize = Vector2.new(260, 118)
	limit.MaxSize = Vector2.new(880, 400)
	limit.Parent = container

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.AnchorPoint = Vector2.new(0.5, 0.5)
	title.Position = UDim2.fromScale(0.5, 0.32)
	title.Size = UDim2.fromScale(1, 0.4)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.Text = "Modular"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextScaled = true
	title.TextTransparency = 1
	title.Parent = container

	local titleScale = Instance.new("UIScale")
	titleScale.Parent = title

	local discord = Instance.new("TextLabel")
	discord.Name = "Discord"
	discord.AnchorPoint = Vector2.new(0.5, 0.5)
	discord.Position = UDim2.fromScale(0.5, 0.62)
	discord.Size = UDim2.fromScale(1, 0.13)
	discord.BackgroundTransparency = 1
	discord.Font = Enum.Font.Gotham
	discord.Text = "discord.gg/getmodular"
	discord.TextColor3 = Color3.fromRGB(160, 160, 160)
	discord.TextScaled = true
	discord.TextTransparency = 1
	discord.Parent = container

	local discordCap = Instance.new("UITextSizeConstraint")
	discordCap.MaxTextSize = 20
	discordCap.Parent = discord

	local barTrack = Instance.new("Frame")
	barTrack.Name = "BarTrack"
	barTrack.AnchorPoint = Vector2.new(0.5, 0.5)
	barTrack.Position = UDim2.fromScale(0.5, 0.85)
	barTrack.Size = UDim2.fromScale(0.8, 0.035)
	barTrack.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	barTrack.BorderSizePixel = 0
	barTrack.Parent = container

	Instance.new("UICorner", barTrack).CornerRadius = UDim.new(1, 0)

	local barFill = Instance.new("Frame")
	barFill.Name = "BarFill"
	barFill.Size = UDim2.fromScale(0, 1)
	barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	barFill.BorderSizePixel = 0
	barFill.Parent = barTrack

	Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

	self.Gui = gui
	self.Background = background
	self.Title = title
	self.TitleScale = titleScale
	self.Discord = discord
	self.BarTrack = barTrack
	self.BarFill = barFill
end

function _Modular:FadeIn()
	local info = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	self:Tween(self.Title, info, {TextTransparency = 0})
	task.wait(0.2)
	self:Tween(self.Discord, info, {TextTransparency = 0})
end

function _Modular:RunBar()
	local cfg = self.Config

	local barTween = self:Tween(
		self.BarFill,
		TweenInfo.new(cfg.LoadTime, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
		{Size = UDim2.fromScale(1, 1)}
	)

	task.wait(cfg.LoadTime - cfg.PreFade)

	if self.Sound then
		self:Tween(
			self.Sound,
			TweenInfo.new(cfg.PreFade, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
			{Volume = 0.35}
		)
	end

	barTween.Completed:Wait()
	task.wait(0.2)
end

function _Modular:CollapseTitle()
	local cfg = self.Config
	local info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

	self:Tween(self.Discord, info, {TextTransparency = 1})
	self:Tween(self.BarTrack, info, {BackgroundTransparency = 1})
	self:Tween(self.BarFill, info, {BackgroundTransparency = 1})

	local text = self.Title.Text
	while #text > 1 do
		task.wait(cfg.LetterSpeed)
		text = string.sub(text, 1, #text - 1)
		self.Title.Text = text
	end

	self:Tween(
		self.TitleScale,
		TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Scale = 1.25}
	)

	task.wait(cfg.MHold)
end

function _Modular:FadeOut()
	local cfg = self.Config
	local info = TweenInfo.new(cfg.FadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

	self:Tween(self.Background, info, {BackgroundTransparency = 1})
	self:Tween(self.Title, info, {TextTransparency = 1})

	if self.Sound then
		self:Tween(
			self.Sound,
			TweenInfo.new(cfg.FadeTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			{Volume = 0}
		)
	end

	task.wait(cfg.FadeTime + 0.1)
end

function _Modular:Destroy()
	if self.Gui then self.Gui:Destroy() end

	if self.Sound then
		self.Sound:Stop()
		self.Sound:Destroy()
	end

	getgenv()._ModularActive = false
end

function _Modular:Play()
	self:FadeIn()
	self:RunBar()
	self:CollapseTitle()
	self:FadeOut()
	self:Destroy()
end

local intro = _Modular.new()
if intro then
	intro:Play()
end
