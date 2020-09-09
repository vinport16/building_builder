# Using standard graphics dimensions:
# +X direction: right
# +Y direction: up
# +Z direction: away (into screen)


class Vector

  attr_accessor :x, :y, :z

  def initialize(x, y, z)
    @x = x.to_f
    @y = y.to_f
    @z = z.to_f
  end

  def -(v)
    return Vector.new(x - v.x, y - v.y, z - v.z)
  end

  def +(v)
    return Vector.new(x + v.x, y + v.y, z + v.z)
  end

  def *(n)
    return Vector.new(x * n, y * n, z * n)
  end

  def /(n)
    return Vector.new(x / n, y / n, z / n)
  end

  def to_s
    return "#{x}\t#{y}\t#{z}"
  end

  def rotate_y!
    @x, @z = @z, -@x
  end

  def copy
    return Vector.new(x, y, z)
  end

end