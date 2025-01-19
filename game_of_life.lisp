;;; game_of_life.lisp

(defvar *grid-width* 20)
(defvar *grid-height* 20)
(defvar *game-grid* nil)

(defun copy-list (lst)
  (mapcar 'identity lst))

(defun initialize-empty-grid ()
  (setq *game-grid*
        (mapcar (lambda (_)
                  (make-list *grid-width* nil))
                (make-list *grid-height* nil))))


(defun set-block ()
  (initialize-empty-grid)
  (setf (nth 10 (nth 10 *game-grid*)) t
        (nth 11 (nth 10 *game-grid*)) t
        (nth 10 (nth 11 *game-grid*)) t
        (nth 11 (nth 11 *game-grid*)) t))

(defun set-beehive ()
  (initialize-empty-grid)
  (setf (nth 11 (nth 10 *game-grid*)) t
        (nth 12 (nth 10 *game-grid*)) t
        (nth 10 (nth 11 *game-grid*)) t
        (nth 13 (nth 11 *game-grid*)) t
        (nth 11 (nth 12 *game-grid*)) t
        (nth 12 (nth 12 *game-grid*)) t))

(defun set-blinker ()
  (initialize-empty-grid) 
  (setf (nth 10 (nth 10 *game-grid*)) t
        (nth 10 (nth 11 *game-grid*)) t
        (nth 10 (nth 12 *game-grid*)) t))

(defun set-toad ()
  (initialize-empty-grid) 
  (setf (nth 10 (nth 10 *game-grid*)) t
        (nth 11 (nth 10 *game-grid*)) t
        (nth 12 (nth 10 *game-grid*)) t
        (nth 11 (nth 11 *game-grid*)) t
        (nth 12 (nth 11 *game-grid*)) t
        (nth 13 (nth 11 *game-grid*)) t))

(defun set-beacon ()
  (initialize-empty-grid)
  (setf (nth 10 (nth 10 *game-grid*)) t
        (nth 11 (nth 10 *game-grid*)) t
        (nth 10 (nth 11 *game-grid*)) t
        (nth 11 (nth 11 *game-grid*)) t
        (nth 12 (nth 12 *game-grid*)) t
        (nth 13 (nth 12 *game-grid*)) t
        (nth 12 (nth 13 *game-grid*)) t
        (nth 13 (nth 13 *game-grid*)) t))

(defun set-pulsar ()
  (initialize-empty-grid)
  (let ((coords '((2 4) (2 5) (2 6) (2 10) (2 11) (2 12)
                  (4 2) (5 2) (6 2) (4 7) (5 7) (6 7)
                  (4 9) (5 9) (6 9) (4 14) (5 14) (6 14)
                  (7 4) (7 5) (7 6) (7 10) (7 11) (7 12)
                  (9 4) (9 5) (9 6) (9 10) (9 11) (9 12)
                  (10 2) (11 2) (12 2) (10 7) (11 7) (12 7)
                  (10 9) (11 9) (12 9) (10 14) (11 14) (12 14)
                  (14 4) (14 5) (14 6) (14 10) (14 11) (14 12))))
    (dolist (pos coords)
      (setf (nth (car pos) (nth (cadr pos) *game-grid*)) t))))

(defun set-penta-decathlon ()
  (initialize-empty-grid)
  (let ((coords '((4 5) (5 5) (6 4) (6 6) (7 5) (8 5) 
                  (9 5) (10 5) (11 4) (11 6) (12 5) (13 5))))
    (dolist (pos coords)
      (setf (nth (car pos) (nth (cadr pos) *game-grid*)) t))))

(defun set-glider ()
  (initialize-empty-grid)
  (let ((coords '((1 2) (2 3) (3 1) (3 2) (3 3))))
    (dolist (pos coords)
      (setf (nth (car pos) (nth (cadr pos) *game-grid*)) t))))

(defun set-spaceship ()
  (initialize-empty-grid)
  (let ((coords '((2 1) (2 2) (2 3) (2 4) 
                  (3 0) (3 4)              
                  (4 4)                   
                  (5 0) (5 3))))            
    (dolist (pos coords)
      (setf (nth (car pos) (nth (cadr pos) *game-grid*)) t))))




(defun initialize-grid ()
  (setq *game-grid*
        (mapcar (lambda (_)
                  (mapcar (lambda (_) (zerop (random 2)))
                          (make-list *grid-width* nil)))
                (make-list *grid-height* nil))))



(defun set-pattern (pattern)
  (interactive "SPattern (block, beehive, blinker, toad, beacon, pulsar, penta-decathlon, glider, spaceship): ")
  (cl-case pattern
    ('block (set-block))
    ('beehive (set-beehive))
    ('blinker (set-blinker))
    ('toad (set-toad))
    ('beacon (set-beacon))
    ('pulsar (set-pulsar))
    ('penta-decathlon (set-penta-decathlon))
    ('glider (set-glider))
    ('spaceship (set-spaceship))
    (t (message "Unknown pattern"))))

(defun print-grid ()
  (with-current-buffer (get-buffer-create "*Game of Life*")
    (read-only-mode -1) 
    (erase-buffer) 
    (dolist (row *game-grid*)
      (dolist (cell row)
        (insert (if cell
                    (propertize "█" 'face '(:foreground "green")) 
                  (propertize "█" 'face '(:foreground "black"))))) 
      (insert "\n"))
    (goto-char (point-min))
    (read-only-mode 1))) 

(defun count-live-neighbors (x y)
  (let ((count 0))
    (dotimes (dx 3)
      (dotimes (dy 3)
        (let ((nx (+ x (- dx 1)))
              (ny (+ y (- dy 1))))
          (when (and (not (and (= dx 1) (= dy 1)))
                     (>= nx 0) (< nx *grid-width*)
                     (>= ny 0) (< ny *grid-height*)
                     (nth nx (nth ny *game-grid*)))
            (setq count (1+ count))))))
    count))

(defun update-grid ()
  (let ((new-grid (mapcar 'copy-list *game-grid*)))
    (dotimes (y *grid-height*)
      (dotimes (x *grid-width*)
        (let* ((live-neighbors (count-live-neighbors x y))
               (is-alive (nth x (nth y *game-grid*))))
          (setf (nth x (nth y new-grid))
                (or (and is-alive (member live-neighbors '(2 3)))
                    (and (not is-alive) (= live-neighbors 3)))))))
    (setq *game-grid* new-grid)))

(defun game-of-life-step ()
  (interactive)
  (update-grid)
  (print-grid))

(defun game-of-life-run (steps delay)
  (interactive "nNumber of steps: \nnDelay between steps (seconds): ")
  (dotimes (_ steps)
    (game-of-life-step)
    (sit-for delay))) 

(defun game-of-life ()
  (interactive)
  (initialize-grid)
  (print-grid)
  (message "Use M-x game-of-life-step to advance one step, or M-x game-of-life-run for multiple steps."))
