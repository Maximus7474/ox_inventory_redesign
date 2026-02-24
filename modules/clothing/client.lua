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

local animations = {
    components = {
        [1] = { --[[ berd ]]
            dict = "mp_masks@standard_car@ds@",
            anim = "put_on_mask",
            move = 51,
            duration = 600
        },
        [4] = { --[[ lowr ]]
            dict = "re@construction",
            anim = "out_of_breath",
            move = 51,
            duration = 1300
        },
        [6] = { --[[ feet ]]
            dict = "random@domestic",
            anim = "pickup_low",
            move = 51,
            duration = 1300
        },
        [11] = { --[[ jbib ]]
            dict = "clothingtie",
            anim = "try_tie_negative_a",
            move = 51,
            duration = 1200
        }
    },
    props = {
        [0] = {
            on = {
                dict = "veh@common@fp_helmet@",
                anim = "put_on_helmet",
                move = 51,
                duration = 1800,
                wait = 1400
            },
            off = {
                dict = "veh@bike@common@front@base",
                anim = "take_off_helmet_stand_l",
                move = 51,
                duration = 1200,
                wait = 600
            },
        },
        [1] = {
            on = {
                dict = "clothingspecs",
                anim = "try_glasses_neutral_b",
                move = 51,
                duration = 1200,
                wait = 1000
            },
            off = {
                dict = "clothingspecs",
                anim = "take_off",
                move = 51,
                duration = 1200,
                wait = 800
            },
        }
    }
}

RegisterNetEvent('setPedComponent', function(components)
    local animation = animations.components[components.component_id]
    if animation then
        lib.playAnim(cache.ped, animation.dict, animation.anim, 3.0, 3.0, animation.duration, animation.move, 0)
        Wait(animation.duration)
    end

    exports['illenium-appearance']:setPedComponent(PlayerPedId(), components)
end)

RegisterNetEvent('setPedProp', function(props)
    local animation = animations.props[props.prop_id]
    if animation then

        local currentIndex = GetPedPropIndex(cache.ped, props.prop_id)
        -- local currentVar = GetPedPropTextureIndex(cache.ped, props.prop_id)

        if currentIndex ~= -1 then
            lib.playAnim(cache.ped, animation.off.dict, animation.off.anim, 3.0, 3.0, animation.off.duration, animation.off.move, 0)
            Wait(animation.off?.wait or 0)
        end
        if props.drawable ~= -1 then
            lib.playAnim(cache.ped, animation.on.dict, animation.on.anim, 3.0, 3.0, animation.on.duration, animation.on.move, 0)
            Wait(animation.on?.wait or 0)
        end
    end

    exports['illenium-appearance']:setPedProp(PlayerPedId(), props)
end)

RegisterNetEvent('savePlayer', function()
    local playerPed = PlayerPedId()
    local appearance = exports['illenium-appearance']:getPedAppearance(playerPed)
    TriggerServerEvent("illenium-appearance:server:saveAppearance", appearance)
end)

local clothesComponentID = { 1, 0, 2, 1, 7, 8, 11, 9, 7, 6, 5, 4, 6, 3 }
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

local function clearSkin()
    local src = source
    for index, _ in ipairs(clothesComponentID) do
        local playerIdx = GetPlayerFromServerId(src)
        local ped = GetPlayerPed(playerIdx)
        local hash = GetEntityModel(ped)
        if hash == 1885233650 then
            if index == 2 or index == 4 or index == 3 or index == 10 or index == 9 then
                local props = {
                    texture = defaultClothingMen[index].text,
                    drawable = defaultClothingMen[index].draw,
                    prop_id = clothesComponentID[index]
                }
                exports['illenium-appearance']:setPedProp(PlayerPedId(), props)
            else
                local components = {
                    texture = defaultClothingMen[index].text,
                    drawable = defaultClothingMen[index].draw,
                    component_id = clothesComponentID[index]
                }
                exports['illenium-appearance']:setPedComponent(PlayerPedId(), components)
            end
        else
            if index == 2 or index == 4 or index == 3 or index == 10 or index == 9 then
                local props = {
                    texture = defaultClothingWoman[index].text,
                    drawable = defaultClothingWoman[index].draw,
                    prop_id = clothesComponentID[index]
                }
                exports['illenium-appearance']:setPedProp(PlayerPedId(), props)
            else
                local components = {
                    texture = defaultClothingWoman[index].text,
                    drawable = defaultClothingWoman[index].draw,
                    component_id = clothesComponentID[index]
                }
                exports['illenium-appearance']:setPedComponent(PlayerPedId(), components)
            end
        end
    end
    local playerPed = PlayerPedId()
    local appearance = exports['illenium-appearance']:getPedAppearance(playerPed)
    TriggerServerEvent("illenium-appearance:server:saveAppearance", appearance)
end

exports('clearSkin', clearSkin)
