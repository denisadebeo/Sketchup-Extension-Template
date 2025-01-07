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
        bottom_left_front_face_pt__A,
        bottom_right_front_face_pt__B,
        bottom_left_back_face_pt__C,
        bottom_right_back_face_pt__D,
        top_left_front_face_pt__E,
        top_right_front_face_pt__F,
        top_left_back_face_pt__G,
        top_right_back_face_pt__H
      ]
    end

    def lines
      [
        bottom_front_line__A_B,
        bottom_back_line__C_D,
        top_front_line__E_F,
        top_back_line__G_H,
        left_front_line__A_E,
        left_back_line__C_G,
        left_bottom_line__A_C,
        left_top_line__E_G,
        right_front_line__B_F,
        right_back_line__D_H,
        right_bottom_line__B_D,
        right_top_line__F_H
      ]
    end

    def faces
      [
        front_face__A_B_F_E,
        back_face__G_H_D_C,
        left_face__E_G_C_A,
        right_face__F_H_D_B,
        top_face__E_F_H_G,
        bottom_face__A_B_D_C
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
    def bottom_left_front_face_pt__A
      @insertion_point
    end

    def bottom_right_front_face_pt__B
      @insertion_point.clone.offset!(@width_v)
    end

    def bottom_left_back_face_pt__C
      @insertion_point.clone.offset!(@depth_v)
    end

    def bottom_right_back_face_pt__D
      @insertion_point.clone.offset!(@width_v + @depth_v)
    end

    def top_left_front_face_pt__E
      @insertion_point.clone.offset!(@height_v)
    end

    def top_right_front_face_pt__F
      @insertion_point.clone.offset!(@width_v + @height_v)
    end

    def top_left_back_face_pt__G
      @insertion_point.clone.offset!(@depth_v + @height_v)
    end

    def top_right_back_face_pt__H
      @insertion_point.clone.offset!(@width_v + @depth_v + @height_v)
    end

    ### lines
    def bottom_front_line__A_B
      [bottom_left_front_face_pt__A, bottom_right_front_face_pt__B]
    end

    def bottom_back_line__C_D
      [bottom_left_back_face_pt__C, bottom_right_back_face_pt__D]
    end

    def top_front_line__E_F
      [top_left_front_face_pt__E, top_right_front_face_pt__F]
    end

    def top_back_line__G_H
      [top_left_back_face_pt__G, top_right_back_face_pt__H]
    end

    def left_front_line__A_E
      [bottom_left_front_face_pt__A, top_left_front_face_pt__E]
    end

    def left_back_line__C_G
      [bottom_left_back_face_pt__C, top_left_back_face_pt__G]
    end

    def right_front_line__B_F
      [bottom_right_front_face_pt__B, top_right_front_face_pt__F]
    end

    def right_back_line__D_H
      [bottom_right_back_face_pt__D, top_right_back_face_pt__H]
    end

    def right_bottom_line__B_D
      [bottom_right_front_face_pt__B, bottom_right_back_face_pt__D]
    end

    def left_bottom_line__A_C
      [bottom_left_front_face_pt__A, bottom_left_back_face_pt__C]
    end

    def left_top_line__E_G
      [top_left_front_face_pt__E, top_left_back_face_pt__G]
    end

    def right_top_line__F_H
      [top_right_front_face_pt__F, top_right_back_face_pt__H]
    end
    ### faces

    def front_face__A_B_F_E
      [bottom_left_front_face_pt__A, bottom_right_front_face_pt__B, top_right_front_face_pt__F, top_left_front_face_pt__E]
    end

    def back_face__G_H_D_C
      [top_left_back_face_pt__G, top_right_back_face_pt__H, bottom_right_back_face_pt__D, bottom_left_back_face_pt__C]
    end

    def left_face__E_G_C_A
      [top_left_front_face_pt__E, top_left_back_face_pt__G, bottom_left_back_face_pt__C, bottom_left_front_face_pt__A ]
    end

    def right_face__F_H_D_B
      [top_right_front_face_pt__F,top_right_back_face_pt__H, bottom_right_back_face_pt__D, bottom_right_front_face_pt__B]
    end

    def top_face__E_F_H_G
      [top_left_front_face_pt__E, top_right_front_face_pt__F, top_right_back_face_pt__H, top_left_back_face_pt__G]
    end

    def bottom_face__A_B_D_C
      [bottom_left_front_face_pt__A, bottom_right_front_face_pt__B, bottom_right_back_face_pt__D, bottom_left_back_face_pt__C]
    end

  end
end
