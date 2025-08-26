--1. Revisa el tipo de relación y crea el modelo correspondiente. Respeta las claves
--primarias, foráneas y tipos de datos.

CREATE TABLE PELICULAS(
ID INTEGER PRIMARY KEY,
NOMBRE VARCHAR(255),
ANNO INTEGER
);

CREATE TABLE TAGS(
ID INTEGER PRIMARY KEY,
TAG VARCHAR(255)
);

CREATE TABLE PELICULAS_TAGS(
ID_PELICULAS INT,
ID_TAGS INT,
PRIMARY KEY (ID_PELICULAS, ID_TAGS),
FOREIGN KEY (ID_PELICULAS) REFERENCES PELICULAS(ID),
FOREIGN KEY (ID_TAGS) REFERENCES TAGS(ID)

);


--2. Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados, la
--segunda película debe tener 2 tags asociados.
INSERT INTO PELICULAS 
VALUES
(1,'JOKER',2015),
(2,'AWAKEN',2016),
(3,'DREAMT',2017),
(4,'PERSUE OF JOY',2018),
(5,'JON STONE',2019)
;

INSERT INTO TAGS
VALUES
(1,'DRAMA'),
(2, 'ACCION'),
(3, 'ROMANCE'),
(4, 'INDEPENDIENTE'),
(5, 'COMEDIA')
;

INSERT INTO PELICULAS_TAGS
VALUES
(1,1),
(1,2),
(1,4),
(2,2),
(2,4)
;

--3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe
--mostrar 0.
SELECT PELICULAS.ID, PELICULAS.NOMBRE, COUNT (PELICULAS_TAGS.ID_TAGS)
FROM PELICULAS 
LEFT JOIN PELICULAS_TAGS
ON PELICULAS.ID=PELICULAS_TAGS.ID_PELICULAS
GROUP BY PELICULAS.ID, PELICULAS.NOMBRE
ORDER BY ID
;



--4. Crea las tablas correspondientes respetando los nombres, tipos, claves primarias y
--foráneas y tipos de datos.

CREATE TABLE PREGUNTAS(
ID INTEGER PRIMARY KEY,
PREGUNTA VARCHAR(255),
RESPUESTA_CORRECTA VARCHAR
);
SELECT * FROM PREGUNTAS

CREATE TABLE USUARIOS (
ID INTEGER PRIMARY KEY,
NOMBRE VARCHAR(255),
EDAD INTEGER 
);
SELECT * FROM USUARIOS

CREATE TABLE RESPUESTAS(
ID INTEGER PRIMARY KEY,
RESPUESTA VARCHAR (255),
USUARIO_ID INTEGER,
PREGUNTA_ID INTEGER,
FOREIGN KEY (USUARIO_ID) REFERENCES USUARIOS(ID),
FOREIGN KEY (PREGUNTA_ID) REFERENCES PREGUNTAS(ID)
);
select * from RESPUESTAS;

--5. Agrega 5 usuarios y 5 preguntas.
--a. La primera pregunta debe estar respondida correctamente dos veces, por dos
--usuarios diferentes.
--b. La segunda pregunta debe estar contestada correctamente solo por un
--usuario.
--c. Las otras tres preguntas deben tener respuestas incorrectas.
--Contestada correctamente signica que la respuesta indicada en la tabla respuestas
--es exactamente igual al texto indicado en la tabla de preguntas.

INSERT INTO USUARIOS VALUES
(1,'JUAN', 19),
(2, 'MATIAS',21),
(3, 'JOSÉ', 19),
(4, 'JUANP',20),
(5, 'KARLOS', 35)
;
INSERT INTO PREGUNTAS VALUES
(1,'PAIS MÁS RICO','USA'),
(2, 'PAIS MÁS POPULOSO', 'CHINA'),
(3, 'CAPITAL DE PARAGUAY', 'ASUNCIÓN'),
(4, 'CAPITAL DE CHILE', 'SANTIAGO'),
(5, 'CAPITAL DE URUGUAY', 'MONTEVIDEO')
;

INSERT INTO RESPUESTAS VALUES
(1,'USA',1,1),
(2, 'USA',2,1),
(3, 'CHINA',3,2),
(4, 'PARAGUAY',3,3),
(5, 'MONTEVIDEO',3,4),
(6, 'REDENTOR',3,5)
;


--6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
--pregunta).
SELECT USUARIOS.ID, USUARIOS.NOMBRE , COUNT (RESPUESTAS.ID)
FROM USUARIOS
LEFT JOIN RESPUESTAS ON USUARIOS.ID = RESPUESTAS.USUARIO_ID
LEFT JOIN PREGUNTAS ON RESPUESTAS.PREGUNTA_ID = PREGUNTAS.ID
WHERE RESPUESTAS.RESPUESTA=PREGUNTAS.RESPUESTA_CORRECTA
GROUP BY USUARIOS.ID, USUARIOS.NOMBRE
;

--7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron
--correctamente.
SELECT PREGUNTAS.ID, PREGUNTAS.PREGUNTA , COUNT (RESPUESTAS.ID)
FROM PREGUNTAS
LEFT JOIN RESPUESTAS ON PREGUNTAS.ID = RESPUESTAS.PREGUNTA_ID
LEFT JOIN USUARIOS ON RESPUESTAS.USUARIO_ID = USUARIOS.ID
WHERE RESPUESTAS.RESPUESTA=PREGUNTAS.RESPUESTA_CORRECTA
GROUP BY PREGUNTAS.ID,PREGUNTAS.PREGUNTA
;
--8. Implementa un borrado en cascada de las respuestas al borrar un usuario. Prueba la
--implementación borrando el primer usuario.

ALTER TABLE RESPUESTAS 
DROP CONSTRAINT RESPUESTAS_USUARIO_ID_FKEY , 
ADD FOREIGN KEY (USUARIO_ID) REFERENCES USUARIOS(ID) ON DELETE CASCADE;

DELETE FROM USUARIOS WHERE ID=1;
select * from respuestas;

--9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de
--datos.
ALTER TABLE USUARIOS 
ADD CONSTRAINT USUARIOS_EDAD_CHECK
CHECK(EDAD>=18);

--10. Altera la tabla existente de usuarios agregando el campo email. Debe tener la
--restricción de ser único.
ALTER TABLE USUARIOS ADD COLUMN EMAIL VARCHAR UNIQUE;
SELECT * FROM USUARIOS;