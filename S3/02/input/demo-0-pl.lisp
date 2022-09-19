;;;; -*-coding: utf-8;-*-

(in-package :grieg)

(define-flexible-questionnaire "demo-0-pl"
  :title "Dodatkowe informacje"
  :next "PRZEJDŹ DALEJ"
  :back "WRÓĆ"
  :items
  `((:sc "Na ile martwisz się zmianą klimatu?"
     :opt ("W ogóle się tym nie martwię"
           "Niezbyt się martwię"
           "Trochę się martwię"
           "Bardzo się martwię"
           "Niezwykle się tym martwię"))
    (:sc "Wskaż swoją płeć."
     :opt ("Kobieta"
           "Mężczyzna"
           ("Inna" :subq ((:te "Jaka?")))))
    (:te "Podaj swój rok urodzenia."  :verifier ,(in-interval-checker 1900 2022))
    (:te "Wskaż państwo, w którym mieszkasz obecnie."
     :helptext "Chodzi tutaj o miejsce stałego pobytu, a nie o pobyt
     tymczasowy (np. w celu wyjazdu wypoczynkowego lub służbowego)."
     :completions ,*countries-pl*)
    (:te "Jakim językiem posługujesz się najczęściej w swoim domu? Wskaż pierwszy,
    najczęściej używany przez ciebie język:"
     :completions ,*languages-pl*)
    (:te "Czy w swoim domu posługujesz się jeszcze jakimś językiem? Jeśli tak,
    wskaż drugi, najczęściej używany przez ciebie język:"
     :helptext "Pytanie opcjonalne."
     :optional t
     :completions ,*languages-pl*)
    (:sc "Które z przedstawionych określeń najlepiej opisuje miejsce, w którym mieszkasz?"
     :opt ("Duże miasto"
           "Przedmieścia lub obrzeża dużego miasta"
           "Średnie lub małe miasto"
           "Wieś"
           "Pojedyncze gospodarstwo lub dom na terenie wiejskim"))
    (:sc "Jakie masz wykształcenie?"
     :helptext "Chodzi tutaj o ukończoną przez ciebie szkołę najwyższego szczebla."
     :opt ("Niepełne podstawowe"
           "Podstawowe"
           "Gimnazjalne"
           "Zawodowe lub zasadnicze zawodowe"
           "Średnie"
           "Dyplom licencjacki lub dyplom inżynierski"
           "Dyplom magistra lub dyplom lekarza"
           "Stopień naukowy doktora, doktora habilitowanego lub tytuł profesora"
           ("Inne" :subq ((:te "Jakie?")))))
    (:sc "Czy uważasz siebie za osobę o określonych poglądach politycznych?"
     :opt ("Nie"
           ("Tak" :subq ((:sc "W polityce mówi się czasem o „lewicy” i
           „prawicy”. Czy potrafisz określić swoje poglądy posługując
           się tymi pojęciami?"
                          :opt ("Nie"
                                ("Tak" :id "yes"))
                          :id "p2"))
                  :id "yes"))
     :id "p1")
    (:scale "Wskaż, jak opisał[[//a]]byś swoje poglądy polityczne."
     :helptext "Na poniższej skali 0 oznacza lewicę, a 10 – prawicę.
     Pozostałe liczby służą do wyrażenia przekonań pośrednich."
     :visible-if (:and (:selected "p1" "yes") (:selected "p2" "yes"))
     :ends (0 10)
     :descriptions ("Lewica" "Prawica"))
    (:sc "Które z określeń najlepiej opisuje twoje odczucia na temat
    obecnych dochodów w gospodarstwie domowym?"
     :opt ("Żyjemy/żyję dostatnio przy obecnym poziomie dochodów"
           "Dajemy/daję sobie radę przy obecnym poziomie dochodów"
           "Z trudem dajemy/daję sobie radę przy obecnym poziomie dochodów"
           "Praktycznie nie dajemy/nie daję sobie rady przy obecnym poziomie dochodów"))))
