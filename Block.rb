require "./Box"

# Using standard graphics dimensions:
# +X direction: right
# +Y direction: up
# +Z direction: away (into screen)

class Block
  
  attr_accessor :position, :box, :front_color, :back_color, :top_color, :bottom_color, :left_color, :right_color
  
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
      front_color, right_color, back_color, left_color = right_color, back_color, left_color, front_color
    end
  end

  def faces
    f = box.faces
    return f.map {|face| face.map {|vector| vector+position}}
  end

end


def translate_faces faces, translation
  f_out = []
  faces.each do |face|
    f_out << face.map {|vertex| vertex + translation}
  end
  return f_out
end

def translate_blocks blocks, translation
  blocks.each do |block|
    block.position += translation
  end
  return blocks
end

def rotate_faces_y faces, rotation
  faces.each do |face|
    face.each do |vector|
      rotation.times do
        vector.rotate_y!
      end
    end
  end
end




