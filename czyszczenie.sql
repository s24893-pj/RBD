/*___________________________________________________________________________________________________________________________

							CZYSZCZENIE BAZY DANYCH
___________________________________________________________________________________________________________________________*/

/*---------CZYSZCZENIE PROCEDUR---------*/
DROP PROCEDURE AvgCenaWynajmu;
DROP PROCEDURE DaneKlientów;
DROP PROCEDURE PensjaPracownika;

/*---------CZYSZCZENIE INDEXÓW---------*/
ALTER TABLE klient DROP INDEX klient_imie_idx;
ALTER TABLE pracownik DROP INDEX pracownik_imie_idx;
ALTER TABLE model DROP INDEX model_marka_idx;
ALTER TABLE oddział DROP INDEX oddział_miasto_idx;
ALTER TABLE samochód DROP INDEX samochód_rejestracja_idx;
ALTER TABLE adres DROP INDEX adres_miasto_idx;

/*---------CZYSZCZENIE FOREIGN KEY---------*/
ALTER TABLE pracownik DROP FOREIGN KEY id_pracownik_oddział_fk;
ALTER TABLE pracownik DROP FOREIGN KEY id_pracownik_adres_fk;
ALTER TABLE samochód DROP FOREIGN KEY id_samochód_oddział_fk;
ALTER TABLE klient DROP FOREIGN KEY id_klient_adres_fk;
ALTER TABLE samochód_model DROP FOREIGN KEY id_samochód_model_samochód_fk;
ALTER TABLE samochód_model DROP FOREIGN KEY id_samochód_model_model_fk;
ALTER TABLE wynajem DROP FOREIGN KEY id_wynajem_samochód_model_fk;
ALTER TABLE usługa DROP FOREIGN KEY id_usługa_pracownik_dostawa_fk;
ALTER TABLE usługa DROP FOREIGN KEY id_usługa_pracownik_odbiór_fk;
ALTER TABLE usługa DROP FOREIGN KEY id_usługa_adres_dostawa_fk;
ALTER TABLE usługa DROP FOREIGN KEY id_usługa_adres_obiór_fk;
ALTER TABLE usługa DROP FOREIGN KEY id_usługa_wynajem_fk;
ALTER TABLE klient_usługa DROP FOREIGN KEY id_klient_usługa_klient_fk;
ALTER TABLE klient_usługa DROP FOREIGN KEY id_klient_usługa_usługa_fk;

/*---------CZYSZCZENIE WIDOKÓW---------*/
DROP VIEW dane_klient;
DROP VIEW dane_pracownik;
DROP VIEW dane_wynajmu;
DROP VIEW samochody_niesprawne;
DROP VIEW samochody_sprawne;

/*---------CZYSZCZENIE TABEL Z DANYCH---------*/
TRUNCATE TABLE klient_usługa;
TRUNCATE TABLE usługa;
TRUNCATE TABLE wynajem;
TRUNCATE TABLE samochód_model;
TRUNCATE TABLE model;
TRUNCATE TABLE samochód;
TRUNCATE TABLE klient;
TRUNCATE TABLE pracownik;
TRUNCATE TABLE oddział;
TRUNCATE TABLE adres;

/*---------CZYSZCZENIE TABEL---------*/
drop table klient_usługa;
drop table usługa;
drop table wynajem;
drop table samochód_model;
drop table model;
drop table samochód;
drop table klient;
drop table pracownik;
drop table oddział;
drop table adres;



/*---------CZYSZCZENIE BAZY DANYCH---------*/
DROP DATABASE wypożyczalnia;