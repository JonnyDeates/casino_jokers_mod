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
SMODS.Joker{
    key = 'roulette-wheel-green', --joker key
    loc_txt = { -- local text
        name = 'Roulette Bet On Green',
        text = {
            '{C:green}#4# in #1#{} chance',
            'to {X:mult,C:white}X#3#{} Mult.',
            'Costs {C:red}-$#2#{} ',
            'to play.'
        }
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'RouletteWheel', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 2, --cost
    unlocked = true, --where it is unlocked or not: if true,
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = {
        extra = {
            odds = 38,
            dollar_cost = 1,
            Xmult= 36,
        }
    },
    loc_vars = function(self,info_queue,center)
        -- info_queue[#info_queue+1] = G.P_CENTERS.j_joker --adds "Joker"'s description next to this card's description
        return {vars = {
            center.ability.extra.odds, --#1# is replaced with card.ability.extra.odds
            center.ability.extra.dollar_cost, --#2# is replaced with card.ability.extra.chips
            center.ability.extra.Xmult, --#3# is replaced with card.ability.extra.xMulti
            "" .. (G.GAME and G.GAME.probabilities.normal or 1) --#4# is replaced with the current players probabilities
        }}
    end,
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            if math.random() < (G.GAME.probabilities.normal / card.ability.extra.odds) then
                return {
                    card = card,
                    dollars = (card.ability.extra.dollar_cost * -1),
                    Xmult_mod = card.ability.extra.Xmult,
                    message = 'X' .. card.ability.extra.Xmult,
                    colour = G.C.MULT
                }
            else
                return {
                    card = card,
                    dollars = (card.ability.extra.dollar_cost * -1),
                    colour = G.C.RED
                }
            end
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
    --calc_dollar_bonus = function(self,card)
       -- return 123
--    end,
}

SMODS.Joker{
    key = 'roulette-wheel-even', --joker key
    loc_txt = { -- local text
        name = 'Roulette Bet Even',
        text = {
            '{C:green}#4# in #1#{} chance',
            'to {X:mult,C:white}X#3#{} Mult.',
            'Costs {C:red}-$#2#{} ',
            'to play.'
        }
    },
    --[[unlock = {
        'Be {C:legendary}cool{}',
    }]]
    atlas = 'RouletteWheel', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 2, --cost
    unlocked = true, --where it is unlocked or not: if true,
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = {
        extra = {
            odds = 2,
            dollar_cost = 1,
            Xmult= 2,
        }
    },
    loc_vars = function(self,info_queue,center)
        -- info_queue[#info_queue+1] = G.P_CENTERS.j_joker --adds "Joker"'s description next to this card's description
        return {vars = {
            center.ability.extra.odds, --#1# is replaced with card.ability.extra.odds
            center.ability.extra.dollar_cost, --#2# is replaced with card.ability.extra.chips
            center.ability.extra.Xmult, --#3# is replaced with card.ability.extra.xMulti
            "" .. (G.GAME and G.GAME.probabilities.normal or 1) --#4# is replaced with the current players probabilities
        }}
    end,
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            if math.random() < (G.GAME.probabilities.normal / card.ability.extra.odds) then
                return {
                    card = card,
                    dollars = (card.ability.extra.dollar_cost * -1),
                    Xmult_mod = card.ability.extra.Xmult,
                    message = 'X' .. card.ability.extra.Xmult,
                    colour = G.C.MULT
                }
            else
                return {
                    card = card,
                    dollars = (card.ability.extra.dollar_cost * -1),
                    colour = G.C.RED
                }
            end
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
    --calc_dollar_bonus = function(self,card)
    -- return 123
    --    end,
}

SMODS.Joker{
    key = 'roulette-wheel-column', --joker key
    loc_txt = { -- local text
        name = 'Roulette Bet Column',
        text = {
            '{C:green}#4# in #1#{} chance',
            'to {X:mult,C:white}X#3#{} Mult.',
            'Costs {C:red}-$#2#{} ',
            'to play.'
        }
    },
    --[[unlock = {
        'Be {C:legendary}cool{}',
    }]]
    atlas = 'RouletteWheel', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 2, --cost
    unlocked = true, --where it is unlocked or not: if true,
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = {
        extra = {
            odds = 3,
            dollar_cost = 1,
            Xmult= 3,
        }
    },
    loc_vars = function(self,info_queue,center)
        -- info_queue[#info_queue+1] = G.P_CENTERS.j_joker --adds "Joker"'s description next to this card's description
        return {vars = {
            center.ability.extra.odds, --#1# is replaced with card.ability.extra.odds
            center.ability.extra.dollar_cost, --#2# is replaced with card.ability.extra.chips
            center.ability.extra.Xmult, --#3# is replaced with card.ability.extra.xMulti
            "" .. (G.GAME and G.GAME.probabilities.normal or 1) --#4# is replaced with the current players probabilities
        }}
    end,
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            if math.random() < (G.GAME.probabilities.normal / card.ability.extra.odds) then
                return {
                    card = card,
                    dollars = (card.ability.extra.dollar_cost * -1),
                    Xmult_mod = card.ability.extra.Xmult,
                    message = 'X' .. card.ability.extra.Xmult,
                    colour = G.C.MULT
                }
            else
                return {
                    card = card,
                    dollars = (card.ability.extra.dollar_cost * -1),
                    colour = G.C.RED
                }
            end
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
    --calc_dollar_bonus = function(self,card)
    -- return 123
    --    end,
}

SMODS.Joker{
    key = 'roulette-wheel-corner', --joker key
    loc_txt = { -- local text
        name = 'Roulette Bet Corner',
        text = {
            '{C:green}#4# in #1#{} chance',
            'to {X:mult,C:white}X#3#{} Mult.',
            'Costs {C:red}-$#2#{} ',
            'to play.'
        }
    },
    --[[unlock = {
        'Be {C:legendary}cool{}',
    }]]
    atlas = 'RouletteWheel', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 2, --cost
    unlocked = true, --where it is unlocked or not: if true,
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = {
        extra = {
            odds = 10,
            dollar_cost = 1,
            Xmult= 9,
        }
    },
    loc_vars = function(self,info_queue,center)
        -- info_queue[#info_queue+1] = G.P_CENTERS.j_joker --adds "Joker"'s description next to this card's description
        return {vars = {
            center.ability.extra.odds, --#1# is replaced with card.ability.extra.odds
            center.ability.extra.dollar_cost, --#2# is replaced with card.ability.extra.chips
            center.ability.extra.Xmult, --#3# is replaced with card.ability.extra.xMulti
            "" .. (G.GAME and G.GAME.probabilities.normal or 1) --#4# is replaced with the current players probabilities
        }}
    end,
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            if math.random() < (G.GAME.probabilities.normal / card.ability.extra.odds) then
                return {
                    card = card,
                    dollars = (card.ability.extra.dollar_cost * -1),
                    Xmult_mod = card.ability.extra.Xmult,
                    message = 'X' .. card.ability.extra.Xmult,
                    colour = G.C.MULT
                }
            else
                return {
                    card = card,
                    dollars = (card.ability.extra.dollar_cost * -1),
                    colour = G.C.RED
                }
            end
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
    --calc_dollar_bonus = function(self,card)
    -- return 123
    --    end,
}

SMODS.ConsumableType{
    key = 'DerekConsumableType', --consumable type key

    collection_rows = {4,5}, --amount of cards in one page
    primary_colour = G.C.PURPLE, --first color
    secondary_colour = G.C.DARK_EDITION, --second color
    loc_txt = {
        collection = 'Derek Cards', --name displayed in collection
        name = 'Derek', --name displayed in badge
        undiscovered = {
            name = 'Hidden Derek', --undiscovered name
            text = {'Derek is', 'not here'} --undiscovered text
        }
    },
    shop_rate = 1, --rate in shop out of 100
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
