require 'yarlisp/reader'

describe "the reader" do
    include Yarlisp::Reader

    it "a => :a" do
        read("a").should eq :a
    end

    xit "() => []" do
        read("()").should eq []
    end

    xit "(a) => [:a]" do
        reader ("(a)").should eq [:a]
    end

    xit "(a b) => [:a, [:b, :NIL]]" do
        reader("(a b)").should eq [:a, [:b, :NIL]]
    end

    xit "((a) (b c)) => [[:a, :NIL], [[:b, [:c, :NIL]], :NIL]]" do
        reader("((a) (b c))").should eq [[:a, :NIL], [[:b, [:c, :NIL]], :NIL]]
    end

end
