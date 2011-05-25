
;; EX 5.21 solution
;; not runnable because it depends on the version of 
;; the regmachine sim that implements list structures
;; directly (cons, car, cdr are machine ops)
(define count-leaves-machine
  (make-machine
	'(tree cont val temp)
	(list (list 'null? null) (list 'pair? pair) (list 'not not))
	'(start
	   (assign cont (label done))
	   cl-begin

	   (test (op null?) (reg tree))
	   (branch (label null-case))

	   (assign temp (op pair?) (reg tree))
	   (test (op not) (reg temp))
	   (branch (label not-pair-case))

	   (save (reg cont))
	   (save (reg tree))
	   (assign tree (op car) (reg tree))
	   (assign cont (label cl-car-after))
	   (goto (label cl-begin))
	   cl-car-after
	   (restore (reg tree))
	   (save (reg tree)) ; keep tree on stack 

	   (assign tree (op cdr (reg tree)))
	   (save (reg val)) ; save val from (count-leaves (car tree))
	   (assign cont (label cl-cdr-after))
	   (goto (label cl-begin))
	   cl-cdr-after
	   (restore (reg temp)) ; get back val of (count-leaves (car tree))
	   (assign val (op +) (reg val) (reg temp))
	   (restore (reg tree))
	   (restore (reg cont))
	   (goto (reg cont))

	   null-case 
	   (assign val (const 0))
	   (goto (reg cont))

	   not-pair-case
	   (assign val (const 1))
	   (goto (reg cont))

	   done)))



