class Graphic
    def show_image()
        Image.new(
            'img/card_black_draw_four.png',
            x: 400, y: 200,
            width: 50, height: 25,
            color: [1.0, 0.5, 0.2, 1.0],
            rotate: 90,
            z: 10
        )
    end
end