module Yarlisp
    module Core
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
                    (EQ a, b)
                elsif !(ATOM a) && !(ATOM b)
                    (equal (CAR a), (CAR b)) && (equal (CDR a), (CDR b))
                else
                    :NIL
                end
            end
            def null(val)
                (ATOM val) && (EQ val, :NIL)
            end
            def assoc(x, a)
                if (equal (CAR (CAR a)), x)
                    (CDR (CAR a))
                else
                    (assoc x, (CDR a))
                end
            end
            def cond(x, a)
                condition = (EVAL (CAR (CAR x)), a)
                if (condition == false || (EQ condition, :NIL))
                    (cond (CDR x), a)
                else
                    (EVAL (CAR (CDR (CAR x))), a)
                end
            end
            def eval_list(m, a)
                if (null m) 
                    :NIL
                else
                    (CONS (EVAL (CAR m), a), (eval_list (CDR m), a))
                end
            end

            if (ATOM expr)
                (assoc expr, env)
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
                    (CAR (EVAL (CAR args), env))
                elsif (EQ fn, :CDR)
                    (CDR (EVAL (CAR args), env))
                elsif (EQ fn, :CONS)
                    (CONS (EVAL (CAR args), env),
                     (EVAL (CAR (CDR args)), env))
                elsif (EQ fn, :COND)
                    (cond args, env)
                else
                    (EVAL (CONS (assoc fn, env), (eval_list args, env)), env)
                end
            else
                if (EQ (CAR (CAR expr)), :LABEL)
                    (EVAL (CONS (CAR (CDR (CDR (CAR expr)))), (CDR expr)),
                     (CONS (CONS (CAR (CDR (CAR expr))), (CAR expr)), env))
                elsif (EQ (CAR (CAR expr)), :LAMBDA)
                    def pair(x, y)
                        return :NIL if (null x) and (null y)
                        if !(ATOM x) and !(ATOM y)
                            (CONS (CONS (CAR x), (CAR y)), (pair (CDR x), (CDR y)))
                        end
                    end
                    def append(x, y)
                        return y if (null x)
                        (CONS (CAR x), (append (CDR x), y))
                    end

                    (EVAL (CAR (CDR (CDR (CAR expr)))),
                     (append (pair (CAR (CDR (CAR expr))), (eval_list (CDR expr), env)), env))
                end
            end
        end
    end
end

