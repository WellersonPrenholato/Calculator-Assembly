;Disciplina: Arquitetura de Computadores - UFES
;Aluno(s): Wellerson Prenholato de Jesus
;          Hádamo da Silva Egito
;Curso: Ciência da Computação
;Trabalho: Calculadora Básica - Linguagem de Montagem (NASM)

global main

extern printf
extern scanf

section .data ;Declaração de Constantes
    formato db "%lf", 0
    fmtCaracter db "%*c%c", 0

    mensagem1: db "Insira o Primeiro Número: ", 0
    mensagem2: db "Insira o Segundo Número: ", 0
    mensagem3: db "Insira o Operador: ", 0

    mensagemFim: db "Código Encerrado! Operador Vazio.", 10, 0

    mensagemResultado: db "Resultado: %.4lf", 10, 10, 0

    mensagemOperandoZero: db "Na Divisão: O Segundo Número NÃO pode ser ZERO! Insira outro Número.", 10, 0

    mensagemOperador: db "Insira um Operador Válido!", 10, 10, 0

    mensagemMenu: db "*** Calculadora Básica - Linguagem de Montagem (NASM) ***", 10, 0
    mensagemMenu2: db " -> Operações:", 10, "     * :Multiplicação", 10, "     + :Soma", 10, "     - :Subtração", 10, "     / :Divisão", 10, 10, 0

section .bss ; Declaração de Variáveis
    num resq 1
    num2 resq 1
    op resb 4

section .text ; Secção de Texto

main: ; Função Principal

menu_mensagem:
    mov rdi, mensagemMenu
    mov al, 0
    call printf

menu_operacoes:
    mov rdi, mensagemMenu2
    mov al, 0
    call printf

ler_op1:
    mov rdi, mensagem1
    mov al, 0
    call printf

	sub rsp, 8
    	mov 	rax, 0                                          
		mov     rdi, formato                      
		mov	   	rsi, num                                    
		call    scanf  
    add rsp, 8

ler_operador:
    mov rdi, mensagem3
    mov al, 0
    call printf

    sub rsp, 8
        mov     rax, 0                                          
        mov     rdi, fmtCaracter                      
        mov     rsi, op                                    
        call    scanf  
    add rsp, 8

    mov ebx, 10        ; Verifica se o operador é Enter
    cmp ebx, [op]
    jz fim


ler_op2:
    mov rdi, mensagem2
    mov al, 0
    call printf

    sub rsp, 8
    	mov 	rax, 0                                          
		mov     rdi, formato                      
		mov	   	rsi, num2                                    
		call    scanf  
    add rsp, 8


def_operador:      ;Funçao para definir o operador

    movq xmm0, qword [num]
    
    mov ebx, '+'
    cmp ebx, [op]
    jz adicao

    mov ebx, '-'
    cmp ebx, [op]
    jz subtracao

    mov ebx, '*'
    cmp ebx, [op]
    jz multiplicacao

    mov ebx, '/'
    cmp ebx, [op]
    jz verifica_Operando2_Zero ;Jump para verificar se o segundo operando é Zero.

    jne novo_operador ;Caso o operador digitado nao exista
    
subtracao:      ;Funcao de Subtracao
    subsd xmm0, [num2]
    jmp exibir

adicao:         ;Funcao de Adicao
    addsd xmm0, [num2]
    jmp exibir

multiplicacao:  ;Funcao de Multiplicacao
    mulsd xmm0, [num2]
    jmp exibir

divisao:        ;Funcao de Divisao
    divsd xmm0, [num2]
    jmp exibir

verifica_Operando2_Zero: ; FUNCIONANDO
    mov     rsi, [num2]
    cmp     rsi, 0

    jne divisao  ;Jump se nao for igual

    sub rsp, 8
        mov rdi, mensagemOperandoZero
        mov rax, 1
        call printf
    add rsp, 8

    jmp ler_op2 ; Jump padrao

novo_operador: ;Mensagem para inserir um novo operador e jump para operador
    mov rdi, mensagemOperador
    mov al, 0
    call printf

jmp ler_operador ; Volta para o operador

exibir:         ;Funcao para exibir resultado  
    sub rsp, 8
        movq [num], xmm0  
        mov rdi, mensagemResultado
        mov rax, 1
        call printf
    add rsp, 8

    jmp ler_operador

  
fim:            ;Funcao para encerrar o código
    mov rdi, mensagemFim
    mov al, 0
    call printf

    mov eax, 1
    mov ebx, 0
    int 80h ;Encerrar o código
