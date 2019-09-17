require "memoized"

class Zaru
  VERSION = "0.1.0"

  CHARACTER_FILTER       = /[\x00-\x1F\/\\:\*\?\"<>\|]/i
  UNICODE_WHITESPACE     = /[[:space:]]+/i
  WINDOWS_RESERVED_NAMES =
    %w{CON PRN AUX NUL COM1 COM2 COM3 COM4 COM5
      COM6 COM7 COM8 COM9 LPT1 LPT2 LPT3 LPT4
      LPT5 LPT6 LPT7 LPT8 LPT9}
  FALLBACK_FILENAME = "file"

  @fallback : String
  @raw : String
  @padding : Int32
  @truncated : String

  def initialize(filename, fallback, padding)
    @fallback = fallback || FALLBACK_FILENAME
    @padding = padding || 0
    @raw = filename
    @truncated = ""
  end

  # strip whitespace on beginning and end
  # collapse intra-string whitespace into single spaces
  def normalize
    Memoized(String).new do
      @raw.strip.gsub(UNICODE_WHITESPACE, " ")
    end.get
  end

  # remove bad things!
  # - remove characters that aren't allowed cross-OS
  # - don't allow certain special filenames (issue on Windows)
  # - don't allow filenames to start with a dot
  # - don't allow empty filenames
  #
  # this renormalizes after filtering in order to collapse whitespace
  def sanitize
    Memoized(String).new do
      filter(normalize.gsub(CHARACTER_FILTER, "")).gsub(UNICODE_WHITESPACE, " ")
    end.get
  end

  # cut off at 255 characters
  # optionally provide a padding, which is useful to
  # make sure there is room to add a file extension later
  def truncate
    Memoized(String).new do
      sanitize.chars.to_a[0..254 - @padding].join
    end.get
  end

  def to_s
    truncate
  end

  # convenience method
  def self.sanitize!(filename, fallback = nil, padding = nil)
    new(filename, fallback, padding).to_s
  end

  private getter :fallback

  private def filter(filename)
    filename = filter_windows_reserved_names(filename)
    filename = filter_blank(filename)
    filename = filter_dot(filename)
    filename
  end

  private def filter_windows_reserved_names(filename)
    WINDOWS_RESERVED_NAMES.includes?(filename.upcase) ? fallback : filename
  end

  private def filter_blank(filename)
    filename.empty? ? fallback : filename
  end

  private def filter_dot(filename)
    filename.starts_with?(".") ? "#{fallback}#{filename}" : filename
  end
end
