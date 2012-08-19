require 'yarlisp/reader'

describe "the reader" do
    include Yarlisp::Reader

    it "() => []" do
        read("()").should eq []
    end

    xit "(a) => [:a]" do
        reader ("(a)").shoudl eq [:a]
    end

    xit "(a b) => [:a, [:b, :nil]]" do
    end

    xit "((a) (b c)) => [[:a], [:b, [:c, :nil]]]" do
    end

end
