;create an array as game board(ex #(z nil nil nil .... ))
(defun initial_state ()
(setf board (make-array '(17)))
;first index (board[0] = 'z) 
;just make easy count in program (ex: 1 2 3 .. 16 as position of the game board)
(setf (aref board 0) 'z)
)

;human always moves first, so the game board size can tell the player turn's
(defun player (board)
(setq size (board_size board))
(if (eq (mod size 2) 0) (ai_turn) (human_turn) )
)

;passes the game board, and it return the size 
(defun board_size (board)
(setq size 0)
(loop for i from 0 to 16
    do(setf temp(aref board i))
    (if (not (eq nil temp)) (setq size (+ size 1)) )
)
(return-from board_size size)
)

;call this function for human turn's
;asks position for the move, and makes a moves for human
(defun human_turn ()
(terpri)
(princ "human_turn")
(terpri)
(princ "Pick a position for move: ")
(setq position_picked (read))
;if user picked not empty position(illegal move)
;ask user to pick the position again
(cond 
((eq t (is_empty board position_picked)) (result board position_picked 'x) )
(t (human_turn ))
)
)

;call this function for AI turn's
;use minimax algorithm to calculate the best move for AI
(defun ai_turn ()
(terpri)
(princ "ai_turn")
(setf bestmove (minimax board))
(result board bestmove 'o)
)

;global variable for alpha and beta
;this value will update during the recursion
(setf alpha -2)
(setf beta 2)

;alpha_beta_search algorithm
;this function gives the best move for AI
;by calling alternatively min_value and max_value (recursion)

(defun minimax (board)
(setf best_move 0)
(setf minimax_score 2)
(loop for i from 1 to 16
    do
    (cond
    ( (eq t (is_empty board i))
    (setf temp_score (max_value (result board i 'o) -2 2) ) ;set alpha -infinity || beta +infinity
    (cond
    ((< temp_score minimax_score) (setf minimax_score temp_score) (setf best_move i))
    )
    (result board i nil)
    (if(<= minimax_score alpha) (return-from minimax best_move))
    (setf beta (min beta minimax_score))
    ) )  
)
(return-from minimax best_move)
)

;return the utility value if the game is over(win,lose,tie)
;otherwise get max score by calling 'min_value' function recursive
(defun max_value (board alpha beta)
(cond
((eq t (terminal_test board)) (return-from max_value (utility board)))
)
(setf max_score -2)
(loop for i from 1 to 16
    do
    (cond
    ( (eq t (is_empty board i)) 
    ( setf temp_score (min_value (result board i 'x) alpha beta) )
    (setf max_score (max max_score temp_score))
    (result board i nil)
    (if(>= max_score beta) (return-from max_value max_score))
    (setf alpha (max alpha max_score))
    ) )
)
(return-from max_value max_score)
)

;turn the utility value if the game is over(win,lose,tie)
;otherwise get min score by calling 'max_value' function recursive
(defun min_value (board alpha beta)
(cond
((eq t (terminal_test board)) (return-from min_value (utility board)))
)
(setf min_score 2)
(loop for i from 1 to 16
    do
    (cond
    ( (eq t (is_empty board i))
    ( setf temp_score (max_value (result board i 'o) alpha beta) )
    (setf min_score (min min_score temp_score))
    (result board i nil)
    (if(<= min_score alpha) (return-from min_value min_score))
    (setf beta (min beta min_score))
    ) )  
)
(return-from min_value min_score)
)

;if the game is over, return utility value
;if the game is tie, return zero '0'
;if AI win, return '-1'
;if human win, return '1'
(defun utility (board)
    ;according the game board, it decides who turns ( ai; 'o' or human; 'x')
    (cond
    ((eq (mod (board_size board) 2) 0) (setf turn 'x))
    (t (setf turn 'o))
    )
    (cond 
    ((eq nil (is_space board)) (return-from utility 0))
    ((eq t (is_winning board 'o)) (if (eq 'o turn) (return-from utility -1) (return-from utility +1)) )
    ((eq t (is_winning board 'x)) (if (eq 'x turn) (return-from utility +1) (return-from utility -1)) )
    )
)

;helper function, make sure the move is legal move
;if the posion is not nil (not empty/can't make move), return nil
;otherwise return t
(defun is_empty (board position)
(if (eq nil (aref board position)) t nil )
)

;according to the game board, it finds all possible legal moves
; *** not using in this assignment, only for future upgrade
(defun action (board)
(setq actions(make-array 16 :fill-pointer 0))
(loop for i from 1 to 16
    do(setf temp (aref board i))
    (cond
    ((eq nil temp) (vector-push i actions))
    )
)
(return-from action actions)
)

;a transition, make a move and update the game board
(defun result (board position turn)
(setf (aref board position) turn)
board
)

;return t, if the game is ending(either AI/human win or the game is tie)
;if it is ending, return t
;otherwise return nil
(defun terminal_test (board)
(cond 
((eq nil (is_space board)) (return-from terminal_test t) )
((eq t (is_winning board 'x)) (return-from terminal_test t) )
((eq t (is_winning board 'o)) (return-from terminal_test t) )
(t nil)
)
)

;if the game board is full, return nil
;otherwise return t
(defun is_space (board)
(setq empty_space 0)
(loop for i from 1 to 16
    do (setf temp (aref board i))
    (if (eq nil temp) (setq empty_space (+ empty_space 1)) )
)
(cond
((> empty_space 0) (return-from is_space t))
(t nil)
)
)

;check the winning status for both AI and human player
(defun is_winning (board xoro)
(cond 
( (and (eq (aref board 1) xoro) (eq (aref board 2) xoro) (eq (aref board 3) xoro) (eq (aref board 4) xoro)) 
(return-from is_winning t) )
( (and (eq (aref board 5) xoro) (eq (aref board 6) xoro) (eq (aref board 7) xoro) (eq (aref board 8) xoro)) 
(return-from is_winning t) )
( (and (eq (aref board 9) xoro) (eq (aref board 10) xoro) (eq (aref board 11) xoro) (eq (aref board 12) xoro)) 
(return-from is_winning t) )
( (and (eq (aref board 13) xoro) (eq (aref board 14) xoro) (eq (aref board 15) xoro) (eq (aref board 16) xoro)) 
(return-from is_winning t) ) 

( (and (eq (aref board 1) xoro) (eq (aref board 5) xoro) (eq (aref board 9) xoro) (eq (aref board 13) xoro)) 
(return-from is_winning t) )
( (and (eq (aref board 2) xoro) (eq (aref board 6) xoro) (eq (aref board 10) xoro) (eq (aref board 14) xoro)) 
(return-from is_winning t) )
( (and (eq (aref board 3) xoro) (eq (aref board 7) xoro) (eq (aref board 11) xoro) (eq (aref board 15) xoro)) 
(return-from is_winning t) )
( (and (eq (aref board 4) xoro) (eq (aref board 8) xoro) (eq (aref board 12) xoro) (eq (aref board 16) xoro)) 
(return-from is_winning t) )

( (and (eq (aref board 1) xoro) (eq (aref board 6) xoro) (eq (aref board 11) xoro) (eq (aref board 16) xoro)) 
(return-from is_winning t) )
( (and (eq (aref board 4) xoro) (eq (aref board 7) xoro) (eq (aref board 10) xoro) (eq (aref board 13) xoro)) 
(return-from is_winning t) )

(t nil)
)
)

;print the game board
;and also print the (winning or draw status) if the game is over
(defun print_board (array)
(terpri)
(princ " ")
(if (eq nil (aref array 1)) (princ "1  | ") (write (aref array 1)) )
(if (not (eq nil (aref array 1))) (princ "  | " ) )
(if (eq nil (aref array 2)) (princ "2  | ") (write (aref array 2)) )
(if (not (eq nil (aref array 2))) (princ "  | " ) )
(if (eq nil (aref array 3)) (princ "3  | ") (write (aref array 3)) )
(if (not (eq nil (aref array 3))) (princ "  | " ) )
(if (eq nil (aref array 4)) (princ "4  ") (write (aref array 4)) )
(terpri)
(princ "----+----+----+----")
(terpri)
(princ " ")
(if (eq nil (aref array 5)) (princ "5  | ") (write (aref array 5)) )
(if (not (eq nil (aref array 5))) (princ "  | " ) )
(if (eq nil (aref array 6)) (princ "6  | ") (write (aref array 6)) )
(if (not (eq nil (aref array 6))) (princ "  | " ) )
(if (eq nil (aref array 7)) (princ "7  | ") (write (aref array 7)) )
(if (not (eq nil (aref array 7))) (princ "  | " ) )
(if (eq nil (aref array 8)) (princ "8  ") (write (aref array 8)) )
(terpri)
(princ "----+----+----+----")
(terpri)
(princ " ")
(if (eq nil (aref array 9)) (princ "9  | ") (write (aref array 9)) )
(if (not (eq nil (aref array 9))) (princ "  | " ) )
(if (eq nil (aref array 10)) (princ "10 | ") (write (aref array 10)) )
(if (not (eq nil (aref array 10))) (princ "  | " ) )
(if (eq nil (aref array 11)) (princ "11 | ") (write (aref array 11)) )
(if (not (eq nil (aref array 11))) (princ "  | " ) )
(if (eq nil (aref array 12)) (princ "12 ") (write (aref array 12)) )
(terpri)
(princ "----+----+----+----")
(terpri)
(princ " ")
(if (eq nil (aref array 13)) (princ "13 | ") (write (aref array 13)) )
(if (not (eq nil (aref array 13))) (princ "  | " ) )
(if (eq nil (aref array 14)) (princ "14 | ") (write (aref array 14)) )
(if (not (eq nil (aref array 14))) (princ "  | " ) )
(if (eq nil (aref array 15)) (princ "15 | ") (write (aref array 15)) )
(if (not (eq nil (aref array 15))) (princ "  | " ) )
(if (eq nil (aref array 16)) (princ "16 ") (write (aref array 16)) )
(terpri)

(cond
( (eq t (terminal_test array)) 
(if (eq t (is_winning array 'x)) (princ "x winning") )
(if (eq t (is_winning array 'o)) (princ "o winning") )
(if (and (eq nil (is_winning array 'x)) (eq nil (is_winning array 'o)) (eq nil (is_space board))) (princ "Draw!"))
) )
(terpri)

)

(initial_state )
(print_board board)

(result board 1 'x)
(result board 2 'o)
(result board 3 'x)
(result board 4 'o)

(result board 5 'x)
(result board 6 'o)
(result board 7 'x)
(result board 8 'o)

(result board 12 'x)
(result board 11 'o)
(print_board board)

;looping until the game terminates
(loop while(eq nil (terminal_test board))
    do
    (player board) ;player make alternative trun for human and AI
    (print_board board) ;print the updated game board, and also print the (winning or draw status) if the game is over
)

;still the algorithm takes some time for first AI moves
;these will fill the board for testing
;(result board 1 'x)
;(result board 2 'o)
;(result board 3 'x)
;(result board 4 'o)

;(result board 5 'x)
;(result board 6 'o)
;(result board 7 'x)
;(result board 8 'o)

;(result board 12 'x)
;(result board 11 'o)
;(print_board board)

