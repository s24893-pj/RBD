/*___________________________________________________________________________________________________________________________

					TWORZENIE BAZY DANYCH, TABEL, RELACJI, INDEXÓW
___________________________________________________________________________________________________________________________*/
CREATE TABLE adres
(
    id           INT         NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    kraj         varchar(50) NOT NULL,
    ulica        varchar(50) NOT NULL,
    miasto       varchar(50) NOT NULL,
    kod_pocztowy varchar(10) NOT NULL
);
CREATE TABLE oddział
(
    id     INT         NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    kraj   varchar(50) NOT NULL,
    miasto varchar(50) NOT NULL
);
CREATE TABLE pracownik
(
    id                INT           NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    imie              VARCHAR(50)   NOT NULL,
    nazwisko          VARCHAR(50)   NOT NULL,
    id_oddział        INT           NOT NULL,
    id_adres          INT           NOT NULL,
    pesel             long          NOT NULL,
    nr_tel            long          NOT NULL,
    data_zatrudnienie DATE          NOT NULL,
    pensja            DECIMAL(6, 2) NOT NULL
);
CREATE TABLE samochód
(
    id          INT         NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    id_oddział  INT         NOT NULL,
    rejestracja VARCHAR(20) NOT NULL,
    sprawny     BOOLEAN     NOT NULL
);
CREATE TABLE model
(
    id      INT         NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    marka   varchar(50) NOT NULL,
    model   varchar(50) NOT NULL,
    rocznik INT         NOT NULL,
    silnik  varchar(10) NOT NULL,
    K_M     int         NOT NULL
);
CREATE TABLE klient
(
    id       INT         NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    imie     varchar(50) NOT NULL,
    nazwisko varchar(50) NOT NULL,
    pesel    long        NOT NULL,
    nr_tel   long        NOT NULL,
    id_adres INT         NOT NULL
);
CREATE TABLE samochód_model
(
    id          INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    id_samochód INT NOT NULL,
    id_model    INT NOT NULL
);
CREATE TABLE wynajem
(
    id                INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    id_samochód_model INT NOT NULL,
    cena_24h          INT NOT NULL
);
CREATE TABLE usługa
(
    id                   INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    id_pracownik_dostawa INT NOT NULL,
    id_pracownik_odbiór  INT NOT NULL,
    id_adres_dostawa     INT NOT NULL,
    id_adres_obiór       INT NOT NULL,
    id_wynajem           INT NOT NULL
);
CREATE TABLE klient_usługa
(
    id            INT  NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    id_klient     INT  NOT NULL,
    id_usługa     INT  NOT NULL,
    data_początek DATE NOT NULL,
    data_koniec   DATE NOT NULL
);

