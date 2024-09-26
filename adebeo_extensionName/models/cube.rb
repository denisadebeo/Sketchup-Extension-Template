module Adebeo::ExtensionName
  class Cube

    MIN_WIDTH = 10.cm.freeze
    MIN_DEPTH = 10.cm.freeze
    MIN_HEIGHT = 10.cm.freeze

    def self.grep_all_groups
      Sketchup.active_model.entities.grep(Sketchup::Group).select do |group|
        group.get_attribute('adebeo_extensionName', 'type') == self.to_s
      end
    end

    attr_accessor :insertion_point

    def initialize(insertion_point, width = MIN_WIDTH, depth = MIN_DEPTH, height = MIN_HEIGHT)
      @insertion_point = insertion_point
      @width = width
      @depth = depth
      @height = height
      set_vectors
    end

    def draw(entities = nil)
      entities = entities || Sketchup.active_model.active_entities
      group = entities.add_group
      group_entities = group.entities
      faces.each do |face|
        group_entities.add_face(face)
      end
      group.set_attribute('adebeo_extensionName', 'type', self.class.to_s)
      CubesOverlay.grep
    end

    def display(view)
      lines.each do |line|
        view.draw_line(line)
      end
    end

    def points
      [
        bottom_left_front_face_pt,
        bottom_right_front_face_pt,
        bottom_left_back_face_pt,
        bottom_right_back_face_pt,
        top_left_front_face_pt,
        top_right_front_face_pt,
        top_left_back_face_pt,
        top_right_back_face_pt
      ]
    end

    def lines
      [
        bottom_front_line,
        bottom_back_line,
        top_front_line,
        top_back_line,
        left_front_line,
        left_back_line,
        left_bottom_line,
        left_top_line,
        right_front_line,
        right_back_line,
        right_bottom_line,
        right_top_line
      ]
    end

    def faces
      [
        front_face,
        back_face,
        left_face,
        right_face,
        top_face,
        bottom_face
      ]
    end

    def dimensions_as_txt
      text = "#{@width};#{@depth};#{@height}"

    end

    private

    def set_vectors
      @width_v = Geom::Vector3d.new(@width, 0, 0)
      @depth_v = Geom::Vector3d.new(0, @depth, 0)
      @height_v = Geom::Vector3d.new(0, 0, @height)
    end

    # points
    def bottom_left_front_face_pt
      @insertion_point
    end

    def bottom_right_front_face_pt
      @insertion_point.clone.offset!(@width_v)
    end

    def bottom_left_back_face_pt
      @insertion_point.clone.offset!(@depth_v)
    end

    def bottom_right_back_face_pt
      @insertion_point.clone.offset!(@width_v + @depth_v)
    end

    def top_left_front_face_pt
      @insertion_point.clone.offset!(@height_v)
    end

    def top_right_front_face_pt
      @insertion_point.clone.offset!(@width_v + @height_v)
    end

    def top_left_back_face_pt
      @insertion_point.clone.offset!(@depth_v + @height_v)
    end

    def top_right_back_face_pt
      @insertion_point.clone.offset!(@width_v + @depth_v + @height_v)
    end

    ### lines
    def bottom_front_line
      [bottom_left_front_face_pt, bottom_right_front_face_pt]
    end

    def bottom_back_line
      [bottom_left_back_face_pt, bottom_right_back_face_pt]
    end

    def top_front_line
      [top_left_front_face_pt, top_right_front_face_pt]
    end

    def top_back_line
      [top_left_back_face_pt, top_right_back_face_pt]
    end

    def left_front_line
      [bottom_left_front_face_pt, top_left_front_face_pt]
    end

    def left_back_line
      [bottom_left_back_face_pt, top_left_back_face_pt]
    end

    def right_front_line
      [bottom_right_front_face_pt, top_right_front_face_pt]
    end

    def right_back_line
      [bottom_right_back_face_pt, top_right_back_face_pt]
    end

    def right_bottom_line
      [bottom_right_front_face_pt, bottom_right_back_face_pt]
    end

    def left_bottom_line
      [bottom_left_front_face_pt, bottom_left_back_face_pt]
    end

    def left_top_line
      [top_left_front_face_pt, top_left_back_face_pt]
    end

    def right_top_line
      [top_right_front_face_pt, top_right_back_face_pt]
    end
    ### faces

    def front_face
      [bottom_left_front_face_pt, bottom_right_front_face_pt, top_right_front_face_pt, top_left_front_face_pt]
    end

    def back_face
      [top_left_back_face_pt, top_right_back_face_pt, bottom_right_back_face_pt, bottom_left_back_face_pt]
    end

    def left_face
      [top_left_front_face_pt, top_left_back_face_pt, bottom_left_back_face_pt, bottom_left_front_face_pt ]
    end

    def right_face
      [top_right_front_face_pt,top_right_back_face_pt, bottom_right_back_face_pt, bottom_right_front_face_pt]
    end

    def top_face
      [top_left_front_face_pt, top_right_front_face_pt, top_right_back_face_pt, top_left_back_face_pt]
    end

    def bottom_face
      [bottom_left_front_face_pt, bottom_right_front_face_pt, bottom_right_back_face_pt, bottom_left_back_face_pt]
    end

  end
end

=begin
module Adebeo::ExtensionName
  class Cube
    POSITIONS = %w[bottom top left right front back]

    def initialize(insertion_point, width = 1.m, depth = 1.m, height = 1.m)
      @insertion_point = insertion_point
      @width = width
      @depth = depth
      @height = height
      set_vectors
      define_point_methods
      define_line_methods
    end

    def draw(entities = nil)
      entities = entities || Sketchup.active_model.active_entities
      faces.each do |face|
        entities.add_face(face)
      end
    end

    def display(view)
      view.draw_lines(*lines)
    end

    private

    def set_vectors
      @width_v = Geom::Vector3d.new(@width, 0, 0)
      @depth_v = Geom::Vector3d.new(0, @depth, 0)
      @height_v = Geom::Vector3d.new(0, 0, @height)
    end

    def define_point_methods
      POSITIONS.combination(3).each do |pos|
        method_name = "#{pos.join('_')}_pt"
        define_singleton_method(method_name) do
          point = @insertion_point.clone
          point.offset!(@width_v) if pos.include?('right')
          point.offset!(@depth_v) if pos.include?('back')
          point.offset!(@height_v) if pos.include?('top')
          point
        end
      end
    end

    def define_line_methods
      POSITIONS.combination(2).each do |pos|
        remaining = POSITIONS - pos
        method_name = "#{pos.join('_')}_line"
        define_singleton_method(method_name) do
          [
            send("#{pos.join('_')}_#{remaining[0]}_pt"),
            send("#{pos.join('_')}_#{remaining[1]}_pt")
          ]
        end
      end
    end

    def lines
      POSITIONS.combination(2).map do |pos|
        send("#{pos.join('_')}_line")
      end
    end

    def faces
      POSITIONS.map do |pos|
        remaining = POSITIONS - [pos]
        [
          send("#{pos}_#{remaining[0]}_#{remaining[1]}_pt"),
          send("#{pos}_#{remaining[0]}_#{remaining[2]}_pt"),
          send("#{pos}_#{remaining[1]}_#{remaining[2]}_pt"),
          send("#{pos}_#{remaining[3]}_#{remaining[4]}_pt")
        ]
      end
    end
  end
end
=end
