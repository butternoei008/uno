class Card
    def deck_uno
        uno = { deck: [] }

        colors = ["red", "yellow","green", "blue"]
        special_cards = ["Wild_draw", "draw_four"]

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
                uno[:deck].push({color: action_color, value: "draw_two", point: 10})
                uno[:deck].push({color: action_color, value: "Wild", point: 10})
                uno[:deck].push({color: "black", value: special_card, point: 50})
            end
        end
        
        return uno[:deck].shuffle
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
            if(card[:color] == find_card[:color])
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
        if(card[:color] == top_card[:color] || card[:value] == top_card[:value])
            return true
        else
            return false
        end
    end
end