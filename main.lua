--- STEAMODDED HEADER
--- MOD_NAME: Casino Jokers
--- MOD_ID: CASINOJOKERS
--- MOD_AUTHOR: [jonnydeates]
--- MOD_DESCRIPTION: Jokers with casino mechanics.
--- PREFIX: cjjd
----------------------------------------------
------------MOD CODE -------------------------


SMODS.Atlas{
    key = 'RouletteWheel', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}
-- Create a helper function that builds a roulette joker card
local function createRouletteCard(params)
    -- Base template with common properties and functions
    local base = {
        atlas = 'RouletteWheel',
        rarity = 1,
        cost = 3,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,
        pos = {x = 0, y = 0},
        loc_txt = {
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

-- Now define each roulette card using the helper

createRouletteCard{
    key = 'roulette-wheel-green',
    loc_txt = {
        name = 'Single',
        text = {
            '{C:green}#4# in #1#{} chance',
            'to {X:mult,C:white}X#3#{} Mult.',
        }
    },
    config = {
        extra = {
            odds = 37,
            wins = 1,
            Xmult = 36,
        }
    },
    pos = {x = 1, y = 0},
}

createRouletteCard{
    key = 'roulette-wheel-split',
    loc_txt = {
        name = 'Split',
        text = {
            '{C:green}#4# in #1#{} chance',
            'to {X:mult,C:white}X#3#{} Mult.',
        }
    },
    config = {
        extra = {
            odds = 37,
            wins = 2,
            Xmult = 18,
        }
    },
     pos = {x = 2, y = 0},

}

createRouletteCard{
    key = 'roulette-wheel-street',
    loc_txt = {
        name = 'Street',
        text = {
            '{C:green}#4# in #1#{} chance',
            'to {X:mult,C:white}X#3#{} Mult.',
        }
    },
    config = {
        extra = {
            odds = 37,
            Xmult = 12,
            wins = 3,
        }
    },
    pos = {x = 3, y = 0},
}

createRouletteCard{
    key = 'roulette-wheel-corner',
    loc_txt = {
        name = 'Corner',
        text = {
            '{C:green}#4# in #1#{} chance',
            'to {X:mult,C:white}X#3#{} Mult.',
        }
    },
    config = {
        extra = {
            odds = 37,
            Xmult = 9,
            wins = 4,
        }
    },
    pos = {x = 4, y = 0},
}
createRouletteCard{
    key = 'roulette-wheel-dbl-street',
    loc_txt = {
        name = 'Double Street',
        text = {
            '{C:green}#4# in #1#{} chance',
            'to {X:mult,C:white}X#3#{} Mult.',
        }
    },
    config = {
        extra = {
            odds = 37,
            Xmult = 6,
            wins = 6,
        }
    },
    pos = {x = 0, y = 1},
}
createRouletteCard{
    key = 'roulette-wheel-dozen',
    loc_txt = {
        name = 'Dozen',
        text = {
            '{C:green}#4# in #1#{} chance',
            'to {X:mult,C:white}X#3#{} Mult.',
        }
    },
    config = {
        extra = {
            odds = 37,
            Xmult = 3,
            wins = 12,
        }
    },
    pos = {x = 1, y = 1},
}
createRouletteCard{
    key = 'roulette-wheel-red',
    loc_txt = {
        name = 'Red',
        text = {
            '{C:green}#4# in #1#{} chance',
            'to {X:mult,C:white}X#3#{} Mult.',
        }
    },
    config = {
        extra = {
            odds = 37,
            Xmult = 2,
            wins = 18,
        }
    },
    pos = {x = 2, y = 1},
}
-- The consumable type can remain as is (or be similarly refactored if more types share common behavior)
SMODS.ConsumableType{
    key = 'DerekConsumableType',
    collection_rows = {4,5},
    primary_colour = G.C.PURPLE,
    secondary_colour = G.C.DARK_EDITION,
    loc_txt = {
        collection = 'Derek Cards',
        name = 'Derek',
        undiscovered = {
            name = 'Hidden Derek',
            text = {'Derek is', 'not here'}
        }
    },
    shop_rate = 1,
}



SMODS.UndiscoveredSprite{
    key = 'DerekConsumableType', --must be the same key as the consumabletype
    atlas = 'Jokers',
    pos = {x = 0, y = 0}
}


SMODS.Consumable{
    key = 'Derek', --key
    set = 'DerekConsumableType', --the set of the card: corresponds to a consumable type
    atlas = 'Jokers', --atlas
    pos = {x = 0, y = 0}, --position in atlas
    loc_txt = {
        name = 'Derek Consumable', --name of card
        text = { --text of card
            'Add Negative to up to #1# selected cards',
            'and create a Derek consumable'
        }
    },
    config = {
        extra = {
            cards = 5, --configurable value
        }
    },
    loc_vars = function(self,info_queue, center)
        return {vars = {center.ability.extra.cards}} --displays configurable value: the #1# in the description is replaced with the configurable value
    end,
    can_use = function(self,card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.cards then --if cards in hand highlighted are above 0 but below the configurable value then
                return true
            end
        end
        return false
    end,
    use = function(self,card,area,copier)
        for i = 1, #G.hand.highlighted do
            --for every card in hand highlighted

            G.hand.highlighted[i]:set_edition({negative = true},true)
            --set their edition to negative
        end

        local newcard = create_card('DerekConsumableType', G.consumeables) --create a derek consumable
        newcard:add_to_deck() --add it to deck
        G.consumeables:emplace(newcard) --place it into G.consumeables

    end,
}



----------------------------------------------
------------MOD CODE END----------------------
