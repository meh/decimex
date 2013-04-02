Code.require_file "../test_helper.exs", __FILE__

defmodule DecimalTest do
  use    ExUnit.Case
  import Decimal.Conversion

  test "creation" do
    assert to_decimal(0).equal?(0)
    assert to_decimal("12").equal?(12)
  end

  test "add" do
    assert to_decimal("Infinity").add(1).infinite?
    assert to_decimal("NaN").add(1).nan?
    assert to_decimal("NaN").add("Infinity").nan?
    assert to_decimal(12).add("7.00").equal?(19)
    assert to_decimal("1e+2").add("1e+4").equal?("1.01e+4")
  end

  test "subtract" do
    assert to_decimal(1).subtract("Infinity").infinite?
    assert to_decimal("-0").subtract(0).zero?
    assert to_decimal("-0").subtract(0).negative?
    assert to_decimal("1.3").subtract("1.07").equal?("0.23")
    assert to_decimal("1.3").subtract("1.30").zero?
    assert to_decimal("1.3").subtract("2.07").equal?("-0.77")
  end

  test "multiply" do

  end

  test "divide" do
    assert to_decimal("1").divide("0").infinite?
    assert to_decimal("1").divide("-0").infinite?
    assert to_decimal("1").divide("-0").negative?
    assert to_decimal("-1").divide("0").infinite?
    assert to_decimal("-1").divide("0").negative?
    assert to_decimal(1).divide(3, precision: 1).equal?("0.3")
    assert to_decimal(5).divide(2).equal?("2.5")
    assert to_decimal(1).divide(10).equal?("0.1")
    assert to_decimal(12).divide(12).equal?(1)
    assert to_decimal("8.00").divide(2).equal?("4.00")
    assert to_decimal("2.400").divide("2.0").equal?("1.200")
    assert to_decimal(1000).divide(100).equal?(10)
    assert to_decimal(1000).divide(1).equal?(1000)
  end
end
