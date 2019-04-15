--[[
Copyright 2019 Sean McNamara AKA @Coorbin <smcnam@gmail.com>.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]

local smnt_name = "SearchMemberNotesToo"
local smnt_savedVarsName = "SearchMemberNotesTooSettings"

local function smnt_OnAddOnLoaded(event, addonName)
	if addonName == smnt_name then
		EVENT_MANAGER:UnregisterForEvent(smnt_name, EVENT_ADD_ON_LOADED)
		smnt_savedVariables = ZO_SavedVars:NewAccountWide(smnt_savedVarsName, 15, nil, {})
        local grm = GUILD_ROSTER_KEYBOARD
        
        local og_FilterScrollList = grm.FilterScrollList

        grm.FilterScrollList = function(self)
            local scrollData = ZO_ScrollList_GetDataList(self.list)
            ZO_ClearNumericallyIndexedTable(scrollData)

            local searchTerm = self.searchBox:GetText()
            local hideOffline = GetSetting_Bool(SETTING_TYPE_UI, UI_SETTING_SOCIAL_LIST_HIDE_OFFLINE)

            local masterList = GUILD_ROSTER_MANAGER:GetMasterList()
            for i = 1, #masterList do
                local data = masterList[i]
                if searchTerm == "" or GUILD_ROSTER_MANAGER:IsMatch(searchTerm, data)
                or string.find(string.lower(data.note), string.lower(searchTerm)) then
                    if not hideOffline or data.online then
                        table.insert(scrollData, ZO_ScrollList_CreateDataEntry(GUILD_MEMBER_DATA, data))
                    end
                end
            end
        end
	end
end

EVENT_MANAGER:RegisterForEvent(smnt_name, EVENT_ADD_ON_LOADED, smnt_OnAddOnLoaded)
