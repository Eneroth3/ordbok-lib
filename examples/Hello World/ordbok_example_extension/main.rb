require "sketchup"

# In a real life extension Ordbok is loaded from within the extension's support
# directory, something like this (assuming PLUGIN_DIR is the path to the
# extension support directory).
### Sketchup.require(File.join(PLUGIN_DIR, "ordbok")
### Sketchup.require(File.join(PLUGIN_DIR, "lang_menu")

# In this example we know Ordbok is located 3 steps up and in modules/.
require_relative "../../../modules/ordbok.rb"
require_relative "../../../modules/lang_menu.rb"

# In a real life extension there is no third wrapping module, outside Author and
# Extension modules.
module OrdbokLib

module Eneroth
module OrdbokExample

  # Create Ordbok object and assign it to a constant as constants can be easily
  # referenced inside nested modules and classes.
  #
  # Set remember_lang to true and add a language selector menu to let the user
  # switch language themselves for this extension, and remember it between
  # sessions.
  OB = Ordbok.new(remember_lang: true)

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

  menu = UI.menu("Plugins").add_submenu(OB[:greeting])
  menu.add_item(OB[:greeting]) { hello_world }

  # Optional language selector.
  # Submenu name is itself localized (but wont be updated until SU is
  # restarted).
  OB.lang_menu(
    menu.add_submenu(OB[:lang_option]),
    true,
    OB[:system_lang_name]
  )

end
end
end
