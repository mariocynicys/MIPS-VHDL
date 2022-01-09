main: 0xaf
  mov $1, $7
  add $1, $7, $7
  iadd $5
  ldd $7, 0x12($6)
  std $3, 0x12($6)
  int 15
  hlt

int1: 0xa7            ; -> m[6]&m[7]
  mov $1, $7
  add $1, $7, $7
  rti

int2: 0xd             ; -> m[8]&m[9]
  mov $1, $7
  add $1, $7, $7
  rti

exp1: 0x13             ; -> m[2]&m[3]
  mov $1, $7
  add $1, $7, $7
  hlt

exp2: 0x19             ; -> m[4]&m[5]
  mov $1, $7
  add $1, $7, $7
  hlt

func1: 0x1f
  mov $1, $7
  add $1, $7, $7
  ret

func2: 0x2f
  mov $1, $7
  add $1, $7, $7
  ret
; this is a commend

;mov ;this is a commend
