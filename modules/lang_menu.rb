# Wrapping module. On install to your own extension, replace this with the
# namespace of the extension.
module OrdbokLib

class Ordbok

  # Create menu items for selecting language.
  #
  # @param menu [Sketchup::Menu]
  # @param system_lang [Boolean] Whether to include "System Default" as an
  #   option for picking language based on SU language.
  # @param system_lang_name [String] What to call menu item for system language.
  #   Note that this isn't the name of the any language itself but the phrase
  #   denoting to language is explicitly picked.
  #
  # @example
  #   OB = Ordbok.new(remember_lang: true)
  #   menu = UI.menu("Plugins").add_submenu("My Extension").add_submenu("Language")
  #   OB.lang_menu(menu)
  #
  # @return [Void]
  def lang_menu(menu, system_lang = true, system_lang_name = "System Default")
    if system_lang
      item = menu.add_item(system_lang_name) { self.lang = nil }
      menu.set_validation_proc(item) { lang_pref.nil? ? MF_CHECKED : MF_UNCHECKED }
      menu.add_separator
    end

    available_langs.sort.each do |lang|
      # TODO: Perhaps use full language name (and set it in language file)
      # rather than use ISO codes?
      item = menu.add_item(lang.to_s) { self.lang = lang }
      if system_lang
        menu.set_validation_proc(item) { lang_pref == lang ? MF_CHECKED : MF_UNCHECKED }
      else
        menu.set_validation_proc(item) { self.lang == lang ? MF_CHECKED : MF_UNCHECKED }
      end
    end

    nil
  end

end
end

