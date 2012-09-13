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

        def COND(*clauses)
            clauses.each do |pe|
                p, e = pe
                if p.call != :NIL
                    return e.call
                end
            end
        end

        def EVAL(expr, env)
            def null(val)
                (EQ val, :NIL)
            end
            def assoc(x, a)
                (COND [lambda{(EQ (CAR (CAR a)), x)},
                       lambda{(CDR (CAR a))}],
                       [lambda{:T},
                        lambda{(assoc x, (CDR a))}])
            end
            def evcon(c, a)
                (COND [lambda{(EVAL (CAR (CAR c)), a)},
                       lambda{(EVAL (CAR (CDR (CAR c))), a)}],
                       [lambda{:T}, lambda{(evcon (CDR c), a)}])
            end
            def eval_list(m, a)
                (COND [lambda{(null m)}, lambda{:NIL}],
                 [lambda{:T}, lambda{
                    (CONS (EVAL (CAR m), a), (eval_list (CDR m), a))
                }])
            end
            def yar_not(x)
                (COND [lambda{(null x)}, lambda{:T}],
                 [lambda{:T}, lambda{:NIL}])
            end
            def yar_and(x, y)
                (COND [lambda{x}, 
                       lambda{
                    (COND [lambda{y}, lambda{:T}], [lambda{:T}, lambda{:NIL}])}],
                    [lambda{:T}, lambda{:NIL}])
            end
            def pair(x, y)
                (COND [lambda{(yar_and (null x), (null y))},
                       lambda{:NIL}],
                       [lambda{(yar_and (yar_not (ATOM x)), (yar_not (ATOM x)))},
                        lambda{
                           (CONS (CONS (CAR x), (CAR y)), (pair (CDR x), (CDR y)))
                       }])
            end
            def append(x, y)
                (COND [lambda{(null x)}, lambda{y}],
                 [lambda{:T}, lambda{
                    (CONS (CAR x), (append (CDR x), y))
                }])
            end

            if (ATOM expr) == :T
                return (assoc expr, env)
            else
                if (ATOM (CAR expr)) == :T
                    fn=(CAR expr)
                    args=(CDR expr)

                    if (EQ fn, :QUOTE) == :T
                        return (CAR args)
                    else
                        if (EQ fn, :ATOM) == :T
                            return (ATOM (EVAL (CAR args), env))
                        else
                            if (EQ fn, :EQ) == :T
                                return (EQ (EVAL (CAR args), env),
                                        (EVAL (CAR (CDR args)), env))
                            else
                                if (EQ fn, :CAR) == :T
                                    return (CAR (EVAL (CAR args), env))
                                else
                                    if (EQ fn, :CDR) == :T
                                        return (CDR (EVAL (CAR args), env))
                                    else
                                        if (EQ fn, :CONS) == :T
                                            return (CONS (EVAL (CAR args), env),
                                                    (EVAL (CAR (CDR args)), env))
                                        else
                                            if (EQ fn, :COND) == :T
                                                return (evcon args, env)
                                            else
                                                return (EVAL (CONS (assoc fn, env), args), env)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    if (EQ (CAR (CAR expr)), :LABEL) == :T
                        return (EVAL (CONS (CAR (CDR (CDR (CAR expr)))), (CDR expr)),
                                (CONS (CONS (CAR (CDR (CAR expr))), (CAR expr)), env))
                    else
                        if (EQ (CAR (CAR expr)), :LAMBDA) == :T
                            return (EVAL (CAR (CDR (CDR (CAR expr)))),
                                    (append (pair (CAR (CDR (CAR expr))), (eval_list (CDR expr), env)), env))
                        end
                    end
                end
                return :NIL
            end
        end
    end
end

