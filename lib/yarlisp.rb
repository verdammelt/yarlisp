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
            elsif !(ATOM a) && !(ATOM b)
                (equal (CAR a), (CAR b)) && (equal (CDR a), (CDR b))
            else
                false
            end
        end
        def null(val)
            (equal val, :NIL)
        end
        def assoc(x, a)
            if (equal (CAR (CAR a)), x)
                (CAR a)
            else
                (assoc x, (CDR a))
            end
        end
        def cond(x, a)
            condition = (EVAL (CAR (CAR x)), a)
            if (!(null condition))
                (EVAL (CAR (CDR (CAR x))), a)
            else
                (cond (CDR x), a)
            end
        end

        def evlis(m, a)
            if (null m) 
                :NIL
            else
                (CONS (EVAL (CAR m), a), (evlis (CDR m), a))
            end
        end

        puts "(EVAL #{expr} #{env})"

        if (ATOM expr)
            (CDR (assoc expr, env))
        elsif (ATOM (CAR expr))
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
            elsif (EQ fn, :COND)
                (cond args, env)
            else
                (EVAL (CONS (CDR (assoc fn, env)), (evlis args, env)), env)
            end
        else
            if (EQ (CAR (CAR expr)), :LABEL)
                (EVAL (CONS (CAR (CDR (CDR (CAR expr)))), (CDR expr)),
                    (CONS (CONS (CAR (CDR (CAR expr))), (CAR expr)), :NIL))
            end
        end
    end
end

