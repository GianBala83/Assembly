;================================
; Projeto de Assembly
; Arquitetura I
; Projessor: Ewerton Salvador
; Alunos: Giancarlo Silveira Cavalcante             20220055086
;         Herlan Alef de Lima Nascimento Matricula  20220096712
;================================

;não sei
.686
.model flat, stdcall
option casemap:none

;includes
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
includelib \masm32\lib\masm32.lib
include \masm32\macros\macros.asm

.data
    str_001 db "Bem-vindo ao Programa", 0ah, 0h
    str_002 db "Digite o nome do arquivo [com a extensao]", 0ah, 0h
    str_003 db "Digite a coordenada X", 0ah, 0h
    str_004 db "Digite a coordenada Y", 0ah, 0h
    str_005 db "Digite a Altura do Retangulo", 0ah, 0h
    str_006 db "Digite a Largura do Retangulo", 0ah, 0h
    str_007 db "Digite a nome da saida do Arquivo [com a extensao]", 0ah, 0h

    nome_de_entrada db 100 dup(0)
    nome_de_saida db 100 dup(0)
    tmp_entra_inteiros db 10 dup(0)
    
    output_Handle dd 0
    input_Handle dd 0
    file_open_Handle dd 0
    file_create_Handle dd 0

    write_count dd 0

    tmp dd 0
    tmp_2 dd 0
    tmp_3 dd 0

    larguda_da_imagem_debug dd 900

.data?
    coordenada_x dd ?
    coordenada_y dd ?
    altura_retangulo dd ?
    largura_retangulo dd ?
    
    larguda_da_imagem dd ?
    larguda_da_imagem_bits dd ?
    size_do_arquivo dd ?

    file_Buffer dd ?
    read_Count dd ?
    write_Count dd ?

.code


