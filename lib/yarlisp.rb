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
        else
            fn=(CAR expr)
            args=(CDR expr)

            if (EQ fn, :QUOTE)
                (CAR args)
            elsif (EQ fn, :ATOM)
                (ATOM (EVAL (CAR args), env))
            elsif (EQ fn, :EQ)
                (EQ (EVAL (CAR args), env),
                 (EVAL (CAR (CDR args)), env))
            elsif (EQ fn, :CAR)
                (EVAL (CAR args), env)
            elsif (EQ fn, :CDR)
                (EVAL (CDR args), env)
            elsif (EQ fn, :CONS)
                (CONS (EVAL (CAR args), env),
                 (EVAL (CAR (CDR args)), env))
            else
                :NIL
            end
        end
    end
end
