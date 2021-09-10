---round
---@param num number
---@param numDecimalPlaces number
---@return number
---@public
function math.round(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

---starts
---@param String string
---@param Start number
---@return number
---@public
function string.starts(String, Start)
	return string.sub(String, 1, string.len(Start)) == Start
end

---@type table
RageUI2.Menus = setmetatable({}, RageUI2.Menus)

---@type table
---@return boolean
RageUI2.Menus.__call = function()
	return true
end

---@type table
RageUI2.Menus.__index = RageUI2.Menus

---@type table
RageUI2.CurrentMenu = nil

---@type table
RageUI2.NextMenu = nil

---@type number
RageUI2.Options = 0

---@type number
RageUI2.ItemOffset = 0

---@type number
RageUI2.StatisticPanelCount = 0

---@type table
RageUI2.Settings = {
	Debug = false,
	Controls = {
		Up = {
			Enabled = true,
			Active = false,
			Pressed = false,
			Keys = {
				{ 0, 172 },
				{ 1, 172 },
				{ 2, 172 },
				{ 0, 241 },
				{ 1, 241 },
				{ 2, 241 }
			}
		},
		Down = {
			Enabled = true,
			Active = false,
			Pressed = false,
			Keys = {
				{ 0, 173 },
				{ 1, 173 },
				{ 2, 173 },
				{ 0, 242 },
				{ 1, 242 },
				{ 2, 242 }
			}
		},
		Left = {
			Enabled = true,
			Active = false,
			Pressed = false,
			Keys = {
				{ 0, 174 },
				{ 1, 174 },
				{ 2, 174 }
			}
		},
		Right = {
			Enabled = true,
			Pressed = false,
			Active = false,
			Keys = {
				{ 0, 175 },
				{ 1, 175 },
				{ 2, 175 }
			}
		},
		SliderLeft = {
			Enabled = true,
			Active = false,
			Pressed = false,
			Keys = {
				{ 0, 174 },
				{ 1, 174 },
				{ 2, 174 }
			}
		},
		SliderRight = {
			Enabled = true,
			Pressed = false,
			Active = false,
			Keys = {
				{ 0, 175 },
				{ 1, 175 },
				{ 2, 175 }
			}
		},
		Select = {
			Enabled = true,
			Pressed = false,
			Active = false,
			Keys = {
				{ 0, 201 },
				{ 1, 201 },
				{ 2, 201 }
			}
		},
		Back = {
			Enabled = true,
			Active = false,
			Pressed = false,
			Keys = {
				{ 0, 177 },
				{ 1, 177 },
				{ 2, 177 },
				{ 0, 199 },
				{ 1, 199 },
				{ 2, 199 }
			}
		},
		Click = {
			Enabled = true,
			Active = false,
			Pressed = false,
			Keys = {
				{ 0, 24 }
			}
		},
		Enabled = {
			Controller = {
				{ 0, 2 }, -- Look Up and Down
				{ 0, 1 }, -- Look Left and Right
				{ 0, 25 }, -- Aim
				{ 0, 24 } -- Attack
			},
			Keyboard = {
				{ 0, 201 }, -- Select
				{ 0, 195 }, -- X axis
				{ 0, 196 }, -- Y axis
				{ 0, 187 }, -- Down
				{ 0, 188 }, -- Up
				{ 0, 189 }, -- Left
				{ 0, 190 }, -- Right
				{ 0, 202 }, -- Back
				{ 0, 217 }, -- Select
				{ 0, 242 }, -- Scroll down
				{ 0, 241 }, -- Scroll up
				{ 0, 239 }, -- Cursor X
				{ 0, 240 }, -- Cursor Y
				{ 0, 31 }, -- Move Up and Down
				{ 0, 30 }, -- Move Left and Right
				{ 0, 21 }, -- Sprint
				{ 0, 22 }, -- Jump
				{ 0, 23 }, -- Enter
				{ 0, 75 }, -- Exit Vehicle
				{ 0, 71 }, -- Accelerate Vehicle
				{ 0, 72 }, -- Vehicle Brake
				{ 0, 59 }, -- Move Vehicle Left and Right
				{ 0, 89 }, -- Fly Yaw Left
				{ 0, 9 }, -- Fly Left and Right
				{ 0, 8 }, -- Fly Up and Down
				{ 0, 90 }, -- Fly Yaw Right
				{ 0, 76 } -- Vehicle Handbrake
			}
		}
	},
	Audio = {
		Id = nil,
		Use = "RageUI2",
		RageUI2 = {
			UpDown = {
				audioName = "HUD_FREEMODE_SOUNDSET",
				audioRef = "NAV_UP_DOWN",
			},
			LeftRight = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "NAV_LEFT_RIGHT",
			},
			Select = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "SELECT",
			},
			Back = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "BACK",
			},
			Error = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "ERROR",
			},
			Slider = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "CONTINUOUS_SLIDER",
				Id = nil
			}
		},
		NativeUI = {
			UpDown = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "NAV_UP_DOWN",
			},
			LeftRight = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "NAV_LEFT_RIGHT",
			},
			Select = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "SELECT",
			},
			Back = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "BACK",
			},
			Error = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "ERROR",
			},
			Slider = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "CONTINUOUS_SLIDER",
				Id = nil
			}
		}
	},
	Items = {
		Title = {
			Background = { Width = 431, Height = 97 },
			Text = { X = 215, Y = 20, Scale = 1.15 }
		},
		Subtitle = {
			Background = { Width = 431, Height = 37 },
			Text = { X = 8, Y = 3, Scale = 0.35 },
			PreText = { X = 425, Y = 3, Scale = 0.35 }
		},
		Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 0, Width = 431 },
		Navigation = {
			Rectangle = { Width = 431, Height = 18 },
			Offset = 5,
			Arrows = { Dictionary = "commonmenu", Texture = "shop_arrows_upanddown", X = 190, Y = -6, Width = 50, Height = 50 }
		},
		Description = {
			Bar = { Y = 4, Width = 431, Height = 4 },
			Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 30 },
			Text = { X = 8, Y = 10, Scale = 0.35 }
		}
	},
	Panels = {
		Grid = {
			Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 275 },
			Grid = { Dictionary = "pause_menu_pages_char_mom_dad", Texture = "nose_grid", X = 115.5, Y = 47.5, Width = 200, Height = 200 },
			Circle = { Dictionary = "mpinventory", Texture = "in_world_circle", X = 115.5, Y = 47.5, Width = 20, Height = 20 },
			Text = {
				Top = { X = 215.5, Y = 15, Scale = 0.35 },
				Bottom = { X = 215.5, Y = 250, Scale = 0.35 },
				Left = { X = 57.75, Y = 130, Scale = 0.35 },
				Right = { X = 373.25, Y = 130, Scale = 0.35 }
			}
		},
		Percentage = {
			Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 76 },
			Bar = { X = 9, Y = 50, Width = 413, Height = 10 },
			Text = {
				Left = { X = 25, Y = 15, Scale = 0.35 },
				Middle = { X = 215.5, Y = 15, Scale = 0.35 },
				Right = { X = 398, Y = 15, Scale = 0.35 }
			}
		}
	}
}

