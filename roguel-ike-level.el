;;; level.el --- Contains the data structures relative to levels

;;; Commentary:

;;; Code:
(require 'eieio)
(require 'roguel-ike-entity)

(defclass rlk--level-cell ()
  ((type :initarg :type
         :accessor get-type
         :writer set-type
         :type symbol
         :protection :protected
         :documentation "The intrinsic type of the cell
e.g. wall, ground, etc...")
   (lit :initform nil
        :type boolean
        :accessor is-lit-p
        :write set-lit
        :protection private
        :documentation "Tells wether the cell is lit or not.")
   (grid :initarg :grid
          :accessor get-grid
          :type rlk--level-grid
          :protection :private
          :documentation "The grid,which contains the cell.")
   (x :initarg :x
      :accessor get-x
      :type integer
      :protection :private
      :documentation "The horizontal position of the cell in the grid.")
   (y :initarg :y
      :accessor get-y
      :type integer
      :protection :private
      :documentation "The vertical position of the cell in the grid."))
  "A class representing a level's cell")

(defmethod get-neighbour ((cell rlk--level-cell) dx dy)
  "Return the cell at position (x + dx, y + dy), or nil if it does not exists."
  (get-cell-at (get-grid cell) (+ (get-x cell) dx) (+ (get-y cell) dy)))

(defmethod is-accessible ((cell rlk-level-cell))
  "Returns t if the cell can be the destination of an entity, nil otherwise."
  nil)

(defclass rlk--level-cell-groud (rlk--level-cell)
  ((type :initform :ground
         :protection :protected)
   (entity :initform nil
           :accessor get-entity
           :writer set-entity
           :type (or rlk--entity boolean)
           :protection :private
           :documentation "The game entity currently on the cell."))
  "A ground cell")

(defmethod has-entity-p ((cell rlk--level-cell-ground))
  "Return `t' if the cell contains an entity, nil otherwise"
  (rlk--entity-child-p (get-entity cell)))

(defmethod is-accessible ((cell rlk-level-cell-ground))
  "Return t if cell is empty, nil otherwise."
  (not (has-entity-p cell)))

(defclass rlk--level-grid ()
  ((cells :initarg :cells
          :type list
          :accessor get-cells
          :protection :private
          :documentation "A two-dimensional list of cells"))
  "A two-dimensional grid of cells")

(defmethod width ((grid rlk--level-grid))
  "Return the horizontal number of cells."
  (length (oref grid cells)))

(defmethod height ((grid rlk--level-grid))
  "Return the vertical number of cells."
  (if (eq (width grid) 0)
      0
    (length (car (oref grid cells)))))

(defmethod get-cell-at ((grid rlk--level-grid) x y)
  "Return the cell at position x, y."
  (nth x (nth y (get-cells grid))))

(provide 'roguel-ike-level)
;;; roguel-ike-level.el ends here
