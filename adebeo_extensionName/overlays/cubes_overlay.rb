module Adebeo::ExtensionName
  class CubesOverlay < Sketchup::Overlay

    # PLUGIN::FacadeOverlay::NAME
    NAME = "Cubes"
    def initialize
      super('Adebeo.ExtensionName', NAME)
      set_existing_cubes
    end

    def set_existing_cubes
      @existing_cube_groups = PLUGIN::Cube.grep_all_groups()
    end

    def draw(view)
      entities_to_ve_removed = []
      @existing_cube_groups&.each{|cube_group|
          result = display_points(view,cube_group)
          entities_to_ve_removed << result unless result
      }
      @existing_cube_groups -= entities_to_ve_removed

    end

    def add_cube(cube)
      @existing_cube_groups << cube
    end

    def display_points(view,cube_group)
      return false if !cube_group.valid?
      vertices = cube_group.entities.grep(Sketchup::Face).map{|face| face.vertices}.flatten.uniq
      vertices.map{|vertex| view.draw_points(vertex.position, 10, 1, 'red')}
    end

    # CubesOverlay.grep
    def self.grep
      Sketchup.active_model.overlays.each { |overlay|
        @cube_overlay = overlay if overlay.name == NAME
      }
      @cube_overlay&.set_existing_cubes() if @cube_overlay
      return @cube_overlay
    end

  end
end
