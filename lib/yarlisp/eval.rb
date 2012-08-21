module Yarlisp
    module Core
        def ATOM(x)
            return :NIL if (x.is_a? Array)
            return :T
        end

        def EQ(x, y)
            return :T if x.eql?(y)
            return :NIL
        end

        def CAR(x)
            raise('Undefined') if (ATOM x) == :T
            x[0]
        end

        def CDR(x)
            raise('Undefined') if (ATOM x) == :T
            x[1]
        end

        def CONS(x, y)
            [x, y]
        end

        def EVAL(expr, env)
            def null(val)
                (ATOM val) && (EQ val, :NIL)
            end
            def equal(a, b)
                if (ATOM a) == :T && (ATOM b) == :T
                    (EQ a, b)
                elsif (ATOM a) == :NIL && (ATOM b) == :NIL
                    (equal (CAR a), (CAR b)) && (equal (CDR a), (CDR b))
                else
                    :NIL
                end
            end
            def cond(x, a)
                condition = (EVAL (CAR (CAR x)), a)
                if condition != :NIL
                    (EVAL (CAR (CDR (CAR x))), a)
                else
                    (cond (CDR x), a)
                end
            end
            def assoc(x, a)
                first = (CAR a)
                if (equal (CAR first), x) == :T
                    first
                else
                    (assoc x, (CDR a))
                end
            end
            def eval_list(m, a)
                if (null m) == :T
                    :NIL
                else
                    (CONS (EVAL (CAR m), a), (eval_list (CDR m), a))
                end
            end

            if (ATOM expr) == :T
                (CDR (assoc expr, env))
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
                    (EVAL (CAR args), env)
                elsif (EQ fn, :CDR) == :T
                    (EVAL (CDR args), env)
                elsif (EQ fn, :CONS) == :T
                    (CONS (EVAL (CAR args), env),
                     (EVAL (CAR (CDR args)), env))
                elsif (EQ fn, :COND) == :T
                    (cond args, env)
                else
                    (EVAL (CONS (CDR (assoc fn, env)), (eval_list args, env)), env)
                end
            else
                if (EQ (CAR (CAR expr)), :LABEL) == :T
                    (EVAL (CONS (CAR (CDR (CDR (CAR expr)))), (CDR expr)),
                     (CONS (CONS (CAR (CDR (CAR expr))), (CAR expr)), env))
                elsif (EQ (CAR (CAR expr)), :LAMBDA) == :T
                    def pair(x, y)
                        return :NIL if (null x) == :T and (null y) == :T
                        if (null (ATOM x)) == :T and (null (ATOM y)) == :T
                            (CONS (CONS (CAR x), (CAR y)), (pair (CDR x), (CDR y)))
                        end
                    end
                    def append(x, y)
                        return y if (null x) == :T
                        (CONS (CAR x), (append (CDR x), y))
                    end

                    (EVAL (CAR (CDR (CDR (CAR expr)))),
                     (append (pair (CAR (CDR (CAR expr))), (eval_list (CDR expr), env)), env))
                end
            end
        end
    end
end

