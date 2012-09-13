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
            return :NIL
        end

        def EVAL(e, a)
            def null(val)
                (EQ val, :NIL)
            end
            def assoc(x, a)
                (COND [->{(EQ (CAR (CAR a)), x)},
                       ->{(CDR (CAR a))}],
                       [->{:T},
                        ->{(assoc x, (CDR a))}])
            end
            def evcon(c, a)
                (COND [->{(EVAL (CAR (CAR c)), a)},
                       ->{(EVAL (CAR (CDR (CAR c))), a)}],
                       [->{:T}, ->{(evcon (CDR c), a)}])
            end
            def eval_list(m, a)
                (COND [->{(null m)}, ->{:NIL}],
                 [->{:T}, ->{
                    (CONS (EVAL (CAR m), a), (eval_list (CDR m), a))
                }])
            end
            def yar_not(x)
                (COND [->{(null x)}, ->{:T}],
                 [->{:T}, ->{:NIL}])
            end
            def yar_and(x, y)
                (COND [->{x}, 
                       ->{
                    (COND [->{y}, ->{:T}], [->{:T}, ->{:NIL}])}],
                    [->{:T}, ->{:NIL}])
            end
            def pair(x, y)
                (COND [->{(yar_and (null x), (null y))},
                       ->{:NIL}],
                       [->{(yar_and (yar_not (ATOM x)), (yar_not (ATOM x)))},
                        ->{
                           (CONS (CONS (CAR x), (CAR y)), (pair (CDR x), (CDR y)))
                       }])
            end
            def append(x, y)
                (COND [->{(null x)}, ->{y}],
                 [->{:T}, ->{
                    (CONS (CAR x), (append (CDR x), y))
                }])
            end

            (COND [->{(ATOM e)}, 
                   ->{(assoc e, a)
            }],
            [->{(ATOM (CAR e))},
             ->{(COND [->{(EQ (CAR e), :QUOTE)}, 
                       ->{(CAR (CDR e))}],
                       [->{(EQ (CAR e), :ATOM)},
                        ->{(ATOM (EVAL (CAR (CDR e)), a))}],
                        [->{(EQ (CAR e), :EQ)},
                         ->{(EQ (EVAL (CAR (CDR e)), a), (EVAL (CAR (CDR (CDR e))), a))}],
                         [->{(EQ (CAR e), :CAR)},
                          ->{(CAR (EVAL (CAR (CDR e)), a))}],
                          [->{(EQ (CAR e), :CDR)},
                           ->{(CDR (EVAL (CAR (CDR e)), a))}],
                           [->{(EQ (CAR e), :CONS)},
                            ->{(CONS (EVAL (CAR (CDR e)), a), (EVAL (CAR (CDR (CDR e))), a))}],
                            [->{(EQ (CAR e), :COND)},
                             ->{(evcon (CDR e), a)}],
                             [->{:T},
                              ->{(EVAL (CONS (assoc (CAR e), a), (CDR e)), a)}])
            }],
            [->{(EQ (CAR (CAR e)), :LABEL)},
             ->{(EVAL (CONS (CAR (CDR (CDR (CAR e)))), (CDR e)),
                 (CONS (CONS (CAR (CDR (CAR e))), (CAR e)), a))
            }],
            [->{(EQ (CAR (CAR e)), :LAMBDA)},
             ->{(EVAL (CAR (CDR (CDR (CAR e)))),
                 (append (pair (CAR (CDR (CAR e))), 
                          (eval_list (CDR e), a)), a))}])
        end
    end
end

