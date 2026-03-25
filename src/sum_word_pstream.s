    .data
input_addr:      .word  0x80
output_addr:     .word  0x84

    .text
_start:
    @p input_addr a! @
    dup if exit
    lit -1 +
    >r
    lit 0                    \ sum_high
    lit 0                    \ sum_low


read_numbers_loop:
    @p input_addr a! @
    add64
    next read_numbers_loop


print_result:
    over
    @p output_addr a! !
    @p output_addr a! !


exit:
    halt


add64:
    dup
    -if is_positive

    lit -1
    add64_sum ;

is_positive:
    lit 0

add64_sum:
    \ data stack: [sum_high, sum_low, val_low, val_high]
    \ we need to sum up (sum_low + val_low) and (sum_high + val_high + carry)

    over                     \ [sum_high, sum_low, val_high, val_low]
    a!                       \ [sum_high, sum_low, val_high]
    over                     \ [sum_high, val_high, sum_low]
    a                        \ [sum_high, val_high, sum_low, val_low]

    lit 1 eam

    +                        \ sum_low + val_low
    >r

    +                        \ sum_high + val_high + carry
    r>

    lit 0 eam
    ;
