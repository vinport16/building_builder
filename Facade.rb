require "./Window"
require "./Doorway"

class Facade

  # a Facade consists of:
  # - a left side corner peice horizontally centered at the origin (x = z = 0)
  # - a row of features aligned with the corner peice
  # the :width is the combined width of the features
  # the actual width is :width + :thickness (corner peice is :thickness wide)

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
    return door_width_component/width_components.sum * width 
  end

  def window_width
    return window_width_component/width_components.sum * width
  end

  def left_corner_block
    size = Vector.new(thickness,height,thickness)
    return Block.new(size, Vector.new(0, size.y/2, 0))
  end

  def blocks
    width_per_component_unit = width / width_components.sum
    b = []
    for idx in 0...features.length
      feature = features[idx]
      x_translation = width_per_component_unit * width_components[0...idx].sum + thickness/2.0
      b += translate_blocks(feature.blocks, Vector.new(x_translation, 0, 0))
    end

    b << left_corner_block

    return b
  end

  def faces
    width_per_component_unit = width / width_components.sum 
    f = []
    for idx in 0...features.length
      feature = features[idx]
      x_translation = width_per_component_unit * width_components[0...idx].sum + thickness/2.0
      f += translate_faces(feature.faces, Vector.new(x_translation, 0, 0))
    end

    f += left_corner_block.faces

    return f
  end
end