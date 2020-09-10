require "./Block"

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
    # 0,0,0 will be at the front left bottom corner of the left side

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

    side1_position = Vector.new(side_size.x/2.0, side_size.y/2.0, side_size.z/2.0)
    side2_position = side1_position + Vector.new(opening_width+side_width, 0, 0)
    bottom_position = Vector.new(feature_width/2.0, bottom_size.y/2.0, bottom_size.z/2.0)
    top_position = Vector.new(feature_width/2.0, feature_height-top_size.y/2.0 ,top_size.z/2.0)

    side1 = Block.new(side_size, side1_position)
    side2 = Block.new(side_size, side2_position)
    bottom = Block.new(bottom_size, bottom_position)
    top = Block.new(top_size, top_position)

    return [side1, side2, bottom, top]
  end

end

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
    # 0,0,0 will be at the front left bottom corner of the left side

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

    side1_position = Vector.new(side_size.x/2.0, side_size.y/2.0, side_size.z/2.0)
    side2_position = side1_position + Vector.new(door_width+door_side_width, 0, 0)
    top_position = Vector.new(feature_width/2.0, feature_height-top_size.y/2.0 ,top_size.z/2.0)

    side1 = Block.new(side_size, side1_position)
    side2 = Block.new(side_size, side2_position)
    top = Block.new(top_size, top_position)

    return [side1, side2, top]
  end
end

class Facade
  attr_reader :features, :parent
  attr_accessor :door_width_component, :window_width_component, :height, :width, :thickness

  def initialize height, width, thickness, features
    @height = height.to_f
    @width = width.to_f
    @thickness = thickness.to_f
    set_features(features)
    @parent = nil
    @door_width_component = 1.0
    @window_width_component = 1.0
  end

  def set_features features
    features.each do |feature|
      feature.set_parent self
    end
    @features = features
  end

  def set_parent parent
    @parent = parent
  end

  def width_components
    return features.map {|feature| feature.class == Window ? window_width_component : door_width_component }
  end

  def door_width
    return door_width_component/width_components.sum * (width - 2 * thickness)
  end

  def window_width
    return window_width_component/width_components.sum * (width - 2 * thickness)
  end

  def left_corner_block
    size = Vector.new(thickness,height,thickness)
    return Block.new(size, Vector.new(size.x/2, size.y/2, size.z/2))
  end

  def blocks
    width_per_component_unit = (width - 2 * thickness) / width_components.sum
    b = []
    for idx in 0...features.length
      feature = features[idx]
      x_translation = width_per_component_unit * width_components[0...idx].sum + thickness
      b += translate_blocks(feature.blocks, Vector.new(x_translation, 0, 0))
    end

    b << left_corner_block

    return b
  end

  def faces
    width_per_component_unit = (width - 2 * thickness) / width_components.sum
    f = []
    for idx in 0...features.length
      feature = features[idx]
      x_translation = width_per_component_unit * width_components[0...idx].sum + thickness
      f += translate_faces(feature.faces, Vector.new(x_translation, 0, 0))
    end

    f += left_corner_block.faces

    return f
  end
end