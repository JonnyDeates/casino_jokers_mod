--- STEAMODDED HEADER
--- MOD_NAME: Casino Jokers
--- MOD_ID: CASINOJOKERS
--- MOD_AUTHOR: [jonnydeates]
--- MOD_DESCRIPTION: Jokers with casino mechanics.
--- PREFIX: cjjd
----------------------------------------------
------------MOD CODE -------------------------
function SMODS.INIT.CasinoMods()
    sendDebugMessage("Loaded CasinoMods")
end
SMODS.Atlas {
    key = 'CasinoMods', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

function shallowCopyInto(original, copyFromBase)
    for k, v in pairs(copyFromBase) do
        original[k] = v
    end
    return original
end
local Rarity = {
    Common = 1,
    Uncommon = 2,
    Rare = 3,
    Legendary = 4
}
local function baseCard(name, column, row, params, cardAttributes)
    local base = {
        atlas = 'CasinoMods',
        key = 'roulette-wheel-' .. string.lower(name):gsub(' ', '-'),
        rarity = Rarity.Common,
        cost = 3,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,
        pos = { x = column, y = row },
        in_pool = function(self, _, _)
            return true
        end,
    }
    -- Merge the custom parameters into the base table
    shallowCopyInto(base, cardAttributes)
    shallowCopyInto(base, params)

    SMODS.Joker(base)
end

-- Create a helper function that builds a roulette joker card
local function createRouletteCard(name, column, row, params)
    baseCard(name, column, row, params, {
        loc_txt = {
            name = name,
            text = {
                'Every played high card has a',
                'chance of {C:green}#4# in #1#{} to double',
                'its to {X:mult,C:white}X#3#{} Mult.',
            }
        },
        loc_vars = function(self, info_queue, center)
            return {
                vars = {
                    center.ability.extra.odds, -- #1#: odds
                    center.ability.extra.wins, -- #1#: odds
                    center.ability.extra.Xmult, -- #3#: multiplier
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
        end
    })
end
local function createMoneySlotsCard(name, column, row, params)
    baseCard(name, column, row, params, {
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
                    center.ability.extra.costs, -- #1#: costs
                    center.ability.extra.overall_odds, -- 2#: overall_odds
                    center.ability.extra.payout_1, -- 3#: odds
                    "" .. (G.GAME and G.GAME.probabilities.normal or 1), -- #4#: player's probability
                    center.ability.extra.odds_2, -- #5#: odds
                    center.ability.extra.payout_2, -- #6#: payout
                    "" .. (G.GAME and G.GAME.probabilities.normal * center.ability.extra.odds_2 or 1), -- #7#: player's probability
                    center.ability.extra.odds_3, -- #8#: odds
                    center.ability.extra.payout_3, -- #9#: payout
                    "" .. (G.GAME and G.GAME.probabilities.normal * center.ability.extra.odds_3 or 1), -- #10#: player's probability
                    center.ability.extra.odds_4, -- #11#: odds
                    center.ability.extra.payout_4, -- #12#: payout
                    "" .. (G.GAME and G.GAME.probabilities.normal * center.ability.extra.odds_4 or 1), -- #13#: player's probability
                }
            }
        end,
        calculate = function(self, card, context)
            if context.end_of_round then
                local gameProbability = G.GAME.probabilities.normal
                local odds = card.ability.extra.overall_odds
                local random = math.random()
                local costs = (card.ability.extra.costs * -1)
                if random < (gameProbability / odds) then
                    return {
                        card = card,
                        dollars = costs + card.ability.extra.payout_1,
                        message = '+' .. card.ability.extra.payout_1,
                        colour = G.C.Money
                    }
                elseif random < ((card.ability.extra.odds_2 * gameProbability) / odds) then
                    return {
                        card = card,
                        dollars = costs + card.ability.extra.payout_2,
                        message = '+' .. card.ability.extra.payout_2,
                        colour = G.C.Money
                    }
                elseif random < ((card.ability.extra.odds_3 * gameProbability) / odds) then
                    return {
                        card = card,
                        dollars = costs + card.ability.extra.payout_3,
                        message = '+' .. card.ability.extra.payout_3,
                        colour = G.C.Money
                    }
                elseif random < ((card.ability.extra.odds_4 * gameProbability) / odds) then
                    return {
                        card = card,
                        dollars = costs + card.ability.extra.payout_4,
                        message = '+' .. card.ability.extra.payout_4,
                        colour = G.C.Money
                    }
                else
                    return {
                        card = card,
                        dollars = costs,
                        message = '-' .. card.ability.extra.costs,
                        colour = G.C.Red
                    }
                end
            end
        end
    })
end

local function createChipSlotsCard(name, column, row, params)
    baseCard(name, column, row, params, {
        loc_txt = {
            name = name,
            text = {
                'Every hand there is a chance',
                'to win on of the following:',
                '{C:green}#3# in #1#{} chance for {C:chips}#2# chips{}',
                '{C:green}#6# in #1#{} chance for {C:chips}#5# chips{}',
                '{C:green}#9# in #1#{} chance for {C:chips}#8# chips{}',
                '{C:green}#12# in #1#{} chance for {C:chips}#11# chips{}',
            }
        },
        loc_vars = function(self, info_queue, center)
            return {
                vars = {
                    center.ability.extra.overall_odds, -- 2#: overall_odds
                    center.ability.extra.payout_1, -- 3#: odds
                    "" .. (G.GAME and G.GAME.probabilities.normal or 1), -- #4#: player's probability
                    center.ability.extra.odds_2, -- #5#: odds
                    center.ability.extra.payout_2, -- #6#: payout
                    "" .. (G.GAME and G.GAME.probabilities.normal * center.ability.extra.odds_2 or 1), -- #7#: player's probability
                    center.ability.extra.odds_3, -- #8#: odds
                    center.ability.extra.payout_3, -- #9#: payout
                    "" .. (G.GAME and G.GAME.probabilities.normal * center.ability.extra.odds_3 or 1), -- #10#: player's probability
                    center.ability.extra.odds_4, -- #11#: odds
                    center.ability.extra.payout_4, -- #12#: payout
                    "" .. (G.GAME and G.GAME.probabilities.normal * center.ability.extra.odds_4 or 1), -- #13#: player's probability
                }
            }
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                local gameProbability = G.GAME.probabilities.normal
                local odds = card.ability.extra.overall_odds
                local random = math.random()
                if random < (gameProbability / odds) then
                    return {
                        card = card,
                        chips_mod = card.ability.extra.payout_1,
                        message = '+' .. card.ability.extra.payout_1,
                        colour = G.C.Chip
                    }
                elseif random < ((card.ability.extra.odds_2 * gameProbability) / odds) then
                    return {
                        card = card,
                        chips_mod = card.ability.extra.payout_2,
                        message = '+' .. card.ability.extra.payout_2,
                        colour = G.C.Chip
                    }
                elseif random < ((card.ability.extra.odds_3 * gameProbability) / odds) then
                    return {
                        card = card,
                        chips_mod = card.ability.extra.payout_3,
                        message = '+' .. card.ability.extra.payout_3,
                        colour = G.C.Chip
                    }
                elseif random < ((card.ability.extra.odds_4 * gameProbability) / odds) then
                    return {
                        card = card,
                        chips_mod = card.ability.extra.payout_4,
                        message = '+' .. card.ability.extra.payout_4,
                        colour = G.C.Chip
                    }
                end
            end
        end,
    })
end
local function createMultiSlotsCard(name, column, row, params)
    baseCard(name, column, row, params, {
        loc_txt = {
            name = name,
            text = {
                'Every hand there is a chance',
                'to win on of the following:',
                '{C:green}#3# in #1#{} chance for {X:mult,C:white}+#2# mult{}',
                '{C:green}#6# in #1#{} chance for {X:mult,C:white}+#5# mult{}',
                '{C:green}#9# in #1#{} chance for {X:mult,C:white}+#8# mult{}',
                '{C:green}#12# in #1#{} chance for {X:mult,C:white}+#11# mult{}',
            }
        },
        loc_vars = function(self, info_queue, center)
            return {
                vars = {
                    center.ability.extra.overall_odds, -- 2#: overall_odds
                    center.ability.extra.payout_1, -- 3#: odds
                    "" .. (G.GAME and G.GAME.probabilities.normal or 1), -- #4#: player's probability
                    center.ability.extra.odds_2, -- #5#: odds
                    center.ability.extra.payout_2, -- #6#: payout
                    "" .. (G.GAME and G.GAME.probabilities.normal * center.ability.extra.odds_2 or 1), -- #7#: player's probability
                    center.ability.extra.odds_3, -- #8#: odds
                    center.ability.extra.payout_3, -- #9#: payout
                    "" .. (G.GAME and G.GAME.probabilities.normal * center.ability.extra.odds_3 or 1), -- #10#: player's probability
                    center.ability.extra.odds_4, -- #11#: odds
                    center.ability.extra.payout_4, -- #12#: payout
                    "" .. (G.GAME and G.GAME.probabilities.normal * center.ability.extra.odds_4 or 1), -- #13#: player's probability
                }
            }
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                local gameProbability = G.GAME.probabilities.normal
                local odds = card.ability.extra.overall_odds
                local random = math.random()
                if random < (gameProbability / odds) then
                    return {
                        card = card,
                        mult_mod = card.ability.extra.payout_1,
                        message = '+' .. card.ability.extra.payout_1,
                        colour = G.C.MULT
                    }
                elseif random < ((card.ability.extra.odds_2 * gameProbability) / odds) then
                    return {
                        card = card,
                        mult_mod = card.ability.extra.payout_2,
                        message = '+' .. card.ability.extra.payout_2,
                        colour = G.C.MULT
                    }
                elseif random < ((card.ability.extra.odds_3 * gameProbability) / odds) then
                    return {
                        card = card,
                        mult_mod = card.ability.extra.payout_3,
                        message = '+' .. card.ability.extra.payout_3,
                        colour = G.C.MULT
                    }
                elseif random < ((card.ability.extra.odds_4 * gameProbability) / odds) then
                    return {
                        card = card,
                        mult_mod = card.ability.extra.payout_4,
                        message = '+' .. card.ability.extra.payout_4,
                        colour = G.C.MULT
                    }
                end
            end
        end,
    })
end
local function createMultiTimesSlotsCard(name, column, row, params)
    baseCard(name, column, row, params, {
        loc_txt = {
            name = name,
            text = {
                'Every hand there is a chance',
                'to win on of the following:',
                '{C:green}#3# in #1#{} chance for {X:mult,C:white}x#2#{}',
                '{C:green}#6# in #1#{} chance for {X:mult,C:white}x#5#{}',
                '{C:green}#9# in #1#{} chance for {X:mult,C:white}x#8#{}',
                '{C:green}#12# in #1#{} chance for {X:mult,C:white}x#11#{}',
            }
        },
        loc_vars = function(self, info_queue, center)
            return {
                vars = {
                    center.ability.extra.overall_odds, -- 2#: overall_odds
                    center.ability.extra.payout_1, -- 3#: odds
                    "" .. (G.GAME and G.GAME.probabilities.normal or 1), -- #4#: player's probability
                    center.ability.extra.odds_2, -- #5#: odds
                    center.ability.extra.payout_2, -- #6#: payout
                    "" .. (G.GAME and G.GAME.probabilities.normal * center.ability.extra.odds_2 or 1), -- #7#: player's probability
                    center.ability.extra.odds_3, -- #8#: odds
                    center.ability.extra.payout_3, -- #9#: payout
                    "" .. (G.GAME and G.GAME.probabilities.normal * center.ability.extra.odds_3 or 1), -- #10#: player's probability
                    center.ability.extra.odds_4, -- #11#: odds
                    center.ability.extra.payout_4, -- #12#: payout
                    "" .. (G.GAME and G.GAME.probabilities.normal * center.ability.extra.odds_4 or 1), -- #13#: player's probability
                }
            }
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                local gameProbability = G.GAME.probabilities.normal
                local odds = card.ability.extra.overall_odds
                local random = math.random()
                if random < (gameProbability / odds) then
                    return {
                        card = card,
                        Xmult_mod = card.ability.extra.payout_1,
                        message = 'x' .. card.ability.extra.payout_1,
                        colour = G.C.MULT
                    }
                elseif random < ((card.ability.extra.odds_2 * gameProbability) / odds) then
                    return {
                        card = card,
                        Xmult_mod = card.ability.extra.payout_2,
                        message = 'x' .. card.ability.extra.payout_2,
                        colour = G.C.MULT
                    }
                elseif random < ((card.ability.extra.odds_3 * gameProbability) / odds) then
                    return {
                        card = card,
                        Xmult_mod = card.ability.extra.payout_3,
                        message = 'x' .. card.ability.extra.payout_3,
                        colour = G.C.MULT
                    }
                elseif random < ((card.ability.extra.odds_4 * gameProbability) / odds) then
                    return {
                        card = card,
                        Xmult_mod = card.ability.extra.payout_4,
                        message = 'x' .. card.ability.extra.payout_4,
                        colour = G.C.MULT
                    }
                end
            end
        end,
    })
end
-- Increases Game Probability Multiplier by x3
baseCard('Oops! All 12s', 0, 0, {}, {
    rarity = Rarity.Rare,
    blueprint_compat = false,
    ability = {
        name = "Oops! All 12s"
    },
    loc_txt = {
        name = 'Oops! All 12s',
        text = {
            'Quadruples all {C:attention}listed{} \n',
            '{C:green}probabilities{}',
            '(ex: {C:green}1 in 4{} -> {C:green}4 in 4{})',
        }
    },
})

local add_to_deckref = Card.add_to_deck
function Card.add_to_deck(self, from_debuff)
    if not self.added_to_deck then
        if self.ability.name == 'j_roulette-wheel-oops!-all-12s' then
            for k, v in pairs(G.GAME.probabilities) do
                G.GAME.probabilities[k] = v * 4
            end
        end
    end
    add_to_deckref(self, from_debuff)
end

local remove_from_deckref = Card.remove_from_deck
function Card.remove_from_deck(self, from_debuff)
    if self.added_to_deck then
        if self.ability.name == 'j_roulette-wheel-oops!-all-12s' then
            for k, v in pairs(G.GAME.probabilities) do
                G.GAME.probabilities[k] = v / 4
            end
        end
    end
    remove_from_deckref(self, from_debuff)
end

baseCard('Single', 1, 0, {}, {
    rarity = Rarity.Rare,
    ability = {
        name = "Single! All on 00"
    },
    loc_txt = {
        name = "Single! All on 00",
        text = {
            'Every hand played with only',
            '1 Card has a chance of {C:green}#1#/#2#{} to',
            'increase current multiplier by {X:mult,C:white}x#3#{}',
            '(Current Multiplier {X:mult,C:white}x#4#{})',
        }
    },
    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                "" .. (G.GAME and G.GAME.probabilities.normal or 1),
                center.ability.extra.odds,
                center.ability.extra.multiplier,
                center.ability.extra.current_odds_multiplier,
            }
        }
    end,
    config = {
        extra = {
            odds = 37,
            multiplier = 36,
            current_odds_multiplier = 1
        }
    },
    calculate = function(self, card, context)
        if context.joker_main then
            local gameProbability = G.GAME.probabilities.normal
            local odds = card.ability.extra.odds
            local random = math.random()
            if #context.full_hand == 1 and random < (gameProbability / odds) then
                card.ability.extra.current_odds_multiplier = card.ability.extra.current_odds_multiplier + card.ability.extra.multiplier
            end
            return {
                card = card,
                Xmult_mod = card.ability.extra.current_odds_multiplier,
                message = 'x' .. card.ability.extra.current_odds_multiplier,
                colour = G.C.MULT
            }
        end
    end,
})
baseCard('Split', 2, 0, {}, {
    rarity = Rarity.Common,
    ability = {
        name = "Split!"
    },
    loc_txt = {
        name = "Split!",
        text = {
            'Every hand played with a pair',
            'has a chance of {C:green}#1#/#2#{} to',
            'increase chips by {C:chips}+#3#{}',
            '(Current Chips {C:chips}+#4#{})',
        }
    },
    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                "" .. (G.GAME and (G.GAME.probabilities.normal * 2 or 1 * 2)),
                center.ability.extra.odds,
                center.ability.extra.chips,
                center.ability.extra.current_chips,
            }
        }
    end,
    config = {
        extra = {
            odds = 37,
            chips = 18,
            current_chips = 0
        }
    },
    calculate = function(self, card, context)
        if context.joker_main then
            local gameProbability = G.GAME.probabilities.normal * 2
            local odds = card.ability.extra.odds
            local random = math.random()
            local text, disp_text, poker_hands, scoring_hand, non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)

            if random < (gameProbability / odds) then
                local hands = { "Pair", "Three of a Kind", "Two Pair", "Four of a Kind", "Flush Five", "Five of a Kind", "Full House" }

                for _, value in ipairs(hands) do
                    if non_loc_disp_text == value then
                        card.ability.extra.current_chips = card.ability.extra.current_chips + card.ability.extra.chips
                    end
                end
            end
            return {
                card = card,
                chips = card.ability.extra.current_chips,
                colour = G.C.Chips
            }
        end
    end,
})
createRouletteCard('Street', 3, 0, {
    config = {
        extra = {
            odds = 37,
            Xmult = 12,
            wins = 3,
        }
    },
})