---Visible
---@param Menu function
---@param Value boolean
---@return table
---@public
function RageUI2.Visible(Menu, Value)
	if Menu ~= nil then
		if Menu() then
			if type(Value) == "boolean" then
				if Value then
					if RageUI2.CurrentMenu ~= nil then
						RageUI2.CurrentMenu.Open = not Value
					end

					Menu:UpdateInstructionalButtons(Value)
					RageUI2.CurrentMenu = Menu
					RageUI2.Options = 0
					RageUI2.ItemOffset = 0
					Menu.Open = Value
				else
					Menu.Open = Value
					RageUI2.CurrentMenu = nil
					RageUI2.Options = 0
					RageUI2.ItemOffset = 0
				end
			else
				return Menu.Open
			end
		end
	end
end

---CloseAll
---@return void
---@public
function RageUI2.CloseAll()
	PlaySound(RageUI2.Settings.Audio.Library, RageUI2.Settings.Audio.Back)
	RageUI2.Visible(RageUI2.CurrentMenu, false)
	RageUI2.CurrentMenu = nil
	RageUI2.NextMenu = nil
	RageUI2.Options = 0
	RageUI2.ItemOffset = 0
end

---PlaySound
---@param Library string
---@param Sound string
---@param IsLooped boolean
---@return void
---@public
function RageUI2.PlaySound(Library, Sound, IsLooped)
	local audioId

	if not IsLooped then
		PlaySoundFrontend(-1, Sound, Library, true)
	else
		if not audioId then
			Citizen.CreateThread(function()
				audioId = GetSoundId()
				PlaySoundFrontend(audioId, Sound, Library, true)
				Citizen.Wait(0)

				StopSound(audioId)
				ReleaseSoundId(audioId)
				audioId = nil
			end)
		end
	end
