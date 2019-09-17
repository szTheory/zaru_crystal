require "./spec_helper"

describe Zaru do
  it "normalizes" do
    ["a", " a", "a ", " a ", "a    \n"].each do |name|
      Zaru.sanitize!(name).should eq("a")
    end

    ["x x", "x  x", "x   x", " x  |  x ", "x\tx", "x\r\nx"].each do |name|
      Zaru.sanitize!(name).should eq("x x")
    end
  end

  it "truncates" do
    name = "A"*400
    Zaru.sanitize!(name).size.should eq(255)

    Zaru.sanitize!(name, padding: 10).size.should eq(245)
  end

  it "sanitizes" do
    Zaru.sanitize!("abcdef").should eq("abcdef")

    ["<", ">", "|", "/", "\\", "*", "?", ":"].each do |char|
      Zaru.sanitize!(char).should eq("file")
      Zaru.sanitize!("a#{char}").should eq("a")
      Zaru.sanitize!("#{char}a").should eq("a")
      Zaru.sanitize!("a#{char}a").should eq("aa")
    end

    Zaru.sanitize!("笊, ざる.pdf").should eq("笊, ざる.pdf")

    Zaru.sanitize!("  what\\ēver//wëird:user:înput:").should eq("whatēverwëirduserînput")
  end

  it "handles Windows reserved names" do
    Zaru.sanitize!("CON").should eq("file")
    Zaru.sanitize!("lpt1 ").should eq("file")
    Zaru.sanitize!("com4").should eq("file")
    Zaru.sanitize!(" aux").should eq("file")
    Zaru.sanitize!(" LpT\x122").should eq("file")
    Zaru.sanitize!("COM10").should eq("COM10")
  end

  it "handles blanks" do
    Zaru.sanitize!("<").should eq("file")
  end

  it "handles dots" do
    Zaru.sanitize!(".pdf").should eq("file.pdf")
    Zaru.sanitize!("<.pdf").should eq("file.pdf")
    Zaru.sanitize!("..pdf").should eq("file..pdf")
  end

  it "provides fallback filenames" do
    Zaru.sanitize!("<").should eq("file")
    Zaru.sanitize!("lpt1").should eq("file")
    Zaru.sanitize!("<.pdf").should eq("file.pdf")

    Zaru.sanitize!("<", fallback: "blub").should eq("blub")
    Zaru.sanitize!("lpt1", fallback: "blub").should eq("blub")
    Zaru.sanitize!("<.pdf", fallback: "blub").should eq("blub.pdf")
  end
end
