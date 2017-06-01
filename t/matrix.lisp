(in-package :gamebox-math.test)

(setf *default-test-function* #'equalp)

(plan 166)

(diag "structure")
(let ((*print-pretty* nil))
  (is-type +mid+ '(simple-array single-float (16)))
  (is-type (matrix) '(simple-array single-float (16))))

(diag "accessors")
(with-matrix (m (mtest))
  (is (mref m 0 0) 1)
  (is (mref m 0 1) 5)
  (is (mref m 0 2) 9)
  (is (mref m 0 3) 13)
  (is (mref m 1 0) 2)
  (is (mref m 1 1) 6)
  (is (mref m 1 2) 10)
  (is (mref m 1 3) 14)
  (is (mref m 2 0) 3)
  (is (mref m 2 1) 7)
  (is (mref m 2 2) 11)
  (is (mref m 2 3) 15)
  (is (mref m 3 0) 4)
  (is (mref m 3 1) 8)
  (is (mref m 3 2) 12)
  (is (mref m 3 3) 16)
  (is m00 1)
  (is m01 5)
  (is m02 9)
  (is m03 13)
  (is m10 2)
  (is m11 6)
  (is m12 10)
  (is m13 14)
  (is m20 3)
  (is m21 7)
  (is m22 11)
  (is m23 15)
  (is m30 4)
  (is m31 8)
  (is m32 12)
  (is m33 16)
  (psetf (mref m 0 0) 10.0
         (mref m 0 1) 50.0
         (mref m 0 2) 90.0
         (mref m 0 3) 130.0
         (mref m 1 0) 20.0
         (mref m 1 1) 60.0
         (mref m 1 2) 100.0
         (mref m 1 3) 140.0
         (mref m 2 0) 30.0
         (mref m 2 1) 70.0
         (mref m 2 2) 110.0
         (mref m 2 3) 150.0
         (mref m 3 0) 40.0
         (mref m 3 1) 80.0
         (mref m 3 2) 120.0
         (mref m 3 3) 160.0)
  (is (mref m 0 0) 10)
  (is (mref m 0 1) 50)
  (is (mref m 0 2) 90)
  (is (mref m 0 3) 130)
  (is (mref m 1 0) 20)
  (is (mref m 1 1) 60)
  (is (mref m 1 2) 100)
  (is (mref m 1 3) 140)
  (is (mref m 2 0) 30)
  (is (mref m 2 1) 70)
  (is (mref m 2 2) 110)
  (is (mref m 2 3) 150)
  (is (mref m 3 0) 40)
  (is (mref m 3 1) 80)
  (is (mref m 3 2) 120)
  (is (mref m 3 3) 160)
  (psetf m00 -1.0
         m01 -5.0
         m02 -9.0
         m03 -13.0
         m10 -2.0
         m11 -6.0
         m12 -10.0
         m13 -14.0
         m20 -3.0
         m21 -7.0
         m22 -11.0
         m23 -15.0
         m30 -4.0
         m31 -8.0
         m32 -12.0
         m33 -16.0)
  (is m00 -1)
  (is m01 -5)
  (is m02 -9)
  (is m03 -13)
  (is m10 -2)
  (is m11 -6)
  (is m12 -10)
  (is m13 -14)
  (is m20 -3)
  (is m21 -7)
  (is m22 -11)
  (is m23 -15)
  (is m30 -4)
  (is m31 -8)
  (is m32 -12)
  (is m33 -16))

(diag "identity")
(with-matrices ((ma (mid))
                (r (matrix 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1)))
  (is ma r)
  (is +mid+ r))

(diag "copy")
(with-matrices ((m +mid+) (o (matrix)))
  (is (mcp! o m) +mid+)
  (is o +mid+)
  (is (mcp m) +mid+)
  (isnt m (mcp m) :test #'eq))

(diag "clamp")
(with-matrices ((m (matrix 1 -2 3 -4 5 -6 7 -8 9 -10 11 -12 13 -14 15 -16))
                (o (matrix))
                (r (matrix 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1)))
  (is (mclamp! o m :min -1.0 :max 1.0) r)
  (is o r)
  (is (mclamp m :min -1.0 :max 1.0) r)
  (is (mclamp m) m))

(diag "multiplication")
(with-matrices ((ma (mtest))
                (mb (matrix 10 50 90 130 20 60 100 140 30 70 110 150 40 80 120 160))
                (mc +mid+)
                (r (matrix 90 202 314 426 100 228 356 484 110 254 398 542 120 280 440 600))
                (rot-x (mrot +mid+ (vec (/ pi 3) 0 0)))
                (rot-y (mrot +mid+ (vec 0 (/ pi 4) 0)))
                (rot-xy (mrot +mid+ (vec (/ pi 3) (/ pi 4) 0)))
                (tr1 (mtr +mid+ (vec 5 10 15)))
                (tr2 (mtr +mid+ (vec 10 20 30)))
                (o (matrix)))
  (is (m*! o ma ma) r)
  (is o r)
  (is (m* ma mc) ma)
  (is (m* mc ma) ma)
  (is (m* ma mb) (m* mb ma))
  (is (m* rot-x rot-y) rot-xy)
  (isnt (m* rot-x rot-y) (m* rot-y rot-x))
  (is (mtr->v (m* tr1 rot-xy)) (mtr->v tr1))
  (is (mtr->v (m* tr1 tr2)) (vec 15 30 45))
  (is (mtr->v (m* tr2 tr1)) (vec 15 30 45)))

(diag "translation conversion")
(with-matrices ((ma (mtest))
                (rm (matrix 1 0 0 5 0 1 0 10 0 0 1 15 0 0 0 1))
                (om (mid)))
  (with-vectors ((v (vec 5 10 15))
                 (rv (vec 13 14 15))
                 (ov (vec)))
    (is (v->mtr! om v) rm)
    (is om rm)
    (is (v->mtr om v) rm)
    (is (mtr->v! ov ma) rv)
    (is ov rv)
    (is (mtr->v ma) rv)))

(diag "translate")
(with-matrices ((m (mrot +mid+ (vec (/ pi 3))))
                (o (mid))
                (r (matrix 1 0 0 5 0 0.5 -0.86602545 10 0 0.86602545 0.5 15 0 0 0 1)))
  (with-vector (v (vec 5 10 15))
    (ok (m~ (mtr! o m v) r))
    (ok (m~ o r))
    (is (mtr->v (mtr +mid+ v)) v)
    (is (mtr->v (mtr m v)) v)))

(diag "rotation copy")
(with-matrices ((ma (mtest))
                (r (matrix 1 5 9 0 2 6 10 0 3 7 11 0 0 0 0 1))
                (o (mid)))
  (is (mcprot! o ma) r)
  (is o r)
  (is (mcprot ma) r))

(diag "rotation conversion")
(with-matrices ((m (mrot +mid+ (vec (/ pi 3) 0 0)))
                (rmx +mid+)
                (rmy (matrix 1 0 0 0 0 0.5 0 0 0 0.86602545 1 0 0 0 0 1))
                (rmz (matrix 1 0 0 0 0 1 -0.86602545 0 0 0 0.5 0 0 0 0 1))
                (omx (mid))
                (omy (mid))
                (omz (mid)))
  (with-vectors ((rvx (vec 1 0 0))
                 (rvy (vec 0 0.5 0.86602545))
                 (rvz (vec 0 -0.86602545 0.5))
                 (ovx (vec))
                 (ovy (vec))
                 (ovz (vec)))
    (is (mrot->v! ovx m :x) rvx)
    (ok (v~ (mrot->v! ovy m :y) rvy))
    (ok (v~ (mrot->v! ovz m :z) rvz))
    (ok (v~ ovx rvx))
    (ok (v~ ovy rvy))
    (ok (v~ ovz rvz))
    (is (mrot->v m :x) rvx)
    (ok (v~ (mrot->v m :y) rvy))
    (ok (v~ (mrot->v m :z) rvz))
    (is (v->mrot! omx rvx :x) rmx)
    (ok (m~ (v->mrot! omy rvy :y) rmy))
    (ok (m~ (v->mrot! omz rvz :z) rmz))
    (ok (m~ omx rmx))
    (ok (m~ omy rmy))
    (ok (m~ omz rmz))
    (is (v->mrot +mid+ rvx :x) rmx)
    (ok (m~ (v->mrot +mid+ rvy :y) rmy))
    (ok (m~ (v->mrot +mid+ rvz :z) rmz))))

(diag "rotation")
(with-matrices ((omx (mid))
                (omy (mid))
                (omz (mid))
                (rmx (matrix 1 0 0 0 0 0.5 -0.86602545 0 0 0.86602545 0.5 0 0 0 0 1))
                (rmy (matrix 0.5 0 0.86602545 0 0 1 0 0 -0.86602545 0 0.5 0 0 0 0 1))
                (rmz (matrix 0.5 -0.86602545 0 0 0.86602545 0.5 0 0 0 0 1 0 0 0 0 1)))
  (with-vectors ((vx (vec (/ pi 3) 0 0))
                 (vy (vec 0 (/ pi 3) 0))
                 (vz (vec 0 0 (/ pi 3))))
    (ok (m~ (mrot! omx +mid+ vx) rmx))
    (ok (m~ (mrot! omy +mid+ vy) rmy))
    (ok (m~ (mrot! omz +mid+ vz) rmz))
    (ok (m~ omx rmx))
    (ok (m~ omy rmy))
    (ok (m~ omz rmz))
    (ok (m~ (mrot +mid+ vx) rmx))
    (ok (m~ (mrot +mid+ vy) rmy))
    (ok (m~ (mrot +mid+ vz) rmz))))

(diag "matrix * vector multiplication")
(with-matrices ((m (mrot +mid+ (vec (/ pi 3) 0 0))))
  (with-vectors ((v (vec 1 2 3))
                 (o (vec))
                 (rv (vec 1.0 -1.5980763 3.232051)))
    (is (m*v! o m v) rv)
    (is o rv)
    (is (m*v m v) rv)
    (is (m*v +mid+ v) v)
    (is (m*v +mid+ +0vec+) +0vec+)))

(diag "transpose")
(with-matrices ((m (mtest))
                (r (matrix 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16))
                (o (mid)))
  (is (mtranspose! o m) r)
  (is o r)
  (is (mtranspose m) r)
  (is (mtranspose +mid+) +mid+))

(diag "orthogonality predicate")
(ok (morthop (mrot +mid+ (vec pi))))
(ok (morthop (mrot +mid+ (vec (/ pi 2)))))
(ok (morthop (mrot +mid+ (vec (/ pi 3)))))
(ok (morthop (mrot +mid+ (vec (/ pi 4)))))
(ok (morthop (mrot +mid+ (vec (/ pi 5)))))
(ok (morthop (mrot +mid+ (vec (/ pi 6)))))

(diag "orthogonalization")
(with-matrices ((m (matrix 0 1 -0.12988785 1.0139829 0 0 0.3997815 -0.027215311 1 0 0.5468181 0.18567966 0 0 0 0))
                (o (mid))
                (r (matrix 0 1 0 0 0 0 1 0 1 0 0 0 0 0 0 1)))
  (is (mortho! o m) r)
  (is o r)
  (is (mortho m) r))

(diag "trace")
(is (mtrace (matrix)) 0)
(is (mtrace +mid+) 4)
(is (mtrace (mtest)) 34)

(diag "determinant")
(is (mdet (mtest)) 0)
(is (mdet +mid+) 1)
(is (mdet (mrot +mid+ (vec (/ pi 3)))) 1)
(is (mdet (matrix 1 0 0 0 0 0 1 0 0 1 0 0 0 0 0 1)) -1)

(diag "inversion")
(with-matrices ((m (mrot +mid+ (vec (/ pi 3))))
                (r (mrot +mid+ (vec (/ pi -3))))
                (o (mid)))
  (is (minvt! o m) r)
  (is o r)
  (is (minvt m) r)
  (is (minvt +mid+) +mid+)
  (is-error (minvt (mtest)) simple-error))

(diag "view matrix")
(with-matrices ((o (mid))
                (r (matrix -0.7071068 0 0.7071068 -1 0 1 0 0 -0.7071068 0 -0.7071068 0 0 0 0 1)))
  (ok (m~ (mkview! o (vec 1 0 0) (vec 0 0 1) (vec 0 1 0)) r))
  (ok (m~ o r))
  (ok (m~ (mkview (vec 1 0 0) (vec 0 0 1) (vec 0 1 0)) r))
  (is (mkview +0vec+ +0vec+ +0vec+) (matrix 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)))

(diag "orthographic projection matrix")
(with-matrices ((r (matrix 0.05 0 0 0 0 0.1 0 0 0 0 -0.002 -1 0 0 0 1))
                (o (mid)))
  (is (mkortho! o -20 20 -10 10 0 1000) r)
  (is o r)
  (is (mkortho -20 20 -10 10 0 1000) r))

(diag "perspective projection matrix")
(with-matrices ((r (matrix 0.97427857 0 0 0 0 1.7320508 0 0 0 0 -1.002002 -2.002002 0 0 -1 1))
                (o (mid)))
  (is (mkpersp! o (/ pi 3) (/ 16 9) 1 1000) r)
  (is o r)
  (is (mkpersp (/ pi 3) (/ 16 9) 1 1000) r))

(finalize)