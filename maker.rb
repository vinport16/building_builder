require "./Facade"

# Using standard graphics dimensions:
# +X direction: right
# +Y direction: up
# +Z direction: away (into screen)


def export_obj(faces)
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



my_facade = Facade.new(2,1,0.2,[Doorway.new(90,75)])


export_obj(my_facade.faces)









File.write('out.txt', 'Some glorious content')













