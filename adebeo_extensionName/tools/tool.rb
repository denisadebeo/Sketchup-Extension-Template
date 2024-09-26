module Adebeo::ExtensionName

  def self.tool_launcher
    Sketchup.active_model.select_tool Tool.new
  end

	class Tool
    CURSOR_PATH_1 = File.join(PLUGIN_PATH, "icons", "tool_cursor_1.#{CURSOR_EXTENSION}")
    CURSOR_PATH_NO = File.join(PLUGIN_PATH, "icons", "tool_cursor_no.#{CURSOR_EXTENSION}")
    DRAWING_COLOR = "black"
    DIMENSION_NAMES = %w[width depth height].freeze
		attr_accessor
		def initialize()
      # create cursors
      @cursor_1 = UI.create_cursor(CURSOR_PATH_1, 0, 0)
      @cursor_no = UI.create_cursor(CURSOR_PATH_NO, 0, 0)
		end

    def activate
      reset
    end

    def reset(view = nil)
			@model=Sketchup.active_model
      @mouse_ip = Sketchup::InputPoint.new
      @cube = Cube.new(ORIGIN, *default_dimensions)
      set_vcb_label
      UI.set_cursor(@cursor_1)
    end

    def deactivate(view)
      view.lock_inference if view&.inference_locked?
      view.invalidate()
    end

    def resume(view)
      view.invalidate()
    end

    def onCancel(reason, view)
      reset
      view.invalidate
    end

    def onMouseMove(flags, x, y, view)
      @mouse_ip.pick view, x, y
      view.tooltip = @mouse_ip.tooltip if @mouse_ip.valid?
			@cube.insertion_point= @mouse_ip.position if @cube
      view.invalidate()
      set_vcb_label
    end

    def onLButtonDown(flags, x, y, view)
      create_cube
      reset
      view.invalidate()
    end

    def onKeyUp(key, repeat, flags, view)
    end

    def onUserText(text, view)
      get_width_depth_height_from(text)
      reset
      set_vcb_label
    end

    def onSetCursor
      cursor = @mouse_ip&.valid? ? @cursor_1 : @cursor_no
      UI.set_cursor(cursor)
    end

    def draw(view)
      return if !@mouse_ip.valid?
      @cube.display(view)
    end

    def getExtents
      bb = Geom::BoundingBox.new
      return bb unless @cube
      @cube.points.each{|pt| bb.add(pt)}
      bb
    end

		private

		def set_vcb_label
			Sketchup::set_status_text LH["dimensions"], SB_VCB_LABEL
			Sketchup::set_status_text(LH["select insertion point"],SB_PROMPT)
			if @mouse_ip.valid?
				txt = @cube.dimensions_as_txt
				Sketchup::set_status_text txt, SB_VCB_VALUE
			else
				Sketchup::set_status_text "", SB_VCB_VALUE
			end
		end

		def create_cube
      @model.start_operation(LH["create cube"], true)
			@cube.draw(@model.active_entities)
			@model.commit_operation
		end

    def get_width_depth_height_from(text)
      return unless text
      begin
        values = text.gsub(' ','')
          .split(";")
          .map{|v| v.to_l}
        set_defaut_dimensions(values)
      rescue => e
        puts "Error: #{e}"
        puts text
        UI.beep
        return
      end
    end

    def set_defaut_dimensions(values)
      DIMENSION_NAMES.each_with_index do |dim, index|
        return unless  values[index]
        Sketchup.write_default(default_options_name, dim, values[index].to_s)
      end
    end

    def default_dimensions
      DIMENSION_NAMES.map { |dim| read_default_dimension(dim) }
    end

    def read_default_dimension(dimension)
      Sketchup.read_default(default_options_name, dimension)&.to_l || 10.cm
    end

    def default_options_name
      self.class.to_s.gsub("::","_")
    end

	end
end
