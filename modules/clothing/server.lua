--[[
    CREDIT & LICENSE NOTICE

    This module contains code derived from the ox_inventory redesign by NoLag Development.
    Redesign Author: toshko003 (https://github.com/toshko003)
    Redesign Repository: https://github.com/NoLag-Development/ox_inventory

    Original Repository: https://github.com/overextended/ox_inventory

    Licensed under the GNU General Public License v3.0 (LGPL-3.0).
    You may obtain a copy of the License at: https://www.gnu.org/licenses/gpl-3.0.txt

    Modified by: https://github.com/Maximus7474
--]]

local clothesComponentID = { 1, 0, 2, 1, 7, 8, 11, 9, 7, 6, 5, 4, 6, 3 }
local clothesComponentNames = { "mask", "hat", "earrings", "glasses", "chain", "undershirt", "jacket", "bodyarmor",
    "bracelet", "watch", "bag", "pants", "shoes", "gloves" }
local clothesSlotID = { 11, 6, 8, 7, 16, 14, 12, 13, 10, 9, 17, 18, 19, 15 }
-- Use statebag to define if the player can change clothes
-- Useful for stopping a player changing clothes when in job outfit
local UseExports = false
local canCC
local ox_inventory = exports.ox_inventory

local defaultClothingWoman = {
    [1] = { draw = 0, text = 0 },
    [2] = { draw = -1, text = -1 },
    [3] = { draw = -1, text = -1 },
    [4] = { draw = -1, text = -1 },
    [5] = { draw = 0, text = 0 },
    [6] = { draw = 15, text = 0 },
    [7] = { draw = 15, text = 0 },
    [8] = { draw = 0, text = 0 },
    [9] = { draw = -1, text = -1 },
    [10] = { draw = -1, text = -1 },
    [11] = { draw = 0, text = 0 },
    [12] = { draw = 15, text = 0 },
    [13] = { draw = 35, text = 0 },
    [14] = { draw = 15, text = 0 }
}

local defaultClothingMen = {
    [1] = { draw = 0, text = 0 },
    [2] = { draw = -1, text = -1 },
    [3] = { draw = -1, text = -1 },
    [4] = { draw = -1, text = -1 },
    [5] = { draw = 0, text = 0 },
    [6] = { draw = 15, text = 0 },
    [7] = { draw = 15, text = 0 },
    [8] = { draw = 0, text = 0 },
    [9] = { draw = -1, text = -1 },
    [10] = { draw = -1, text = -1 },
    [11] = { draw = 0, text = 0 },
    [12] = { draw = 21, text = 0 },
    [13] = { draw = 34, text = 0 },
    [14] = { draw = 15, text = 0 }
}

local function findClothesSlot(slot)
    for i = 1, #clothesSlotID do
        if slot == clothesSlotID[i] then
            return true
        end
    end
    return false
end

local addItems = ox_inventory:registerHook('createItem', function(payload)
    if not payload.inventoryId then return end

    local slot = ox_inventory:GetEmptySlot(payload.inventoryId)

    -- * terrible solution, too lazy to make a better one
    local slotExists = lib.waitFor(function()
        return findClothesSlot(slot)
    end)

    if slotExists then
        SetTimeout(250, function()
            local secondCheck = findClothesSlot(slot)
            if secondCheck then
                ox_inventory:RemoveItem(payload.inventoryId, payload.item.name, payload.count, nil, slot)
                ox_inventory:CustomDrop('Drop', {
                    {
                        payload.item.name,
                        payload.count,
                        payload.metadata
                    }
                }, GetEntityCoords(GetPlayerPed(payload.inventoryId)))
                lib.notify(payload.inventoryId, {
                    position = "top-left",
                    description = 'Your inventory is full, items have been dropped on the ground.',
                    type = 'error'
                })
            end
        end)
    end
end, {
    print = false,
})

local buyItem = ox_inventory:registerHook('buyItem', function(payload)
    local slot = payload.toSlot
    local slotExists = false
    for _, id in ipairs(clothesSlotID) do
        if id == slot then
            slotExists = true
            break
        end
    end

    return not slotExists
end, {
    print = false,
})

local checkMovingItems = ox_inventory:registerHook('swapItems', function(payload)
    local source_ = payload.source
    local action = payload.action

    if action == 'swap' then
        local fromSlotMoved = payload.fromSlot.slot
        local toSlotMoved = payload.toSlot.slot

        local CurrentItemNames = { payload.fromSlot.name, payload.toSlot.name }
        local CurrentItemMetadata = { payload.fromSlot.metadata, payload.toSlot.metadata }

        local cItemMoved = false
        local cItemMovedIndex = -1

        local cSlotToDetect = false
        local cSlotToIndex = -1

        local cSlotFromDetect = false
        local cSlotFromIndex = -1

        for index, searchingClothingName in ipairs(clothesComponentNames) do
            if CurrentItemNames[1] == searchingClothingName or CurrentItemNames[2] == searchingClothingName then
                cItemMoved = true
                cItemMovedIndex = index
                break
            end
        end

        for index, searchingClothingSlot in ipairs(clothesSlotID) do
            if payload.toType == 'player' and toSlotMoved == searchingClothingSlot then
                cSlotToDetect = true
                cSlotToIndex = index
                break
            end
        end

        for index, searchingClothingSlot in ipairs(clothesSlotID) do
            if payload.toType == 'player' and toSlotMoved == searchingClothingSlot then
                cSlotFromDetect = true
                cSlotFromIndex = index
                break
            end
        end

        local isComponent
        if cItemMovedIndex == 2 or cItemMovedIndex == 4 or cItemMovedIndex == 3 or cItemMovedIndex == 10 or cItemMovedIndex == 9 then
            isComponent = false
        else
            isComponent = true
        end

        if cItemMoved then
            if payload.toType == 'player' and payload.toInventory ~= payload.source then
                if payload.toInventory ~= payload.fromInventory then
                    return false
                end
            end

            if UseExports then
                canCC = Player(source_).state.canChangeClothes
            else
                canCC = true
            end
            if cSlotFromIndex == cItemMovedIndex then
                if CurrentItemNames[1] == CurrentItemNames[2] then
                    if canCC then
                        if isComponent then
                            if clothesComponentNames[cItemMovedIndex] == 'bag' then
                                BagAdd(source_, CurrentItemMetadata[1], true)
                            end
                            local components = {
                                texture = CurrentItemMetadata[1].texture,
                                drawable = CurrentItemMetadata[1].drawable,
                                component_id = clothesComponentID[cItemMovedIndex]
                            }
                            TriggerClientEvent('setPedComponent', source_, components)
                        else
                            local props = {
                                texture = CurrentItemMetadata[1].texture,
                                drawable = CurrentItemMetadata[1].drawable,
                                prop_id = clothesComponentID[cItemMovedIndex]
                            }
                            TriggerClientEvent('setPedProp', source_, props)
                        end
                        TriggerClientEvent('savePlayer', source_)
                    else
                        return false
                    end
                else
                    return false
                end
            elseif cSlotToIndex == cItemMovedIndex then
                if CurrentItemNames[1] == CurrentItemNames[2] then
                    if canCC then
                        if isComponent then
                            if clothesComponentNames[cItemMovedIndex] == 'bag' then
                                BagAdd(source_, CurrentItemMetadata[2], true)
                            end
                            local components = {
                                texture = CurrentItemMetadata[2].texture,
                                drawable = CurrentItemMetadata[2].drawable,
                                component_id = clothesComponentID[cItemMovedIndex]
                            }
                            TriggerClientEvent('setPedComponent', source_, components)
                        else
                            local props = {
                                texture = CurrentItemMetadata[2].texture,
                                drawable = CurrentItemMetadata[2].drawable,
                                prop_id = clothesComponentID[cItemMovedIndex]
                            }
                            TriggerClientEvent('setPedProp', source_, props)
                        end

                        TriggerClientEvent('savePlayer', source_)
                    else
                        return false
                    end
                else
                    return false
                end
            end
        else
            if cSlotFromDetect or cSlotToDetect then
                return false
            end
        end
    elseif action == 'move' then
        local fromSlotMoved = payload.fromSlot.slot
        local toSlotMoved = payload.toSlot

        local CurrentItemName = payload.fromSlot.name
        local CurrentItemMetadata = payload.fromSlot.metadata

        local MovedCitem = false
        local MovedCitemIndex = -1


        local MovedToCslot = false
        local MovedToCslotIndex = -1

        local MovedFromCslot = false

        for index, searchingClothingName in ipairs(clothesComponentNames) do
            if CurrentItemName == searchingClothingName then
                MovedCitem = true
                MovedCitemIndex = index
                break
            end
        end

        local isComponent
        if MovedCitemIndex == 2 or MovedCitemIndex == 4 or MovedCitemIndex == 3 or MovedCitemIndex == 10 or MovedCitemIndex == 9 then
            isComponent = false
        else
            isComponent = true
        end

        for index, searchingClothingSlot in ipairs(clothesSlotID) do
            if payload.toType == 'player' and toSlotMoved == searchingClothingSlot then
                MovedToCslot = true
                MovedToCslotIndex = index
                break
            end
        end

        for _, searchingClothingSlot in ipairs(clothesSlotID) do
            if fromSlotMoved == searchingClothingSlot then
                MovedFromCslot = true
                break
            end
        end

        if MovedCitem then
            if payload.toType == 'player' and payload.toInventory ~= payload.source then
                if payload.toInventory ~= payload.fromInventory then
                    return false
                end
            end

            if UseExports then
                canCC = Player(source_).state.canChangeClothes
            else
                canCC = true
            end
            if MovedToCslot then
                if MovedCitemIndex == MovedToCslotIndex then
                    if canCC then
                        if isComponent then
                            if clothesComponentNames[MovedCitemIndex] == 'bag' then
                                BagAdd(source_, CurrentItemMetadata, true)
                            end
                            local components = {
                                texture = CurrentItemMetadata.texture,
                                drawable = CurrentItemMetadata.drawable,
                                component_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedComponent', source_, components)
                        else
                            local props = {
                                texture = CurrentItemMetadata.texture,
                                drawable = CurrentItemMetadata.drawable,
                                prop_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedProp', source_, props)
                        end
                        TriggerClientEvent('savePlayer', source_)
                    else
                        return false
                    end
                else
                    return false
                end
            elseif MovedFromCslot then
                if payload.fromInventory ~= payload.toInventory and payload.fromType == 'player' and payload.toType == 'player' then
                    local fromSource = payload.fromInventory
                    local ped = GetPlayerPed(fromSource)
                    local hash = GetEntityModel(ped)
                    if hash == 1885233650 then
                        if isComponent then
                            if clothesComponentNames[MovedCitemIndex] == 'bag' then
                                BagAdd(fromSource, CurrentItemMetadata, false)
                            end
                            local components = {
                                texture = defaultClothingMen[MovedCitemIndex].text,
                                drawable = defaultClothingMen[MovedCitemIndex].draw,
                                component_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedComponent', fromSource, components)
                        else
                            local props = {
                                texture = defaultClothingMen[MovedCitemIndex].text,
                                drawable = defaultClothingMen[MovedCitemIndex].draw,
                                prop_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedProp', fromSource, props)
                        end
                    else
                        if isComponent then
                            if clothesComponentNames[MovedCitemIndex] == 'bag' then
                                BagAdd(fromSource, CurrentItemMetadata, false)
                            end
                            local components = {
                                texture = defaultClothingWoman[MovedCitemIndex].text,
                                drawable = defaultClothingWoman[MovedCitemIndex].draw,
                                component_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedComponent', fromSource, components)
                        else
                            local props = {
                                texture = defaultClothingWoman[MovedCitemIndex].text,
                                drawable = defaultClothingWoman[MovedCitemIndex].draw,
                                prop_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedProp', fromSource, props)
                        end
                    end
                    TriggerClientEvent('savePlayer', fromSource)
                    return true
                end
                if canCC then
                    local ped = GetPlayerPed(source_)
                    local hash = GetEntityModel(ped)
                    if hash == 1885233650 then
                        if isComponent then
                            if clothesComponentNames[MovedCitemIndex] == 'bag' then
                                BagAdd(source_, CurrentItemMetadata, false)
                            end
                            local components = {
                                texture = defaultClothingMen[MovedCitemIndex].text,
                                drawable = defaultClothingMen[MovedCitemIndex].draw,
                                component_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedComponent', source_, components)
                        else
                            local props = {
                                texture = defaultClothingMen[MovedCitemIndex].text,
                                drawable = defaultClothingMen[MovedCitemIndex].draw,
                                prop_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedProp', source_, props)
                        end
                    else
                        if isComponent then
                            if clothesComponentNames[MovedCitemIndex] == 'bag' then
                                BagAdd(source_, CurrentItemMetadata, false)
                            end
                            local components = {
                                texture = defaultClothingWoman[MovedCitemIndex].text,
                                drawable = defaultClothingWoman[MovedCitemIndex].draw,
                                component_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedComponent', source_, components)
                        else
                            local props = {
                                texture = defaultClothingWoman[MovedCitemIndex].text,
                                drawable = defaultClothingWoman[MovedCitemIndex].draw,
                                prop_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedProp', source_, props)
                        end
                    end
                    TriggerClientEvent('savePlayer', source_)
                else
                    return false
                end
            end
        else
            if MovedToCslot then
                return false
            end
        end
    elseif action == 'give' then
        local fromSlotMoved = payload.fromSlot.slot

        local CurrentItemName = payload.fromSlot.name
        local CurrentItemMetadata = payload.fromSlot.metadata

        local MovedCitem = false
        local MovedCitemIndex = -1


        local MovedToCslot = false
        local MovedToCslotIndex = -1

        local MovedFromCslot = false

        for index, searchingClothingName in ipairs(clothesComponentNames) do
            if CurrentItemName == searchingClothingName then
                MovedCitem = true
                MovedCitemIndex = index
                break
            end
        end

        local isComponent
        if MovedCitemIndex == 2 or MovedCitemIndex == 4 or MovedCitemIndex == 3 or MovedCitemIndex == 10 or MovedCitemIndex == 9 then
            isComponent = false
        else
            isComponent = true
        end

        for _, searchingClothingSlot in ipairs(clothesSlotID) do
            if fromSlotMoved == searchingClothingSlot then
                MovedFromCslot = true
                break
            end
        end

        if MovedCitem then
            -- if payload.toType == 'player' and payload.toInventory ~= payload.source then
            --     if payload.toInventory ~= payload.fromInventory then
            --         return false
            --     end
            -- end

            if UseExports then
                canCC = Player(source_).state.canChangeClothes
            else
                canCC = true
            end
            if MovedToCslot then
                if MovedCitemIndex == MovedToCslotIndex then
                    if canCC then
                        if isComponent then
                            if clothesComponentNames[MovedCitemIndex] == 'bag' then
                                BagAdd(source_, CurrentItemMetadata, true)
                            end
                            local components = {
                                texture = CurrentItemMetadata.texture,
                                drawable = CurrentItemMetadata.drawable,
                                component_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedComponent', source_, components)
                        else
                            local props = {
                                texture = CurrentItemMetadata.texture,
                                drawable = CurrentItemMetadata.drawable,
                                prop_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedProp', source_, props)
                        end
                        TriggerClientEvent('savePlayer', source_)
                    else
                        return false
                    end
                else
                    return false
                end
            elseif MovedFromCslot then
                if payload.fromInventory ~= payload.toInventory and payload.fromType == 'player' and payload.toType == 'player' then
                    local fromSource = payload.fromInventory
                    local ped = GetPlayerPed(fromSource)
                    local hash = GetEntityModel(ped)
                    if hash == 1885233650 then
                        if isComponent then
                            if clothesComponentNames[MovedCitemIndex] == 'bag' then
                                BagAdd(fromSource, CurrentItemMetadata, false)
                            end
                            local components = {
                                texture = defaultClothingMen[MovedCitemIndex].text,
                                drawable = defaultClothingMen[MovedCitemIndex].draw,
                                component_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedComponent', fromSource, components)
                        else
                            local props = {
                                texture = defaultClothingMen[MovedCitemIndex].text,
                                drawable = defaultClothingMen[MovedCitemIndex].draw,
                                prop_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedProp', fromSource, props)
                        end
                    else
                        if isComponent then
                            if clothesComponentNames[MovedCitemIndex] == 'bag' then
                                BagAdd(fromSource, CurrentItemMetadata, false)
                            end
                            local components = {
                                texture = defaultClothingWoman[MovedCitemIndex].text,
                                drawable = defaultClothingWoman[MovedCitemIndex].draw,
                                component_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedComponent', fromSource, components)
                        else
                            local props = {
                                texture = defaultClothingWoman[MovedCitemIndex].text,
                                drawable = defaultClothingWoman[MovedCitemIndex].draw,
                                prop_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedProp', fromSource, props)
                        end
                    end
                    TriggerClientEvent('savePlayer', fromSource)
                    return true
                end
                if canCC then
                    local ped = GetPlayerPed(source_)
                    local hash = GetEntityModel(ped)
                    if hash == 1885233650 then
                        if isComponent then
                            if clothesComponentNames[MovedCitemIndex] == 'bag' then
                                BagAdd(source_, CurrentItemMetadata, false)
                            end
                            local components = {
                                texture = defaultClothingMen[MovedCitemIndex].text,
                                drawable = defaultClothingMen[MovedCitemIndex].draw,
                                component_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedComponent', source_, components)
                        else
                            local props = {
                                texture = defaultClothingMen[MovedCitemIndex].text,
                                drawable = defaultClothingMen[MovedCitemIndex].draw,
                                prop_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedProp', source_, props)
                        end
                    else
                        if isComponent then
                            if clothesComponentNames[MovedCitemIndex] == 'bag' then
                                BagAdd(source_, CurrentItemMetadata, false)
                            end
                            local components = {
                                texture = defaultClothingWoman[MovedCitemIndex].text,
                                drawable = defaultClothingWoman[MovedCitemIndex].draw,
                                component_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedComponent', source_, components)
                        else
                            local props = {
                                texture = defaultClothingWoman[MovedCitemIndex].text,
                                drawable = defaultClothingWoman[MovedCitemIndex].draw,
                                prop_id = clothesComponentID[MovedCitemIndex]
                            }
                            TriggerClientEvent('setPedProp', source_, props)
                        end
                    end
                    TriggerClientEvent('savePlayer', source_)
                else
                    return false
                end
            end
        else
            if MovedToCslot then
                return false
            end
        end
    end
end, {
    print = false,
})

---@param source number
---@param itemMetadata table
---@param isEquip boolean
function BagAdd(source, itemMetadata, isEquip)
    local removedItems = {}
    local removedItemsArray = {}
    ---@diagnostic disable-next-line: param-type-mismatch
    local inventory = ox_inventory:GetInventory(source, true)

    if itemMetadata.slot then
        local curSlots = inventory?.slots
        local totalSlots = 0
        if isEquip then
            totalSlots = curSlots + itemMetadata.slot
        else
            totalSlots = curSlots - itemMetadata.slot
            for i = curSlots, curSlots - itemMetadata.slot + 1, -1 do
                local item = ox_inventory:GetSlot(source, i)
                if item then
                    removedItems[#removedItems + 1] = item
                    removedItemsArray[#removedItemsArray + 1] = { item.name, item.count, item.metadata }
                end
            end

            if next(removedItems) then
                for _, item in ipairs(removedItems) do
                    ox_inventory:RemoveItem(source, item.name, item.count, nil, item.slot)
                end

                ox_inventory:CustomDrop('Drop', removedItemsArray, GetEntityCoords(GetPlayerPed(source)))
            end
        end
        ox_inventory:SetSlotCount(source, totalSlots)
    end

    if itemMetadata.WeightBag then
        local curWeight = inventory?.maxWeight
        local totalWeight = isEquip and curWeight + itemMetadata.WeightBag or curWeight - itemMetadata.WeightBag
        ox_inventory:SetMaxWeight(source, totalWeight)
    end
end

local function onPlayerLoaded(source)
    local bagSlot = ox_inventory:GetSlot(source, 44)
    if bagSlot then
        BagAdd(source, bagSlot.metadata, true)
    end
end

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local src = source
    if not src then return end

    onPlayerLoaded(src)
end)

RegisterNetEvent('esx:playerLoaded', function(playerId)
    if not playerId then return end

    onPlayerLoaded(playerId)
end)

RegisterNetEvent('ox:playerLoaded', function (playerId)
    if not playerId then return end

    onPlayerLoaded(playerId)
end)
