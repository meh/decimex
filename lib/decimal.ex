#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defrecord Decimal, internal: :decimal_conv.number(0) do
  def from(value) when is_tuple value do
    case value do
      { Decimal, _ } -> value
      _              -> { Decimal, value }
    end
  end

  def from(value) do
    { Decimal, :decimal_conv.number(value) }
  end

  def nan?(self) do
    :decimal.is_NaN(from(self).internal)
  end

  def infinite?(self) do
    :decimal.is_infinite(from(self).internal)
  end

  def finite?(self) do
    :decimal.is_finite(from(self).internal)
  end

  def zero?(self) do
    :decimal.is_zero(from(self).internal)
  end

  def negative?(self) do
    :decimal.is_signed(from(self).internal)
  end

  def positive?(self) do
    not negative?(self)
  end

  def plus(self) do
    plus([], self)
  end

  def plus(context, self) do
    from(:decimal.plus(from(self).internal, context))
  end

  def minus(self) do
    minus([], self)
  end

  def minus(context, self) do
    from(:decimal.minus(from(self).internal, context))
  end

  def abs(self) do
    abs([], self)
  end

  def abs(context, self) do
    from(:decimal.abs(from(self).internal, context))
  end

  def compare(other, self) do
    compare(other, [], self)
  end

  def compare(other, context, self) do
    :decimal.compare(from(self).internal, from(other).internal, context)
  end

  def equal?(other, self) do
    equal?(other, [], self)
  end

  def equal?(other, context, self) do
    compare(other, context, self) == 0
  end

  def add(other, self) do
    add(other, [], self)
  end

  def add(other, context, self) do
    from(:decimal.add(from(self).internal, from(other).internal, context))
  end

  def subtract(other, self) do
    subtract(other, [], self)
  end

  def subtract(other, context, self) do
    from(:decimal.subtract(from(self).internal, from(other).internal, context))
  end

  def multiply(other, self) do
    multiply(other, [], self)
  end

  def multiply(other, context, self) do
    from(:decimal.multiply(from(self).internal, from(other).internal, context))
  end

  def divide(other, self) do
    divide(other, [], self)
  end

  def divide(other, context, self) do
    from(:decimal.divide(from(self).internal, from(other).internal, context))
  end

  def remainder(other, self) do
    remainder(other, [], self)
  end

  def remainder(other, context, self) do
    from(:decimal.remainder(from(self).internal, from(other).internal, context))
  end

  def exp(self) do
    exp([], self)
  end

  def exp(context, self) do
    from(:decimal.exp(from(self).internal, context))
  end

  def ln(self) do
    ln([], self)
  end

  def ln(context, self) do
    from(:decimal.ln(from(self).internal, context))
  end

  def log10(self) do
    log10([], self)
  end

  def log10(context, self) do
    from(:decimal.log10(from(self).internal, context))
  end

  def power(other, self) do
    power(other, [], self)
  end

  def power(other, context, self) do
    from(:decimal.power(from(self).internal, from(other).internal, context))
  end

  def sqrt(self) do
    sqrt([], self)
  end

  def sqrt(context, self) do
    from(:decimal.sqrt(from(self).internal, context))
  end

  def max(self, other) do
    max(self, other, [])
  end

  def max(self, other, context) do
    from(:decimal.max(from(self).internal, from(other).internal, context))
  end

  def min(self, other) do
    min(self, other, [])
  end

  def min(self, other, context) do
    from(:decimal.min(from(self).internal, from(other).internal, context))
  end

  def reduce(self) do
    reduce([], self)
  end

  def reduce(context, self) do
    from(:decimal.reduce(from(self).internal, context))
  end
end

defimpl Binary.Chars, for: Decimal do
  def to_binary(decimal) do
    Kernel.to_binary(:decimal.format(decimal.internal))
  end
end

defimpl Binary.Inspect, for: Decimal do
  def inspect(decimal, _) do
    to_binary(decimal)
  end
end

defprotocol Decimal.Conversion do
  def to_decimal(value)
end

defimpl Decimal.Conversion, for: Tuple do
  def to_decimal(value) do
    { Decimal, value }
  end
end

defimpl Decimal.Conversion, for: Number do
  def to_decimal(value) do
    Decimal.from(value)
  end
end

defimpl Decimal.Conversion, for: BitString do
  def to_decimal(value) do
    Decimal.from(value)
  end
end
