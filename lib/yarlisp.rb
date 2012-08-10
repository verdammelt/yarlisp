require "yarlisp/version"

module Yarlisp
    def ATOM(x)
        not (x.is_a? Array)
    end

    def EQ(x, y)
        raise('Undefined') unless ATOM(x) && ATOM(y)
        x.eql?(y)
    end

    def CAR(x)
        raise('Undefined') if ATOM(x)
        x[0]
    end

    def CDR(x)
        raise('Undefined') if ATOM(x)
        x[1]
    end
end
