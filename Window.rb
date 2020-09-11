require "./Block.rb"

class Window

  # note: :distance_from_floor is the percent of the non-open space
  # that is below the opening vs above the opening
  # to put the opening higher up, increase :distance_from_floor

  attr_reader :width, :height, :distance_from_floor, :parent

  def initialize width, height, distance_from_floor
    self.set_width(width)
    self.set_height(height)
    self.set_distance_from_floor(distance_from_floor)
    parent = nil
  end

  def set_width width
    @width = width.clamp(0, 100).to_f
  end

  def set_height height
    @height = height.clamp(0, 100).to_f
  end

  def set_distance_from_floor distance_from_floor
    @distance_from_floor = distance_from_floor.clamp(0,100).to_f
  end

  def set_parent parent
    @parent = parent
  end

  def faces
    b = self.blocks
    return b[0].faces + b[1].faces + b[2].faces + b[3].faces
  end

  def blocks
    # create boxes for sides of window, top of window, bottom of window
    # 0,0,0 will be at the center of the left bottom corner of the left side

    # ----------
    # |  |top|  |
    # |  |---|  |
    # |s1|___|s2|
    # |  |btm|  |
    # -----------

    feature_height = parent.height
    feature_width = parent.window_width
    
    opening_width = width/100.0 * feature_width
    side_width = (1.0-width/100.0) * feature_width / 2.0
    opening_height = height/100.0 * feature_height
    bottom_height = (1.0-height/100.0) * (distance_from_floor/100.0) * feature_height
    top_height = feature_height - (opening_height + bottom_height)
    
    side_size = Vector.new(side_width, feature_height, parent.thickness)
    bottom_size = Vector.new(opening_width, bottom_height, parent.thickness)
    top_size = Vector.new(opening_width, top_height, parent.thickness)

    side1_position = Vector.new(side_size.x/2.0, side_size.y/2.0, 0)
    side2_position = side1_position + Vector.new(opening_width+side_width, 0, 0)
    bottom_position = Vector.new(feature_width/2.0, bottom_size.y/2.0, 0)
    top_position = Vector.new(feature_width/2.0, feature_height-top_size.y/2.0, 0)

    side1 = Block.new(side_size, side1_position)
    side2 = Block.new(side_size, side2_position)
    bottom = Block.new(bottom_size, bottom_position)
    top = Block.new(top_size, top_position)

    return [side1, side2, bottom, top]
  end

end