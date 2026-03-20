---@type Frame
MyPetMountSearchFrame = MyPetMountSearchFrame

-- Function to get all mount names
local function GetAllMountNames()
    local mountNames = {}

    -- Get the total number of mounts
    local numMounts = GetNumCompanions("MOUNT")

    -- Iterate through each mount to get its name
    for i = 1, numMounts do
        local _, mountName, _, _, _, _ = GetCompanionInfo("MOUNT", i)
        table.insert(mountNames, mountName:lower())
    end

    return mountNames
end


-- Function to get all pet names
local function GetAllPetNames()
    local petNames = {}

    -- Get the total number of pets
    local numPets = GetNumCompanions("CRITTER")

    -- Iterate through each pet to get its name
    for i = 1, numPets do
        local _, petName, _, _, _, _ = GetCompanionInfo("CRITTER", i)
        table.insert(petNames, petName:lower())
    end

    return petNames
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


-- Declare global variables
local myFrame
local displayWindow
local icon1
local icon2
local icon3
local icon4
local iconName1
local iconName2
local iconName3
local iconName4
local iconCompanionType1
local iconCompanionType2
local iconCompanionType3
local iconCompanionType4
local iconCompanionID1
local iconCompanionID2
local iconCompanionID3
local iconCompanionID4
local checkboxPets
local checkboxMounts
local NamesNumbersType = {}

