/*___________________________________________________________________________________________________________________________

							ZAPYTANIA DO BAZY DANYCH
___________________________________________________________________________________________________________________________*/

/*---------WYKORZYSTANIE WIDOKI---------*/

-- Select pozwalający dodać imie I numer do klienta do widoku dane_wynajmu I sortować po jego id
SELECT dane_wynajmu.*, pesel, nr_tel FROM dane_wynajmu
join klient;

-- Select pozwalający wyświetlić pełne dane klienta
SELECT * FROM dane_klient;

-- Select pozwalający wyświetlić pełne dane pracowników o id 1-5
SELECT * FROM dane_pracownik
WHERE dane_pracownik.id_pracownika BETWEEN 1 AND 5;

-- Select pozwalający wyświetlić rejestracje wszystkich sprawnych samochodów toyota solara
SELECT rejestracja FROM samochody_sprawne
WHERE marka = 'Toyota' AND model = 'SOLARA';

-- Select pozwalający wyświetlić rejestrację markę oraz model każdego niesprawnego pojazdu
SELECT rejestracja, marka, model FROM samochody_niesprawne;

/*---------WYKORZYSTANIE FUNKCJI LEFT RIGHT FULL JOIN---------*/
/*---------INNER JOIN WYKORZYSTANY PRZY TWORZENIU WIDOKÓW---------*/

-- Selekt wypisujący listę klientów którzy nie skorzystali z żadnej usługi
SELECT ku.id, imie, nazwisko FROM klient
left join klient_usługa ku on klient.id = ku.id_klient
where ku.id is null;

-- Selekt wypisujący listę wynajmów które nie zostały jeszcze realizowane przez klientów
SELECT w.id from usługa
right join wynajem w on usługa.id_wynajem = w.id
WHERE usługa.id IS NULL;

-- Full Outer Join
select * from pracownik
left join usługa
on pracownik.id = usługa.id_pracownik_odbiór
union
select * from pracownik
right JOIN usługa on pracownik.id = usługa.id_pracownik_dostawa;


/*---------AKTUALIZACJA DANYCH---------*/

-- Zmiana nazwisk klientów z id 15-20 na "Kowalski"
UPDATE klient
SET nazwisko = 'Kowalski'
WHERE id BETWEEN 15 AND 20;

-- Podniesienie wszystkich cen wynajmu o 10%
UPDATE wynajem
SET cena_24h = cena_24h+(cena_24h*0.1);

-- Podwyżka 200 dla pracowników oddziału nr.2
UPDATE pracownik
SET pensja = pensja + 200
WHERE id_oddział = '2';

-- Przedłużenie usługi wynajmu o indexie 8 o jeden dzień
UPDATE klient_usługa
SET data_koniec = data_koniec + day('0000-00-01')
WHERE id = 8;

/*---------WYKORZYSTANIE FUNKCJI---------*/

DELIMITER $$
CREATE PROCEDURE DaneKlientów()
BEGIN
    SELECT *
    FROM klient;
end $$
DELIMITER ;
-- Wywołanie
CALL DaneKlientów();

DELIMITER $$
CREATE PROCEDURE PensjaPracownika(IN peselPracownika VARCHAR(11))
BEGIN
    SELECT pensja
    FROM pracownik
    WHERE pracownik.pesel = peselPracownika;
end $$
DELIMITER ;
-- Wywołanie
CALL PensjaPracownika(95840588113);

DELIMITER $$
CREATE PROCEDURE AvgCenaWynajmu()
BEGIN
    SELECT AVG(cena_24h)
    FROM wynajem;
end $$
DELIMITER ;
-- Wywołanie
CALL AvgCenaWynajmu();

/*---------WYKORZYSTANIE FILTRÓW---------*/

-- wypisanie id i imion klientów na A
select id, imie FROM klient
WHERE imie LIKE 'A%';

-- wypisanie id i imion klientów zawierających A
select id, imie FROM klient
WHERE imie LIKE '%A%';

-- wypisanie nazwisk klientów zaczynających się na k i kończących na i
select id, nazwisko FROM klient
WHERE nazwisko LIKE 'k%i';

-- wypisanie nazwisk prawcowników o indeksie 3-7
SELECT id, nazwisko FROM pracownik
WHERE id BETWEEN 3 AND 7;

/*---------WYKORZYSTANIE FUNKCJI SORTOWANIA I GRUPOWANIA---------*/

-- Selekt grupujący liczbę sprawnych i niesprawnych samochodów
SELECT COUNT(id) as 'liczba_samochodów', sprawny
FROM samochód
group by sprawny
order by sprawny desc;

-- Selekt sortujący imiona klientów alfabetycznie
SELECT imie FROM klient
order by imie;

/*---------USUWANIE DANYCH---------*/

-- Usunięcie wszystkich nie użytych do tej pory adresów
DELETE A from adres A
left join klient k on A.id = k.id_adres
left join pracownik p on A.id = p.id_adres
left join usługa u on A.id = u.id_adres_dostawa and A.id = u.id_adres_obiór
WHERE k.id_adres IS NULL AND p.id_adres IS NULL AND u.id_adres_obiór IS NULL AND u.id_adres_dostawa IS NULL;