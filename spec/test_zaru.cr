require "spec"
require "../src/zaru"

describe Zaru do

  it "normalizes" do
    ["a", " a", "a ", " a ", "a    \n"].each do |name|
      assert_equal "a", Zaru.sanitize!(name)
    end

    ["x x", "x  x", "x   x", " x  |  x ", "x\tx", "x\r\nx"].each do |name|
      assert_equal "x x", Zaru.sanitize!(name)
    end
  end

  it "truncates" do
    name = "A"*400
    assert_equal 255, Zaru.sanitize!(name).length

    assert_equal 245, Zaru.sanitize!(name, padding: 10).length
  end

  it "sanitizes" do
    assert_equal "abcdef", Zaru.sanitize!("abcdef")

    ["<", ">", "|", "/", "\\", "*", "?", ":"].each do |char|
      assert_equal "file", Zaru.sanitize!(char)
      assert_equal "a", Zaru.sanitize!("a#{char}")
      assert_equal "a", Zaru.sanitize!("#{char}a")
      assert_equal "aa", Zaru.sanitize!("a#{char}a")
    end

    assert_equal "笊, ざる.pdf", Zaru.sanitize!("笊, ざる.pdf")

    assert_equal "whatēverwëirduserînput",
      Zaru.sanitize!("  what\\ēver//wëird:user:înput:")
  end

  it "handles Windows reserved names" do
    assert_equal "file", Zaru.sanitize!("CON")
    assert_equal "file", Zaru.sanitize!("lpt1 ")
    assert_equal "file", Zaru.sanitize!("com4")
    assert_equal "file", Zaru.sanitize!(" aux")
    assert_equal "file", Zaru.sanitize!(" LpT\x122")
    assert_equal "COM10", Zaru.sanitize!("COM10")
  end

  it "handles blanks" do
    assert_equal "file", Zaru.sanitize!("<")
  end

  it "handles dots" do
    assert_equal "file.pdf", Zaru.sanitize!(".pdf")
    assert_equal "file.pdf", Zaru.sanitize!("<.pdf")
    assert_equal "file..pdf", Zaru.sanitize!("..pdf")
  end

  it "provides fallback filenames" do
    assert_equal "file", Zaru.sanitize!("<")
    assert_equal "file", Zaru.sanitize!("lpt1")
    assert_equal "file.pdf", Zaru.sanitize!("<.pdf")

    assert_equal "blub", Zaru.sanitize!("<", fallback: "blub")
    assert_equal "blub", Zaru.sanitize!("lpt1", fallback: "blub")
    assert_equal "blub.pdf", Zaru.sanitize!("<.pdf", fallback: "blub")
  end

end