end

---Banner
---@return void
---@public
---@param Enabled boolean
function RageUI2.Banner(Enabled)
	if type(Enabled) == "boolean" then
		if Enabled == true then
			if RageUI2.CurrentMenu ~= nil then
				if RageUI2.CurrentMenu() then
					RageUI2.ItemsSafeZone(RageUI2.CurrentMenu)

					if RageUI2.CurrentMenu.Sprite then
						RenderSprite(RageUI2.CurrentMenu.Sprite.Dictionary, RageUI2.CurrentMenu.Sprite.Texture, RageUI2.CurrentMenu.X, RageUI2.CurrentMenu.Y, RageUI2.Settings.Items.Title.Background.Width + RageUI2.CurrentMenu.WidthOffset, RageUI2.Settings.Items.Title.Background.Height, 0, 255, 255, 255, 255)
					else
						RenderRectangle(RageUI2.CurrentMenu.X, RageUI2.CurrentMenu.Y, RageUI2.Settings.Items.Title.Background.Width + RageUI2.CurrentMenu.WidthOffset, RageUI2.Settings.Items.Title.Background.Height, RageUI2.CurrentMenu.Rectangle.R, RageUI2.CurrentMenu.Rectangle.G, RageUI2.CurrentMenu.Rectangle.B, RageUI2.CurrentMenu.Rectangle.A)
					end

					RenderText(RageUI2.CurrentMenu.Title, RageUI2.CurrentMenu.X + RageUI2.Settings.Items.Title.Text.X + (RageUI2.CurrentMenu.WidthOffset / 2), RageUI2.CurrentMenu.Y + RageUI2.Settings.Items.Title.Text.Y, 4, RageUI2.Settings.Items.Title.Text.Scale, 0, 89, 255, 255, 1)
					RageUI2.ItemOffset = RageUI2.ItemOffset + RageUI2.Settings.Items.Title.Background.Height
				end
			end
		end
	else
		error("Enabled is not boolean")
	end
end

