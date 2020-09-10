require "./Level"

# Using standard graphics dimensions:
# +X direction: right
# +Y direction: up
# +Z direction: away (into screen)

def export_obj faces
  v = []
  v_index = {}
  f = []

  faces.each do |face|
    f << []
    face.each do |vert|
      if(v_index[vert.to_s].nil?)
        v << vert
        v_index[vert.to_s] = v.length-1
        f[f.length-1] << v.length
      else
        f[f.length-1] << v_index[vert.to_s] + 1
      end
    end
  end

  first_part = "v " + v.join("\nv ")
  f_strings = f.map {|face| face.join(" ")}
  second_part = "\nf " + f_strings.join("\nf ")

  File.write('out.obj', first_part + second_part)
end



my_facade = Facade.new(2,5,0.2,[Doorway.new(90,75),
                                Window.new(70,50,70),
                                Window.new(70,50,70),
                                Doorway.new(90,75),
                                Window.new(70,40,50)])

my_level = Level.new([my_facade, my_facade, my_facade, my_facade], [0,1,2,3])



export_obj(my_level.faces)









File.write('out.txt', 'Some glorious content')













