require "./Level"

# Using standard graphics dimensions:
# +X direction: right
# +Y direction: up
# +Z direction: away (into screen)

def export_obj faces, filename
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

  File.write("#{filename}.obj", first_part + second_part)
end



my_facade = Facade.new(2,5,0.2,[Doorway.new(90,75),
                                Window.new(70,50,70),
                                Window.new(70,50,70),
                                Doorway.new(90,75),
                                Window.new(70,40,50)])

my_square_level = Level.new([my_facade, my_facade, my_facade, my_facade], [0,1,2,3])

doorway_facade = Facade.new(3,5.5,0.25,[Window.new(33,0,100),
                                        Window.new(33,0,100),
                                        Doorway.new(90,70),
                                        Window.new(33,0,100),
                                        Window.new(33,0,100)])

windows_facade = Facade.new(3,5.5,0.25,[Window.new(60,40,70),
                                        Window.new(60,40,70),
                                        Window.new(60,40,70),
                                        Window.new(60,40,70),
                                        Window.new(60,40,70)])


my_plus_level = Level.new([doorway_facade,
                      windows_facade,
                      windows_facade,
                      doorway_facade,
                      windows_facade,
                      windows_facade,
                      doorway_facade,
                      windows_facade,
                      windows_facade,
                      doorway_facade,
                      windows_facade,
                      windows_facade],
                     [0,1,0,1,2,1,2,3,2,3,0,3])


export_obj(my_plus_level.faces + [my_plus_level.roof_face], "plus")
export_obj(my_square_level.faces, "square")























