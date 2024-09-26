module Adebeo::ExtensionName
# Using an observer to create a new overlay per model.
  class CubesAppObserver < Sketchup::AppObserver

    def expectsStartupModelNotifications
      true
    end

    def register_overlay(model)
      overlay = CubesOverlay.new
      model.overlays.add(overlay)
    end
    alias_method :onNewModel, :register_overlay
    alias_method :onOpenModel, :register_overlay

  end

end

cube_overlay_observer = Adebeo::ExtensionName::CubesAppObserver.new
Sketchup.add_observer(cube_overlay_observer)
