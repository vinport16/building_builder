require "./Block"

class Window
  attr_reader :width, :height, :distance_from_floor, :parent

  def initialize width, height, distance_from_floor
    self.set_width(width)
    self.set_height(height)
    self.set_distance_from_floor(distance_from_floor)
    parent = null
  end

  def set_width width
    @width = width.clamp(0, 100)
  end

  def set_height height
    @height = height.clamp(0, 100)
  end

  def set_distance_from_floor distance_from_floor
    @distance_from_floor = distance_from_floor.clamp(0,100)
  end

  def set_parent parent
    @parent = parent
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
    @width = width.clamp(0, 100)
  end

  def set_height height
    @height = height.clamp(0, 100)
  end

  def set_parent parent
    @parent = parent
  end

  def faces
    # create boxes for sides of doorway, top of doorway
    # then return the union of their visible faces
    # 0,0,0 will be at the front left bottom corner of the left side of the door

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

    return side1.faces + side2.faces + top.faces
  end
end

class Facade
  attr_reader :features, :parent
  attr_accessor :door_width_component, :window_width_component, :height, :width, :thickness

  def initialize height, width, thickness, features
    @height = height
    @width = width
    @thickness = thickness
    set_features(features)
    @parent = nil
    @door_width_component = 1
    @window_width_component = 1
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

  def sum_of_width_components
    return features.map {|feature| feature.class == Window ? window_width_component : door_width_component }.sum
  end

  def door_width
    return door_width_component/sum_of_width_components * width
  end

  def window_width
    return window_width_component/sum_of_width_components * width
  end

  def faces
    f = []
    features.each do |feature|
      f = f + feature.faces
    end
    return f
  end
end