# Wrapping library module.
module OrdbokLib

# @example
#   # In extension-dir/resources/en-US.lang
#   # {hello: "Hello World"}
#
#   # In your extensions main file:
#   require "extension-dir/ordbok"
#   OB = Ordbok.new
#   OB.tr(:hello)
#   # => "Hello World"
class Ordbok

  # Initialize Ordbok object.
  #
  # It is recommended to assign this object to constant for access throughout
  # your extension.
  #
  # @example
  #   OB = Ordbok.new
  #
  # @param opts [Hash] Options for Ordbok object.
  # @option opts :resource_dir [String] Path to directory containing language
  #   files (defaults to "resources", relative to where Ordbok is defined).
  # @option opts :lang_code [Symbol] The language to use
  #   (defaults to what SketchUp uses).
  #
  # @raise [LoadError] if resource_dir is missing.
  def initialize(opts = {})
    @resource_dir = opts[:resource_dir] || File.join(local_dir, "resources")
    raise LoadError, "No .lang files found in #{@resource_dir}." if available_langs.empty?

    opts[:lang_code] && try_set_lang(opts[:lang_code].to_sym) ||
      try_set_lang(Sketchup.os_language.to_sym) ||
      try_set_lang(:"en-US") ||
      try_set_lang(available_langs.first)

    load_lang_file
  end

  # Returns the code of the currently used language.
  #
  # @return [Symbol]
  attr_reader :lang

  # List the available languages in the resources directory.
  #
  # A language is a file with the extension .lang.
  #
  # @return [Array<Symbol>]
  def available_langs
    Dir.glob("#{@resource_dir}/*.lang").map { |p| File.basename(p, ".*").to_sym }
  end

  # Set language.
  #
  # @param lang_code [Symbol]
  #
  # @raise [ArgumentError] If the language is unavailable.
  def lang=(lang_code)
    unless lang_available?(lang_code)
      raise ArgumentError, "Language unavailable does file exist? #{lang_path(lang_code)}"
    end

    @lang = lang_code.to_sym
    load_lang_file
  end

  # Check if a specific language is available.
  #
  # @param lang_code [Symbol]
  #
  # @return [Boolean]
  def lang_available?(lang_code)
    File.exist?(lang_path(lang_code))
  end

  private

  # Path to lang file.
  def lang_path(lang_code = @lang)
    File.join(@resource_dir, "#{lang_code}.lang")
  end

  def local_dir
    dir = __dir__
    dir.force_encoding("UTF-8") if dir.respond_to?(:force_encoding)

    dir
  end

  def load_lang_file
    # TODO: Load lang file. Parse it. Save hash.
    warn "Not yet implemented"
  end

  # Set language to lang_code if it can be found. Otherwise keep the current
  # language. Does NOT load the language file.
  #
  # @param lang_code [Symbol]
  #
  # @return [Symbol, nil] lang_code on success.
  def try_set_lang(lang_code)
    return nil unless lang_available?(lang_code)
    # TODO: Fall back to similar lang?
    @lang = lang_code

    lang_code
  end

end

end
