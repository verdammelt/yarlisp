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
        (CAR [:x, :y]).should eq :x
        (CAR [[:x, :y], :z]).should eq [:x, :y]
        expect { (CAR :x) }.to raise_error('Undefined')
    end

    it "cdr" do
        (CDR [:x, :y]).should eq :y
        (CDR [[:x, :y], :z]).should eq :z
        expect { (CDR :x) }.to raise_error('Undefined')
    end

    it "cons" do
        (CONS :x, :y).should eq [:x, :y]
        (CONS [:x, :y], :z).should eq [[:x, :y], :z]
    end

    it "relationship of car, cdr and cons" do
        (CAR(CONS :x, :y)).should eq :x
        (CDR(CONS :x, :y)).should eq :y

        x = [:x, :y]
        (CONS(CAR(x), CDR(x))).should eq x
    end

    context "eval" do
        it "looks up atom in environment" do
            (EVAL :x, [[:x, :y]]).should eq :y
            (EVAL :x, [[:y, :a], [[:x, :b], :NIL]]).should eq :b
        end

        it "handles QUOTE function" do
            (EVAL [:QUOTE, [:x, :NIL]], []).should eq :x
        end

        it "handles ATOM function" do
            (EVAL [:ATOM, [:x, :NIL]], [[:x, :y]]).should be_true
            (EVAL [:ATOM, [:x, :NIL]], [[:x, [:a, :b]]]).should_not be_true
        end

        it "handles EQ function" do
            (EVAL [:EQ, [:x, [:y, :NIL]]], [[:x, :a], [[:y, :a], :NIL]]).should be_true
            (EVAL [:EQ, [:x, [:y, :NIL]]], [[:x, :a], [[:y, :b], :NIL]]).should_not be_true
        end
    end


end
