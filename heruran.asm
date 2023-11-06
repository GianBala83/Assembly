;================================
; Projeto de Assembly
; Arquitetura I
; Professor:
; Ewerton Monteiro Salvador
; Alunos: 
; Giancarlo Silveira Cavalcante             20220055086
; Herlan Alef de Lima Nascimento Matricula  20220096712
;================================

.686
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

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
    entrada_inteiros db 10 dup(0)
    output_Handle dd 0
    input_Handle dd 0
    
    file_open_Handle dd 0
    file_create_Handle dd 0
    write_count dd 0
    
    ; Variavies de controle para loop da censura e copia de imagem
    controle_copia dd 0
    controle_censura_horizontal dd 0
    controle_censura_vertical dd 0
    
    Reader_Line_Buffer db 6480 dup(0)

.data?
    coordenada_x dd ?
    coordenada_y dd ?
    altura_retangulo dd ?
    largura_retangulo dd ?
    larguda_da_imagem dd ?
    larguda_da_imagem_bits dd ?
    size_do_arquivo dd ?
    
    file_Buffer dd ?
    file_Buffer_2 dd ?
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
    ;Ler o nome da imagem
    ;------------------------------------------------------------------
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov output_Handle, eax
    invoke WriteConsole, output_Handle, addr str_002, sizeof str_002 -1, addr write_count, NULL

    push STD_INPUT_HANDLE
    call GetStdHandle
    mov input_Handle, eax
    invoke ReadConsole, input_Handle, addr nome_de_entrada, sizeof nome_de_entrada, addr write_count, NULL
	
    ; Tratamento da String
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
    ;Ler os 4 valores inteiros para demarcação das coordenadas
	;Os blocos de codigo a baixo se repetem 4 vezes para cada valor
    ;------------------------------------------------------------------
	
    ;Coordenada X
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov output_Handle, eax
    invoke WriteConsole, output_Handle, addr str_003, sizeof str_003 -1, addr write_count, NULL

    push STD_INPUT_HANDLE
    call GetStdHandle
    mov input_Handle, eax
    invoke ReadConsole, input_Handle, addr entrada_inteiros, sizeof entrada_inteiros, addr write_count, NULL
	
    ; Tratamento do Valor Inteiro
    mov esi, offset entrada_inteiros
    proximo_01:
    mov al, [esi]
    inc esi
    cmp al, 13
    jne proximo_01
    dec esi
    xor al, al
    mov [esi], al
    invoke atodw, addr entrada_inteiros
    mov coordenada_x, eax
    
    ;Coordenada Y
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov output_Handle, eax
    invoke WriteConsole, output_Handle, addr str_004, sizeof str_004 -1, addr write_count, NULL

    push STD_INPUT_HANDLE
    call GetStdHandle
    mov input_Handle, eax
    invoke ReadConsole, input_Handle, addr entrada_inteiros, sizeof entrada_inteiros, addr write_count, NULL
	
    ; Tratamento do Valor Inteiro
    mov esi, offset entrada_inteiros
    proximo_02:
    mov al, [esi]
    inc esi
    cmp al, 13
    jne proximo_02
    dec esi
    xor al, al
    mov [esi], al
    invoke atodw, addr entrada_inteiros
    mov coordenada_y, eax
	
	
    ;Largura do Retangulo
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov output_Handle, eax
    invoke WriteConsole, output_Handle, addr str_006, sizeof str_006 -1, addr write_count, NULL

    push STD_INPUT_HANDLE
    call GetStdHandle
    mov input_Handle, eax
    invoke ReadConsole, input_Handle, addr entrada_inteiros, sizeof entrada_inteiros, addr write_count, NULL
	
    ; Tratamento do Valor Inteiro
    mov esi, offset entrada_inteiros
    proximo_04:
    mov al, [esi]
    inc esi
    cmp al, 13
    jne proximo_04
    dec esi
    xor al, al
    mov [esi], al
    invoke atodw, addr entrada_inteiros
    mov largura_retangulo, eax
    mov input_Handle, 0
	
	
    ;Altura do Retangulo
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov output_Handle, eax
    invoke WriteConsole, output_Handle, addr str_005, sizeof str_005 -1, addr write_count, NULL

    push STD_INPUT_HANDLE
    call GetStdHandle
    mov input_Handle, eax
    invoke ReadConsole, input_Handle, addr entrada_inteiros, sizeof entrada_inteiros, addr write_count, NULL

    ; Tratamento do Valor Inteiro
    mov esi, offset entrada_inteiros
    proximo_03:
    mov al, [esi]
    inc esi
    cmp al, 13
    jne proximo_03
    dec esi
    xor al, al
    mov [esi], al
    invoke atodw, addr entrada_inteiros
    mov altura_retangulo, eax
    mov input_Handle, 0

    ;------------------------------------------------------------------
    ;Recebimento do nome do arquivo de saida
    ;------------------------------------------------------------------
    
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov output_Handle, eax
    invoke WriteConsole, output_Handle, addr str_007, sizeof str_007 -1, addr write_count, NULL

    push STD_INPUT_HANDLE
    call GetStdHandle
    mov input_Handle, eax
    invoke ReadConsole, input_Handle, addr nome_de_saida, sizeof nome_de_saida, addr write_count, NULL

    ; Tratamento da String
    mov esi, offset nome_de_saida
    proximo2:
    mov al, [esi]
    inc esi
    cmp al, 13
    jne proximo2
    dec esi
    xor al, al
    mov [esi], al

    ;---------------------------------------------------------------------------------
    ;Fazer a copia do arquivo em outro arquivo
    ;No processo aplicar a censura nas coordenadas x,y e desenhar o retangulo preto 
    ;---------------------------------------------------------------------------------

    invoke CreateFile, addr nome_de_entrada, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov file_open_Handle, eax

    invoke CreateFile, addr nome_de_saida, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    mov file_create_Handle, eax

    invoke ReadFile, file_open_Handle, addr Reader_Line_Buffer, 18, addr read_Count, NULL
    invoke WriteFile, file_create_Handle, addr Reader_Line_Buffer, 18, addr write_Count, NULL

    invoke ReadFile, file_open_Handle, addr file_Buffer, 4, addr read_Count, NULL
    invoke WriteFile, file_create_Handle, addr file_Buffer, 4, addr write_Count, NULL

    invoke ReadFile, file_open_Handle, addr file_Buffer_2, 4, addr read_Count, NULL
    invoke WriteFile, file_create_Handle, addr file_Buffer_2, 4, addr write_Count, NULL

    invoke ReadFile, file_open_Handle, addr Reader_Line_Buffer, 28, addr read_Count, NULL
    invoke WriteFile, file_create_Handle, addr Reader_Line_Buffer, 28, addr write_Count, NULL

    ;Tratamento para pegar a largura da imagem e a Altura
    ;Esses dois valores x 3 + 54(Cabeçalho) = tamanho total da imagem
    mov ecx, file_Buffer[0]
    mov larguda_da_imagem, ecx
    xor edx, edx
    xor eax, eax
    mov edx, ecx
    mov ecx, file_Buffer_2[0]
    mov eax, ecx
    mul edx
    mov edx, eax
    mov eax, 3
    mul edx
    add eax, 54
    mov size_do_arquivo, eax

    ; Prepara valores para serem usados nos loop de cópia e censura
    mov eax, 3
    mul larguda_da_imagem
    mov larguda_da_imagem_bits, eax
    mov eax, 54
    mov controle_copia, eax
    mov ecx, 0
    mov controle_censura_horizontal, ecx

	
    laco_copiar:
        ; Nesse label é feita a leitura do arquivo original por linha
	  ; e esse valor é jogado dentro de um array de bytes
	  ; e a condição de censura é checada.
	  mov eax, larguda_da_imagem_bits
        add controle_copia, eax
        
        invoke ReadFile, file_open_Handle, addr Reader_Line_Buffer, larguda_da_imagem_bits, addr read_Count, NULL
        mov eax, 1
        add controle_censura_horizontal, eax

        mov ecx, coordenada_y
                
        mov ebx, coordenada_y
        add ebx, altura_retangulo

        cmp controle_censura_horizontal, ecx
        jge chamada_de_funcao_censura
        jmp continua_sem_censura

        chamada_de_funcao_censura:
            cmp controle_censura_horizontal, ebx
            jle chamada_de_funcao_censura_2
            jmp continua_sem_censura
        chamada_de_funcao_censura_2:
            call funcao_censura
                    
        continua_sem_censura:
            invoke WriteFile, file_create_Handle, addr Reader_Line_Buffer, larguda_da_imagem_bits, addr write_Count, NULL
        

        mov edx, 0
        mov edx, size_do_arquivo
        cmp controle_copia, edx
        jl laco_copiar
        jmp sair_do_loop
        
    funcao_censura:
	  ;Nesse label os bytes delimitados são censurados.
        push ebp
        mov ebp, esp
        sub esp, 8
    
	  ; Aqui são lidos os 3 parametros na "função"
        mov esi, offset Reader_Line_Buffer
        mov eax, coordenada_x
        mov DWORD PTR[ebp-4], eax
        mov eax, largura_retangulo
        mov DWORD PTR[ebp-8], eax
        mov ecx, DWORD PTR[ebp-4]
        mov controle_censura_vertical, ecx
        mov eax, 3
        mul ecx
        mov ecx, eax
        mov ebx, DWORD PTR[ebp-4]
        add ebx, DWORD PTR[ebp-8]
        mov eax, 3
        mul ebx
        mov ebx, eax

	  ;Aqui é verificado as condições para aplicar a censura
        cmp controle_censura_vertical, ebx
        jle censura_condicao_1
        jmp continuar

        censura_condicao_1:
            cmp controle_censura_vertical, ebx
            jg continuar
            
        censura:
            xor eax, eax
            mov [esi + ecx], al
			mov [esi + ecx+1], al
			mov [esi + ecx+2], al
        continuar:
            add ecx, 1
            
            cmp ecx, ebx
            jbe censura_condicao_1
        
        retorno:
            mov esp, ebp
            pop ebp
            ret

    sair_do_loop:
    invoke CloseHandle, file_open_Handle
    invoke CloseHandle, file_create_Handle

    invoke GetLastError
    invoke ExitProcess, 0

end start