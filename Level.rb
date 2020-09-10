require "./Facade"

class Level

  # orientations: the Y rotation of each facade. ex, for a
  # rectangular Level, orientations = [0,1,2,3]
  # L shaped Level, orientations = [0,1,2,1,2,3]

  attr_reader :facades, :orientations

  def initialize facades, orientations
    @facades = facades
    @orientations = orientations
    if !facades_close
      puts "!!! Facades do not form a closed shape"
    end
  end

  def facades_close
    dx = 0
    dz = 0

    for idx in 0...facades.length
      if orientations[idx]%4 == 0
        dx += facades[idx].width
      elsif orientations[idx]%4 == 1
        dz += facades[idx].width
      elsif orientations[idx]%4 == 2
        dx -= facades[idx].width
      elsif orientations[idx]%4 == 3
        dz -= facades[idx].width
      end
    end
    return dx.round(5) == 0 && dz.round(5) == 0
  end

  def faces
    f = []
    dx = 0
    dz = 0

    for idx in 0...facades.length
      f_faces = facades[idx].faces
      f_faces = rotate_faces_y(f_faces, orientations[idx])
      f += translate_faces(f_faces, Vector.new(dx,0,dz))

      if orientations[idx]%4 == 0
        dx += facades[idx].width
      elsif orientations[idx]%4 == 1
        dz += facades[idx].width
      elsif orientations[idx]%4 == 2
        dx -= facades[idx].width
      elsif orientations[idx]%4 == 3
        dz -= facades[idx].width
      end
      
    end

    return f
  end

  def blocks
    b = []
    dx = 0
    dz = 0

    for idx in 0...facades.length
      f_blocks = facades[idx].blocks
      f_blocks.each do |block|
        block.rotate_y!(orientations[idx])
      end
      b += translate_blocks(f_blocks, Vector.new(dx,0,dz))

      if orientations[idx]%4 == 0
        dx += facades[idx].width
      elsif orientations[idx]%4 == 1
        dz += facades[idx].width
      elsif orientations[idx]%4 == 2
        dx -= facades[idx].width
      elsif orientations[idx]%4 == 3
        dz -= facades[idx].width
      end
      
    end

    return b
  end


end