---Subtitle
---@return void
---@public
function RageUI2.Subtitle()
	if RageUI2.CurrentMenu ~= nil then
		if RageUI2.CurrentMenu() then
			RageUI2.ItemsSafeZone(RageUI2.CurrentMenu)

			if RageUI2.CurrentMenu.Subtitle ~= "" then
				RenderRectangle(RageUI2.CurrentMenu.X, RageUI2.CurrentMenu.Y + RageUI2.ItemOffset, RageUI2.Settings.Items.Subtitle.Background.Width + RageUI2.CurrentMenu.WidthOffset, RageUI2.Settings.Items.Subtitle.Background.Height + RageUI2.CurrentMenu.SubtitleHeight, 0, 0, 0, 255)
				RenderText(RageUI2.CurrentMenu.Subtitle, RageUI2.CurrentMenu.X + RageUI2.Settings.Items.Subtitle.Text.X, RageUI2.CurrentMenu.Y + RageUI2.Settings.Items.Subtitle.Text.Y + RageUI2.ItemOffset, 0, RageUI2.Settings.Items.Subtitle.Text.Scale, 245, 245, 245, 255, nil, false, false, RageUI2.Settings.Items.Subtitle.Background.Width + RageUI2.CurrentMenu.WidthOffset)

				if RageUI2.CurrentMenu.PageCounter == nil then
					RenderText(RageUI2.CurrentMenu.PageCounterColour .. RageUI2.CurrentMenu.Index .. " / " .. RageUI2.CurrentMenu.Options, RageUI2.CurrentMenu.X + RageUI2.Settings.Items.Subtitle.PreText.X + RageUI2.CurrentMenu.WidthOffset, RageUI2.CurrentMenu.Y + RageUI2.Settings.Items.Subtitle.PreText.Y + RageUI2.ItemOffset, 0, RageUI2.Settings.Items.Subtitle.PreText.Scale, 245, 245, 245, 255, 2)
				else
					RenderText(RageUI2.CurrentMenu.PageCounter, RageUI2.CurrentMenu.X + RageUI2.Settings.Items.Subtitle.PreText.X + RageUI2.CurrentMenu.WidthOffset, RageUI2.CurrentMenu.Y + RageUI2.Settings.Items.Subtitle.PreText.Y + RageUI2.ItemOffset, 0, RageUI2.Settings.Items.Subtitle.PreText.Scale, 245, 245, 245, 255, 2)
				end

				RageUI2.ItemOffset = RageUI2.ItemOffset + RageUI2.Settings.Items.Subtitle.Background.Height
			end
		end
	end
end

---Background
---@return void
---@public
function RageUI2.Background()
	if RageUI2.CurrentMenu ~= nil then
		if RageUI2.CurrentMenu() then
			RageUI2.ItemsSafeZone(RageUI2.CurrentMenu)
			SetScriptGfxDrawOrder(0)
			RenderSprite(RageUI2.Settings.Items.Background.Dictionary, RageUI2.Settings.Items.Background.Texture, RageUI2.CurrentMenu.X, RageUI2.CurrentMenu.Y + RageUI2.Settings.Items.Background.Y + RageUI2.CurrentMenu.SubtitleHeight, RageUI2.Settings.Items.Background.Width + RageUI2.CurrentMenu.WidthOffset, RageUI2.ItemOffset, 0, 0, 0, 255)
			SetScriptGfxDrawOrder(1)
		end
	end
end

---Description
---@return void
---@public
function RageUI2.Description()
	if RageUI2.CurrentMenu ~= nil and RageUI2.CurrentMenu.Description ~= nil and RageUI2.CurrentMenu.Description ~= "" then
		if RageUI2.CurrentMenu() then
			RageUI2.ItemsSafeZone(RageUI2.CurrentMenu)
			RenderRectangle(RageUI2.CurrentMenu.X, RageUI2.CurrentMenu.Y + RageUI2.Settings.Items.Description.Bar.Y + RageUI2.CurrentMenu.SubtitleHeight + RageUI2.ItemOffset, RageUI2.Settings.Items.Description.Bar.Width + RageUI2.CurrentMenu.WidthOffset, RageUI2.Settings.Items.Description.Bar.Height, 0, 0, 0, 255)
			RenderSprite(RageUI2.Settings.Items.Description.Background.Dictionary, RageUI2.Settings.Items.Description.Background.Texture, RageUI2.CurrentMenu.X, RageUI2.CurrentMenu.Y + RageUI2.Settings.Items.Description.Background.Y + RageUI2.CurrentMenu.SubtitleHeight + RageUI2.ItemOffset, RageUI2.Settings.Items.Description.Background.Width + RageUI2.CurrentMenu.WidthOffset, RageUI2.CurrentMenu.DescriptionHeight, 0, 0, 0, 255)
			RenderText(RageUI2.CurrentMenu.Description, RageUI2.CurrentMenu.X + RageUI2.Settings.Items.Description.Text.X, RageUI2.CurrentMenu.Y + RageUI2.Settings.Items.Description.Text.Y + RageUI2.CurrentMenu.SubtitleHeight + RageUI2.ItemOffset, 0, RageUI2.Settings.Items.Description.Text.Scale, 255, 255, 255, 255, nil, false, false, RageUI2.Settings.Items.Description.Background.Width + RageUI2.CurrentMenu.WidthOffset)
			RageUI2.ItemOffset = RageUI2.ItemOffset + RageUI2.CurrentMenu.DescriptionHeight + RageUI2.Settings.Items.Description.Bar.Y
		end
	end