-- Function to run when the input box changes
local function OnTextChanged(self)
    local searchText = self:GetText()
	local includePets = checkboxPets:GetChecked()
    local includeMounts = checkboxMounts:GetChecked()
	
	icon1:SetTexture("")
	icon2:SetTexture("")
	icon3:SetTexture("")
	icon4:SetTexture("")
	iconName1:SetText("")
	iconName2:SetText("")
	iconName3:SetText("")
	iconName4:SetText("")
	iconCompanionType1 = nil
	iconCompanionType2 = nil
	iconCompanionType3 = nil
	iconCompanionType4 = nil
	iconCompanionID1 = nil
	iconCompanionID2 = nil
	iconCompanionID3 = nil
	iconCompanionID4 = nil
	NamesNumbersType = {}

	
	if searchText == "" then
		-- Display all mounts and pets?
	else
		-- See what to include in the search
		if includePets and includeMounts then
			-- Function to compare two tables based on the 'name' field
			local function compareNames(a, b)
    				return a.name < b.name
			end

			-- Get all pets and their number as a struct in an array
			local petNames = GetAllPetNames()
			local PetNamesNumbers = {}
			for i = 1, #petNames do
    				local structPetNamesNumber = {name = petNames[i], num = i, type = "pet"}
    				table.insert(PetNamesNumbers, structPetNamesNumber)
			end

			-- Get all mounts and their number as a struct in an array
			local mountNames = GetAllMountNames()
			local MountNamesNumbers = {}
			for i = 1, #mountNames do
    				local structMountNamesNumber = {name = mountNames[i], num = i, type = "mount"}
    				table.insert(MountNamesNumbers, structMountNamesNumber)
			end

			-- Add the arrays together and sort it
			for i = 1, #petNames do
				table.insert(NamesNumbersType, PetNamesNumbers[i])
			end
			for i = 1, #mountNames do
				table.insert(NamesNumbersType, MountNamesNumbers[i])
			end

			table.sort(NamesNumbersType, compareNames)

			-- Create a array only containing searched items
			local hasSearchedLetter = {}
			for i = 1, #NamesNumbersType do
				if string.find(NamesNumbersType[i].name, searchText) ~= nil then
					table.insert(hasSearchedLetter, NamesNumbersType[i])
				end
			end
			
			-- Show the icons
			if #hasSearchedLetter >= 1 then
				if hasSearchedLetter[1].type == "pet" then
					local _, _, _, icon, _, _ = GetCompanionInfo("CRITTER", hasSearchedLetter[1].num)
					icon1:SetTexture(icon)
					iconCompanionType1 = "CRITTER"
					iconCompanionID1 = hasSearchedLetter[1].num
				else
					local _, _, _, icon, _, _ = GetCompanionInfo("MOUNT", hasSearchedLetter[1].num)
					icon1:SetTexture(icon)
					iconCompanionType1 = "MOUNT"
					iconCompanionID1 = hasSearchedLetter[1].num
				end
				iconName1:SetText(hasSearchedLetter[1].name)
				if #hasSearchedLetter >= 2 then
					if hasSearchedLetter[2].type == "pet" then
						local _, _, _, icon, _, _ = GetCompanionInfo("CRITTER", hasSearchedLetter[2].num)
						icon2:SetTexture(icon)
						iconCompanionType2 = "CRITTER"
						iconCompanionID2 = hasSearchedLetter[2].num
					else
						local _, _, _, icon, _, _ = GetCompanionInfo("MOUNT", hasSearchedLetter[2].num)
						icon2:SetTexture(icon)
						iconCompanionType2 = "MOUNT"
						iconCompanionID2 = hasSearchedLetter[2].num
					end
					iconName2:SetText(hasSearchedLetter[2].name)
					if #hasSearchedLetter >= 3 then
						if hasSearchedLetter[3].type == "pet" then
							local _, _, _, icon, _, _ = GetCompanionInfo("CRITTER", hasSearchedLetter[3].num)
							icon3:SetTexture(icon)
							iconCompanionType3 = "CRITTER"
							iconCompanionID3 = hasSearchedLetter[3].num
						else
							local _, _, _, icon, _, _ = GetCompanionInfo("MOUNT", hasSearchedLetter[3].num)
							icon3:SetTexture(icon)
							iconCompanionType3 = "MOUNT"
							iconCompanionID3 = hasSearchedLetter[3].num
						end
						iconName3:SetText(hasSearchedLetter[3].name)
						if #hasSearchedLetter >= 4 then
							if hasSearchedLetter[4].type == "pet" then
								local _, _, _, icon, _, _ = GetCompanionInfo("CRITTER", hasSearchedLetter[4].num)
								icon4:SetTexture(icon)
								iconCompanionType4 = "CRITTER"
								iconCompanionID4 = hasSearchedLetter[4].num
							else
								local _, _, _, icon, _, _ = GetCompanionInfo("MOUNT", hasSearchedLetter[4].num)
								icon4:SetTexture(icon)
								iconCompanionType4 = "MOUNT"
								iconCompanionID4 = hasSearchedLetter[4].num
							end
							iconName4:SetText(hasSearchedLetter[4].name)
							
						end
					end
				end
			end
		elseif includePets then
			local petNames = GetAllPetNames()
			local hasSearchedLetterPetNames = {}
			local hasSearchedLetterPetNum = {}
			for i = 1, #petNames do
				if string.find(petNames[i], searchText) ~= nil then
					table.insert(hasSearchedLetterPetNames, petNames[i])
					table.insert(hasSearchedLetterPetNum, i)
				end
			end
			if #hasSearchedLetterPetNames >= 1 then
				local _, _, _, icon, _, _ = GetCompanionInfo("CRITTER", hasSearchedLetterPetNum[1])
				icon1:SetTexture(icon)
				iconCompanionType1 = "CRITTER"
				iconCompanionID1 = hasSearchedLetterPetNum[1]
				iconName1:SetText(hasSearchedLetterPetNames[1])
				if #hasSearchedLetterPetNames >= 2 then
					local _, _, _, icon, _, _ = GetCompanionInfo("CRITTER", hasSearchedLetterPetNum[2])
					icon2:SetTexture(icon)
					iconCompanionType2 = "CRITTER"
					iconCompanionID2 = hasSearchedLetterPetNum[2]
					iconName2:SetText(hasSearchedLetterPetNames[2])
					if #hasSearchedLetterPetNames >= 3 then
						local _, _, _, icon, _, _ = GetCompanionInfo("CRITTER", hasSearchedLetterPetNum[3])
						icon3:SetTexture(icon)
						iconCompanionType3 = "CRITTER"
						iconCompanionID3 = hasSearchedLetterPetNum[3]
						iconName3:SetText(hasSearchedLetterPetNames[3])
						if #hasSearchedLetterPetNames >= 4 then
							local _, _, _, icon, _, _ = GetCompanionInfo("CRITTER", hasSearchedLetterPetNum[4])
							icon4:SetTexture(icon)
							iconCompanionType4 = "CRITTER"
							iconCompanionID4 = hasSearchedLetterPetNum[4]
							iconName4:SetText(hasSearchedLetterPetNames[4])
						end
					end
				end
			end
		elseif includeMounts then
			local mountNames = GetAllMountNames()
			local hasSearchedLetterMountNames = {}
			local hasSearchedLetterMountNum = {}
			for i = 1, #mountNames do
				if string.find(mountNames[i], searchText) ~= nil then
					table.insert(hasSearchedLetterMountNames, mountNames[i])
					table.insert(hasSearchedLetterMountNum, i)
				end
			end
			if #hasSearchedLetterMountNames >= 1 then
				local _, _, _, icon, _, _ = GetCompanionInfo("MOUNT", hasSearchedLetterMountNum[1])
				icon1:SetTexture(icon)
				iconCompanionType1 = "MOUNT"
				iconCompanionID1 = hasSearchedLetterMountNum[1]
				iconName1:SetText(hasSearchedLetterMountNames[1])
				if #hasSearchedLetterMountNames >= 2 then
					local _, _, _, icon, _, _ = GetCompanionInfo("MOUNT", hasSearchedLetterMountNum[2])
					icon2:SetTexture(icon)
					iconCompanionType2 = "MOUNT"
					iconCompanionID2 = hasSearchedLetterMountNum[2]
					iconName2:SetText(hasSearchedLetterMountNames[2])
					if #hasSearchedLetterMountNames >= 3 then
						local _, _, _, icon, _, _ = GetCompanionInfo("MOUNT", hasSearchedLetterMountNum[3])
						icon3:SetTexture(icon)
						iconCompanionType3 = "MOUNT"
						iconCompanionID3 = hasSearchedLetterMountNum[3]
						iconName3:SetText(hasSearchedLetterMountNames[3])
						if #hasSearchedLetterMountNames >= 4 then
							local _, _, _, icon, _, _ = GetCompanionInfo("MOUNT", hasSearchedLetterMountNum[4])
							icon4:SetTexture(icon)
							iconCompanionType4 = "MOUNT"
							iconCompanionID4 = hasSearchedLetterMountNum[4]
							iconName4:SetText(hasSearchedLetterMountNames[4])
						end
					end
				end
			end
		end
	end
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
	
	-- Add icon1
        icon1 = displayWindow:CreateTexture(nil, "OVERLAY")
        icon1:SetSize(50, 50)
        icon1:SetPoint("TOPLEFT", displayWindow, "TOPLEFT", -13, 0)
		
	-- Add a overlay button to icon1
		local icon1Overlay = CreateFrame("Button", nil, displayWindow)
		icon1Overlay:SetSize(50, 50)
		icon1Overlay:SetPoint("TOPLEFT", displayWindow, "TOPLEFT", -13, 0)
		local f1 = function()
			OnIconClick(iconCompanionType1, iconCompanionID1)
		end
		icon1Overlay:SetScript("OnClick", f1)

	-- Add icon1's name
        iconName1 = displayWindow:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        iconName1:SetPoint("TOPLEFT", icon1, "TOPRIGHT", 10, -15)

	-- Add icon2
        icon2 = displayWindow:CreateTexture(nil, "OVERLAY")
        icon2:SetSize(50, 50)
        icon2:SetPoint("TOPLEFT", displayWindow, "TOPLEFT", -13, -60)
		
	-- Add a overlay button to icon2
		local icon2Overlay = CreateFrame("Button", nil, displayWindow)
		icon2Overlay:SetSize(50, 50)
		icon2Overlay:SetPoint("TOPLEFT", displayWindow, "TOPLEFT", -13, -60)
		local f2 = function()
			OnIconClick(iconCompanionType2, iconCompanionID2)
		end
		icon2Overlay:SetScript("OnClick", f2)

	-- Add icon2's name
        iconName2 = displayWindow:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        iconName2:SetPoint("TOPLEFT", icon2, "TOPRIGHT", 10, -15)

	-- Add icon3
        icon3 = displayWindow:CreateTexture(nil, "OVERLAY")
        icon3:SetSize(50, 50)
        icon3:SetPoint("TOPLEFT", displayWindow, "TOPLEFT", -13, -120)
		
	-- Add a overlay button to icon3
		local icon3Overlay = CreateFrame("Button", nil, displayWindow)
		icon3Overlay:SetSize(50, 50)
		icon3Overlay:SetPoint("TOPLEFT", displayWindow, "TOPLEFT", -13, -120)
		local f3 = function()
			OnIconClick(iconCompanionType3, iconCompanionID3)
		end
		icon3Overlay:SetScript("OnClick", f3)

	-- Add icon3's name
        iconName3 = displayWindow:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        iconName3:SetPoint("TOPLEFT", icon3, "TOPRIGHT", 10, -15)

	-- Add icon4
        icon4 = displayWindow:CreateTexture(nil, "OVERLAY")
        icon4:SetSize(50, 50)
        icon4:SetPoint("TOPLEFT", displayWindow, "TOPLEFT", -13, -180)
		
	-- Add a overlay button to icon4
		local icon4Overlay = CreateFrame("Button", nil, displayWindow)
		icon4Overlay:SetSize(50, 50)
		icon4Overlay:SetPoint("TOPLEFT", displayWindow, "TOPLEFT", -13, -180)
		local f4 = function()
			OnIconClick(iconCompanionType4, iconCompanionID4)
		end
		icon4Overlay:SetScript("OnClick", f4)

	-- Add icon4's name
        iconName4 = displayWindow:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        iconName4:SetPoint("TOPLEFT", icon4, "TOPRIGHT", 10, -15)

	-- Add a checkbox to include pets
        checkboxPets = CreateFrame("CheckButton", "MyPetMountSearchCheckboxPets", myFrame, "UICheckButtonTemplate")
        checkboxPets:SetPoint("BOTTOMLEFT", myFrame, "BOTTOMLEFT", 10, 40)
		checkboxPets:SetChecked(true)

	-- Add pets-checkbox name
        local checkboxPetsName = myFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        checkboxPetsName:SetPoint("TOPLEFT", checkboxPets, "TOPRIGHT", 0, -6)
        checkboxPetsName:SetText("Include Pets")

	-- Add a checkbox to include mounts
        checkboxMounts = CreateFrame("CheckButton", "MyPetMountSearchCheckboxMounts", myFrame, "UICheckButtonTemplate")
        checkboxMounts:SetPoint("BOTTOMLEFT", myFrame, "BOTTOMLEFT", 10, 10)
		checkboxMounts:SetChecked(true)

	-- Add mounts-checkbox name
        local checkboxMountsName = myFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        checkboxMountsName:SetPoint("TOPLEFT", checkboxMounts, "TOPRIGHT", 0, -6)
        checkboxMountsName:SetText("Include Mounts")
	
    -- Add a close button
        local closeButton = CreateFrame("Button", nil, myFrame, "UIPanelCloseButton")
        closeButton:SetPoint("TOPRIGHT", myFrame, "TOPRIGHT", -4, -4)
        closeButton:SetScript("OnClick", function() myFrame:Hide() end)

    -- Show the frame
        myFrame:Show()
	-- Set focus on the search box
        searchBox:SetFocus()
    end
end