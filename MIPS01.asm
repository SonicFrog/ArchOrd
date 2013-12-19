        ;; Compteur de bits
        ;; Compte tout les bits à 1 dans $a1 mots commencant à
        ;; l'addresse $a0
        ;; Exercice archord 1 hiver 2013

start:
        add     $v0, $zero, $zero ; Mettre $v0 à zéro
        add     $t0, $zero, $zero ; Même chose pour $t0

outer:
        sltu    $t2, $t0, $a1 ; Si $t0 est plus petit que $a1
        beq     $t2, $zero, end ; Si ce n'est pas le cas on a fini
        lw      $t3, 0($a0)     ; On charge le mot à l'address $a0
        addi    $t4, $zero, 32  ; On met $t4 à 32 pour compter les bits

inner:
        beq      $t3, $zero, next    ; Si le contenu de $t3 est zéro tout
                                ; ses bits sont à zéro donc pas besoin
                                ; de compter
        andi    $t1, $t3, 1     ; Sinon on regarde le bit actuel
        add     $v0, $v0, $t1   ; On l'ajoute au compte total overflow
                                ; possible
        slt     $t5, $vo, $zero ; Si v0 est négatif --> overflow
        bne     $t5, $zero, overflow 
        srl     $t3, $t3, 1     ; On shift pour examiner le bit suivant
        j inner                 ; On recommence pour le bit suivant

next:
        addi    $t0, $t0, 1     ; On ajoute 1 à $t0 pour signifier
                                ; qu'on a examiner un mot de plus
        addi    $a0, $a0, 1     ; On augment l'addresse de 1
        j outer                 ; Puis on recommence à compter les
                                ; bits à 1

overflow:
        addi $v0, $zero, -1     ; On met la réponse à 1 car on a overflow

end:
        jr $ra                  ; Retourne la main au caller
