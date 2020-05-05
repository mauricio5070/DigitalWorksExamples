;El programa  imprime el numero mayor al ingresar 4 numeros
; Declarando el segmento de pila 
pila segment   ; Inicio del segmento de pila

pila ENDS    ; Fin del segmento de pila 


datos segment  ;inicio del segmento de dato. Reserva de espacio para todas als variables q usa el programa
 LINE db 10,13,36
 aviso1 DB " Has ingresado 4 numeros: $"
 
 aviso2 DB " Hola... $"
 aviso DB " El numero MAYOR es: $"
 carac DB 64H DUP(' ')
 MAYOR DB 00
datos ends   ;fin del segmento de datos

CODE SEGMENT  ;Definicion de todos los procedimientos e instrucciones del programa.
 numerom proc far
 ASSUME CS:code, SS:pila, ds: datos  ;La directiva ASSUME no inicializa los registros de segmento, simplemente
          ;conduce al compilador dónde está cada uno y su uso

inicio: push ds
 mov ax, datos  ;AX=Direccion del segmento de datos
    MOV DS, AX    ; DS=AX. Indicar el segmento de datos  
 mov cx, 0  ;Proposito: transferencia de datos entre celdas de memoria
     ;En este caso se ha asignado al registro CX el valor 25, el cual sera utilizado como contador de bucle. 
     ;registros y acumulador   mob: destino,fuente

sigue: cmp cx, 4    ;cmp=La instruccion que se utiliza para comparar se llama CMP (CoMPare).
 je fin    ;je= si es igual

 MOV AH, 01
 INT 21H   ;interrupcion servicios de la pc

 MOV CARAC[BX], AL
 MOV AH, 09
 LEA DX, LINE
 INT 21H
 MOV AL, CARAC[BX]
 CMP AL, MAYOR
 JL AGREGAR    ;salta si es menor q o salta si es mayor
 MOV MAYOR, AL
 INC BX
 inc cx
 jmp sigue   ;Esta instruccion se utiliza para desviar el flujo de un programa
    ;sin tomar en cuenta las condiciones actuales de los datos

agregar:INC BX
 inc cx
 jmp sigue

fin:
 lea dx, line
 mov ah, 09
 int 21h

 lea dx, aviso2
 mov ah, 09
 
 int 21h
 lea dx, aviso1
 mov ah, 09
 
 int 21h
 lea dx, aviso
 mov ah, 09
 

 int 21h
 
 mov al, mayor
 mov ah, 02
 
 mov dl, AL
 int 21h
 
 mov ah, 4ch
 int 21h
 
numerom endp
code ends
end inicio