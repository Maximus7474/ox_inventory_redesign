return {
    -- mainly used serverside
    clothesComponentID = { 1, 0, 2, 1, 7, 8, 11, 9, 7, 6, 5, 4, 6, 3 },
    clothesComponentNames = { "mask", "hat", "earrings", "glasses", "chain", "undershirt", "jacket", "bodyarmor",
        "bracelet", "watch", "bag", "pants", "shoes", "gloves" },
    clothesSlotID = { 11, 6, 8, 7, 16, 14, 12, 13, 10, 9, 17, 18, 19, 15 },

    -- Used client side
    animations = {
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
}
