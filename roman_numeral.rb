# Does not support overline symbols i.e. "M"s must be written out e.g. MMMMM == 5000
class RomanNumeral

  DECIMAL_VALUE = {
    "I" => 1,
    "V" => 5,
    "X" => 10,
    "L" => 50,
    "C" => 100,
    "D" => 500,
    "M" => 1000
  }

  attr_reader :string
  alias_method :to_s, :string

  def initialize(s)
    raise "INVALID ROMAN NUMERAL #{s}" unless self.class.valid?(s)
    @string = s
  end

  def ==(other)
    case
    when self.class.valid?(other)
      self == RomanNumeral.new(other)
    when other.respond_to?(:to_f)
      self.to_f == other.to_f
    else
      super
    end
  end

  # Compares object identity.
  # Do not override.
  #
  # def equal?(other)
  # end

  # Used by "case" statements
  # This is the default behavior. No need to override.
  # def ===(other)
  #   self == other
  # end

  # Used to compare Hash keys
  def eql?(other)
    other.kind_of?(RomanNumeral) && self.to_i.eql?(other.to_i)
  end

  # Used to create Hash keys
  def hash
    self.to_i.hash
  end

  def to_i
    decimal_values = @string.each_char.map { |numeral| DECIMAL_VALUE[numeral] }
    decimal_values.each_with_index.inject(0) do |sum, (val, i)|
      next_val = decimal_values[i+1]
      sign = next_val.nil? || val >= next_val ? 1 : -1
      sum + (val * sign)
    end
  end

  def respond_to?(name)
    super || self.to_i.respond_to?(name)
  end

  def method_missing(name, *args)
    if self.respond_to?(name)
      return self.to_i.send(name, *args)
    end
    super
  end

  def self.valid?(s)
    s.kind_of?(String) && /^[#{DECIMAL_VALUE.keys.join}]+$/ === s
  end

end

