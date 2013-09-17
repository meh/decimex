#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defrecord Decimal, internal: :decimal_conv.number(0) do
  @moduledoc """
  This module implements a decimal representation and various operations on
  those values.

  A context specifies precision and rounding, `precision: 3` for example tells
  it to use a precision up to 3 decimals.

  Convertible values can be passed to most operations, this means you can do
  `dec.add("3")` instead of `dec.add(Decimal.from("3"))`, the specs specify
  what can be passed and what can't.
  """

  @type i :: { integer, integer, integer } | { integer, atom }
  @type t :: Decimal[internal: i]
  @type c :: [{ :precision, integer } | { :rounding, atom }]
  @type v :: t | i | number | binary | char_list

  @doc """
  Convert a value to a decimal.
  """
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

  @doc """
  Check if the decimal is not a number.
  """
  @spec nan?(t) :: boolean
  def nan?(self) do
    :decimal.is_NaN(from(self).internal)
  end

  @doc """
  Check if the decimal is infinite.
  """
  @spec infinite?(t) :: boolean
  def infinite?(self) do
    :decimal.is_infinite(from(self).internal)
  end

  @doc """
  Check if the decimal is not infinite.
  """
  @spec finite?(t) :: boolean
  def finite?(self) do
    :decimal.is_finite(from(self).internal)
  end

  @doc """
  Check if the decimal is zero.
  """
  @spec zero?(t) :: boolean
  def zero?(self) do
    :decimal.is_zero(from(self).internal)
  end

  @doc """
  Check if the decimal is negative.
  """
  @spec negative?(t) :: boolean
  def negative?(self) do
    :decimal.is_signed(from(self).internal)
  end

  @doc """
  Check if the decimal is positive.
  """
  @spec positive?(t) :: boolean
  def positive?(self) do
    not negative?(self)
  end

  @doc """
  Multiply the decimal with +1
  """
  @spec plus(t) :: t
  def plus(self) do
    plus([], self)
  end

  @doc """
  Multiply the decimal with +1, using a context.
  """
  @spec plus(c, t) :: t
  def plus(context, self) do
    from(:decimal.plus(from(self).internal, context))
  end

  @doc """
  Multiply the decimal with -1.
  """
  @spec minus(t) :: t
  def minus(self) do
    minus([], self)
  end

  @doc """
  Multiply the decimal with -1, using a context.
  """
  @spec minus(c, t) :: t
  def minus(context, self) do
    from(:decimal.minus(from(self).internal, context))
  end

  @doc """
  Return the absolute value of the decimal.
  """
  @spec abs(t) :: t
  def abs(self) do
    abs([], self)
  end

  @doc """
  Return the absolute value of the decimal, using a context.
  """
  @spec abs(c, t) :: t
  def abs(context, self) do
    from(:decimal.abs(from(self).internal, context))
  end

  @doc """
  Compare two decimals, returns `<0` if lesser, `0` if equal, `>0` if greater.
  """
  @spec compare(v, t) :: integer
  def compare(other, self) do
    compare(other, [], self)
  end

  @doc """
  Compare two decimals, returns `<0` if lesser, `0` if equal, `>0` if greater,
  using a context.
  """
  @spec compare(v, c, t) :: integer
  def compare(other, context, self) do
    :decimal.compare(from(self).internal, from(other).internal, context)
  end

  @doc """
  Check if two decimals are equal.
  """
  @spec equal?(v, t) :: boolean
  def equal?(other, self) do
    equal?(other, [], self)
  end

  @doc """
  Check if two decimals are equal, using a context.
  """
  @spec equal?(v, c, t) :: boolean
  def equal?(other, context, self) do
    compare(other, context, self) == 0
  end

  @doc """
  Add two decimals.
  """
  @spec add(v, t) :: t
  def add(other, self) do
    add(other, [], self)
  end

  @doc """
  Add two decimals, using a context.
  """
  @spec add(v, c, t) :: t
  def add(other, context, self) do
    from(:decimal.add(from(self).internal, from(other).internal, context))
  end

  @doc """
  Subtract two decimals.
  """
  @spec subtract(v, t) :: t
  def subtract(other, self) do
    subtract(other, [], self)
  end

  @doc """
  Subtract two decimals, using a context.
  """
  @spec subtract(v, c, t) :: t
  def subtract(other, context, self) do
    from(:decimal.subtract(from(self).internal, from(other).internal, context))
  end

  @doc """
  Multiply two decimals.
  """
  @spec multiply(v, t) :: t
  def multiply(other, self) do
    multiply(other, [], self)
  end

  @doc """
  Multiply two decimals, using a context.
  """
  @spec multiply(v, c, t) :: t
  def multiply(other, context, self) do
    from(:decimal.multiply(from(self).internal, from(other).internal, context))
  end

  @doc """
  Divide two decimals.
  """
  @spec divide(v, t) :: t
  def divide(other, self) do
    divide(other, [], self)
  end

  @doc """
  Divide two decimals, using a context.
  """
  @spec divide(v, c, t) :: t
  def divide(other, context, self) do
    from(:decimal.divide(from(self).internal, from(other).internal, context))
  end

  @doc """
  Get the remainder of the division with two decimals.
  """
  @spec remainder(v, t) :: t
  def remainder(other, self) do
    remainder(other, [], self)
  end

  @doc """
  Get the remainder of the division with two decimals, using a context.
  """
  @spec remainder(v, c, t) :: t
  def remainder(other, context, self) do
    from(:decimal.remainder(from(self).internal, from(other).internal, context))
  end

  @doc """
  Returns the base e exponential of the decimal.
  """
  @spec exp(t) :: t
  def exp(self) do
    exp([], self)
  end

  @doc """
  Returns the base e exponential of the decimal, using a context.
  """
  @spec exp(c, t) :: t
  def exp(context, self) do
    from(:decimal.exp(from(self).internal, context))
  end

  @doc """
  Returns the natural logarithm of the decimal.
  """
  @spec ln(t) :: t
  def ln(self) do
    ln([], self)
  end

  @doc """
  Returns the natural logarithm of the decimal, using a context.
  """
  @spec ln(c, t) :: t
  def ln(context, self) do
    from(:decimal.ln(from(self).internal, context))
  end

  @doc """
  Returns the base 10 logarithm of the decimal.
  """
  @spec log10(t) :: t
  def log10(self) do
    log10([], self)
  end

  @doc """
  Returns the base 10 logarithm of the decimal, using a context.
  """
  @spec log10(c, t) :: t
  def log10(context, self) do
    from(:decimal.log10(from(self).internal, context))
  end

  @doc """
  Returns the power of the decimal of the other decimal.
  """
  @spec power(v, t) :: t
  def power(other, self) do
    power(other, [], self)
  end

  @doc """
  Returns the power of the decimal of the other decimal, using a context.
  """
  @spec power(v, c, t) :: t
  def power(other, context, self) do
    from(:decimal.power(from(self).internal, from(other).internal, context))
  end

  @doc """
  Returns the square root of the decimal.
  """
  @spec sqrt(t) :: t
  def sqrt(self) do
    sqrt([], self)
  end

  @doc """
  Returns the square root of the decimal, using a context.
  """
  @spec sqrt(c, t) :: t
  def sqrt(context, self) do
    from(:decimal.sqrt(from(self).internal, context))
  end

  @doc """
  Returns the greater decimal.
  """
  @spec max(v, v) :: t
  def max(self, other) do
    max(self, other, [])
  end

  @doc """
  Returns the greater decimal, using a context.
  """
  @spec max(v, v, c) :: t
  def max(self, other, context) do
    from(:decimal.max(from(self).internal, from(other).internal, context))
  end

  @doc """
  Returns the lesser decimal.
  """
  @spec min(v, v) :: t
  def min(self, other) do
    min(self, other, [])
  end

  @doc """
  Returns the lesser decimal, using a context.
  """
  @spec min(v, v, c) :: t
  def min(self, other, context) do
    from(:decimal.min(from(self).internal, from(other).internal, context))
  end

  @doc """
  Removes leading zeros from the decimal.
  """
  @spec reduce(t) :: t
  def reduce(self) do
    reduce([], self)
  end

  @doc """
  Removes leading zeros from the decimal, using a context.
  """
  @spec reduce(c, t) :: t
  def reduce(context, self) do
    from(:decimal.reduce(from(self).internal, context))
  end
end

defimpl String.Chars, for: Decimal do
  def to_string(decimal) do
    Kernel.to_string(:decimal.format(decimal.internal))
  end
end

defimpl List.Chars, for: Decimal do
  def to_char_list(decimal) do
    :decimal.format(decimal.internal)
  end
end

defimpl Inspect, for: Decimal do
  def inspect(decimal, _) do
    to_string(decimal)
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
