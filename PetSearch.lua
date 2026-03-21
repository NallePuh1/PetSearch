---@type Frame
MyPetMountSearchFrame = MyPetMountSearchFrame


-- Declare global variables
local myFrame
local displayWindow
local icons = {}
local iconNames = {}
local companionTypeOfIcon = {}
local companionIDOfIcon = {}
local checkboxPets
local checkboxMounts
local allCompanionsCache = {}
local searchText


-- Get all companions and store in cache
local function BuildCompanionCache()
    allCompanionsCache = {}

    -- Pets
    local numPets = GetNumCompanions("CRITTER")
    for i = 1, numPets do
        local _, name = GetCompanionInfo("CRITTER", i)
        table.insert(allCompanionsCache, {
            name = name:lower(),
            num = i,
            type = "pet"
        })
    end

    -- Mounts
    local numMounts = GetNumCompanions("MOUNT")
    for i = 1, numMounts do
        local _, name = GetCompanionInfo("MOUNT", i)
        table.insert(allCompanionsCache, {
            name = name:lower(),
            num = i,
            type = "mount"
        })
    end
end


-- Add functionality to press the icons
local function OnIconClick(companionType, companionID)
	local companionTypeExists = not(companionType == nil)
	local companionIDExists = not(companionID == nil)
  -- If companion information is retrieved, use the appropriate function to interact with it
  if companionTypeExists and companionIDExists then
	if companionType == "CRITTER" then
	  CallCompanion("CRITTER", companionID)
	elseif companionType == "MOUNT" then
	  CallCompanion("MOUNT", companionID)
	end
  end
end


-- Display Icons and names
local function DisplayResults(results)
	for i = 1, 4 do
		local result = results[i]

		if result then
			local companionType
			if result.type == "pet" then
				companionType = "CRITTER"
			else
				companionType = "MOUNT"
			end

			local _, _, _, icon, _, _ = GetCompanionInfo(companionType, result.num)

			icons[i]:SetTexture(icon)
			iconNames[i]:SetText(result.name)
			companionTypeOfIcon[i] = companionType
			companionIDOfIcon[i] = result.num
		else
			-- Clear unused slots
			icons[i]:SetTexture("")
			iconNames[i]:SetText("")
			companionTypeOfIcon[i] = nil
			companionIDOfIcon[i] = nil
		end
	end
end


-- Update the results
local function UpdateSearchResults()
	local includePets = checkboxPets:GetChecked()
    local includeMounts = checkboxMounts:GetChecked()
	
	if searchText == "" then
		-- Clear all slots
		for i = 1, 4 do
			icons[i]:SetTexture("")
			iconNames[i]:SetText("")
			companionTypeOfIcon[i] = nil
			companionIDOfIcon[i] = nil
		end
	else
		-- Filter search
		local results = {}
		for i = 1, #allCompanionsCache do
			local companion = allCompanionsCache[i]

			if (includePets and companion.type == "pet") or
			(includeMounts and companion.type == "mount") then
				if string.find(companion.name, searchText) then
					table.insert(results, companion)
				end
			end
		end

		-- Arrange companions by name
		table.sort(results, function(a, b)
			return a.name < b.name
		end)

		-- Display
		DisplayResults(results)
	end
end

-- Function to run when the input box changes
local function OnTextChanged(self)
	searchText = self:GetText():lower()
	UpdateSearchResults()
end


