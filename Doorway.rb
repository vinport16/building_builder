require "./Block"

class Doorway
  attr_reader :width, :height, :parent

  def initialize width, height
    self.set_width(width)
    self.set_height(height)
    parent = nil
  end

  def set_width width
    @width = width.clamp(0, 100).to_f
  end

  def set_height height
    @height = height.clamp(0, 100).to_f
  end

  def set_parent parent
    @parent = parent
  end

  def faces
    b = self.blocks
    return b[0].faces + b[1].faces + b[2].faces
  end

  def blocks
    # create boxes for sides of doorway, top of doorway
    # 0,0,0 will be at the center of the left bottom corner of the left side

    # ----------
    # |  top   |
    # ----------
    # |s1|  |s2|
    # |  |  |  |
    # ----  ----

    feature_height = parent.height
    feature_width = parent.door_width
    
    door_width = width/100.0 * feature_width
    door_side_width = (1.0-width/100.0) * feature_width / 2.0
    door_height = height/100.0 * feature_height
    space_above_height = (1.0-height/100.0) * feature_height
    
    side_size = Vector.new(door_side_width, door_height, parent.thickness)
    top_size = Vector.new(feature_width,space_above_height, parent.thickness)

    side1_position = Vector.new(side_size.x/2.0, side_size.y/2.0, 0)
    side2_position = side1_position + Vector.new(door_width+door_side_width, 0, 0)
    top_position = Vector.new(feature_width/2.0, feature_height-top_size.y/2.0 ,0)

    side1 = Block.new(side_size, side1_position)
    side2 = Block.new(side_size, side2_position)
    top = Block.new(top_size, top_position)

    return [side1, side2, top]
  end
end