module Yarlisp
    module Core
        def ATOM(x)
            (x.is_a? Array) ? :NIL : :T
        end

        def EQ(x, y)
            return :T if x.eql?(y)
            return :NIL
        end

        def CAR(x)
            raise('Undefined') if (ATOM x) == :T
            return :NIL if x.empty?
            x[0]
        end

        def CDR(x)
            raise('Undefined') if (ATOM x) == :T
            return :NIL if x.empty?
            x[1]
        end

        def CONS(x, y)
            [x, y]
        end

        def EVAL(expr, env)
            def equal(a, b)
                if ((ATOM a) == :T) && ((ATOM b) == :T)
                    (EQ a, b)
                elsif ((ATOM a) == :NIL) && ((ATOM b) == :NIL)
                    (equal (CAR a), (CAR b)) && (equal (CDR a), (CDR b))
                else
                    :NIL
                end
            end
            def null(val)
                return :T if ((ATOM val) == :T) && ((EQ val, :NIL) == :T)
                return :NIL
            end
            def assoc(x, a)
                if (equal (CAR (CAR a)), x) == :T
                    (CDR (CAR a))
                else
                    (assoc x, (CDR a))
                end
            end
            def cond(x, a)
                condition = (EVAL (CAR (CAR x)), a)
                if (EQ condition, :NIL) == :T
                    (cond (CDR x), a)
                else
                    (EVAL (CAR (CDR (CAR x))), a)
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
                    (cond args, env)
                else
                    (EVAL (CONS (assoc fn, env), args), env)
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

