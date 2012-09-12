module Yarlisp
    module Core
        def ATOM(x)
            (x.is_a? Array) ? :NIL : :T
        end

        def EQ(x, y)
            x.eql?(y) ? :T : :NIL
        end

        def CAR(x)
            raise('Undefined') if (ATOM x) == :T
            x.empty? ? :NIL : x[0]
        end

        def CDR(x)
            raise('Undefined') if (ATOM x) == :T
            x.empty? ? :NIL : x[1]
        end

        def CONS(x, y)
            [x, y]
        end

        def EVAL(expr, env)
            def null(val)
                (EQ val, :NIL)
            end
            def assoc(x, a)
                if (EQ (CAR (CAR a)), x) == :T
                    (CDR (CAR a))
                else
                    (assoc x, (CDR a))
                end
            end
            def evcon(x, a)
                if (EQ (EVAL (CAR (CAR x)), a), :NIL) == :NIL
                    (EVAL (CAR (CDR (CAR x))), a)
                else
                    (evcon (CDR x), a)
                end
            end
            def eval_list(m, a)
                if (null m) == :T
                    :NIL
                else
                    (CONS (EVAL (CAR m), a), (eval_list (CDR m), a))
                end
            end
            def yar_not(x)
                if (null x) == :T
                    return :T
                else
                    return :NIL
                end
            end
            def yar_and(x, y)
                if (x == :T)
                    if (y == :T)
                        return :T
                    else
                        return :NIL
                    end
                else
                    return :NIL
                end
            end
            def pair(x, y)
                if (yar_and (null x), (null y)) == :T
                    return :NIL
                else
                    if (yar_and (yar_not (ATOM x)), (yar_not (ATOM y)))
                        return (CONS (CONS (CAR x), (CAR y)), (pair (CDR x), (CDR y)))
                    end
                end
            end
            def append(x, y)
                if (null x) == :T
                    return y
                else
                    (CONS (CAR x), (append (CDR x), y))
                end
            end


            if (ATOM expr) == :T
                (assoc expr, env)
            elsif (ATOM (CAR expr)) == :T
                fn=(CAR expr)
                args=(CDR expr)

                if (EQ fn, :QUOTE) == :T
                    (CAR args)
                elsif (EQ fn, :ATOM) == :T
                    (ATOM (EVAL (CAR args), env))
                elsif (EQ fn, :EQ) == :T
                    (EQ (EVAL (CAR args), env),
                     (EVAL (CAR (CDR args)), env))
                elsif (EQ fn, :CAR) == :T
                    (CAR (EVAL (CAR args), env))
                elsif (EQ fn, :CDR) == :T
                    (CDR (EVAL (CAR args), env))
                elsif (EQ fn, :CONS) == :T
                    (CONS (EVAL (CAR args), env),
                     (EVAL (CAR (CDR args)), env))
                elsif (EQ fn, :COND) == :T
                    (evcon args, env)
                else
                    (EVAL (CONS (assoc fn, env), args), env)
                end
            else
                if (EQ (CAR (CAR expr)), :LABEL) == :T
                    (EVAL (CONS (CAR (CDR (CDR (CAR expr)))), (CDR expr)),
                     (CONS (CONS (CAR (CDR (CAR expr))), (CAR expr)), env))
                elsif (EQ (CAR (CAR expr)), :LAMBDA) == :T
                    (EVAL (CAR (CDR (CDR (CAR expr)))),
                     (append (pair (CAR (CDR (CAR expr))), (eval_list (CDR expr), env)), env))
                end
            end
        end
    end
end

