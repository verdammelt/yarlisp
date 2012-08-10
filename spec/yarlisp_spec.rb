require 'yarlisp'

describe "YARLisp" do
    include Yarlisp

    it "atoms" do
        (ATOM :x).should be_true
        (ATOM [:x, :y]).should_not be_true
    end

    it "eq" do
        (EQ :x, :x).should be_true
        (EQ :x, :y).should be_false
        expect { (EQ :x, [:a, :b]) }.to raise_error('Undefined')
    end

    it "car" do
        (CAR [:x, :y]).should be :x
        (CAR [[:x, :y], :z]).should eq [:x, :y]
        expect { (CAR :x) }.to raise_error('Undefined')
    end

    it "cdr" do
        (CDR [:x, :y]).should be :y
        (CDR [[:x, :y], :z]).should be :z
        expect { (CDR :x) }.to raise_error('Undefined')
    end

    it "cons" do
        (CONS :x, :y).should eq [:x, :y]
        (CONS [:x, :y], :z).should eq [[:x, :y], :z]
    end

    it "relationship of car, cdr and cons" do
        (CAR(CONS :x, :y)).should be :x
        (CDR(CONS :x, :y)).should be :y

        x = [:x, :y]
        (CONS(CAR(x), CDR(x))).should eq x
    end
end