-- Slash command handler
SLASH_MYPETMOUNTSEARCH1 = "/ps"
function SlashCmdList.MYPETMOUNTSEARCH(msg, editbox)
    -- Check if the frame is already shown and hide it
    if MyPetMountSearchFrame and MyPetMountSearchFrame:IsShown() then
        MyPetMountSearchFrame:Hide()
    else
        -- Create a basic frame
        myFrame = CreateFrame("Frame", "MyPetMountSearchFrame", UIParent)
        myFrame:SetSize(250, 390)
        myFrame:SetPoint("CENTER", UIParent, "CENTER")
        myFrame:SetMovable(true)
        myFrame:EnableMouse(true)
        myFrame:RegisterForDrag("LeftButton")
        myFrame:SetScript("OnDragStart", myFrame.StartMoving)
        myFrame:SetScript("OnDragStop", myFrame.StopMovingOrSizing)
		myFrame:SetScript("OnKeyDown", function(_, key)
            	if key == "ESCAPE" then
                	myFrame:Hide()  -- Hide the frame when the "Esc" key is pressed
            	end
        end)
		myFrame:EnableKeyboard(true)

		-- Add a background
        local background = myFrame:CreateTexture(nil, "BACKGROUND")
        background:SetAllPoints(myFrame)
        background:SetTexture("Interface\\Buttons\\WHITE8x8")
		background:SetVertexColor(0, 0, 0, 0.7) -- Set the color and alpha of the background (black with 70% opacity)

    	-- Add a title to the frame
        local title = myFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        title:SetPoint("TOP", myFrame, "TOP", 0, -10)
        title:SetText("PetSearch")

		-- Add text for displaying number of pets
		local numOfPets = myFrame:CreateFontString(nil, "OVERLAY", "GameFontWhite")
        numOfPets:SetPoint("BOTTOMRIGHT", myFrame, "BOTTOMRIGHT", -20, 53)
        numOfPets:SetText(tostring(GetNumCompanions("CRITTER")))
	
		-- Add text for displaying number of mounts
		local numOfMounts = myFrame:CreateFontString(nil, "OVERLAY", "GameFontWhite")
        numOfMounts:SetPoint("BOTTOMRIGHT", myFrame, "BOTTOMRIGHT", -20, 23)
        numOfMounts:SetText(tostring(GetNumCompanions("MOUNT")))

		-- Make a frame for search box
		local searchframe = CreateFrame("Frame", nil, myFrame)
		searchframe:SetSize(160, 20)
		searchframe:SetPoint("TOPLEFT", myFrame, "TOPLEFT", 30, -30)
		searchframe:SetBackdrop({
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
				tile = true,
				tileSize = 16,
				edgeSize = 16,
				insets = { left = 4, right = 4, top = 4, bottom = 4 }
			})
		-- Add an input box for search
        local searchBox = CreateFrame("EditBox", nil, myFrame)
        searchBox:SetSize(160, 20)
        searchBox:SetPoint("TOPLEFT", myFrame, "TOPLEFT", 35, -30)
        searchBox:SetAutoFocus(false) -- Prevent the box from auto-focusing
        searchBox:SetFontObject(GameFontNormal)
        searchBox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
		-- Pass the reference of the search box to the OnTextChanged function
        searchBox.OnTextChanged = OnTextChanged
   		-- Set the script for the input box to trigger OnTextChanged when the content changes
		searchBox:SetScript("OnTextChanged", function(self) OnTextChanged(self) end)
		-- Handle the "ESCAPE" key to clear focus
		searchBox:SetScript("OnEscapePressed", function(self)
				self:ClearFocus()
			end)

		-- Add a display window for icons
        displayWindow = CreateFrame("Frame", nil, myFrame)
        displayWindow:SetSize(260, 100)
        displayWindow:SetPoint("TOPLEFT", searchBox, "BOTTOMLEFT", -10, -10)
	
		-- Add icons
		for i = 1, 4 do
			-- Create icon
			icons[i] = displayWindow:CreateTexture(nil, "OVERLAY")
			icons[i]:SetSize(50, 50)
			icons[i]:SetPoint("TOPLEFT", displayWindow, "TOPLEFT", -13, -(i - 1) * 60)

			-- Create clickable overlay
			local button = CreateFrame("Button", nil, displayWindow)
			button:SetSize(50, 50)
			button:SetPoint("TOPLEFT", displayWindow, "TOPLEFT", -13, -(i - 1) * 60)

			-- On icon click
			button:SetScript("OnClick", function()
				OnIconClick(companionTypeOfIcon[i], companionIDOfIcon[i])
			end)

			-- On Hover: Highlight
			button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")

			-- On Hover: Tooltip
			button:SetScript("OnEnter", function(self)
				local companionType = companionTypeOfIcon[i]
				local companionID = companionIDOfIcon[i]

				if companionType and companionID then
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")

					local _, _, spellID = GetCompanionInfo(companionType, companionID)
					if spellID then
						GameTooltip:SetHyperlink("spell:" .. spellID)
					end

					GameTooltip:Show()
				end
			end)
			button:SetScript("OnLeave", function()
				GameTooltip:Hide()
			end)

			-- Create name text
			iconNames[i] = displayWindow:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
			iconNames[i]:SetPoint("TOPLEFT", icons[i], "TOPRIGHT", 10, -15)
		end

		-- Add a checkbox to include pets
        checkboxPets = CreateFrame("CheckButton", "MyPetMountSearchCheckboxPets", myFrame, "UICheckButtonTemplate")
        checkboxPets:SetPoint("BOTTOMLEFT", myFrame, "BOTTOMLEFT", 10, 40)
		checkboxPets:SetChecked(true)
		checkboxPets:SetScript("OnClick", function()
			UpdateSearchResults()
		end)

		-- Add pets-checkbox name
        local checkboxPetsName = myFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        checkboxPetsName:SetPoint("TOPLEFT", checkboxPets, "TOPRIGHT", 0, -6)
        checkboxPetsName:SetText("Include Pets")

		-- Add a checkbox to include mounts
        checkboxMounts = CreateFrame("CheckButton", "MyPetMountSearchCheckboxMounts", myFrame, "UICheckButtonTemplate")
        checkboxMounts:SetPoint("BOTTOMLEFT", myFrame, "BOTTOMLEFT", 10, 10)
		checkboxMounts:SetChecked(true)
		checkboxMounts:SetScript("OnClick", function()
			UpdateSearchResults()
		end)

		-- Add mounts-checkbox name
        local checkboxMountsName = myFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        checkboxMountsName:SetPoint("TOPLEFT", checkboxMounts, "TOPRIGHT", 0, -6)
        checkboxMountsName:SetText("Include Mounts")
	
    	-- Add a close button
        local closeButton = CreateFrame("Button", nil, myFrame, "UIPanelCloseButton")
        closeButton:SetPoint("TOPRIGHT", myFrame, "TOPRIGHT", -4, -4)
        closeButton:SetScript("OnClick", function() myFrame:Hide() end)

		-- Load and save companions to cache
		BuildCompanionCache()
    	-- Show the frame
        myFrame:Show()
		-- Set focus on the search box
        searchBox:SetFocus()
    end
end