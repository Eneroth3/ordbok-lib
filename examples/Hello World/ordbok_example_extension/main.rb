require "sketchup"

# In a real extension Ordbok is loaded from within the extension's support
# directory.
### Sketchup.require(File.join(PLUGIN_DIR, "ordbok")

# In this example we know Ordbok is located 3 steps up and in the modules/ dir.
require_relative "../../../modules/ordbok.rb"

# In a real extension there is no third wrapping module, outside Author and
# Extension modules.
module OrdbokLib

module Eneroth
module OrdbokExample

  # Create Ordbok object and assign it to a constant as constants can be easily
  # referenced inside nested modules and classes.
  OB = Ordbok.new(resource_dir: File.join(PLUGIN_DIR, "resources"))

  # This simple extension merely uses the language of SketchUp, and falls back
  # to English if it's missing.
  #
  # You can also use Ordbok#available_langs to list available languages and
  # Ordbok#lang= to let the user chose language.
  #
  # For testing purposes you can reference the Ordbok object from
  # OrdbokLib::Eneroth::OrdbokExample::OB to change language.

  # Business code below...

  def self.hello_world
    model = Sketchup.active_model
    model.start_operation(OB[:greeting], true)

    definition = model.definitions.add(OB[:greeting])
    definition.entities.add_3d_text(
      OB[:greeting],
      TextAlignLeft,
      "Arial",
      false,
      false,
      1.m,
      0.0,
      0,
      true
    )

    # Why would anyone want the back side up??
    definition.entities.grep(Sketchup::Face, &:reverse!)

    model.commit_operation
    model.place_component(definition)
  end

  menu = UI.menu("Plugins")
  menu.add_item(OB[:greeting]) { hello_world }

end
end
end