start:
    ;------------------------------------------------------------------
    ;Mensagem de boas vindas!
    ;------------------------------------------------------------------
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov output_Handle, eax
    invoke WriteConsole, output_Handle, addr str_001, sizeof str_001 -1, addr write_count, NULL

    ;------------------------------------------------------------------
    ;ler o nome da imagem 54 bits e pixels multiplos de 4
    ;------------------------------------------------------------------
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov output_Handle, eax
    invoke WriteConsole, output_Handle, addr str_002, sizeof str_002 -1, addr write_count, NULL

    push STD_INPUT_HANDLE
    call GetStdHandle
    mov input_Handle, eax
    invoke ReadConsole, input_Handle, addr nome_de_entrada, sizeof nome_de_entrada, addr write_count, NULL

    ;Tratamento da String
    mov esi, offset nome_de_entrada
    proximo:
    mov al, [esi]
    inc esi
    cmp al, 13
    jne proximo
    dec esi
    xor al, al
    mov [esi], al
    
    ;------------------------------------------------------------------
    ; Ler os 4 numeros
    ;------------------------------------------------------------------
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov output_Handle, eax
    invoke WriteConsole, output_Handle, addr str_003, sizeof str_003 -1, addr write_count, NULL

    push STD_INPUT_HANDLE
    call GetStdHandle
    mov input_Handle, eax
    invoke ReadConsole, input_Handle, addr tmp_entra_inteiros, sizeof tmp_entra_inteiros, addr write_count, NULL

    ;Tratamento da entrada Part1
    mov esi, offset tmp_entra_inteiros
    proximo_01:
    mov al, [esi]
    inc esi
    cmp al, 13
    jne proximo_01
    dec esi
    xor al, al
    mov [esi], al
    ;Tratamente da entrada Part2
    invoke atodw, addr tmp_entra_inteiros
    mov coordenada_x, eax
    
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov output_Handle, eax
    invoke WriteConsole, output_Handle, addr str_004, sizeof str_004 -1, addr write_count, NULL

    push STD_INPUT_HANDLE
    call GetStdHandle
    mov input_Handle, eax
    invoke ReadConsole, input_Handle, addr tmp_entra_inteiros, sizeof tmp_entra_inteiros, addr write_count, NULL

    ;Tratamento da entrada Part1
    mov esi, offset tmp_entra_inteiros
    proximo_02:
    mov al, [esi]
    inc esi
    cmp al, 13
    jne proximo_02
    dec esi
    xor al, al
    mov [esi], al
    ;Tratamente da entrada Part2
    invoke atodw, addr tmp_entra_inteiros
    mov coordenada_y, eax

    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov output_Handle, eax
    invoke WriteConsole, output_Handle, addr str_006, sizeof str_006 -1, addr write_count, NULL

    push STD_INPUT_HANDLE
    call GetStdHandle
    mov input_Handle, eax
    invoke ReadConsole, input_Handle, addr tmp_entra_inteiros, sizeof tmp_entra_inteiros, addr write_count, NULL

    ;Tratamento da entrada Part1
    mov esi, offset tmp_entra_inteiros
    proximo_04:
    mov al, [esi]
    inc esi
    cmp al, 13
    jne proximo_04
    dec esi
    xor al, al
    mov [esi], al
    ;Tratamente da entrada Part2
    invoke atodw, addr tmp_entra_inteiros
    mov largura_retangulo, eax
    mov input_Handle, 0
	
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov output_Handle, eax
    invoke WriteConsole, output_Handle, addr str_005, sizeof str_005 -1, addr write_count, NULL

    push STD_INPUT_HANDLE
    call GetStdHandle
    mov input_Handle, eax
    invoke ReadConsole, input_Handle, addr tmp_entra_inteiros, sizeof tmp_entra_inteiros, addr write_count, NULL

    ;Tratamento da entrada Part1
    mov esi, offset tmp_entra_inteiros
    proximo_03:
    mov al, [esi]
    inc esi
    cmp al, 13
    jne proximo_03
    dec esi
    xor al, al
    mov [esi], al
    ;Tratamente da entrada Part2
    invoke atodw, addr tmp_entra_inteiros
    mov altura_retangulo, eax
    mov input_Handle, 0

    ;------------------------------------------------------------------
    ;nome da saida do arquivo
    ;------------------------------------------------------------------
    
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov output_Handle, eax
    invoke WriteConsole, output_Handle, addr str_007, sizeof str_007 -1, addr write_count, NULL

    push STD_INPUT_HANDLE
    call GetStdHandle
    mov input_Handle, eax
    invoke ReadConsole, input_Handle, addr nome_de_saida, sizeof nome_de_saida, addr write_count, NULL

    ;Tratamento da String
    mov esi, offset nome_de_saida
    proximo2:
    mov al, [esi]
    inc esi
    cmp al, 13
    jne proximo2
    dec esi
    xor al, al
    mov [esi], al

    ;mov eax, 250
    ;mov coordenada_x, eax
    ;mov eax, 310
    ;mov coordenada_y, eax

    ;printf("valor x %d", coordenada_x)
    ;printf("valor y %d", coordenada_y)

    ;------------------------------------------------------------------
    ;fazer a copia do arquivo em outro arquivo
    ;No processo aplicar a censura nas coordenadas x,y desenha o retangulo
    ;------------------------------------------------------------------

    invoke CreateFile, addr nome_de_entrada, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov file_open_Handle, eax

    invoke CreateFile, addr nome_de_saida, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    mov file_create_Handle, eax

    invoke ReadFile, file_open_Handle, addr file_Buffer, 54, addr read_Count, NULL
    invoke WriteFile, file_create_Handle, addr file_Buffer, 54, addr write_Count, NULL

    mov ecx, file_Buffer[18]
    mov larguda_da_imagem, ecx
    xor edx, edx
    xor eax, eax
    mov edx, ecx
    mov ecx, file_Buffer[22]
    mov eax, ecx
    mul edx
    mov edx, eax
    mov eax, 3
    mul edx
    add eax, 54
    mov size_do_arquivo, eax


    mov eax, 3
    mul larguda_da_imagem
    mov larguda_da_imagem_bits, eax
    mov eax, 54
    mov tmp, eax

    mov ecx, 0
    mov tmp_2, ecx ; salv

    laco_copiar:
        mov eax, larguda_da_imagem_bits
        add tmp, eax
        
        invoke ReadFile, file_open_Handle, addr file_Buffer, larguda_da_imagem_bits, addr read_Count, NULL
        mov eax, 1
        add tmp_2, eax

        mov ecx, coordenada_y
                
        mov ebx, coordenada_y
        add ebx, altura_retangulo

        cmp tmp_2, ecx
        jge chamada_de_funcao_censura
        jmp continua_sem_censura

        chamada_de_funcao_censura:
            cmp tmp_2, ebx
            jle chamada_de_funcao_censura_2
            jmp continua_sem_censura
        chamada_de_funcao_censura_2:
            call funcao_censura
                    
        continua_sem_censura:
            invoke WriteFile, file_create_Handle, addr file_Buffer, larguda_da_imagem_bits, addr write_Count, NULL
        

        mov edx, 0
        mov edx, size_do_arquivo
        cmp tmp, edx
        jl laco_copiar
        jmp sair_do_loop
        
    funcao_censura:

        push ebp
        mov ebp, esp
        sub esp, 8
    
        mov esi, offset file_Buffer
        mov eax, coordenada_x
        mov DWORD PTR[ebp-4], eax
        mov eax, largura_retangulo
        mov DWORD PTR[ebp-8], eax

        mov ecx, DWORD PTR[ebp-4]
        mov tmp_3, ecx ;salvar
        mov eax, 3
        mul ecx
        mov ecx, eax

        mov ebx, DWORD PTR[ebp-4]
        add ebx, DWORD PTR[ebp-8]
        mov eax, 3
        mul ebx
        mov ebx, eax

        cmp tmp_3, ebx
        jle censura_condicao_1
        jmp continuar

        censura_condicao_1:
            cmp tmp_3, ebx
            jg continuar
            ;jmp censura
            
        censura:
            xor eax, eax
            mov [esi + ecx], eax
        continuar:
            add ecx, 1
            cmp ecx, ebx
            jbe censura_condicao_1
            ;jmp retorno
        
        retorno:
            mov esp, ebp
            pop ebp
            ret

    sair_do_loop:
    invoke CloseHandle, file_open_Handle
    invoke CloseHandle, file_create_Handle

    invoke ExitProcess, 0

end start
