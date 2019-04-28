--[[
TheNexusAvenger

Class representing an overrider.
This is used to store overrides for the Nexus Dependency Injector.
--]]

local OverriderClass = {}

local IndexOverriderClass = require(script:WaitForChild("IndexOverriderClass"))
local CallOverriderClass = require(script:WaitForChild("CallOverriderClass"))



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------               CONSTRUCTOR              --------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--[[
Creates an overrider instance.
--]]
function OverriderClass.new()
	--Create the object.
	local OverriderObject = {
		IndexOverrides = {},
		CallOverrides = {},
	}
	
	setmetatable(OverriderObject,{
		__index = OverriderClass
	})
	
	--Return the object.
	return OverriderObject
end



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------             OBJECT METHODS             --------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--[[
Clones the overrider object. It does not clone the individual overriders, but
adding new overrides will not affect the existing object.
--]]
function OverriderClass:Clone()
	--Create a new overrider.
	local NewOverrider = OverriderClass.new()
	
	--Add the new overriders.
	for Index,Overrider in pairs(self.IndexOverrides) do
		NewOverrider.IndexOverrides[Index] = Overrider
	end
	for Index,OverriderTable in pairs(self.CallOverrides) do
		local NewCallOverrides = {}
		NewOverrider.CallOverrides[Index] = NewCallOverrides
		for SubIndex,Overrider in pairs(OverriderTable) do
			NewCallOverrides[SubIndex] = Overrider
		end
	end
	
	--Return the new overrider.
	return NewOverrider
end

--[[
Returns the override for determining the override of an index.
--]]
function OverriderClass:GetIndexOverride(Index)
	return self.IndexOverrides[Index]
end

--[[
Returns the override for determining the override of an index.
--]]
function OverriderClass:GetIndexOverride(Index)
	return self.IndexOverrides[Index]
end

--[[
Returns the override for determining the override of calling an index.
--]]
function OverriderClass:GetCallOverride(Index,Parameters)
	if not Parameters then Parameters = {} end
	local CallOverrides = self.CallOverrides[Index]
	
	--Get the call override.
	if CallOverrides then
		for _,Override in pairs(CallOverrides) do
			if Override:CanBeCalled(Parameters) then
				return Override
			end
		end
	end
end

--[[
Overides what is returned when a global variable is indexed.
]]
function OverriderClass:WhenIndexed(Index)
	local IndexOverrider = IndexOverriderClass.new()
	self.IndexOverrides[Index] = IndexOverrider
	
	return IndexOverrider
end

--[[
Overides what is returned when a global variable is called.
]]
function OverriderClass:WhenCalled(Index,...)
	local CallOverrider = CallOverriderClass.new({...})
	if not self.CallOverrides[Index] then self.CallOverrides[Index] = {} end
	table.insert(self.CallOverrides[Index],CallOverrider)
	
	return CallOverrider
end



return OverriderClass