ALTER TABLE pracownik
    ADD CONSTRAINT id_pracownik_oddział_fk
        FOREIGN KEY (id_oddział) REFERENCES oddział (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    ADD CONSTRAINT id_pracownik_adres_fk
        FOREIGN KEY (id_adres) REFERENCES adres (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE;

ALTER TABLE samochód
    ADD CONSTRAINT id_samochód_oddział_fk
        FOREIGN KEY (id_oddział) REFERENCES oddział (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE;

ALTER TABLE klient
    ADD CONSTRAINT id_klient_adres_fk
        FOREIGN KEY (id_adres) REFERENCES adres (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE;

ALTER TABLE samochód_model
    ADD CONSTRAINT id_samochód_model_samochód_fk
        FOREIGN KEY (id_samochód) REFERENCES samochód (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT id_samochód_model_model_fk
        FOREIGN KEY (id_model) REFERENCES model (id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION;

ALTER TABLE wynajem
    ADD CONSTRAINT id_wynajem_samochód_model_fk
        FOREIGN KEY (id_samochód_model) REFERENCES samochód_model (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE;

ALTER TABLE usługa
    ADD CONSTRAINT id_usługa_pracownik_dostawa_fk
        FOREIGN KEY (id_pracownik_dostawa) REFERENCES pracownik (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    ADD CONSTRAINT id_usługa_pracownik_odbiór_fk
        FOREIGN KEY (id_pracownik_odbiór) REFERENCES pracownik (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    ADD CONSTRAINT id_usługa_adres_dostawa_fk
        FOREIGN KEY (id_adres_dostawa) REFERENCES adres (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    ADD CONSTRAINT id_usługa_adres_obiór_fk
        FOREIGN KEY (id_adres_obiór) REFERENCES adres (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    ADD CONSTRAINT id_usługa_wynajem_fk
        FOREIGN KEY (id_wynajem) REFERENCES wynajem (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE;

ALTER TABLE klient_usługa
    ADD CONSTRAINT id_klient_usługa_klient_fk
        FOREIGN KEY (id_klient) REFERENCES klient (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
ADD CONSTRAINT id_klient_usługa_usługa_fk
        FOREIGN KEY (id_usługa) REFERENCES usługa (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE;

CREATE INDEX klient_imie_idx
ON klient(imie);

CREATE INDEX pracownik_imie_idx
ON pracownik(imie);

CREATE INDEX model_marka_idx
ON model(marka);

CREATE INDEX oddział_miasto_idx
ON oddział(miasto);

CREATE INDEX samochód_rejestracja_idx
ON samochód(rejestracja);

CREATE INDEX adres_miasto_idx
ON adres(miasto);

/*___________________________________________________________________________________________________________________________

							TWORZENIE WIDOKÓW
___________________________________________________________________________________________________________________________*/


/*---------DANE WYNAJMU (ID KLIENTA, MARKA MODEL SAMOCHODU, CENA WYNAJMU)---------*/
create view dane_wynajmu
AS SELECT klient.id as 'id_klient', marka, model ,datediff(data_koniec, data_początek) as 'liczba_dni', datediff(data_koniec, data_początek)*w.cena_24h as 'cena_total'
FROM klient
JOIN klient_usługa ku on klient.id = ku.id_klient
join usługa u on ku.id_usługa = u.id
join wynajem w on u.id_wynajem = w.id
join samochód_model sm on sm.id = w.id_samochód_model
join model m on sm.id_model = m.id;

/*---------DANE WYNAJMU UPDATE SORTUJĄCY PO ID KLIENTA OD NAJWYŻSZEGO---------*/
alter view dane_wynajmu
AS SELECT klient.id as 'id_klient', marka, model ,datediff(data_koniec, data_początek) as 'liczba_dni', datediff(data_koniec, data_początek)*w.cena_24h as 'cena_total'
FROM klient
JOIN klient_usługa ku on klient.id = ku.id_klient
join usługa u on ku.id_usługa = u.id
join wynajem w on u.id_wynajem = w.id
join samochód_model sm on sm.id = w.id_samochód_model
join model m on sm.id_model = m.id
order by klient.id desc;



/*___________________________________________________________________________________________________________________________*/

/*---------DANE KLIENTÓW Z ADRESEM---------*/
CREATE VIEW dane_klient
AS SELECT klient.id as 'id_klienta', imie, nazwisko,pesel, nr_tel, ulica, miasto
FROM klient
join adres a on a.id = klient.id_adres;

/*---------DANE PRACOWNIKA Z ADRESEM---------*/
CREATE VIEW dane_pracownik
AS SELECT pracownik.id as 'id_pracownika', imie, nazwisko,pesel, nr_tel, ulica, miasto
FROM pracownik
join adres a on a.id = pracownik.id_adres;

/*___________________________________________________________________________________________________________________________*/

/*---------SAMOCHODY SPRAWNE---------*/
CREATE VIEW samochody_sprawne
AS SELECT samochód.id, samochód.rejestracja, m.marka, m.model, samochód.sprawny
FROM samochód
join samochód_model sm on samochód.id = sm.id_samochód
join model m on m.id = sm.id_model
WHERE samochód.sprawny = true;

/*---------SAMOCHODY SPRAWNE UPDATE SORTUJĄCY PO ID---------*/
ALTER VIEW samochody_sprawne
AS SELECT samochód.id, samochód.rejestracja, m.marka, m.model, samochód.sprawny
FROM samochód
join samochód_model sm on samochód.id = sm.id_samochód
join model m on m.id = sm.id_model
WHERE samochód.sprawny = true
ORDER BY samochód.id;

/*---------SAMOCHODY NIESPRAWNE---------*/
CREATE VIEW samochody_niesprawne
AS SELECT samochód.id, samochód.rejestracja, m.marka, m.model, samochód.sprawny
FROM samochód
join samochód_model sm on samochód.id = sm.id_samochód
join model m on m.id = sm.id_model
WHERE samochód.sprawny = false;