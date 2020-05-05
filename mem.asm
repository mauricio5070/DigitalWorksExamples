    Code Segment Para 'CODE'
     Org 100H
     Assume CS:Code,SS:Code,SS:Code,ES:Code


  inicio Proc near

    mov ax,0003h
      int 10h                ; Pone modo de vmdeo 80X25

    mov dx,offset mensINI    ; Posicisn donde esta esta cadena
    mov cx,0008h             ; Fila y columna a imprimir en pantalla 
      call PrintString       ; Procedimiento que imprime la cadena


    mov dx,offset mens1      ; Posicisn donde esta esta cadena
    mov cx,010ah             ; Fila y columna a imprimir en pantalla 
      call PrintString       ; Procedimiento que imprime la cadena

    mov ax,offset FinaldeCodigo ; Longitud actual de nuestro programa
    mov cx,012dh                ; Fila y columna a imprimir el valor numirico
     call decimaldx0            ; Imprime en pantalla el valor numirico de AX


        mov ah,4ah                   ; Servicio del Sistema Operativo para
                                     ; cambiar la longitud a un bloque de   
                                     ; de memoria existente, en este caso
                                     ; El segmento de csdigo nuestro

          push cs                    ; En ES debe estar la direccisn del
          pop es                     ; segmento a cambiar su longitud   

         mov bx,64                   ; En BX la cantidad de parrafos deseados
                                     ; es decir longitud en bloques de 16 bytes.

         cli                         ; Desactivo las interrupciones
          mov cx,cs                  ; Esto hace que el segmento de pila y
          mov ss,cx                  ; de datos apunten a mi segmento de codigo
          mov sp,0fff0h              ; Muevo el puntero de pila al a mi segmento   
          push cs
          pop ds
          mov bp,0fff2h
         sti                         ; Activo las interrupciones

        int 21h                      ; Interrupcisn del sistema operativo
                                     ; que permite lo anterior
           jnc GoodChange    ; Si no hay error

                             ; Se produjo Error si pasa por aqui

    mov dx,offset mensErr1   ; Posici"n donde est  esta cadena
    mov cx,0a0ah             ; Fila y columna a imprimir en pantalla 
      call PrintString       ; Procedimiento que imprime la cadena

      Xor ah,ah
      int 16h
        Jmp PrintRam

 GoodChange:
         mov ah,48h         ; Como ya hemos liberado la memoria, podemos pedir
         mov bx,64          ; al sistema operativo 64 K de memoria dinamica   
          int 21h           ; en BX cantidad de parrafos o bloques de 16 bytes
           jnc GoodRequest  ; Si no hay error


                             ; Se produjo Error si pasa por aqui

    mov dx,offset mensErr2   ; Posici"n donde est  esta cadena
    mov cx,0a0ah             ; Fila y columna a imprimir en pantalla 
      call PrintString       ; Procedimiento que imprime la cadena
      Xor ah,ah
      int 16h
        Jmp PrintRam

 GoodRequest:
     ; Si pasa por aqui, entonces es que el Sistema Operativo nos ha concedido
     ; Los 64 K de memoria dinamica, por tanto podriamos preguntar cuanta mas
     ; queda libre


PrintRam:
    mov dx,offset mensRAM    ; Posici"n donde est  esta cadena
    mov cx,0408h             ; Fila y columna a imprimir en pantalla 
      call PrintString       ; Procedimiento que imprime la cadena

       mov ah,48h
       mov bx,0ffffh        ; Solicitamos 1 Megabyte de memoria, algo imposible
                            ; de dar por el sistema Operativo en modo real y es
         Int 21h            ; por ello que nos informaria de la cantidad real
                            ; disponible de memoria concecutiva

       mov ax,bx           ; devuelve la cantidad de memoria o bloque concecutivo
       mov cl,4            ; disponible actualmenete en parrafos.
       shl ax,cl           ; Calculo para obtener memoria en bytes y no en parrafos

    mov cx,0433h                ; Fila y columna a imprimir el valor numerico
     call decimaldx0            ; Imprime en pantalla la cantidad de memoria


  exit:
     xor ah,ah
      int 16H


    mov ax,4c00h    ; Este servicio del Sistema Operativo, hace que su
                    ; aplicaci"n termine correctamente
    int 21h



 mensINI  db 'Liberando memoria dinamica disponible y dejando solo la que ocupo$'
 mens1    db 'Nuestro Programa ocupa actualmente:      bytes en memoria$'
 mensErr1 db 'Error al cambiar la longitud de nuestro programa, Pulse una tecla$'
 mensErr2 db 'Error al solicitar 64 K de memoria, Pulse una tecla$'
 mensRam  db 'Cantidad de memoria disponible actualmente:$'



PrintString:             ; Imprime una cadena directamente en pantalla
    mov ax,0b800h
    mov es,ax
    push cs
    pop ds

    mov ax,160
    mul ch

    shl cl,1
    xor ch,ch

    add ax,cx

    mov di,ax
    mov si,dx

    cld

  again_PrintString:
     lodsb
      cmp al,'$'
       je exit_PrintString
      mov ah,1fh
     stosw
   jmp again_PrintString


exit_PrintString:
    ret


decimaldx0:               ;Imprime directamente en pantalla el valor numrico
                          ;contenido en AX
        push ax

        mov dx,0000h

        mov ax,160
        mul ch

        shl cl,1
        xor ch,ch

        add ax,cx
        mov si,ax

        pop ax

decimal:
         mov cx,0b800h
         mov ds,cx
         mov cx,0001h
         mov bx,000ah
ahorra:
         div bx
         mov dh,1eh
         push dx
         mov dx,0000h
         inc ax
         dec ax
         jz imprimir
         inc cx
         jmp  ahorra

imprimir:
         mov ax,0005h
         sub ax,cx
         jz p7a3
         mov cx,ax
         mov ax,1ef0h
p7a4:    push ax
         loop p7a4

p7a3:
         mov cx,0005h






imp1:
         pop dx
         add dl,30h
         mov [si],dx
         inc si
         inc si
 loop    imp1
       RET



   inicio EndP


 FinaldeCodigo db 0     ; FinaldeCodigo para depositar los datos deseados por
                        ; el programador como memoria dinamica dentro de nuestro
                        ; segmento de codigo(CS)ible, as! que de aqu! en adelante
                        ; dentro de este segmento de c"digo, usted puede guardar
                        ; Lo que desee, m ximo de este segmento 64 Kilobytes.
                        ; Es decir 64*1024-FinaldeCodigo-256 bytes y esta ser  la
                        ; cantidad m xima de bytes para guardar informaci{on extra
                        ; en modo real o como aplicaci"n DOS. Hay otras formas... 

Code EndS
     End inicio