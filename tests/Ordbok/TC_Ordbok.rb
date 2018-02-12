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

  def test_initialize_Remember_lang
    # Language preference is optionally saved between sessions on a per
    # extension basis.

    dir = "#{__dir__}/TC_Ordbok/Swedish-Danish-English"
    su_lang = Sketchup.os_language.to_sym

    ob = Ordbok.new(resource_dir: dir, remember_lang: true)
    # No reason to test language here. Depends on last test, if any, or SU
    # language.

    ob.lang = :sv
    ob = Ordbok.new(resource_dir: dir, remember_lang: true)
    assert_equal(:sv, ob.lang)

    ob.lang = :da
    ob = Ordbok.new(resource_dir: dir, remember_lang: true)
    assert_equal(:da, ob.lang)

    # When remember_lang isn't specified as true, the language from last session
    # should not be restored.
    # (Assume SketchUp isn't running in Danish here)
    ob = Ordbok.new(resource_dir: dir)
    expected = (su_lang == :sv && :sv || su_lang == :da && :da|| :"en-US")
    assert_equal(expected, ob.lang)

    # Different extensions should not interfere with each others.

    ob1 = Ordbok.new(resource_dir: dir, remember_lang: true, pref_key: :ordbok_test1)
    ob2 = Ordbok.new(resource_dir: dir, remember_lang: true, pref_key: :ordbok_test2)
    ob1.lang = :da
    ob2.lang = :sv

    ob1 = Ordbok.new(resource_dir: dir, remember_lang: true, pref_key: :ordbok_test1)
    ob2 = Ordbok.new(resource_dir: dir, remember_lang: true, pref_key: :ordbok_test2)
    assert_equal(:da, ob1.lang)
    assert_equal(:sv, ob2.lang)

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

    # Pluralization.
    assert_equal(
      "You have no new messages.",
      ob["message_notification", count: 0]
    )
    assert_equal(
      "You have 1 new message.",
      ob["message_notification", count: 1]
    )
    assert_equal(
      "You have 77 new messages.",
      ob["message_notification", count: 77]
    )
    # Pluralization with symbol key.
    assert_equal(
      "You have 77 new messages.",
      ob[:message_notification, count: 77]
    )
    # Don't append pluralization to lookup path if it point to String already.
    # The user of the library should be able to use :count as any other
    # variable, without specialized lookup when the template string should
    # remain the same and :count just happens to be the most descriptive name.
    assert_equal(
      "You have 77 new messages.",
      ob["message_notification.other", count: 77]
    )
  end

end
