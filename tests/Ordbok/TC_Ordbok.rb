require 'testup/testcase'
require_relative '../../modules/ordbok'

class TC_Ordbok < TestUp::TestCase

  Ordbok = SkippyLib::Ordbok

  def setup
    # ...
  end

  def teardown
    # ...
  end

  #-----------------------------------------------------------------------------

  def test_initialize_No_resource_dir
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

end
