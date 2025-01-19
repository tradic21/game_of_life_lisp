# game_of_life_lisp
Za pokretanje aplikacije potrebno je imati sljedeće alate instalirane na računalu:

1. **GNU Emacs**  
   - Preuzimanje i instalacija: [Emacs službena stranica](https://www.gnu.org/software/emacs/)  

## Pokretanje aplikacije
1. Učitavanje aplikacije u Emacs:
   - Pokrenite Emacs.
   - Pritisnite M-x (Alt+X) i upišite load-file (ENTER)
   - Zatim unesite putanju do datoteke: M-x putanja/do/datoteke/game_of_life.lisp (ENTER)
3. Za pokretanje igre s nasumičnim stanjem stanica:
   - M-x game-of-life
4. Za postavljanje unaprijed definiranih uzoraka:
   - M-x set-pattern
   - Odaberite jedan od ponuđenih uzoraka upisivanjem njegovog naziva (npr. block, blinker, spaceship).
5. Za pokretanje simulacije s definiranim brojem koraka i vremenskim razmakom između njih koristite naredbu:
   - M-x game-of-life-run
6. Za izvođenje pojedinačnog koraka simulacije:
   - M-x game-of-life-step
