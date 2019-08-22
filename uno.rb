require_relative "card_uno.rb"

class Player < Card
    def num_of_player
        loop do 
            print "Number of players 2-4: "
            num = gets.chomp().to_i

            if(num > 1 && num < 5)
                return num
                break
            else
                puts "Enter numbers 2-4 only!"
            end
        end
    end

    def random_turn(num_of_player)
        player_list = ["Player", "Butter", "Fat", "Cheese"]
        turn_order = []

        (0..num_of_player - 1).each do |i|
            turn_order.push(player_list[i])
        end

        return turn_order.shuffle
    end
end

class Game < Player
    def initialize
        @num_of_player = self.num_of_player
        @deck_uno = self.deck_uno
        @top_card = []

        @deck_players = []
        @my_deck = []
        @turn_label = self.random_turn(@num_of_player)
    end

    def dealt_cards
        all_deck = Array.new(@num_of_player, [])

        for i in 1..(7 * @num_of_player)
            all_deck[i % @num_of_player] += [@deck_uno.pop()]
        end
        
        return all_deck
    end

    def set_deck
        decks = dealt_cards
        players = @turn_label

        deck_players = []

        i = 0
        players.map do |player|
            deck_players.push({player: player, deck: decks[i]})
            i += 1
        end

        @deck_players = deck_players
    end

    def set_my_deck
        find_my_deck = @deck_players.map do |deck_player|
            if (deck_player[:player] == "Player")
                @my_deck = deck_player
            end
        end
    end

    def show_card(cards)
        puts "\nCard in your deck: "

        i = 0
        cards[:deck].map do |card| 
            puts "[#{i += 1}]color: #{card[:color]} | value: #{card[:value]}"
        end
    end

    def monitor
        on_top = @top_card

        puts "\n============================================================"
        puts "\nCard on top[ color: #{on_top[:color]} | value: #{on_top[:value]} ]\n\n"

        (0..@num_of_player - 1).each do |i|
            puts "#{i + 1}. #{@turn_label[i]}: #{@deck_players[i][:deck].length}"
        end

        show_card(@my_deck)
    end
    
    def choose_card(deck)
        limit_deck = deck.length
        can_draw = true
        pass = false

        loop do
            puts can_draw == true ? "\n[d]Draw card" : nil
            print "Choose card from your deck: "
            select_card = gets.chomp

            int_card = select_card.to_i

            if(can_draw == true && select_card == "d" || select_card == "D")
                draw = draw_card()

                puts "Your draw: [ color: #{draw[:color]} | value #{draw[:value]}]"
                @my_deck[:deck].push(draw)

                monitor()
                limit_deck = @my_deck[:deck].length
                can_draw = false

                if(draw[:color] == @top_card[:color] || draw[:value] == @top_card[:value])
                    print "\n[p]Pass"
                    pass = true
                else
                    return [deck, "pass"]
                    break
                end
            elsif(pass == true && select_card == "p" || select_card == "P")
                return [deck, "pass"]
                break
            elsif(int_card > 0 && int_card <= limit_deck)
                
                int_card -= 1

                if(check_card(deck[int_card], @top_card))
                    @top_card = deck.delete_at(int_card)
                    return [deck, true]
                    break
                else
                    puts "Card does not match!" 
                end
            else
                puts "Can't select a card. Select no more than #{limit_deck} !!!"
            end
           
        end
    end

    def bot_choose_card(turn_switch)
        deck = @deck_players[turn_switch][:deck]
        name = @turn_label[turn_switch]

        fnd_crd = find_card(deck, @top_card)

        if(fnd_crd[0] == true)
            @top_card = @deck_players[turn_switch][:deck].delete_at(fnd_crd[1])
            puts "#{name}: choose[ color: #{@top_card[:color]} | value: #{@top_card[:value]}]"
        else
            puts "#{name}: no card!"
        end
    end

    def generate_deck_uno
        if(@deck_uno.length == 0)
            @deck_uno = self.deck_uno
            find_card = search_card(@deck_uno, @top_card)

            @deck_uno.delete_at(find_card[1])
        end
    end

    def draw_card
        generate_deck_uno()
        return @deck_uno.pop()
    end

    def turn_player
        require "io/console"

        turn_switch = 0
        revers = false

        loop do
            monitor()
            turn_switch %= @num_of_player
            skip = false

            puts "#{turn_switch + 1}.: #{@turn_label[turn_switch]}"

            if(@turn_label[turn_switch] == "Player")
                find_card = find_card(@my_deck[:deck], @top_card)
                
                if(find_card[0] == true)
                    new_deck = choose_card(@my_deck[:deck])

                    if(new_deck[1] == "pass") 
                        puts "Player: Pass!"
                        skip == true
                    end

                    if(new_deck[1] == true)
                        @my_deck[:deck] = new_deck[0]
                    elsif(new_deck[1] == "skip")
                        skip = true
                    elsif(new_deck[1] == false)
                        puts "Card dose not match!"
                    end
                else
                    draw_card = draw_card()
                    @my_deck[:deck].push(draw_card)

                    puts "You draw: [ color: #{draw_card[:color]} value: #{draw_card[:value]} ]"

                    skip == true
                    STDIN.getc
                end
            else
                bot_choose_card(turn_switch)
                STDIN.getc
            end

            revers == false ? turn_switch += 1: turn_switch -= 1
            skip == true ? next : skip == false
        end
    end
    
    def play
        @top_card = @deck_uno.pop()

        set_deck()
        set_my_deck()
        turn_player()
    end
end

uno = Game.new()
uno.play