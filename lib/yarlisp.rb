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
        raise("Undefined") if ATOM(x)
        x[0]
    end

    def CDR(x)
        raise('Undefined') if ATOM(x)
        x[1]
    end

    def CONS(x, y)
        [x, y]
    end

    def EVAL(expr, env)
        def equal(a, b)
            if (ATOM a) && (ATOM b)
                a.eql? b
            elsif (equal (CAR a), (CAR b))
                (equal (CDR a), (CDR b)) 
            else
                false
            end
        end
        def assoc(x, a)
            if (equal (CAR (CAR a)), x)
                (CAR a)
            else
                (assoc x, (CDR a))
            end
        end

        if (ATOM expr)
            (CDR (assoc expr, env))
        elsif (EQ (CAR expr), :QUOTE)
            (CAR (CDR expr))
        elsif (EQ (CAR expr), :ATOM)
            (ATOM (EVAL (CAR (CDR expr)), env))
        elsif (EQ (CAR expr), :EQ)
            (EQ (EVAL (CAR (CDR expr)), env),
             (EVAL (CAR (CDR (CDR expr))), env))
        else
            :NIL
        end
    end
end
