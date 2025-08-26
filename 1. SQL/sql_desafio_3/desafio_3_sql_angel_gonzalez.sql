--1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo pedido.

CREATE DATABASE if not exists desafio3_angel_gonzalez_001
    WITH
    OWNER = postgres
    ENCODING = 'WIN1252'
    LC_COLLATE = 'Spanish_Paraguay.1252'
    LC_CTYPE = 'Spanish_Paraguay.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

create table if not exists usuarios(
id serial,
email varchar,
nombre varchar,
apellido varchar,
rol varchar
);

insert into usuarios
values 
(1, 'pablo@op.com', 'Pablo', 'Medina', 'Administrador'),
(2, 'juan@op.com', 'Juan', 'Medina', 'Administrador'),
(3, 'karajallo@op.com', 'Ana', 'Karajallo', 'Usuario'),
(4, 'maria@op.com', 'Maria', 'Medina', 'Usuario'),
(5, 'lucinda@pj.com', 'Lucinda', 'Aparecida', 'Usuario')
;

create table if not exists posts(
id serial,
titulo varchar,
contenido text,
fecha_creacion timestamp,
fecha_actualizacion timestamp,
destacado boolean,
usuario_id bigint
);

insert into posts 
values
(1,'Agua contaminada desemboca en el Parana','Agua contaminada desemboca en el Parana','2024-10-10 23:11', '2024-10-10 23:11',true, 1),
(2,'O eso dicen','O eso dicen','2024-10-10 23:11', '2024-10-10 23:11',false, 1),
(3,'hola','hola','2024-11-11 15:15', '2024-11-11 15:16',false, 3),
(4,'que es esto?','que?','2024-11-11 15:20', '2024-11-11 16:00',true, 4),
(5,'cuidense','cuidense','2024-11-11 15:25', '2024-11-11 15:25',false,null)
;

create table if not exists comentarios(
id serial,
contenido varchar,
fecha_creacion timestamp,
usuario_id bigint,
post_id bigint
);

insert into comentarios
values
(1,'comenten','2024-10-10 23:12', 1,1),
(2,'en serio?','2024-10-11 09:27', 2,1),
(3,'yo tmb recien me entero','2024-10-11 09:30', 3,1),
(4,'pueden comentar','2024-10-10 23:12', 1,2),
(5,'quien que?','2024-10-11 09:29', 2,2)
;
select * from posts, usuarios, comentarios
--2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas:
--nombre y email del usuario junto al título y contenido del post.

select usuarios.nombre, usuarios.email,posts.titulo,posts.contenido
from usuarios 
full outer join posts
on usuarios.id= posts.usuario_id;

--3. Muestra el id, título y contenido de los posts de los administradores.
--a. El administrador puede ser cualquier id.

select * from (
select posts.id, posts.titulo,posts.contenido
from usuarios 
full outer join posts
on usuarios.id= posts.usuario_id
where usuarios.rol= 'Administrador')
where id is not null;

--4. Cuenta la cantidad de posts de cada usuario.
--a. La tabla resultante debe mostrar el id e email del usuario junto con la
--cantidad de posts de cada usuario.
--Hint: Aquí hay diferencia entre utilizar inner join, left join o right join, prueba con
--todas y con eso determina cuál es la correcta. No da lo mismo la tabla desde la que
--se parte.

select usuarios.id, usuarios.email,count(posts.id)
from usuarios 
left join posts --Notar que también se podria usar full outer join, de querer mostrar la cantidad de posts sin user
on usuarios.id= posts.usuario_id
group by usuarios.id, usuarios.email;

--5. Muestra el email del usuario que ha creado más posts.
--a. Aquí la tabla resultante tiene un único registro y muestra solo el email.

select email from(
select usuarios.email,count(posts.id) as counts
from usuarios 
left join posts
on usuarios.id= posts.usuario_id
group by usuarios.email
order by counts desc
limit 1);

--6. Muestra la fecha del último post de cada usuario.
--Hint: Utiliza la función de agregado MAX sobre la fecha de creación.

select usuarios.nombre,usuarios.email,max(posts.fecha_creacion) as newest
from usuarios 
full outer join posts
on usuarios.id= posts.usuario_id
group by usuarios.nombre, usuarios.email;

--7. Muestra el título y contenido del post (artículo) con más comentarios.

select titulo, contenido from(
select posts.titulo, posts.contenido, count (comentarios.id) as counts
from posts 
left join comentarios 
on posts.id=comentarios.post_id
group by posts.titulo, posts.contenido
order by counts desc
limit 1);

    --8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
    --de cada comentario asociado a los posts mostrados, junto con el email del usuario
    --que lo escribió.

select posts.titulo as post, posts.contenido as post_content, comentarios.contenido as comment, usuarios.email
from posts
left join comentarios on posts.id= comentarios.post_id
left join usuarios on comentarios.usuario_id= usuarios.id
-- lo anterior muestra el email de quien escribió el comentario
--para mostrar el email de quien escribió el post usar on posts.usuario_id= usuarios.id

--9. Muestra el contenido del último comentario de cada usuario.
select usuarios.nombre,usuarios.email,comentarios.contenido
from usuarios 
full outer join comentarios
on usuarios.id= comentarios.usuario_id
where comentarios.fecha_creacion= ( select max(fecha_creacion) from comentarios where comentarios.usuario_id= usuarios.id)
;

--10. Muestra los emails de los usuarios que no han escrito ningún comentario.
--Hint: Recuerda el uso de Having

select usuarios.email
from usuarios 
left join comentarios
on usuarios.id= comentarios.usuario_id
group by usuarios.nombre, usuarios.email
having count(comentarios.contenido)=0;


