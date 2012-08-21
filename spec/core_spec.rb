require 'yarlisp'

describe "YARLisp" do
    include Yarlisp::Core

    it "atoms" do
        (ATOM :x).should eq :T
        (ATOM [:x, :y]).should eq :NIL
    end

    it "eq" do
        (EQ :x, :x).should eq :T
        (EQ :x, :y).should eq :NIL
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
            (EVAL [:QUOTE, [[:x, :y], :NIL]], []).should eq [:x, :y]
        end

        it "handles ATOM function" do
            (EVAL [:ATOM, [:x, :NIL]], [[:x, :y]]).should eq :T
            (EVAL [:ATOM, [:x, :NIL]], [[:x, [:a, :b]]]).should eq :NIL
        end

        it "handles EQ function" do
            (EVAL [:EQ, [:x, [:y, :NIL]]], [[:x, :a], [[:y, :a], :NIL]]).should eq :T
            (EVAL [:EQ, [:x, [:y, :NIL]]], [[:x, :a], [[:y, :b], :NIL]]).should eq :NIL
        end

        it "handles CAR function" do
            (EVAL [:CAR, [:x, [:y, :NIL]]], [[:x, :a]]).should eq :a
        end

        it "handles CDR function" do
            (EVAL [:CDR, [:x, :y]], [[:y, :a]]).should eq :a
        end

        it "handles CONS function" do
            (EVAL [:CONS, [:x, [:y, :NIL]]], [[:x, :a], [[:y, :b], :NIL]]).should eq [:a, :b]
        end

        it "handles COND function" do
            (EVAL [:COND, [[:x, [:y, :NIL]]]], [[:x, :a], [[:y, :b], :NIL]]).should eq :b
            (EVAL [:COND, [[:x, [:y, :NIL]], [[:z, [:a, :NIL]], :NIL]]],
             [[:x, :NIL], [[:z, :b], [[:a, :c], :NIL]]]).should eq :c
        end

        it "handles recursive evaluation" do
            (EVAL [:x, [:y, [:z, :NIL]]],
             [[:x, :CONS], [[:y, [:QUOTE, [:b, :NIL]]], [[:z, [:QUOTE, [:c, :NIL]]], :NIL]]]).should eq [:b, :c]
        end

        it "handles LABELS function (used to create a binding))" do
            args = [:a, [[:x, [:b, [:c, :NIL]]]]]
            env = [[:a, :m], 
                   [[:b, [:QUOTE, [:n, :NIL]]], 
                    [[:c, [:QUOTE, [:o, :NIL]]], :NIL]]]

            (EVAL [[:LABEL, [:x, [:CONS, :NIL]]], args], env).should eq [:m, [:n, :o]]
        end

        it "handles LAMBDA" do
            (EVAL [[:LAMBDA, [[:x, :NIL], [[:CONS, [:x, [:x, :NIL]]], :NIL]]], 
                   [[:QUOTE, [:a, :NIL]], :NIL]], 
                   []).should eq [:a, :a]
        end
    end

    describe "b0rked COND" do
        xit "second COND test" do
            (EVAL [:COND, [[[:EQ, [:x, [:NIL, :NIL]]], [:y, :NIL]], [[:z, [:a, :NIL]], :NIL]]],
             [[:x, :NIL], [[:z, :b], [[:a, :c], [[:y, :m], :NIL]]]]).should eq :m
        end

        xit "cond is not broken" do
            fn = [:COND, 
                  [[[:ATOM, [:X, :NIL]], [:X, :NIL]], 
                   [[[:QUOTE, [:T, :NIL]], [[:CAR, [:X, :NIL]], :NIL]], :NIL]]]
            #(EVAL fn, [[:X, :A]]).should eq :A
            (EVAL fn, [[:X, [:B, :A]]]).should eq :B
        end
    end

    xit "can handle the ff defintion" do
        # (LABEL, FF, (LAMBDA, (X), (COND, (ATOM, X), X), ((QUOTE, T),(FF, (CAR, X)))))
        fn = [:LABEL,
              [:FF,
               [[:LAMBDA,
                 [[:X, :NIL],
                  [[:COND,
                    [[[:ATOM, [:X, :NIL]], [:X, :NIL]],
                     [[[:QUOTE, [:T, :NIL]], [[:CAR, [:X, NIL]], :NIL]], :NIL]]], :NIL]]], :NIL]]]
        arg = [:QUOTE, [[[[:A, :B], :C], :NIL], :NIL]]
        env = []
        (EVAL [fn, [arg, :NIL]], env).should eq :A
    end
end
