main: af
  mov $1, $7
  add $1, $7, $7
  iadd $5
  ldd $7, 0x12($6)
  std $3, 0x12($6)
  int 15
  hlt

int1: a7            ; -> m[6]&m[7]
  mov $1, $7
  add $1, $7, $7
  rti

int2: d             ; -> m[8]&m[9]
  mov $1, $7
  add $1, $7, $7
  rti

exp1: 13             ; -> m[2]&m[3]
  mov $1, $7
  add $1, $7, $7
  hlt

exp2: 19             ; -> m[4]&m[5]
  mov $1, $7
  add $1, $7, $7
  hlt

func1: 1f
  mov $1, $7
  add $1, $7, $7
  ret

func2: 2f
  mov $1, $7
  add $1, $7, $7
  ret
; this is a commend

;mov ;this is a commend
