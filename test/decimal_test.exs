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
    assert to_decimal(-1).multiply("Infinity").infinite?
    assert to_decimal(-1).multiply("Infinity").negative?
    assert to_decimal(-1).multiply(0).zero?
    assert to_decimal(-1).multiply(0).negative?
    assert to_decimal("1.20").multiply(3).equal?("3.60")
    assert to_decimal(7).multiply(3).equal?(21)
    assert to_decimal("0.9").multiply("0.8").equal?("0.72")
    assert to_decimal("0.9").multiply("-0").zero?
    assert to_decimal("0.9").multiply("-0").negative?
    assert to_decimal(654321).multiply(654321).equal?("4.28135971E+11")
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

  test "remainder" do
    assert to_decimal(1).remainder(1).zero?
    assert to_decimal("2.1").remainder(3).equal?("2.1")
    assert to_decimal(10).remainder(3).equal?(1)
    assert to_decimal(-10).remainder(3).equal?(-1)
    assert to_decimal("10.2").remainder(1).equal?("0.2")
    assert to_decimal(10).remainder("0.3").equal?("0.1")
    assert to_decimal("3.6").remainder("1.3").equal?(1)
  end

  test "abs" do
    assert to_decimal("2.1").abs.equal?("2.1")
    assert to_decimal(-100).abs.equal?(100)
    assert to_decimal("101.5").abs.equal?("101.5")
    assert to_decimal("-101.5").abs.equal?("101.5")
  end

  test "exp" do
    assert to_decimal("-Infinity").exp.zero?
    assert to_decimal(-1).exp.equal?("0.367879441")
    assert to_decimal(0).exp.equal?(1)
    assert to_decimal(1).exp.equal?("2.71828183")
    assert to_decimal("0.693147181").exp.equal?(2)
    assert to_decimal("Infinity").exp.infinite?
    assert to_decimal("Infinity").exp.positive?
  end

  test "ln" do
    assert to_decimal(0).ln.infinite?
    assert to_decimal(0).ln.negative?
    assert to_decimal(1).ln.zero?
    assert to_decimal("2.71828183").ln.equal?(1)
    assert to_decimal(10).ln.equal?("2.30258509")
    assert to_decimal("Infinity").ln.infinite?
    assert to_decimal("Infinity").ln.positive?
  end

  test "log10" do
    assert to_decimal(0).log10.infinite?
    assert to_decimal(0).log10.negative?
    assert to_decimal("0.001").log10.equal?(-3)
    assert to_decimal("1.000").log10.zero?
    assert to_decimal(2).log10.equal?("0.301029996")
    assert to_decimal(10).log10.equal?(1)
    assert to_decimal(70).log10.equal?("1.84509804")
    assert to_decimal("Infinity").infinite?
    assert to_decimal("Infinity").positive?
  end

  test "power" do
    assert to_decimal(2).power(3).equal?(8)
    assert to_decimal(-2).power(3).equal?(-8)
    assert to_decimal(2).power(-3).equal?("0.125")
    assert to_decimal("1.7").power(8).equal?("69.7575744")
    assert to_decimal(10).power("0.301029996").equal?(2)
    assert to_decimal("Infinity").power(-1).zero?
    assert to_decimal("Infinity").power(0).equal?(1)
    assert to_decimal("Infinity").power(1).infinite?
    assert to_decimal("-Infinity").power(-1).zero?
    assert to_decimal("-Infinity").power(0).equal?(1)
    assert to_decimal("-Infinity").power(1).infinite?
    assert to_decimal("-Infinity").power(1).negative?
    assert to_decimal("-Infinity").power(2).infinite?
    assert to_decimal("-Infinity").power(2).positive?
    assert to_decimal(0).power(0).nan?
  end

  test "sqrt" do
    assert to_decimal(0).sqrt.zero?
    assert to_decimal(0).sqrt.positive?
    assert to_decimal("-0").sqrt.zero?
    assert to_decimal("-0").sqrt.negative?
    assert to_decimal("0.39").sqrt.equal?("0.624499800")
    assert to_decimal(100).sqrt.equal?(10)
    assert to_decimal(1).sqrt.equal?(1)
    assert to_decimal(7).sqrt.equal?("2.64575131")
    assert to_decimal(10).sqrt.equal?("3.16227766")
  end

  test "reduce" do
    assert to_binary(to_decimal("2.1").reduce) == "2.1"
    assert to_binary(to_decimal("1.200").reduce) == "1.2"
    assert to_binary(to_decimal("-120").reduce) == "-1.2E+2"
    assert to_binary(to_decimal("120.00").reduce) == "1.2E+2"
    assert to_binary(to_decimal("0.00").reduce) == "0"
  end

  test "max" do
    assert Decimal.max(3, 2).equal?(3)
    assert Decimal.max(-10, 3).equal?(3)
    assert Decimal.max("1.0", 1).equal?(1)
    assert Decimal.max(7, "NaN").equal?(7)
  end

  test "min" do
    assert Decimal.min(3, 2).equal?(2)
    assert Decimal.min(-10, 3).equal?(-10)
    assert Decimal.min("1.0", 1).equal?(1)
    assert Decimal.min(7, "NaN").equal?(7)
  end
end
