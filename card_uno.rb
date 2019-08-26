class Card
    def deck_uno
        uno = { deck: [] }

        colors = ["red", "yellow","green", "blue"]
        special_cards = ["wild_draw", "draw_four"]

        colors.collect do |zero_color|
            uno[:deck].push({color: zero_color, value: 0, point: 0})
        end
        
        special_cards.collect do |special_card|
            (1..9).each do |i|
                uno[:deck].push({color: "red", value: i, point: i})
                uno[:deck].push({color: "yellow", value: i, point: i})
                uno[:deck].push({color: "green", value: i, point: i})
                uno[:deck].push({color: "blue", value: i, point: i})
            end
        
            colors.collect do |action_color|
                uno[:deck].push({color: action_color, value: "skip", point: 10})
                uno[:deck].push({color: action_color, value: "revers", point: 10})
                uno[:deck].push({color: action_color, value: "draw_two", point: 10})
                uno[:deck].push({color: "black", value: special_card, point: 50})
            end
        end
        
        return uno[:deck].shuffle
    end

    def effect_card(card)
        if(card[:value] == "skip")
            return "skip"
        elsif(card[:value] == "revers")
            return "revers"
        elsif(card[:value] == "draw_two")
            return "draw_two"
        else
            return "no_effect"
        end
    end

    def search_card(deck, search_card)
        index = 0
        result = false
        
        deck.collect do |card|
            if(card[:color] == search_card[:color] && card[:color] == search_card[:color]) 
                result = true
            end

            index += 1
        end

        return [result, index]
    end

    def find_card(deck, find_card)
        index = 0
        result = false

        deck.collect do |card|
            if(card[:color] == find_card[:color] || card[:color] == "black")
                result = true
                break
            elsif(card[:value] == find_card[:value])
                result = true
                break
            end

            index += 1
        end

        return [result, index]
    end

    def check_card(card, top_card)
        if(card[:color] == top_card[:color] || card[:value] == top_card[:value] || card[:color] == "black")
            return true
        else
            return false
        end
    end

    def check_spacial_card(top_card)
        if(top_card[:color] == "black")
            if(top_card[:value] == "Wild_draw")
                return "Wild_draw"
            elsif(top_card[:value] == "draw_four")
                return "draw_four"
            end
        else
            return false
        end
    end
end