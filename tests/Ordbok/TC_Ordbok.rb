require 'testup/testcase'
require_relative '../../tools/loader'

class TC_Ordbok < TestUp::TestCase

  Ordbok = OrdbokLib::Ordbok

  def setup
    # ...
  end

  def teardown
    # ...
  end

  #-----------------------------------------------------------------------------

  def test_initialize_No_resources
    msg =
      "Should raise error when there is no resources directory in the same "\
      "folder as Ordbok."
    assert_raises(LoadError, msg) do
      Ordbok.new
    end
  end

  def test_initialize_No_Speciedied_lang
    # Test with no specified language.
    # Should fall back to whatever language exists, but primarily English.

    dir = "#{__dir__}/TC_Ordbok/English-only"
    ob = Ordbok.new(resource_dir: dir)
    assert_equal(:"en-US", ob.lang)

    dir = "#{__dir__}/TC_Ordbok/Swedish-only"
    ob = Ordbok.new(resource_dir: dir)
    assert_equal(:sv, ob.lang)

    su_lang = Sketchup.os_language.to_sym

    dir = "#{__dir__}/TC_Ordbok/Swedish-English"
    ob = Ordbok.new(resource_dir: dir)
    expected = (su_lang == :sv && :sv || :"en-US")
    assert_equal(expected, ob.lang)

    dir = "#{__dir__}/TC_Ordbok/Swedish-Danish-English"
    ob = Ordbok.new(resource_dir: dir)
    expected = (su_lang == :sv && :sv || su_lang == :da && :da|| :"en-US")
    assert_equal(expected, ob.lang)
  end

  def test_initialize_Specified_lang
    # Should load specified language if it exists, otherwise fall back to
    # whatever exists, but primarily English.

    dir = "#{__dir__}/TC_Ordbok/English-only"
    ob = Ordbok.new(resource_dir: dir, lang: :"en-US")
    assert_equal(:"en-US", ob.lang)

    dir = "#{__dir__}/TC_Ordbok/English-only"
    ob = Ordbok.new(resource_dir: dir, lang: :sv)
    assert_equal(:"en-US", ob.lang)

    dir = "#{__dir__}/TC_Ordbok/Swedish-English"
    ob = Ordbok.new(resource_dir: dir, lang: :sv)
    assert_equal(:sv, ob.lang)

    dir = "#{__dir__}/TC_Ordbok/Swedish-only"
    ob = Ordbok.new(resource_dir: dir, lang: :en)
    assert_equal(:sv, ob.lang)
  end

  def test_available_langs
    dir = "#{__dir__}/TC_Ordbok/English-only"
    ob = Ordbok.new(resource_dir: dir)
    assert_equal([:"en-US"], ob.available_langs)

    dir = "#{__dir__}/TC_Ordbok/Swedish-only"
    ob = Ordbok.new(resource_dir: dir)
    assert_equal([:sv], ob.available_langs)

    dir = "#{__dir__}/TC_Ordbok/Swedish-English"
    ob = Ordbok.new(resource_dir: dir)
    assert_equal([:"en-US", :sv], ob.available_langs.sort)

    dir = "#{__dir__}/TC_Ordbok/Swedish-Danish-English"
    ob = Ordbok.new(resource_dir: dir)
    assert_equal([:da, :"en-US", :sv], ob.available_langs.sort)
  end

  def test_lang_Set
    dir = "#{__dir__}/TC_Ordbok/Swedish-Danish-English"
    ob = Ordbok.new(resource_dir: dir)

    ob.lang = :sv
    assert_equal(:sv, ob.lang)

    ob.lang = :da
    assert_equal(:da, ob.lang)

    assert_raises(ArgumentError) do
      ob.lang = :no
    end
  end

  def lang_available_Query
    dir = "#{__dir__}/TC_Ordbok/Swedish-Danish-English"
    ob = Ordbok.new(resource_dir: dir)

    assert(ob.lang_available?(:sv), "Swedish is available.")
    refute(ob.lang_available?(:no), "Norwegian is not available.")
  end

  def test_Operator_Get
    dir = "#{__dir__}/TC_Ordbok/English-only"
    ob = Ordbok.new(resource_dir: dir)

    assert_equal("Hello World!", ob[:greeting])

    # Using String key.
    assert_equal("Hello World!", ob["greeting"])

    # Interpolate.
    assert_equal(
      "Interpolate string here: string.",
      ob[:interpolate, string: "string"]
    )

    # Missing key.
    assert_equal("missing_key", ob[:missing_key])

    # Using nested keys.
    assert_equal("You have no new messages.", ob["message_notification.zero"])
  end

end
