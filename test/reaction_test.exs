defmodule ReactionTest do
  use ExUnit.Case

  @formula "NNCS"

  @rules %{
    "CO" => "S",
    "OO" => "N",
    "CS" => "O",
    "NO" => "C",
    "OS" => "C",
    "OC" => "S",
    "ON" => "C",
    "NN" => "C",
    "SO" => "O",
    "NC" => "S",
    "NS" => "S",
    "SN" => "S",
    "SS" => "N",
    "SC" => "S",
    "CC" => "N",
    "CN" => "C",
  }

  test "A" do
    assert 1588 == Reaction.run(@formula, @rules, 10)
  end

  test "B" do
    assert 2_188_189_693_529 == Reaction.run(@formula, @rules, 40)
  end
end
