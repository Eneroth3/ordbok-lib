require "json"

# Wrapping library module.
module OrdbokLib

# @example
#   # In extension-dir/resources/en-US.lang
#   # {"greeting":"Hello World!"}
#
#   # In your extensions main file:
#   require "extension-dir/ordbok"
#   OB = Ordbok.new
#   OB[:greeting]
#   # => "Hello World!"
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
  # @option opts :lang [Symbol] The language to use
  #   (defaults to what SketchUp uses, en-US, or whatever language is found).
  #
  # @raise [LoadError] if no lang files exists in resource_dir.
  def initialize(opts = {})
    @resource_dir = opts[:resource_dir] || default_resource_dir
    raise LoadError, "No .lang files found in #{@resource_dir}." if available_langs.empty?

    lang_queue = default_lang_queue
    lang_queue.unshift(opts[:lang].to_sym) if opts[:lang]
    try_set_lang(lang_queue)
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
  # @param lang [Symbol]
  #
  # @raise [ArgumentError] If the language is unavailable.
  def lang=(lang)
    unless lang_available?(lang)
      raise ArgumentError, "Language unavailable does file exist? #{lang_path(lang)}"
    end

    @lang = lang.to_sym
    load_lang_file
  end

  # Check if a specific language is available.
  #
  # @param lang [Symbol]
  #
  # @return [Boolean]
  def lang_available?(lang)
    File.exist?(lang_path(lang))
  end

  # Output localized string for key.
  #
  # Formats string according to additional parameters, if any.
  # If key is missing, warn and return stringified key.
  #
  # @param key [Symbol]
  # @param opts [Hash] Interpolation options. See Kernel.format for details.
  # @option opts :count [Fixnum] The count keyword is not only interpolated to
  #   the string, but also used to select nested entry based on pluralization,
  #   if available (see example).
  #
  # @example
  #   # (Assuming there is a resource directory with valid lang files)
  #   OB = Ordbok.new
  #
  #   # (Assuming :greeting defined as "Hello World!")
  #   OB[:greeting]
  #   # => "Hello World!"
  #
  #   # Key can be String too.
  #   OB["greeting"]
  #   # => "Hello World!"
  #
  #   # (Assuming :interpolate defined as "Interpolate string here: %{string}.")
  #   OB[:interpolate, string: "Hello World!"]
  #   # => "Interpolate string here: Hello World!."
  #
  #   # Keys can be nested, defining groups of related messages.
  #   # For nested nested keys, use String with period as separator.
  #   OB["message_notification.zero"]
  #   # => "You have no new messages."
  #
  #   # The :count keyword is not only interpolated to the String, but also
  #   # used to select nested entry (if available). This allows you to
  #   # specify separate strings with different pluralization.
  #
  #   # If the count is 0, the entry :zero is used if available.
  #   # (Assuming "message_notification.zero" is "You have no new message.")
  #   OB["message_notification", count: 0 ]
  #   # => "You have no new messages."
  #
  #   # If the count is 1, the entry :one is used if available.
  #   # (Assuming "message_notification.one" is "You have %{count} new message.")
  #   OB["message_notification", count: 1 ]
  #   # => "You have 1 new message."
  #
  #   # Otherwise the entry :other is used.
  #   # (Assuming "message_notification.other" is "You have %{count} new messages.")
  #   OB["message_notification", count: 7 ]
  #   # => "You have 7 new messages."
  #
  # @return [String]
  def [](key, opts = {})
    count = opts[:count]
    template = lookup(key, count)
    if template
      format(template, opts)
    else
      warn "key #{key} is missing."
      key.to_s
    end
  end

  private

  def default_lang_queue
    [
      Sketchup.os_language.to_sym,
      :"en-US",
      available_langs.first
    ]
  end

  def default_resource_dir
    File.join(local_dir, "resources")
  end

  # Find value in nested hash using array of keys.
  #
  # @param hash [Hash]
  # @param keys [Arraty]
  #
  # @return value or nil if missing.
  def hash_lookup_by_key_array(hash, keys)
    keys.reduce(hash) { |h, k| h.is_a?(Hash) && h[k.to_sym] || nil }
  end

  def lang_path(lang = @lang)
    File.join(@resource_dir, "#{lang}.lang")
  end

  def local_dir
    dir = __dir__
    dir.force_encoding("UTF-8") if dir.respond_to?(:force_encoding)

    dir
  end

  def load_lang_file
    file_content = File.read(lang_path)
    @dictionary = JSON.parse(file_content, symbolize_names: true)

    nil
  end

  def lookup(key, count = nil)
    entry =
      if key.is_a?(Symbol)
        @dictionary[key]
      elsif key.is_a?(String)
        hash_lookup_by_key_array(@dictionary, key.split("."))
      end

    entry = pluralize(entry, count) if entry.is_a?(Hash) && count

    raise KeyError, "key points to sub-Hash, not String: #{key}" if entry.is_a?(Hash)

    entry
  end

  def pluralize(hash, count)
    return hash[:zero] if count.zero? && hash[:zero]

    # TODO: These differs between languages. For now only English and languages
    # with identical pluralization are supported.
    return hash[:one] if count == 1 && hash[:one]

    hash[:other]
  end

  # Try setting the language.
  #
  # @param langs [Array<Symbol>, Symbol]
  #
  # @return [Symbol, nil] lang code on success.
  def try_set_lang(langs)
    langs = [langs] unless langs.is_a?(Array)

    langs.each do |lang|
      next unless lang_available?(lang)
      @lang = lang
      load_lang_file
      return lang
    end

    nil
  end

end

end
