require "sketchup"

# In a real life extension Ordbok is loaded from within the extension's support
# directory, something like this:
### Sketchup.require("my_extension/vendor/ordbok/ordbok")
### Sketchup.require("my_extension/vendor/ordbok/lang_menu")
#
# In this example, inside of the ordbok repository, we load all Ordbok classes
# and add the ordbok source directory to $LOAD_PATH by loading the loader file.
require_relative "../../../tools/loader.rb"

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
  OB = Ordbok.new

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
    system_lang_name: OB[:system_lang_name]
  )

end
end
end