createRouletteCard('Corner', 4, 0, {
    config = {
        extra = {
            odds = 37,
            Xmult = 9,
            wins = 4,
        }
    },
})
createRouletteCard('Double Street', 0, 1, {
    config = {
        extra = {
            odds = 37,
            Xmult = 6,
            wins = 6,
        }
    },
})
createRouletteCard('Dozen', 1, 1, {
    config = {
        extra = {
            odds = 37,
            Xmult = 3,
            wins = 12,
        }
    },
})
createRouletteCard('Red', 2, 1, {
    config = {
        extra = {
            odds = 37,
            Xmult = 2,
            wins = 18,
        }
    },
})
createMoneySlotsCard('Penny Slots', 3, 1, {
    cost = 3,
    config = {
        extra = {
            costs = 1,
            overall_odds = 777,
            payout_1 = 20,
            odds_2 = 10,
            payout_2 = 10,
            odds_3 = 100,
            payout_3 = 3,
            odds_4 = 250,
            payout_4 = 1,
        }
    },
    pos = { x = 3, y = 1 },
})
createMoneySlotsCard('Soothing Slots', 4, 1, {
    cost = 5,
    config = {
        extra = {
            costs = 5,
            overall_odds = 777,
            odds_2 = 10,
            odds_3 = 100,
            odds_4 = 250,
            payout_1 = 100,
            payout_2 = 50,
            payout_3 = 15,
            payout_4 = 5,
        }
    },
})
createMoneySlotsCard('High Roller', 0, 2, {
    rarity = 2,
    cost = 6,
    config = {
        extra = {
            costs = 10,
            overall_odds = 777,
            odds_2 = 10,
            odds_3 = 100,
            odds_4 = 300,
            payout_1 = 200,
            payout_2 = 100,
            payout_3 = 30,
            payout_4 = 10,
        }
    },
})
createChipSlotsCard('Chip Seeker', 1, 2, {
    cost = 3,
    config = {
        extra = {
            overall_odds = 777,
            odds_2 = 10,
            odds_3 = 100,
            odds_4 = 300,
            payout_1 = 150,
            payout_2 = 50,
            payout_3 = 10,
            payout_4 = 5,
        }
    },
})
createChipSlotsCard('Chip Finder', 2, 2, {
    cost = 5,
    config = {
        extra = {
            overall_odds = 777,
            odds_2 = 10,
            odds_3 = 100,
            odds_4 = 300,
            payout_1 = 500,
            payout_2 = 250,
            payout_3 = 100,
            payout_4 = 50,
        }
    },
})
createChipSlotsCard('Chip Collector', 3, 2, {
    rarity = Rarity.Uncommon,
    cost = 7,
    config = {
        extra = {
            overall_odds = 777,
            odds_2 = 10,
            odds_3 = 100,
            odds_4 = 300,
            payout_1 = 1500,
            payout_2 = 1000,
            payout_3 = 500,
            payout_4 = 200,
        }
    },
})
createMultiSlotsCard('Any Multi Plz', 1, 3, {
    cost = 3,
    config = {
        extra = {
            overall_odds = 777,
            odds_2 = 10,
            odds_3 = 100,
            odds_4 = 250,
            payout_1 = 30,
            payout_2 = 15,
            payout_3 = 5,
            payout_4 = 1,
        }
    },
})
createMultiSlotsCard('Multi Maxer', 0, 3, {
    cost = 5,
    rarity = Rarity.Uncommon,
    config = {
        extra = {
            overall_odds = 777,
            odds_2 = 10,
            odds_3 = 100,
            odds_4 = 250,
            payout_1 = 200,
            payout_2 = 100,
            payout_3 = 20,
            payout_4 = 10,
        }
    },
})

createMultiTimesSlotsCard('Multiplier', 4, 2, {
    cost = 7,
    rarity = Rarity.Uncommon,
    config = {
        extra = {
            overall_odds = 777,
            odds_2 = 10,
            odds_3 = 100,
            odds_4 = 250,
            payout_1 = 50,
            payout_2 = 10,
            payout_3 = 3,
            payout_4 = 1.5,
        }
    },
})
----------------------------------------------
------------MOD CODE END----------------------
