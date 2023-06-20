section .data
    person_name db "John Doe", 0
    person_age db 30

section .text
    global _start

_start:
    ; Erzeuge eine Instanz des Person-Objekts
    mov eax, person_name
    movzx ebx, byte [person_age]
    push eax
    push ebx
    call create_person

    ; Rufe die Funktion zur Ausgabe des Namens auf
    mov eax, [eax]
    call print_name

    ; Rufe die Funktion zur Ausgabe des Alters auf
    mov eax, [eax]
    call print_age

    ; Beende das Programm
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Funktion zum Erzeugen einer Person-Instanz
create_person:
    pusha
    ; Alloziere Speicher für die Person-Instanz
    mov eax, 8 ; Größe der Person-Instanz (4 Bytes für den Namen, 1 Byte für das Alter, 3 Bytes Padding)
    mov ebx, 0 ; Flags für allozierten Speicher (hier 0, da wir keinen speziellen Flags verwenden)
    mov ecx, 3 ; Schreib- und Ausführungsberechtigungen
    mov edx, 2 ; Alloziere Speicher
    int 0x80

    ; Initialisiere das Name-Feld der Person-Instanz
    mov [eax], ebp ; Ersatz für den Namen
    add eax, 4 ; Gehe zum Alter-Feld
    mov [eax], ebp ; Ersatz für das Alter

    popa
    ret

; Klasse Person
section .data
    vtable_person dd print_name, print_age ; Vtable mit Methodenzeigern

; Methode print_name der Klasse Person
print_name:
    pusha
    ; Lade das Name-Feld der Person-Instanz
    mov eax, [ecx + 4]
    call print_string
    popa
    ret

; Methode print_age der Klasse Person
print_age:
    pusha
    ; Lade das Alter-Feld der Person-Instanz
    movzx eax, byte [ecx + 8]
    call print_byte
    popa
    ret

; Funktion zur Ausgabe einer Null-terminierten Zeichenkette
print_string:
    pusha
    mov edx, 0
    mov ecx, eax
    mov ebx, 1
    mov eax, 4
    int 0x80
    popa
    ret

; Funktion zur Ausgabe einer einzelnen Byte-Zahl
print_byte:
    pusha
    add al, 0x30 ; Konvertiere das Byte in den ASCII-Wert
    mov edx, 1
    mov ecx, eax
    mov ebx, 1
    mov eax, 4
    int 0x80
    popa
    ret