end

---Header
---@return void
---@public
function RageUI2.Header(EnableBanner)
	RageUI2.Banner(EnableBanner)
	RageUI2.Subtitle()
end

---Render
---@param instructionalButton boolean
---@return void
---@public
function RageUI2.Render(instructionalButton)
	if RageUI2.CurrentMenu ~= nil then
		if RageUI2.CurrentMenu() then
			if RageUI2.Settings.Debug then
				up = nil

				if RageUI2.CurrentMenu.Controls.Up.Pressed then
					up = "~g~True~s~"
				else
					up = "~r~False~s~"
				end

				down = nil

				if RageUI2.CurrentMenu.Controls.Down.Pressed then
					down = "~g~True~s~"
				else
					down = "~r~False~s~"
				end

				left = nil

				if RageUI2.CurrentMenu.Controls.Left.Pressed then
					left = "~g~True~s~"
				else
					left = "~r~False~s~"
				end

				right = nil

				if RageUI2.CurrentMenu.Controls.Right.Pressed then
					right = "~g~True~s~"
				else
					right = "~r~False~s~"
				end

				text = "~r~Debug\n~s~Options max : " .. RageUI2.Options .. "\n" .. "Current index : " .. RageUI2.CurrentMenu.Index .. "\nTitle : " .. RageUI2.CurrentMenu.Title .. "\n~s~Subtitle : " .. RageUI2.CurrentMenu.Subtitle .. "\n~s~Up pressed : " .. up .. "\nDown pressed : " .. down .. "\nRight pressed : " .. right .. "\nLeft pressed : " .. left
				RenderSprite(RageUI2.Settings.Items.Description.Background.Dictionary, RageUI2.Settings.Items.Description.Background.Texture, RageUI2.CurrentMenu.X, RageUI2.CurrentMenu.Y + RageUI2.Settings.Items.Description.Background.Y + RageUI2.CurrentMenu.SubtitleHeight + RageUI2.ItemOffset, RageUI2.Settings.Items.Description.Background.Width + RageUI2.CurrentMenu.WidthOffset, 250, 0, 0, 0, 255)
				RenderText(text, RageUI2.CurrentMenu.X + RageUI2.Settings.Items.Description.Text.X, RageUI2.CurrentMenu.Y + RageUI2.Settings.Items.Description.Text.Y + RageUI2.CurrentMenu.SubtitleHeight + RageUI2.ItemOffset, 0, RageUI2.Settings.Items.Description.Text.Scale, 255, 255, 255, 255, nil, false, false, RageUI2.Settings.Items.Description.Background.Width + RageUI2.CurrentMenu.WidthOffset)
			end

			if RageUI2.CurrentMenu.Safezone then
				ResetScriptGfxAlign()
			end

			if instructionalButton then
				DrawScaleformMovieFullscreen(RageUI2.CurrentMenu.InstructionalScaleform, 255, 255, 255, 255, 0)
			end

			RageUI2.CurrentMenu.Options = RageUI2.Options
			RageUI2.CurrentMenu.SafeZoneSize = nil
			RageUI2.Controls()
			RageUI2.Options = 0
			RageUI2.StatisticPanelCount = 0
			RageUI2.ItemOffset = 0

			if RageUI2.CurrentMenu.Controls.Back.Enabled and RageUI2.CurrentMenu.Closable then
				if RageUI2.CurrentMenu.Controls.Back.Pressed then
					RageUI2.CurrentMenu.Controls.Back.Pressed = false
					RageUI2.GoBack()
				end
			end

			if RageUI2.NextMenu ~= nil then
				if RageUI2.NextMenu() then
					RageUI2.Visible(RageUI2.CurrentMenu, false)
					RageUI2.Visible(RageUI2.NextMenu, true)
					RageUI2.CurrentMenu.Controls.Select.Active = false
				end
			end
		end
	end
