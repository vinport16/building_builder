require "./Vector"

# Using standard graphics dimensions:
# +X direction: right
# +Y direction: up
# +Z direction: away (into screen)

class Box
  # center of box at 0,0,0
  attr_reader :size

  def initialize(size)
    @size = size.copy
  end

  def positive_corner
    return size/2
  end

  def width
    return Vector.new(size.x, 0, 0)
  end

  def height
    return Vector.new(0, size.y, 0)
  end

  def depth
    return Vector.new(0, 0, size.z)
  end

  def back_face
    return [
      positive_corner,
      positive_corner - width,
      positive_corner - width - height,
      positive_corner - height
    ]
  end

  def front_face
    return [
      positive_corner * -1,
      positive_corner * -1 + height,
      positive_corner * -1 + width + height,
      positive_corner * -1 + width
    ]
  end

  def top_face
    return [
      positive_corner,
      positive_corner - depth,
      positive_corner - width - depth,
      positive_corner - width
    ]
  end

  def bottom_face
    return [
      positive_corner * -1,
      positive_corner * -1 + width,
      positive_corner * -1 + width + depth,
      positive_corner * -1 + depth
    ]
  end

  def right_face
    return [
      positive_corner,
      positive_corner - height,
      positive_corner - height - depth,
      positive_corner - depth
    ]
  end

  def left_face
    return [
      positive_corner * -1,
      positive_corner * -1 + depth,
      positive_corner * -1 + height + depth,
      positive_corner * -1 + height
    ]
  end

  def faces
    return [back_face, top_face, right_face, left_face, bottom_face, front_face]
  end

  def rotate_y!
    size.x, size.z = size.z, size.x
  end

  def copy
    return Box.new(size)
  end
end
