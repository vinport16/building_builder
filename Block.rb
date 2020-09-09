require "./Box"

# Using standard graphics dimensions:
# +X direction: right
# +Y direction: up
# +Z direction: away (into screen)

class Block
  
  attr_reader :position, :box
  attr_accessor :front_color, :back_color, :top_color, :bottom_color, :left_color, :right_color
  
  def initialize(box)
    @box = box.copy
    @position = Vector.new(0,0,0)
    set_color("red")
  end

  def initialize(size, position)
    @box = Box.new(size)
    @position = position.copy
    set_color("red")
  end

  def set_color(color)
    front_color = back_color = top_color = bottom_color = left_color = right_color = color
  end

  # rotate clockwise n times
  def rotate_y!(n = 1)
    n.times do
      box.rotate_y!
      position.rotate_y!
      front_color, left_color, back_color, right_color = left_color, back_color, right_color, front_color
    end
  end

  def faces
    f = box.faces
    return f.map {|face| face.map {|vector| vector+position}}
  end

end