end

---DrawContent
---@param items function
---@param panels function
function RageUI2.DrawContent(settings, items, panels)
	if (settings.header ~= nil) then
		RageUI2.Header(settings.header)
	else
		RageUI2.Header(true)
	end

	if (items ~= nil) then
		items()
	end

	RageUI2.Background()
	RageUI2.Navigation()
	RageUI2.Description()

	if (panels ~= nil) then
		panels()
	end

	if (settings.instructionalButton ~= nil) then
		RageUI2.Render(settings.instructionalButton)
	else
		RageUI2.Render(true)
	end
end

---ItemsDescription
---@param CurrentMenu table
---@param Description string
---@param Selected boolean
---@return void
---@public
function RageUI2.ItemsDescription(CurrentMenu, Description, Selected)
	---@type table
	local SettingsDescription = RageUI2.Settings.Items.Description

	if Selected and CurrentMenu.Description ~= Description then
		CurrentMenu.Description = Description or nil

		---@type number
		local DescriptionLineCount = GetLineCount(CurrentMenu.Description, CurrentMenu.X + SettingsDescription.Text.X, CurrentMenu.Y + SettingsDescription.Text.Y + CurrentMenu.SubtitleHeight + RageUI2.ItemOffset, 0, SettingsDescription.Text.Scale, 255, 255, 255, 255, nil, false, false, SettingsDescription.Background.Width + CurrentMenu.WidthOffset)

		if DescriptionLineCount > 1 then
			CurrentMenu.DescriptionHeight = SettingsDescription.Background.Height * DescriptionLineCount
		else
			CurrentMenu.DescriptionHeight = SettingsDescription.Background.Height + 7
		end
	end
end

---MouseBounds
---@param CurrentMenu table
---@param Selected boolean
---@param Option number
---@param SettingsButton table
---@return boolean
---@public
function RageUI2.ItemsMouseBounds(CurrentMenu, Selected, Option, SettingsButton)
	---@type boolean
	local Hovered = false
	Hovered = RageUI2.IsMouseInBounds(CurrentMenu.X + CurrentMenu.SafeZoneSize.X, CurrentMenu.Y + SettingsButton.Rectangle.Y + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + RageUI2.ItemOffset, SettingsButton.Rectangle.Width + CurrentMenu.WidthOffset, SettingsButton.Rectangle.Height)

	if Hovered and not Selected then
		RenderRectangle(CurrentMenu.X, CurrentMenu.Y + SettingsButton.Rectangle.Y + CurrentMenu.SubtitleHeight + RageUI2.ItemOffset, SettingsButton.Rectangle.Width + CurrentMenu.WidthOffset, SettingsButton.Rectangle.Height, 255, 255, 255, 20)

		if CurrentMenu.Controls.Click.Active then
			CurrentMenu.Index = Option
			local Audio = RageUI2.Settings.Audio
			RageUI2.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
		end
	end

	return Hovered
end

---ItemsSafeZone
---@param CurrentMenu table
---@return void
---@public
function RageUI2.ItemsSafeZone(CurrentMenu)
	if CurrentMenu.Safezone then
		CurrentMenu.SafeZoneSize = RageUI2.GetSafeZoneBounds()
		SetScriptGfxAlign(76, 84)
		SetScriptGfxAlignParams(0, 0, 0, 0)
	end
end

---CreateWhile
---@param wait number
---@param closure function
---@param beforeWait boolean
---@return void
---@public
function RageUI2.CreateWhile(wait, closure, beforeWait)
	Citizen.CreateThread(function()
		while true do
			if (beforeWait or beforeWait == nil) then
				Citizen.Wait(wait or 0.1)
				closure()
			else
				closure()
				Citizen.Wait(wait or 0.1)
			end
		end
	end)
end