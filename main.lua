--- STEAMODDED HEADER
--- MOD_NAME: Casino Jokers
--- MOD_ID: CASINOJOKERS
--- MOD_AUTHOR: [jonnydeates]
--- MOD_DESCRIPTION: Jokers with casino mechanics.
--- PREFIX: cjjd
----------------------------------------------
------------MOD CODE -------------------------


SMODS.Atlas{
    key = 'CasinoMods', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}
-- Create a helper function that builds a roulette joker card
local function createRouletteCard(name,params)
    -- Base template with common properties and functions
    local base = {
        atlas = 'CasinoMods',
        rarity = 1,
        cost = 3,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,
        pos = {x = 0, y = 0},
        loc_txt = {
            name = name,
            text = {
                '{C:green}#4# in #1#{} chance',
                'to {X:mult,C:white}X#3#{} Mult.',
            }
        },
        loc_vars = function(self, info_queue, center)
            return {
                vars = {
                    center.ability.extra.odds,         -- #1#: odds
                    center.ability.extra.wins,         -- #1#: odds
                    center.ability.extra.Xmult,          -- #3#: multiplier
                    "" .. (G.GAME and G.GAME.probabilities.normal * center.ability.extra.wins or 1)  -- #4#: player's probability
                }
            }
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                local normalProb = G.GAME.probabilities.normal * card.ability.extra.wins
                local odds = card.ability.extra.odds
                if math.random() < (normalProb / odds) then
                    return {
                        card = card,
                        Xmult_mod = card.ability.extra.Xmult,
                        message = 'X' .. card.ability.extra.Xmult,
                        colour = G.C.MULT
                    }
                end
            end
        end,
        in_pool = function(self, _, _)
            return true
        end,
    }

    -- Merge the custom parameters into the base table
    for k, v in pairs(params) do
        base[k] = v
    end

    -- Register the joker card using the SMODS system
    SMODS.Joker(base)
end
-- Create a helper function that builds a roulette joker card
local function createMoneySlotsCard(name, params)
    -- Base template with common properties and functions
    local base = {
        atlas = 'CasinoMods',
        rarity = 1,
        cost = 3,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,
        pos = {x = 0, y = 0},
        loc_txt = {
            name = name,
            text = {
                'Every round, spend {C:red}-$#1#{} to',
                'have a chance at winning:',
                '{C:green}#4# in #2#{} chance for {C:money}$#3#{}',
                '{C:green}#7# in #2#{} chance for {C:money}$#6#{}',
                '{C:green}#10# in #2#{} chance for {C:money}$#9#{}',
                '{C:green}#13# in #2#{} chance for {C:money}$#12#{}',
            }
        },
        loc_vars = function(self, info_queue, center)
            return {
                vars = {
                    center.ability.extra.costs,         -- #1#: costs
                    center.ability.extra.overall_odds,         -- 2#: overall_odds
                    center.ability.extra.payout_1,         -- 3#: odds
                    "" .. (G.GAME and G.GAME.probabilities.normal or 1),  -- #4#: player's probability
                    center.ability.extra.odds_2,         -- #5#: odds
                    center.ability.extra.payout_2,         -- #6#: payout
                    "" .. (G.GAME and G.GAME.probabilities.normal * center.ability.extra.odds_2 or 1),  -- #7#: player's probability
                    center.ability.extra.odds_3,         -- #8#: odds
                    center.ability.extra.payout_3,              -- #9#: payout
                    "" .. (G.GAME and G.GAME.probabilities.normal * center.ability.extra.odds_3 or 1),  -- #10#: player's probability
                    center.ability.extra.odds_4,         -- #11#: odds
                    center.ability.extra.payout_4,       -- #12#: payout
                    "" .. (G.GAME and G.GAME.probabilities.normal * center.ability.extra.odds_4 or 1),  -- #13#: player's probability
                }
            }
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                local normalProb = G.GAME.probabilities.normal * card.ability.extra.wins
                local odds = card.ability.extra.odds
                if math.random() < (normalProb / odds) then
                    return {
                        card = card,
                        Xmult_mod = card.ability.extra.Xmult,
                        message = 'X' .. card.ability.extra.Xmult,
                        colour = G.C.MULT
                    }
                end
            end
        end,
        in_pool = function(self, _, _)
            return true
        end,
    }

    -- Merge the custom parameters into the base table
    for k, v in pairs(params) do
        base[k] = v
    end

    -- Register the joker card using the SMODS system
    SMODS.Joker(base)
end
-- Now define each roulette card using the helper

createRouletteCard('Single',{
    key = 'roulette-wheel-green',
    config = {
        extra = {
            odds = 37,
            wins = 1,
            Xmult = 36,
        }
    },
    pos = {x = 1, y = 0},
})

createRouletteCard('Split', {
    key = 'roulette-wheel-split',
    config = {
        extra = {
            odds = 37,
            wins = 2,
            Xmult = 18,
        }
    },
     pos = {x = 2, y = 0},
})

createRouletteCard('Street',{
    key = 'roulette-wheel-street',
    config = {
        extra = {
            odds = 37,
            Xmult = 12,
            wins = 3,
        }
    },
    pos = {x = 3, y = 0},
})

createRouletteCard('Corner', {
    key = 'roulette-wheel-corner',
    config = {
        extra = {
            odds = 37,
            Xmult = 9,
            wins = 4,
        }
    },
    pos = {x = 4, y = 0},
})
createRouletteCard('Double Street', {
    key = 'roulette-wheel-dbl-street',
    config = {
        extra = {
            odds = 37,
            Xmult = 6,
            wins = 6,
        }
    },
    pos = {x = 0, y = 1},
})
createRouletteCard('Dozen',{
    key = 'roulette-wheel-dozen',
    config = {
        extra = {
            odds = 37,
            Xmult = 3,
            wins = 12,
        }
    },
    pos = {x = 1, y = 1},
})
createRouletteCard('Red',{
    key = 'roulette-wheel-red',
    config = {
        extra = {
            odds = 37,
            Xmult = 2,
            wins = 18,
        }
    },
    pos = {x = 2, y = 1},
})
createMoneySlotsCard('Penny Slots', {
    key = 'money-slots-penny-slots',
    config = {
        extra = {
            costs = 1,
            overall_odds = 500,
            payout_1 = 20,
            odds_2 = 10,
            payout_2 = 10,
            odds_3 = 100,
            payout_3 = 3,
            odds_4 = 250,
            payout_4 = 1,
        }
    },
    pos = {x = 3, y = 1},
})
createMoneySlotsCard('Soothing Slots', {
    key = 'money-slots-soothing-slots',
    config = {
        extra = {
            costs = 5,
            overall_odds = 500,
            odds_2 = 10,
            odds_3 = 100,
            odds_4 = 250,
            payout_1 = 100,
            payout_2 = 50,
            payout_3 = 15,
            payout_4 = 5,
        }
    },
    pos = {x = 4, y = 1},
})
createMoneySlotsCard('High Roller', {
    key = 'money-slots-high-roller-slots',
    rarity = 2,
    config = {
        extra = {
            costs = 10,
            overall_odds = 500,
            odds_2 = 10,
            odds_3 = 100,
            odds_4 = 250,
            payout_1 = 200,
            payout_2 = 100,
            payout_3 = 30,
            payout_4 = 10,
        }
    },
    pos = {x = 0, y = 2},
})
----------------------------------------------
------------MOD CODE END----------------------
