#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defrecord Decimal, internal: :decimal_conv.number(0) do
  @type i :: { integer, integer, integer }
  @type t :: { Decimal, i }
  @type c :: [{ :precision, integer } | { :rounding, atom }]
  @type v :: { Decimal, i } | i | number | binary | char_list

  @spec from(v) :: t
  def from(value) when is_tuple value do
    case value do
      { Decimal, _ } -> value
      _              -> { Decimal, value }
    end
  end

  def from(value) do
    { Decimal, :decimal_conv.number(value) }
  end

  @spec nan?(t) :: boolean
  def nan?(self) do
    :decimal.is_NaN(from(self).internal)
  end

  @spec infinite?(t) :: boolean
  def infinite?(self) do
    :decimal.is_infinite(from(self).internal)
  end

  @spec finite?(t) :: boolean
  def finite?(self) do
    :decimal.is_finite(from(self).internal)
  end

  @spec zero?(t) :: boolean
  def zero?(self) do
    :decimal.is_zero(from(self).internal)
  end

  @spec negative?(t) :: boolean
  def negative?(self) do
    :decimal.is_signed(from(self).internal)
  end

  @spec positive?(t) :: boolean
  def positive?(self) do
    not negative?(self)
  end

  @spec plus(t) :: t
  def plus(self) do
    plus([], self)
  end

  @spec plus(c, t) :: t
  def plus(context, self) do
    from(:decimal.plus(from(self).internal, context))
  end

  @spec minus(t) :: t
  def minus(self) do
    minus([], self)
  end

  @spec minus(c, t) :: t
  def minus(context, self) do
    from(:decimal.minus(from(self).internal, context))
  end

  @spec abs(t) :: t
  def abs(self) do
    abs([], self)
  end

  @spec abs(c, t) :: t
  def abs(context, self) do
    from(:decimal.abs(from(self).internal, context))
  end

  @spec compare(v, t) :: integer
  def compare(other, self) do
    compare(other, [], self)
  end

  @spec compare(v, c, t) :: integer
  def compare(other, context, self) do
    :decimal.compare(from(self).internal, from(other).internal, context)
  end

  @spec equal?(v, t) :: boolean
  def equal?(other, self) do
    equal?(other, [], self)
  end

  @spec equal?(v, c, t) :: boolean
  def equal?(other, context, self) do
    compare(other, context, self) == 0
  end

  @spec add(v, t) :: t
  def add(other, self) do
    add(other, [], self)
  end

  @spec add(v, c, t) :: t
  def add(other, context, self) do
    from(:decimal.add(from(self).internal, from(other).internal, context))
  end

  @spec subtract(v, t) :: t
  def subtract(other, self) do
    subtract(other, [], self)
  end

  @spec subtract(v, c, t) :: t
  def subtract(other, context, self) do
    from(:decimal.subtract(from(self).internal, from(other).internal, context))
  end

  @spec multiply(v, t) :: t
  def multiply(other, self) do
    multiply(other, [], self)
  end

  @spec multiply(v, c, t) :: t
  def multiply(other, context, self) do
    from(:decimal.multiply(from(self).internal, from(other).internal, context))
  end

  @spec divide(v, t) :: t
  def divide(other, self) do
    divide(other, [], self)
  end

  @spec divide(v, c, t) :: t
  def divide(other, context, self) do
    from(:decimal.divide(from(self).internal, from(other).internal, context))
  end

  @spec remainder(v, t) :: t
  def remainder(other, self) do
    remainder(other, [], self)
  end

  @spec remainder(v, c, t) :: t
  def remainder(other, context, self) do
    from(:decimal.remainder(from(self).internal, from(other).internal, context))
  end

  @spec exp(t) :: t
  def exp(self) do
    exp([], self)
  end

  @spec exp(c, t) :: t
  def exp(context, self) do
    from(:decimal.exp(from(self).internal, context))
  end

  @spec ln(t) :: t
  def ln(self) do
    ln([], self)
  end

  @spec ln(c, t) :: t
  def ln(context, self) do
    from(:decimal.ln(from(self).internal, context))
  end

  @spec log10(t) :: t
  def log10(self) do
    log10([], self)
  end

  @spec log10(c, t) :: t
  def log10(context, self) do
    from(:decimal.log10(from(self).internal, context))
  end

  @spec power(v, t) :: t
  def power(other, self) do
    power(other, [], self)
  end

  @spec power(v, c, t) :: t
  def power(other, context, self) do
    from(:decimal.power(from(self).internal, from(other).internal, context))
  end

  @spec sqrt(t) :: t
  def sqrt(self) do
    sqrt([], self)
  end

  @spec sqrt(c, t) :: t
  def sqrt(context, self) do
    from(:decimal.sqrt(from(self).internal, context))
  end

  @spec max(v, v) :: t
  def max(self, other) do
    max(self, other, [])
  end

  @spec max(v, v, c) :: t
  def max(self, other, context) do
    from(:decimal.max(from(self).internal, from(other).internal, context))
  end

  @spec min(v, v) :: t
  def min(self, other) do
    min(self, other, [])
  end

  @spec min(v, v, c) :: t
  def min(self, other, context) do
    from(:decimal.min(from(self).internal, from(other).internal, context))
  end

  @spec reduce(t) :: t
  def reduce(self) do
    reduce([], self)
  end

  @spec reduce(c, t) :: t
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
  @spec to_decimal(any) :: Decimal.t
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
