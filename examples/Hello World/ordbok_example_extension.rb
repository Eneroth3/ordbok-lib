#-------------------------------------------------------------------------------
#
#    Author: Julia Christina Eneroth
# Copyright: Copyright (c) 2018
#   License: MIT
#
#-------------------------------------------------------------------------------

require "extensions.rb"

# In a real extension there is no third wrapping module, outside Author and
# Extension modules.
module OrdbokLib

module Eneroth
module OrdbokExample

  path = __FILE__
  path.force_encoding("UTF-8") if path.respond_to?(:force_encoding)

  PLUGIN_ID = File.basename(path, ".rb")
  PLUGIN_DIR = File.join(File.dirname(path), PLUGIN_ID)

  EXTENSION = SketchupExtension.new(
    "Eneroth Ordbok Example",
    File.join(PLUGIN_DIR, "main")
  )
  EXTENSION.creator     = "Julia Christina Eneroth"
  EXTENSION.description =
    "Example of how Ordbok can be used for SketchUp extension localization."
  EXTENSION.version     = "1.0.0"
  EXTENSION.copyright   = "#{EXTENSION.creator} Copyright (c) 2018"
  Sketchup.register_extension(EXTENSION, true)

end
end
end
