-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 15, 2019 at 03:08 PM
-- Server version: 5.6.41-84.1-log
-- PHP Version: 7.2.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `aeortizc_mensajes`
--
CREATE DATABASE IF NOT EXISTS `aeortizc_mensajes` DEFAULT CHARACTER SET utf8 COLLATE utf8_swedish_ci;
USE `aeortizc_mensajes`;

DELIMITER $$
--
-- Procedures
--
CREATE PROCEDURE `prc_evento_borrar` (IN `p_id_evento` INT(11) UNSIGNED)  SQL SECURITY INVOKER
BEGIN

  DELETE FROM eventos
  WHERE id_evento = p_id_evento;

END$$

CREATE PROCEDURE `prc_evento_grabar_crear` (IN `p_titulo_evento` VARCHAR(64), IN `p_subtitulo_evento` VARCHAR(64), IN `p_resumen_evento` VARCHAR(64), IN `p_fecha` DATE, IN `p_fecha_fin` DATE, IN `p_horario` VARCHAR(64), IN `p_lugar` VARCHAR(64), IN `p_precio` DECIMAL(10,2), IN `p_ocultar_precio` INT)  SQL SECURITY INVOKER
BEGIN

  INSERT INTO eventos(titulo_evento, subtitulo_evento, resumen_evento, fecha, fecha_fin, horario, lugar, precio, ocultar_precio)
  VALUES (p_titulo_evento, p_subtitulo_evento, p_resumen_evento, p_fecha, p_fecha_fin, p_horario, p_lugar, p_precio, p_ocultar_precio);

END$$

CREATE PROCEDURE `prc_evento_grabar_modificar` (IN `p_id_evento` INT, IN `p_titulo_evento` VARCHAR(64), IN `p_subtitulo_evento` VARCHAR(64), IN `p_resumen_evento` MEDIUMTEXT, IN `p_fecha` DATE, IN `p_fecha_fin` DATE, IN `p_horario` VARCHAR(64), IN `p_lugar` VARCHAR(64), IN `p_precio` DECIMAL(10,2), IN `p_ocultar_precio` INT)  SQL SECURITY INVOKER
BEGIN

  UPDATE eventos set 
    titulo_evento    = p_titulo_evento, 
    subtitulo_evento = p_subtitulo_evento, 
    resumen_evento   = p_resumen_evento, 
    fecha            = p_fecha, 
    fecha_fin        = p_fecha_fin, 
    horario          = p_horario, 
    lugar            = p_lugar, 
    precio           = p_precio,
    ocultar_precio   = p_ocultar_precio
  WHERE id_evento    = p_id_evento;

END$$

CREATE PROCEDURE `prc_expositor_borrar` (IN `p_id_expositor` INT)  SQL SECURITY INVOKER
BEGIN

  IF NOT EXISTS(SELECT * FROM mensajes WHERE id_expositor = p_id_expositor) THEN

    DELETE FROM expositores WHERE id_expositor = p_id_expositor;

  END IF;

END$$

CREATE PROCEDURE `prc_expositor_grabar_crear` (IN `p_nombres` VARCHAR(64), IN `p_apellidos` VARCHAR(64))  SQL SECURITY INVOKER
BEGIN

  INSERT INTO expositores(nombres, apellidos) VALUES(p_nombres, p_apellidos);

END$$

CREATE PROCEDURE `prc_expositor_grabar_modificar` (IN `p_id_expositor` INT, IN `p_nombres` VARCHAR(64), IN `p_apellidos` VARCHAR(64))  SQL SECURITY INVOKER
BEGIN

  UPDATE expositores set nombres = p_nombres, apellidos = p_apellidos
  WHERE id_expositor = p_id_expositor;

END$$

CREATE PROCEDURE `prc_grupo_borrar` (IN `p_id_grupo` INT(10) UNSIGNED)  SQL SECURITY INVOKER
BEGIN

  DELETE FROM grupos
  WHERE id_grupo = p_id_grupo;

END$$

CREATE PROCEDURE `prc_grupo_grabar_crear` (`p_nombre` VARCHAR(64), `p_ubicacion` MEDIUMTEXT, `p_dia_reunion` INT(11), `p_id_lider_grupo` INT, `p_url` VARCHAR(255), `p_hora_reunion` TIME)  BEGIN

  INSERT INTO grupos(nombre, ubicacion, dia_reunion, hora_reunion, id_lider_grupo, url)
  VALUES(p_nombre, p_ubicacion, p_dia_reunion, p_hora_reunion, p_id_lider_grupo, p_url);

END$$

CREATE PROCEDURE `prc_grupo_grabar_modificar` (IN `p_id_grupo` INT, IN `p_nombre` VARCHAR(64), IN `p_ubicacion` MEDIUMTEXT, IN `p_dia_reunion` INT(11), IN `p_id_lider_grupo` INT, IN `p_url` VARCHAR(255), IN `p_hora_reunion` TIME)  SQL SECURITY INVOKER
BEGIN

  UPDATE grupos set 
    nombre = p_nombre, 
    ubicacion = p_ubicacion, 
    dia_reunion = p_dia_reunion,
    hora_reunion = p_hora_reunion, 
    id_lider_grupo = p_id_lider_grupo,
    url = p_url
  WHERE id_grupo = p_id_grupo;

END$$

CREATE PROCEDURE `prc_lider_grupo_borrar` (`p_id_lider_grupo` INT(10) UNSIGNED)  BEGIN

  DELETE FROM grupos_lideres
  WHERE id_lider_grupo = p_id_lider_grupo;

END$$

CREATE PROCEDURE `prc_lider_grupo_grabar_crear` (`p_nombres` VARCHAR(64), `p_apellidos` VARCHAR(64), `p_telefono` VARCHAR(64), `p_email` VARCHAR(64))  BEGIN

  INSERT INTO grupos_lideres(nombres, apellidos, telefono, email)
  VALUES(p_nombres, p_apellidos, p_telefono, p_email);

END$$

CREATE PROCEDURE `prc_lider_grupo_grabar_modificar` (`p_id_lider_grupo` INT(10) UNSIGNED, `p_nombres` VARCHAR(64), `p_apellidos` VARCHAR(64), `p_telefono` VARCHAR(64), `p_email` VARCHAR(64))  BEGIN

  UPDATE grupos_lideres set 
    nombres = p_nombres, 
    apellidos = p_apellidos, 
    telefono = p_telefono, 
    email = p_email
  WHERE id_lider_grupo = p_id_lider_grupo;

END$$

CREATE PROCEDURE `prc_mensaje_borrar` (IN `p_id_mensaje` INT)  SQL SECURITY INVOKER
begin

  DECLARE id_medio_audio int UNSIGNED;
  DECLARE id_medio_video int UNSIGNED;

  IF EXISTS(SELECT * FROM v_mensajes_medios_audio WHERE id_mensaje = p_id_mensaje) THEN

    SELECT id_medio FROM v_mensajes_medios_audio WHERE id_mensaje = p_id_mensaje INTO id_medio_audio;

    DELETE FROM medios_audio    WHERE id_medio = id_medio_audio;
    DELETE FROM mensajes_medios WHERE id_medio = id_medio_audio;
    DELETE FROM medios          WHERE id_medio = id_medio_audio;
  
  END IF;

  IF EXISTS(SELECT * FROM v_mensajes_medios_video WHERE id_mensaje = p_id_mensaje) THEN

    SELECT id_medio FROM v_mensajes_medios_video WHERE id_mensaje = p_id_mensaje INTO id_medio_video;

    DELETE FROM medios_video    WHERE id_medio = id_medio_video;
    DELETE FROM mensajes_medios WHERE id_medio = id_medio_video;
    DELETE FROM medios          WHERE id_medio = id_medio_video;
  
  END IF;

  DELETE FROM mensajes WHERE id_mensaje = p_id_mensaje;

end$$

CREATE PROCEDURE `prc_mensaje_grabar_crear` (IN `p_id_serie` INT, IN `p_mensaje` VARCHAR(64), IN `p_resumen` VARCHAR(1024), IN `p_id_expositor` INT, IN `p_fecha` DATE, IN `p_m3u` VARCHAR(256), IN `p_video_embed` VARCHAR(4096), IN `p_video_url` VARCHAR(512))  SQL SECURITY INVOKER
BEGIN

  DECLARE id_mensaje     int UNSIGNED;
  DECLARE id_medio_audio int UNSIGNED;
  DECLARE id_medio_video int UNSIGNED;

  INSERT INTO mensajes(id_serie, mensaje, resumen, id_expositor, fecha) 
  VALUES(p_id_serie, p_mensaje, p_resumen, p_id_expositor, p_fecha);

  SELECT LAST_INSERT_ID() INTO id_mensaje;

  IF LENGTH(p_m3u) > 0 THEN

    INSERT INTO medios(medio, id_tipo_medio) VALUES('', 1);

    SELECT LAST_INSERT_ID() INTO id_medio_audio;

    INSERT INTO mensajes_medios VALUES(id_mensaje, id_medio_audio);
    INSERT INTO medios_audio VALUES(id_medio_audio, p_m3u, 0, 0);

  END IF;

  IF LENGTH(p_video_embed) > 0 OR LENGTH(p_video_url) > 0 THEN

    INSERT INTO medios(medio, id_tipo_medio) VALUES('', 4);

    SELECT LAST_INSERT_ID() INTO id_medio_video;

    INSERT INTO mensajes_medios VALUES(id_mensaje, id_medio_video);
    INSERT INTO medios_video VALUES(id_medio_video, p_video_embed, p_video_url);

  END IF;

END$$

CREATE PROCEDURE `prc_mensaje_grabar_modificar` (`p_id_mensaje` INT, `p_id_serie` INT, `p_mensaje` VARCHAR(64), `p_resumen` VARCHAR(8192), `p_id_expositor` INT, `p_fecha` DATE, `p_m3u` VARCHAR(256), `p_video_embed` VARCHAR(4096), `p_video_url` VARCHAR(512))  BEGIN


 DECLARE id_medio_audio int UNSIGNED;
 DECLARE id_medio_video int UNSIGNED;

 UPDATE mensajes SET mensaje   = p_mensaje, 
           id_serie   = p_id_serie, 
           resumen   = p_resumen, 
           id_expositor = p_id_expositor, 
           fecha    = p_fecha
 WHERE id_mensaje = p_id_mensaje;

 IF LENGTH(p_m3u) = 0 THEN

   IF EXISTS(SELECT * FROM v_mensajes_medios_audio WHERE id_mensaje = p_id_mensaje) THEN

    SELECT id_medio FROM v_mensajes_medios_audio WHERE id_mensaje = p_id_mensaje INTO id_medio_audio;

    DELETE FROM medios_audio  WHERE id_medio = id_medio_audio;
    DELETE FROM mensajes_medios WHERE id_medio = id_medio_audio;
    DELETE FROM medios     WHERE id_medio = id_medio_audio;
 
   END IF;

 ELSE

   IF EXISTS(SELECT * FROM v_mensajes_medios_audio WHERE id_mensaje = p_id_mensaje) THEN

    SELECT id_medio FROM v_mensajes_medios_audio WHERE id_mensaje = p_id_mensaje INTO id_medio_audio;
    UPDATE medios_audio SET M3U = p_m3u WHERE id_medio = id_medio_audio;

   ELSE

    INSERT INTO medios(medio, id_tipo_medio) VALUES('', 1);
    SELECT LAST_INSERT_ID() into id_medio_audio;
    INSERT INTO medios_audio VALUES(id_medio_audio, p_m3u, 0, 0);
    INSERT INTO mensajes_medios VALUES(p_id_mensaje, id_medio_audio);

   END IF;

 END IF;



 IF LENGTH(p_video_embed) = 0 AND LENGTH(p_video_url) = 0 THEN

   IF EXISTS(SELECT * FROM v_mensajes_medios_video WHERE id_mensaje = p_id_mensaje) THEN

    SELECT id_medio FROM v_mensajes_medios_video WHERE id_mensaje = p_id_mensaje INTO id_medio_video;

    DELETE FROM medios_video  WHERE id_medio = id_medio_video;
    DELETE FROM mensajes_medios WHERE id_medio = id_medio_video;
    DELETE FROM medios     WHERE id_medio = id_medio_video;
 
   END IF;

 ELSE

   IF EXISTS(SELECT * FROM v_mensajes_medios_video WHERE id_mensaje = p_id_mensaje) THEN

    SELECT id_medio FROM v_mensajes_medios_video WHERE id_mensaje = p_id_mensaje INTO id_medio_video;
    UPDATE medios_video SET embed = p_video_embed, video_url = p_video_url WHERE id_medio = id_medio_video;

   ELSE

    INSERT INTO medios(medio, id_tipo_medio) VALUES('', 4);
    SELECT LAST_INSERT_ID() into id_medio_video;
    INSERT INTO medios_video VALUES(id_medio_video, p_video_embed, p_video_url);
    INSERT INTO mensajes_medios VALUES(p_id_mensaje, id_medio_video);

   END IF;

 END IF;

END$$

CREATE PROCEDURE `prc_serie_borrar` (IN `p_id_serie` INT)  SQL SECURITY INVOKER
begin

  if not exists(select * from mensajes where id_serie = @id_serie) then
    if not exists(select * from series_medios where id_serie = @id_serie) THEN

    delete from series
    where id_serie = p_id_serie;

    end if;
  end if;

end$$

CREATE PROCEDURE `prc_serie_grabar_crear` (IN `p_serie` VARCHAR(64), IN `p_subtitulo` VARCHAR(64), IN `p_descripcion` MEDIUMTEXT, IN `p_imagen_archivo` VARCHAR(64), IN `p_imagen_altura` INT, IN `p_imagen_anchura` INT)  SQL SECURITY INVOKER
BEGIN

  INSERT INTO series(serie, subtitulo, descripcion, imagen_archivo, imagen_altura, imagen_anchura)
  VALUES(p_serie, p_subtitulo, p_descripcion, p_imagen_archivo, p_imagen_altura, p_imagen_anchura);

END$$

CREATE PROCEDURE `prc_serie_grabar_modificar` (IN `p_id_serie` INT, IN `p_serie` VARCHAR(64), IN `p_subtitulo` VARCHAR(64), IN `p_descripcion` MEDIUMTEXT, IN `p_imagen_archivo` VARCHAR(64), IN `p_imagen_altura` INT(11), IN `p_imagen_anchura` INT(11))  SQL SECURITY INVOKER
begin

  UPDATE series set 
    serie = p_serie, 
    subtitulo = p_subtitulo, 
    descripcion = p_descripcion, 
    imagen_archivo = p_imagen_archivo, 
    imagen_altura = p_imagen_altura, 
    imagen_anchura = p_imagen_anchura
  WHERE id_serie = p_id_serie;

end$$

--
-- Functions
--
$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `claves`
--

CREATE TABLE `claves` (
  `clave` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `eventos`
--

CREATE TABLE `eventos` (
  `id_evento` int(11) UNSIGNED NOT NULL,
  `titulo_evento` varchar(64) NOT NULL,
  `subtitulo_evento` varchar(64) NOT NULL,
  `resumen_evento` mediumtext NOT NULL,
  `fecha` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `horario` varchar(64) NOT NULL,
  `lugar` varchar(64) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `ocultar_precio` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `eventos`
--

INSERT INTO `eventos` (`id_evento`, `titulo_evento`, `subtitulo_evento`, `resumen_evento`, `fecha`, `fecha_fin`, `horario`, `lugar`, `precio`, `ocultar_precio`) VALUES
(1, 'Compartiendo a Cristo con mis Amigos', '', '', '2010-05-11', '2010-05-11', '7:30pm a 11:00pm', 'Hotel Holiday Inn Express San Jerónimo', '50.00', 0),
(74, 'Platicando con \"El Guille\" Franco', 'Viernes 6 de Febrero', 'El gran ex jugador de futbol de Rayados y de nuestra seleccion nacional, Guillermo Franco, compartira un mensaje positivo a ACCESS el grupo de jovenes de nuestra iglesia acerca del poder transformador de Dios. ', '2015-02-06', '2015-02-06', '8:00 pm', 'Hotel Presidente Intercontinental', '0.00', 1),
(84, 'Misterios sin resolver: Preguntas que no salen de mi cabeza', 'Jueves 20 deOctubre', 'Un evento de chicas para chicas. \"...y mi suspiro no te es oculto\" Salmo 38:9', '2016-10-20', '2016-10-20', '7:30 pm', 'Casa Familia Handal Ortiz', '0.00', 1),
(85, 'Ser Mujer: ', 'Sabado 5 de noviembre', 'Desayuno y conferencia para mujeres que desean aprender más de Dios.', '2016-11-05', '2016-11-05', '11:00 am', 'Carl´s Jr Gonzalitos', '0.00', 1),
(86, '• Taller de Padres: Ayudando a la nueva generación a triunfar.', 'Lunes 28 de Noviembre ', '¿Quisieras ver a tus hijos y a la siguiente generación triunfar? ¿Quisieras poder garantizar el éxito de tus alumnos, de tus hijos o de aquella generación que viene detrás de ti? No te pierdas la oportunidad de aprender en el taller para padres de familia y descubrir cuáles son los errores más comunes que cometemos y sobre todo, cómo evitarlos. Costo de recuperación por pareja.', '2016-11-28', '2016-11-28', '8:00 - 10:00 pm', 'Hotel MS Milenium', '100.00', 0),
(87, '• Posada Ser Mujer: Comparte tu luz ', 'Sábado 10 de diciembre ', 'Ser Mujer, te invita a su celebración de navidad \"Comparte tu Luz\". Un tiempo para agradecerle a Dios, celebrar y también compartir de sus bendiciones. Costo de recuperación por persona (incluye desayuno).', '2016-12-10', '2016-12-10', '10:30 am', 'Crepé de Paris (Av. Anillo Periferico, San Jéronimo, Mty)', '180.00', 0),
(88, '• Operación NaviDAR', 'Sábado 17 de diciembre ', 'Por tercer año consecutivo queremos DAR una navidad llena del amor de Dios a niños y familias que requieren de nuestro apoyo. Tu lo puedes hacer una realidad aportando un caja-regalo. Las cual puedes solicitar y entregar todos los domingos antes de su entrega en las reuniones general de iglesia.', '2016-12-17', '2016-12-17', '10:00 am', 'Por Definir', '0.00', 1),
(89, 'Dia de Ayuno y Oración ', 'Miércoles 3 de mayo 2017', 'Acompáñanos este próximo 3 de mayo para un día de oración y ayuno como iglesia. Estaremos pidiéndole a Dios en particular por nuestro nuevo local como iglesia, por la mudanza hacia ese lugar, por la recolección de fondos para el proyecto. Además será un buen tiempo para orar por nuestras familias, nuestros grupos, las personas que amamos y necesidades especiales. \r\n\r\nTerminaremos ese día con un tiempo de cierre de ayuno todos juntos en el nuevo local de la iglesia a las 8:00pm.\r\n\r\n¡Te esperamos!', '2017-05-03', '2017-05-03', '8:00 pm', 'Nuevo Local de la Iglesia', '0.00', 1),
(90, 'BAZAR Pro-Construcción', 'Sábado 3 de junio de 2017', 'El pueblo estaba feliz de haber contribuido voluntariamente, pues todo lo que ofrecieron al Señor lo dieron de corazón y de manera voluntaria. 		           1° Crónicas 29:9\r\n\r\nUna excelente oportunidad para ayudar en pro de la construcción de nuestro nuevo local, y puedes hacerlo a través de:\r\n\r\n•	Tus donaciones de artículos nuevos o usados, limpios y en buen estado, para ser vendidos en el bazar.\r\n•	Tu tiempo para servir antes, durante y después del bazar.\r\n\r\nPuedes traer tus donaciones los domingos, o directamente en el lugar donde será  el bazar, previa cita, para poder recibirlo. Llama a Ana Bertha Ortiz al 81-8309-1249 o a Rosario Rivera al 81-1513-6090. Tienes hasta antes de la fecha de nuestro bazar.\r\n\r\nHasta cuándo: sábado 3 de junio de 2017\r\nDónde: 13°Ave # 901 Col. Cumbres 2° Sec. Mty', '2017-06-03', '2017-06-03', '9:00 am - 2:00 pm', '13°Ave # 901 Col. Cumbres 2° Sec. Mty', '0.00', 1),
(91, 'Sábado de Evangelismo ', 'Sábado 10 de junio 2017', 'Antes de nuestra primera reunión en el nuevo local, saldremos a invitar y compartir el evangelio con nuestros nuevos vecinos. Acompañanos este sábado, nuestro punto de reunión sera en el \"Auditorio Gran Comisión Monterrey\" ', '2017-06-10', '2017-06-10', '9:00 - 11:00 am', 'Auditorio Gran Comisión Monterrey', '0.00', 1),
(92, 'Comida de Inauguración', 'Domingo 11 de Junio', 'Después de nuestras reuniones de inauguración este 11 de junio, te invitamos a que te quedes y nos acompañes a una comida de celebración por este dia tan especial. Habrá venta de comida, piñata y HotDogs Gratis para los niños. No te pierdas este dia historico.', '2017-06-11', '2017-06-11', '2:00 pm', 'Auditorio Gran Comisión Monterrey', '0.00', 1),
(93, '• Reparto de Invitaciones', 'Sábado 5 de agosto 2017', 'Este día iremos a ser capacitados y luego poder ir a los alrededores de nuestra iglesia a orar pues nuestros vecinos e invitarlos a que nos acompañen en el inicio de nuestra ¡GRAN APERTURA!', '2017-08-05', '2017-08-05', '11:00 am - 1:00 pm', 'Auditorio Gran Comisión Monterrey', '0.00', 1),
(94, '• Capacitación Sheeper programa: \"Todo Poderoso\"', 'Sábado 12 de agosto 2017', 'Porque debemos de estar preparados para toda buena obra, nos estamos preparando para el programa de niños del segundo semestre del año. Capacitacion ofrecida por \"Campo Aventura\" (http://www.campoaventura.mx/)', '2017-08-12', '2017-08-12', '8:00 am - 2:30 pm', 'Salón UNO (Auditorio Gran Comisión)', '0.00', 1),
(95, '• ¡GRAN APERTURA!', 'Domingo 20 de Agosto de 2017', 'Acompañamos a nuestra gran apertura oficial del nuevo auditorio. Estaremos iniciando serie y habrá muchas sorpresas para toda la familia. ', '2017-08-20', '2017-08-20', '11:00 am  y 12:30 pm', 'Auditorio Gran Comisión Monterrey', '0.00', 1),
(96, '• Firma del Pacto de Interdependencia ', 'Lunes 4 de septiembre de 2017', 'Un momento lleno de historia y alegría. Antes de ser reconocido como pastor Isaac Pineda firmara un pacto de interdependencia con GCLA. Una celebración a la que todos están invitados.', '2017-09-04', '2017-09-04', '8:00 pm - 9:30 pm', 'Auditorio Gran Comisión Monterrey', '0.00', 1),
(97, '• Reconocimiento de Jorge Isaac Pineda', 'Jueves 21 de septiembre 2017', 'Como preámbulo a nuestra conferencia anual de GCLA tendremos el reconocimiento de nuevo pastor en medio de nosotros. Ven y acompañanos a esta noche de alegría y celebración.', '2017-09-21', '2017-09-21', '8:00 pm - 9:30 pm', 'Auditorio Gran Comisión Monterrey', '0.00', 1),
(98, '• Conferencia Anual GCLA: \"VERTICAL 2017\"', 'Viernes 22 - Domingo 24 de Septiembre 2017', 'No te puedes perder nuestra conferencia anual de GCLA \"VERTICAL 2017\" ELEVA TU PASIÓN. Un tiempo lleno de reflexión, alabanza y comunión, pero sobre todo de VISIÓN hacia el futuro, bajo la guía de la palabra de Dios.', '2017-09-22', '2017-09-24', 'Viernes 5:00 pm - Domingo 1:00 pm', 'Hotel & Resort Bahía Escondida, Santiago NL', '0.00', 1),
(99, 'Extraordinaria', 'Martes 6 de Marzo', 'Ser Mujer te invita a su primera reunion del año. Tendremos como invitada a Susan Bixbi, bloguista, profesora de la Universidad Cristiana y esposa de pastor.', '2018-03-06', '2018-03-06', '7:30 pm', 'Auditorio Gran Comision', '50.00', 0),
(100, 'Torneo de Futbol', 'Domingo 11 de marzo', 'Te invitamos a que nos acompanes a un torneo de futbol relampago en el Deportivo Capellania (atras de Soriana de Plaza San Pedro). Arma tu equipo e inscribete.  ', '2018-03-11', '2018-03-11', '4:00 a 8:00 pm', 'Deportivo Capellania ', '30.00', 0),
(101, 'Gone Fishing', 'Semana del 9 al 18 de marzo', 'Una semana llena de compañerismo, unidad y evangelismo. Tendremos a un equipo misionero que viene de la Universidad de Texas A&M con el fin de alcanzar a jovenes universitarios. ', '2018-03-09', '2018-03-18', 'Varios', 'Vaios', '0.00', 1),
(102, 'JOCHOTON', 'Viernes 16 de marzo', 'Gran Tercera Edicion del JOCHOTON organizado por ACCESS. Concurso para saber quien puede comer mas HotDogs. -------------------------- ENTRADA LIBRE, Concursantes $50 (cupo limitado)', '2018-03-16', '2018-03-16', '8:00 pm', 'Auditorio Gran Comision', '50.00', 0),
(103, 'Kermes GranCo', 'Sabado 17 de marzo.', 'Kermes GranCo organizada por ACCESS. Una tarde de juegos, amistad y mucha diversion.', '2018-03-17', '2018-03-17', '3:00 - 6:00 pm', 'Auditorio Gran Comision', '0.00', 1),
(104, '-- Realmente es amor?', 'Viernes 20 de Abril', 'Tronamos, regresamos y volvemos a tronar... vamos y venimos y no tenemos una relacion estable, esto REALMENTE ES AMOR? ---- ACCESS: Jovenes GranCo te invitan.', '2018-04-20', '2018-04-20', '8:00 pm', 'Auditorio Gran Comision', '0.00', 1),
(105, '--Como proteger a nuestros hijos de las ideologias destructivas?', 'Viernes 27 de Abril', 'Tus hijos estan bajo un ataque ideologico, cuyo fin es destruirles a ellos, y por no exagerar, a toda tu familia. CONFERENCIA MAGISTRAL - ENTRADA LIBRE', '2018-04-27', '2018-04-27', '8:00 pm', 'Auditorio Gran Comision', '0.00', 1),
(106, '-- Como ayudar a personas con problemas de identidad sexual?', 'Sabado 28 de Abril', 'Muchos jovenes y adultos, con retos en su identidad sexual, no saben a quien acudir. Por una parte, \"la moda ideologica\" es la que mas se escucha y les quita opciones. La inmensa mayoria de ellos no saben que hacer.\r\n\r\nComo brindar una opcion sensata, cientifica y con resultados absolutamente satisfactorios?\r\n\r\nEste taller es recomendado para psicologos, padres de familia, ministros de culto, lideres cristianos- comunitarios y publico en general.\r\n\r\nEl cupo es estrictamente limitado. Es importante pre-inscribirse al whatsapp +5218114818209\r\n\r\nPrecio de Pre-Inscipcion $100\r\nDia del evento $150', '2018-04-28', '2018-04-28', '2:00 - 7:00 pm', 'Auditorio Gran Comision', '100.00', 0),
(107, '-- Seminario de Hermeneutica', 'Todos los Martes del 8 de Mayo al 10 de Julio', 'Seminario de Hermeneutica: Durante nueve semanas estaremos aprendiendo a interpretar la Biblia correctamente. Costo del material: Electronico $50 - Impreso $150', '2018-05-08', '2018-07-10', '7:30 - 9:00pm', 'Iglesia Gran Comision - \"Salon UNO\"', '50.00', 0),
(108, 'Celebracion a mama', 'Domingo 6 de Mayo', 'Ven y acompañanos en la celebracion a mama. Una excelente oportunidad de reconocer su amor y dedicacion para la familia. ', '2018-04-28', '2018-04-28', '11:00 am y 12:30 pm', 'Auditorio Gran Comision', '0.00', 1),
(109, 'RAICES: Campamento para mujeres', 'Sabado 9 y domingo 10 de Junio ', 'El primer campamento de mujeres, un tiempo de amistad, aprendizaje y conexion con Dios. Contaremos con la presencia de Lucy Guerra como expositora invitada. Costo de inscripcion: Solo sabado $690, Sabado y Domingo (incluye hospedaje) $1,200. APARTA YA TU LUGAR Y SE PARTE DE ESTE HISTORICO EVENTO.', '2018-06-09', '2018-06-10', 'Inicia a las 11:30 am ', 'Hotel Hacienda Cola de Caballo', '1200.00', 0),
(110, 'Reunion de Oracion ', 'Jueves 14 de Junio', 'Un tiempo de oracion especial por nuestra nacion de cara a las ELECCIONES 2018', '2018-06-14', '2018-06-14', '8:00 pm', 'Auditorio Gran Comision', '0.00', 1),
(112, 'Mexico vs Alemania', 'Domingo 17 junio', 'Como parte de la celebracion del dia del padre, ven y disfrutemos juntos del primer partido de Mexico en el mundial. Invita a papa, disfruta del juego y luego quedate para nuestra reunion de las 12:30 pm', '2018-06-17', '2018-06-17', '10:00 am ', 'Auditorio Gran Comision', '0.00', 1),
(113, 'Evangelismo de Elevador ', 'Martes 19 de junio', 'Una invitacion a toda la Iglesia para aprender a compartir el evangelio aun en situaciones de poco tiempo.', '2018-06-19', '2018-06-19', '7:30 pm', 'Auditorio Gran Comision', '0.00', 1),
(114, 'Caminata por Chipinque', 'Sabado 14 de Julio', 'Animate a pasar un sabado diferente, disfrutando de las maravillas de la naturaleza que Dios ha creado y conociendo nuevos amigos.\r\n\r\nNo olvides llevar:\r\n- Ropa y calzado adecuado.\r\n- Bloqueador solar.\r\n- Botella de agua.\r\n- Un snack.\r\n- Repelente (si eres sensible a los mosquitos).\r\n- Una buena actitud y ganas de ejercitarte.\r\n\r\nRECUERDA:\r\nLa entrada peatonal al parque es de $20 pesos, y en auto es de $60 pesos y cubre la entrada de todos los ocupantes del mismo.', '2018-07-14', '2018-07-14', '7:30 am', 'Parque Ecologico Chipinque', '60.00', 0),
(115, 'Gran Final RUSIA 2018', 'Domingo 15 julio', 'Ven a ver juntos la Gran Final del Mundial Rusia 2018, este domingo 15 de julio a las 10:00 am en el auditorio Gran Comision. Disfrutemos juntos del juego por campeonato con, cafe, pan dulce, refrescos, botanas, ademas puedes traer tu desayuno... y al finalizar el juego estaremos TODOS JUNTOS en un solo servicio de las 1:00pm.\r\n\r\n09:00 am - Apertura de puertas y transmision de la antesala.\r\n10:00 am - Gran Final \"Rusia 2018\".\r\n01:00 pm - Reunion General: \"El Explosivo Cronico\".', '2018-07-15', '2018-07-15', '9:00 am', 'Auditorio Gran Comision', '0.00', 1),
(116, 'Reunion de Matrimonios: \"No se lo merece\" ', 'Miercoles 18 de julio', 'Muchas veces los conflictos vienen porque pensamos \"No se lo merece\" Ven a esta reunion que te ayudara a cambiar por completo tu actitud hacia tu pareja. Contaremos con refrigerio y cuidado de ni~nos. Costo de recuperacion $100 por pareja.', '2018-07-18', '2018-07-18', '8:00 pm', 'Auditorio Gran Comision', '100.00', 0),
(117, 'Vertical 2018: Sigueme', '28, 29 y 30 de septiembre 2018', 'Conferencia anual de GCLA. VERTICAL 2018: SIGUEME', '2018-09-28', '2018-09-30', 'Inicia a las 9:00 pm', 'Hotel Bahia Escondida, Santiago NL', '450.00', 0),
(118, 'Taller: Las 21 leyes irrefutables del liderazgo.', 'Sabados: 13 y 27 de octubre 2018', 'Todos los participantes obtendran una certificacion oficial del Equipo de John Maxwell al completar ambas sesiones.', '2018-10-13', '2018-10-27', '9:00 am - 1:00 pm', 'Auditorio Iglesia Gran Comision ', '200.00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `eventos_claves`
--

CREATE TABLE `eventos_claves` (
  `id_evento` int(10) UNSIGNED NOT NULL,
  `clave` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `eventos_medios`
--

CREATE TABLE `eventos_medios` (
  `id_evento` int(11) UNSIGNED NOT NULL,
  `id_medio` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `eventos_medios`
--

INSERT INTO `eventos_medios` (`id_evento`, `id_medio`) VALUES
(1, 200);

-- --------------------------------------------------------

--
-- Table structure for table `expositores`
--

CREATE TABLE `expositores` (
  `id_expositor` int(11) UNSIGNED NOT NULL,
  `nombres` varchar(64) NOT NULL,
  `apellidos` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `expositores`
--

INSERT INTO `expositores` (`id_expositor`, `nombres`, `apellidos`) VALUES
(1, 'Sergio', 'Handal'),
(2, 'Oscar', 'Gutierrez'),
(3, 'Allan', 'Handal'),
(4, 'Nelson', 'Guerra'),
(5, 'Jon', 'Herrin'),
(6, 'Fidel', 'Guerrero'),
(7, 'Steve', 'Hutmacher'),
(8, ' ', ' '),
(9, 'Isaac', 'Pineda'),
(10, 'Adrián ', 'Rivera'),
(11, 'Andrés ', 'Panasiuk'),
(12, 'Dennis', 'Chavarria'),
(13, 'Kurt', 'Jurgensmeier'),
(14, 'Francisco', 'Morales'),
(15, 'Edwing', 'Carcamo'),
(16, 'Jason', 'Tucker'),
(17, 'Mandy', 'Fernandz'),
(18, 'Samuel', 'Ortiz'),
(19, 'Henry', 'Kattan'),
(20, 'Alejandro', 'Handal'),
(21, 'Ignacio', 'Pecina'),
(22, 'Alejandro', 'Gonzalez'),
(23, 'Luke', 'Shortdridge');

-- --------------------------------------------------------

--
-- Table structure for table `expositores_medios`
--

CREATE TABLE `expositores_medios` (
  `id_expositor` int(11) UNSIGNED NOT NULL,
  `id_medio` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `expositores_medios`
--

INSERT INTO `expositores_medios` (`id_expositor`, `id_medio`) VALUES
(1, 142),
(2, 141),
(2, 165);

-- --------------------------------------------------------

--
-- Table structure for table `grupos`
--

CREATE TABLE `grupos` (
  `id_grupo` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `ubicacion` mediumtext NOT NULL,
  `dia_reunion` int(11) NOT NULL,
  `hora_reunion` time NOT NULL,
  `id_lider_grupo` int(11) UNSIGNED NOT NULL,
  `url` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `grupos`
--

INSERT INTO `grupos` (`id_grupo`, `nombre`, `ubicacion`, `dia_reunion`, `hora_reunion`, `id_lider_grupo`, `url`) VALUES
(8, 'Matrimonios Jóvenes - Las Lomas', 'Lomas Quetzales, Garcia', 5, '20:00:00', 19, ''),
(12, 'GPS - Anáhuac', 'Carls Jr, Universidad', 3, '20:00:00', 24, 'https://www.facebook.com/groups/203983976296824/'),
(13, 'Universitarios y Profesionistas - Zona Tec', 'Col. Tecnológico', 4, '19:30:00', 21, ''),
(15, 'Matrimonios Jóvenes - Cumbres 2do Sector', 'Cumbres 2do Sector', 5, '20:00:00', 14, ''),
(18, 'Jóvenes Profesionales - Apodaca', 'Privada Iltamarindo, Apodaca', 3, '20:00:00', 12, ''),
(19, 'Universitarios y Profesionistas - Sur', 'Col. del Paseo Residencial, Monterrey.', 3, '20:30:00', 23, ''),
(21, 'Adultos - Zona Valle', 'Col. del Valle (Cada 15 días)', 2, '20:00:00', 25, ''),
(22, 'Matrimonios - Cumbres 2do Sector', 'Cumbres 2do Sector (Por Deportivo Cumbres)', 5, '20:30:00', 5, ''),
(23, 'Matrimonios - Cumbres San Agustín', 'Cumbres San Agustín', 5, '20:30:00', 8, ''),
(25, 'Universitarios y Profesionistas - Guadalupe', 'Centro de Guadalupe', 6, '18:00:00', 15, ''),
(26, 'Miercolitos ', 'Colonia del Valle', 3, '20:00:00', 6, ''),
(27, 'San Jemo', 'Col. Rincón de las Colinas ', 2, '20:00:00', 3, ''),
(28, 'Mamás que trabajan a medio tiempo ', 'Cumbres San Agustín', 3, '16:00:00', 26, ''),
(29, 'Chicas universitarias y profesionistas ', 'Mitras sur', 4, '20:00:00', 27, ''),
(30, 'Esposas', 'Cumbres San Patricio', 4, '20:30:00', 28, ''),
(31, 'Mamás Estrenándose ', 'Lomas Sector Bosques', 4, '17:00:00', 29, ''),
(32, 'Mamas Creciendo ', 'Lomas Quetzales', 4, '10:30:00', 30, ''),
(33, 'Mujeres Zona Sur ', 'Lomas del Paseo, Mty ', 3, '10:00:00', 31, '');

-- --------------------------------------------------------

--
-- Table structure for table `grupos_lideres`
--

CREATE TABLE `grupos_lideres` (
  `id_lider_grupo` int(10) UNSIGNED NOT NULL,
  `nombres` varchar(64) NOT NULL,
  `apellidos` varchar(64) NOT NULL,
  `telefono` varchar(64) NOT NULL,
  `email` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `grupos_lideres`
--

INSERT INTO `grupos_lideres` (`id_lider_grupo`, `nombres`, `apellidos`, `telefono`, `email`) VALUES
(3, 'Juan Manuel', 'Cáceres', '81 1044 9900', 'jcaceres504@yahoo.com'),
(4, 'Andrés', 'Handal', '81 1035 1110', 'andreshandal.04@gmail.com'),
(5, 'Samuel', 'Ortiz', '81 8309 1231', 'samoro55@yahoo.com.mx'),
(6, 'Alex', 'Handal', '81 2351 4624', 'alexhandal@gmail.com'),
(8, 'Allan', 'Handal', '81 1555 3640', 'allanhandal@yahoo.com'),
(9, 'Pablo', 'Gaytan', '81 1010 8650', 'alfa.potencia@gmail.com'),
(10, 'Adrián', 'Rivera', '81 1286 4095', 'adrian.rr@gmail.com'),
(12, 'Henry', 'Kattán', '81 1584 5889', 'henryka87@gmail.com'),
(13, 'Armando', 'Vazquez', '81 8287 1641', 'burojuridico@gmail.com'),
(14, 'Isaac', 'Pineda', '81 1516 7185', 'isaacmex@gmail.com'),
(15, 'Omar', 'Reyes', '81 1939 5873', 'orgmty@gmail.com'),
(17, 'Evelid', 'Melo', '81 1028 1909', 'evelid@hotmail.com'),
(19, 'Alejandro', 'Gonzalez', '81 1244 0321', 'a_gonher@hotmail.com'),
(20, 'Edgar', 'Reyes', '493 103 0352', 'efg2488@hotmail.com'),
(21, 'Raul', 'Garcia', '81 8086 1399', 'raulsgo@gmail.com'),
(22, 'Josué', 'Wong', '81 1652 2636', 'jwongdela@gmail.com'),
(23, 'Abdiel', 'Gaytan', '81 1480 3234', 'abdielgaytan@gmail.com'),
(24, 'Julio', 'Villaseñor', '81 8287 5819', 'gps.anahuac@gmail.com'),
(25, 'Sergio', 'Handal', '81 8029 9111', 'sehandal@gmail.com'),
(26, 'Cynthia ', 'Leal', '81-1413-8313', 'clo185@hotmail.com'),
(27, 'Susy', 'Gibler ', '81-1500-2764', 'susygib@gmail.com'),
(28, 'Rocío', 'Cifuentes de Martínez ', '81-1411-8571', 'rcifuent@hotmail.com'),
(29, 'Aliz', 'Raudales ', '81-8162-8380', 'alizraudales@gmail.com'),
(30, 'Selene', 'Gonzales ', '81-8161-2848 ', 'seleneortiz@hotmail.com'),
(31, 'Mary', 'Rentería de Sanchez', '81-8287-0321', 'marysa3501@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `medios`
--

CREATE TABLE `medios` (
  `id_medio` int(11) UNSIGNED NOT NULL,
  `medio` varchar(64) NOT NULL,
  `id_tipo_medio` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `medios`
--

INSERT INTO `medios` (`id_medio`, `medio`, `id_tipo_medio`) VALUES
(1, '', 1),
(2, '', 1),
(3, '', 1),
(4, '', 1),
(5, '', 1),
(6, '', 1),
(7, '', 1),
(8, '', 1),
(9, '', 1),
(10, '', 1),
(11, '', 1),
(12, '', 1),
(13, '', 1),
(14, '', 1),
(15, '', 1),
(16, '', 1),
(17, '', 1),
(18, '', 1),
(19, '', 1),
(20, '', 1),
(21, '', 1),
(22, '', 1),
(23, '', 1),
(24, '', 1),
(25, '', 1),
(26, '', 1),
(27, '', 1),
(28, '', 1),
(29, '', 1),
(30, '', 1),
(31, '', 1),
(32, '', 1),
(33, '', 1),
(34, '', 1),
(35, '', 1),
(36, '', 1),
(37, '', 1),
(38, '', 1),
(39, '', 1),
(40, '', 1),
(41, '', 1),
(42, '', 1),
(43, '', 1),
(44, '', 1),
(45, '', 1),
(46, '', 1),
(47, '', 1),
(48, '', 1),
(49, '', 1),
(50, '', 1),
(51, '', 1),
(52, '', 1),
(53, '', 1),
(54, '', 1),
(55, '', 1),
(56, '', 1),
(57, '', 1),
(58, '', 1),
(59, '', 1),
(60, '', 1),
(61, '', 1),
(62, '', 1),
(63, '', 1),
(64, '', 1),
(65, '', 1),
(66, '', 1),
(67, '', 1),
(68, '', 1),
(69, '', 1),
(70, '', 1),
(71, '', 1),
(72, '', 1),
(73, '', 1),
(74, '', 1),
(75, '', 1),
(76, '', 5),
(77, '', 5),
(78, '', 5),
(79, '', 5),
(80, '', 5),
(81, '', 5),
(82, '', 5),
(83, '', 5),
(84, '', 5),
(85, '', 5),
(86, '', 5),
(87, '', 5),
(88, '', 5),
(89, '', 5),
(90, '', 5),
(91, '', 5),
(92, '', 5),
(93, '', 5),
(94, '', 5),
(95, '', 5),
(96, '', 5),
(97, '', 5),
(98, '', 5),
(99, '', 5),
(100, '', 5),
(101, '', 5),
(102, '', 5),
(103, '', 5),
(104, '', 5),
(105, '', 5),
(106, '', 5),
(107, '', 5),
(108, '', 5),
(109, '', 5),
(110, '', 5),
(111, '', 5),
(112, '', 5),
(113, '', 5),
(114, '', 5),
(115, '', 5),
(116, '', 5),
(117, '', 5),
(118, '', 5),
(119, '', 5),
(120, '', 5),
(121, '', 5),
(122, '', 5),
(123, '', 5),
(124, '', 5),
(125, '', 5),
(126, '', 5),
(127, '', 5),
(128, '', 5),
(129, '', 5),
(130, '', 5),
(131, '', 5),
(132, '', 5),
(133, '', 5),
(134, '', 5),
(135, '', 5),
(136, '', 5),
(137, '', 5),
(138, '', 5),
(139, '', 5),
(140, '', 1),
(141, '', 1),
(142, '', 1),
(143, '', 1),
(144, '', 1),
(145, '', 1),
(146, '', 1),
(147, '', 1),
(148, '', 1),
(149, '', 1),
(150, '', 1),
(151, '', 1),
(152, '', 1),
(153, '', 1),
(154, '', 1),
(155, '', 1),
(156, '', 1),
(157, '', 1),
(158, '', 1),
(159, '', 1),
(160, '', 1),
(161, '', 1),
(162, '', 1),
(163, '', 1),
(164, '', 1),
(165, '', 1),
(166, '', 1),
(167, '', 1),
(168, '', 1),
(169, '', 1),
(170, '', 1),
(171, '', 1),
(172, '', 1),
(173, '', 1),
(174, '', 1),
(175, '', 1),
(176, '', 1),
(177, '', 1),
(178, '', 1),
(179, '', 1),
(180, '', 1),
(181, '', 1),
(182, '', 1),
(183, '', 1),
(184, '', 1),
(185, '', 1),
(186, '', 1),
(187, '', 1),
(188, '', 1),
(189, '', 1),
(190, '', 1),
(191, '', 1),
(192, '', 1),
(193, '', 1),
(194, '', 1),
(195, '', 1),
(196, '', 1),
(197, '', 1),
(198, '', 1),
(199, '', 1),
(200, '', 2),
(201, '', 2),
(202, '', 4),
(203, '', 1),
(204, '', 1),
(205, '', 1),
(206, '', 1),
(207, '', 1),
(208, '', 1),
(209, '', 1),
(210, '', 1),
(211, '', 1),
(212, '', 1),
(213, '', 1),
(214, '', 4),
(215, '', 4),
(216, '', 4),
(217, '', 1),
(218, '', 4),
(219, '', 1),
(220, '', 1),
(221, '', 1),
(224, '', 1),
(225, '', 1),
(226, '', 1),
(227, '', 4),
(228, '', 1),
(229, '', 4),
(230, '', 4),
(231, '', 1),
(232, '', 1),
(234, '', 4),
(235, '', 4),
(237, '', 1),
(238, '', 1),
(239, '', 1),
(240, '', 1),
(241, '', 4),
(243, '', 1),
(244, '', 1),
(245, '', 4),
(246, '', 1),
(247, '', 4),
(248, '', 1),
(250, '', 1),
(251, '', 1),
(252, '', 1),
(253, '', 1),
(254, '', 4),
(255, '', 1),
(256, '', 1),
(258, '', 4),
(259, '', 1),
(260, '', 4),
(261, '', 1),
(262, '', 4),
(263, '', 4),
(264, '', 1),
(265, '', 1),
(266, '', 1),
(267, '', 1),
(268, '', 4),
(269, '', 1),
(270, '', 1),
(272, '', 1),
(273, '', 1),
(274, '', 1),
(275, '', 1),
(276, '', 1),
(277, '', 1),
(278, '', 1),
(279, '', 1),
(280, '', 4),
(281, '', 4),
(282, '', 1),
(283, '', 1),
(284, '', 1),
(285, '', 1),
(286, '', 1),
(287, '', 1),
(288, '', 1),
(289, '', 1),
(290, '', 1),
(291, '', 1),
(292, '', 1),
(293, '', 1),
(294, '', 4),
(295, '', 4),
(296, '', 1),
(297, '', 1),
(298, '', 1),
(299, '', 1),
(300, '', 1),
(301, '', 1),
(302, '', 1),
(303, '', 1),
(304, '', 1),
(305, '', 1),
(306, '', 1),
(307, '', 1),
(308, '', 1),
(309, '', 1),
(310, '', 1),
(311, '', 1),
(312, '', 1),
(313, '', 1),
(314, '', 1),
(315, '', 1),
(316, '', 1),
(317, '', 1),
(318, '', 1),
(319, '', 1),
(320, '', 1),
(321, '', 1),
(322, '', 1),
(323, '', 1),
(324, '', 1),
(325, '', 1),
(326, '', 1),
(327, '', 1),
(328, '', 1),
(329, '', 1),
(330, '', 1),
(331, '', 1),
(332, '', 1),
(333, '', 1),
(334, '', 1),
(335, '', 1),
(336, '', 1),
(337, '', 1),
(338, '', 1),
(339, '', 1),
(340, '', 1),
(341, '', 1),
(342, '', 1),
(343, '', 1),
(344, '', 1),
(345, '', 1),
(346, '', 1),
(347, '', 1),
(348, '', 1),
(349, '', 1),
(350, '', 1),
(351, '', 1),
(352, '', 1),
(353, '', 1),
(354, '', 1),
(355, '', 1),
(356, '', 1),
(357, '', 1),
(358, '', 1),
(360, '', 1),
(361, '', 1),
(362, '', 1),
(363, '', 1),
(364, '', 1),
(365, '', 1),
(366, '', 1),
(367, '', 1),
(370, '', 1),
(371, '', 1),
(372, '', 1),
(373, '', 1),
(374, '', 1),
(375, '', 1),
(376, '', 1),
(377, '', 1),
(378, '', 1),
(379, '', 1),
(380, '', 1),
(381, '', 1),
(382, '', 1),
(383, '', 1),
(384, '', 1),
(385, '', 1),
(386, '', 1),
(387, '', 1),
(388, '', 1),
(389, '', 1),
(390, '', 1),
(391, '', 1),
(392, '', 1),
(393, '', 1),
(394, '', 1),
(395, '', 1),
(396, '', 1),
(397, '', 1),
(398, '', 1),
(399, '', 1),
(400, '', 1),
(401, '', 1),
(402, '', 1),
(403, '', 1),
(404, '', 1),
(405, '', 1),
(406, '', 1),
(407, '', 1),
(408, '', 1),
(409, '', 1),
(415, '', 1),
(416, '', 1),
(417, '', 1),
(418, '', 1),
(419, '', 1),
(420, '', 1),
(421, '', 1),
(422, '', 1),
(423, '', 1),
(424, '', 1),
(425, '', 1),
(426, '', 1),
(427, '', 1),
(428, '', 1),
(429, '', 1),
(430, '', 1),
(431, '', 1),
(432, '', 1),
(433, '', 1),
(434, '', 1),
(435, '', 1),
(436, '', 1),
(437, '', 1),
(438, '', 1),
(439, '', 1),
(440, '', 1),
(441, '', 1),
(442, '', 1),
(443, '', 1),
(444, '', 1),
(445, '', 1),
(446, '', 1),
(447, '', 1),
(449, '', 1),
(450, '', 1),
(451, '', 1),
(452, '', 1),
(453, '', 1),
(454, '', 1),
(455, '', 1),
(456, '', 1),
(457, '', 1),
(458, '', 1),
(459, '', 1),
(460, '', 1),
(461, '', 1),
(463, '', 1),
(464, '', 1),
(465, '', 1),
(466, '', 1),
(467, '', 1),
(468, '', 1),
(469, '', 1),
(470, '', 1),
(471, '', 1),
(472, '', 1),
(473, '', 1),
(474, '', 1),
(475, '', 1),
(476, '', 1),
(477, '', 1),
(478, '', 1),
(479, '', 1),
(480, '', 1),
(481, '', 1),
(483, '', 1),
(484, '', 1),
(486, '', 1),
(487, '', 1),
(488, '', 1),
(489, '', 1),
(490, '', 1),
(491, '', 1),
(492, '', 1),
(493, '', 1),
(494, '', 1),
(495, '', 1),
(496, '', 1),
(497, '', 1),
(498, '', 1),
(499, '', 1),
(500, '', 1),
(501, '', 1),
(502, '', 1),
(503, '', 1),
(504, '', 1),
(505, '', 1),
(506, '', 1),
(507, '', 1),
(508, '', 1),
(509, '', 1),
(510, '', 1),
(511, '', 1),
(512, '', 1),
(513, '', 1),
(514, '', 1),
(515, '', 1),
(516, '', 1),
(517, '', 1),
(518, '', 1),
(519, '', 1),
(520, '', 1),
(521, '', 1),
(522, '', 1),
(523, '', 1),
(524, '', 1),
(525, '', 1),
(526, '', 1),
(527, '', 1),
(528, '', 1),
(529, '', 1),
(530, '', 1),
(531, '', 1),
(532, '', 1),
(533, '', 1),
(534, '', 1),
(535, '', 1),
(536, '', 1),
(537, '', 1),
(538, '', 1),
(539, '', 1),
(540, '', 1),
(541, '', 1),
(542, '', 1),
(543, '', 1),
(544, '', 1),
(545, '', 1),
(546, '', 1),
(547, '', 1),
(548, '', 1),
(549, '', 1),
(550, '', 1),
(552, '', 1),
(553, '', 1),
(554, '', 1),
(555, '', 1),
(556, '', 1),
(557, '', 1),
(558, '', 1),
(559, '', 1),
(560, '', 1),
(561, '', 1),
(562, '', 1),
(563, '', 1),
(564, '', 1),
(565, '', 1),
(566, '', 1),
(567, '', 1),
(568, '', 1),
(569, '', 1),
(570, '', 1),
(571, '', 1),
(572, '', 1),
(573, '', 1),
(574, '', 1),
(575, '', 1),
(576, '', 1),
(577, '', 1),
(578, '', 1),
(579, '', 1),
(580, '', 1),
(581, '', 1),
(582, '', 1),
(583, '', 1),
(584, '', 1),
(585, '', 1),
(586, '', 1),
(587, '', 1),
(588, '', 1),
(589, '', 1),
(590, '', 1),
(591, '', 1),
(592, '', 1),
(593, '', 1),
(594, '', 1),
(595, '', 1),
(596, '', 1),
(597, '', 1),
(598, '', 1),
(599, '', 1),
(600, '', 1),
(601, '', 1),
(602, '', 1),
(603, '', 1),
(604, '', 1),
(605, '', 1),
(606, '', 1),
(607, '', 1),
(608, '', 1),
(609, '', 1),
(610, '', 1),
(611, '', 1),
(612, '', 1),
(613, '', 1),
(614, '', 1),
(615, '', 1),
(616, '', 1),
(617, '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `medios_archivo`
--

CREATE TABLE `medios_archivo` (
  `id_medio` int(10) UNSIGNED NOT NULL,
  `extension` varchar(3) NOT NULL,
  `url` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `medios_archivo`
--

INSERT INTO `medios_archivo` (`id_medio`, `extension`, `url`) VALUES
(76, 'DOC', 'http://www.igcmonterrey.org/conferencias/200608/Mas Grande que Mis Decepciones.doc'),
(77, 'DOC', 'http://www.igcmonterrey.org/conferencias/200608/Mas Grande Que Mis Heridas.doc'),
(78, 'DOC', 'http://www.igcmonterrey.org/conferencias/200609/Como tratarla a ella.doc'),
(79, 'DOC', 'http://www.igcmonterrey.org/conferencias/200609/Como tratarlo a el.doc'),
(80, 'DOC', 'http://www.igcmonterrey.org/conferencias/200609/Como tratarlos a ellos.doc'),
(81, 'DOC', 'http://www.igcmonterrey.org/conferencias/200610/Como Superar la Depresion.doc'),
(82, 'DOC', 'http://www.igcmonterrey.org/conferencias/200610/Como Manejar el Estres.doc'),
(83, 'DOC', 'http://www.igcmonterrey.org/conferencias/200610/Como Manejar la Envidia.doc'),
(84, 'DOC', 'http://www.igcmonterrey.org/conferencias/200610/Como Controlar el Enojo.doc'),
(85, 'DOC', 'http://www.igcmonterrey.org/conferencias/200611/Como%20perdonar%20al%20que%20me%20ha%20ofendido.doc'),
(86, 'DOC', 'http://www.igcmonterrey.org/conferencias/200611/Como%20corregir%20un%20gran%20error.doc'),
(87, 'DOC', 'http://www.igcmonterrey.org/conferencias/200611/Como%20soportar%20a%20una%20persona%20dificil.doc'),
(88, 'DOC', 'http://www.igcmonterrey.org/conferencias/200611/Un segundo...Que pasa con Nuestros Familiares.doc'),
(89, 'DOC', 'http://www.igcmonterrey.org/conferencias/200612/Como%20aprovechar%20mi%20presupuesto%20navideno.doc'),
(90, 'DOC', 'http://www.igcmonterrey.org/conferencias/200612/Que%20puedo%20hacer%20para%20mejorar%20la%20unidad%20familiar.doc'),
(91, 'DOC', 'http://www.igcmonterrey.org/conferencias/200612/Puedo%20reconciliarme%20con%20otros.doc'),
(92, 'DOC', 'http://www.igcmonterrey.org/conferencias/200612/Cual%20es%20el%20Significado%20de%20la%20Navidad.doc'),
(93, 'DOC', 'http://www.igcmonterrey.org/conferencias/200612/Como%20Podemos%20Despedir%20al%20Viejo%202006.doc'),
(94, 'DOC', 'http://www.igcmonterrey.org/conferencias/200701/Decisiones%20en%20tus%20habitos.doc'),
(95, 'DOC', 'http://www.igcmonterrey.org/conferencias/200701/Decisiones%20en%20tus%20finanzas.doc'),
(96, 'DOC', 'http://www.igcmonterrey.org/conferencias/200701/Decisiones%20en%20tus%20familia.doc'),
(97, 'DOC', 'http://www.igcmonterrey.org/conferencias/200702/Decisiones%20con%20tu%20tiempo.doc'),
(98, 'DOC', 'http://www.igcmonterrey.org/conferencias/200702/El enemigo del amor.doc'),
(99, 'DOC', 'http://www.igcmonterrey.org/conferencias/200702/Amor a prueba.doc'),
(100, 'DOC', 'http://www.igcmonterrey.org/conferencias/200703/Heroes...Abraham.doc'),
(101, 'DOC', 'http://www.igcmonterrey.org/conferencias/200703/Heroes...Jose.doc'),
(102, 'DOC', 'http://www.igcmonterrey.org/conferencias/200703/Heroes...%20Nehemias.doc'),
(103, 'DOC', 'http://www.igcmonterrey.org/conferencias/200704/Heroes,%20Jesus.doc'),
(104, 'DOC', 'http://www.igcmonterrey.org/conferencias/200704/Heroes,%20Carlos.doc'),
(105, 'DOC', 'http://www.igcmonterrey.org/conferencias/200704/Heroes,%20Claudia.doc'),
(106, 'DOC', 'http://www.igcmonterrey.org/conferencias/200706/Estres_En_Nuestras_Finanzas.doc'),
(107, 'DOC', 'http://www.igcmonterrey.org/conferencias/200706/Evolucion_vs_Creacion.doc'),
(108, 'PDF', 'http://www.igcmonterrey.org/conferencias/200608/Mas Grande que Mis Decepciones.pdf'),
(109, 'PDF', 'http://www.igcmonterrey.org/conferencias/200608/Mas Grande que Mis Heridas.pdf'),
(110, 'PDF', 'http://www.igcmonterrey.org/conferencias/200609/Como tratarla a ella.pdf'),
(111, 'PDF', 'http://www.igcmonterrey.org/conferencias/200609/Como tratarlo a el.pdf'),
(112, 'PDF', 'http://www.igcmonterrey.org/conferencias/200609/Como tratarlos a ellos.pdf'),
(113, 'PDF', 'http://www.igcmonterrey.org/conferencias/200610/Como Superar la Depresion.pdf'),
(114, 'PDF', 'http://www.igcmonterrey.org/conferencias/200610/Como Manejar el Estres.pdf'),
(115, 'PDF', 'http://www.igcmonterrey.org/conferencias/200610/Como Manejar la Envidia.pdf'),
(116, 'PDF', 'http://www.igcmonterrey.org/conferencias/200610/Como Controlar el Enojo.pdf'),
(117, 'PDF', 'http://www.igcmonterrey.org/conferencias/200611/Como%20perdonar%20al%20que%20me%20ha%20ofendido.pdf'),
(118, 'PDF', 'http://www.igcmonterrey.org/conferencias/200611/Como%20corregir%20un%20gran%20error.pdf'),
(119, 'PDF', 'http://www.igcmonterrey.org/conferencias/200611/Como%20soportar%20a%20una%20persona%20dificil.pdf'),
(120, 'PDF', 'http://www.igcmonterrey.org/conferencias/200611/Un segundo...Que pasa con Nuestros Familiares.pdf'),
(121, 'PDF', 'http://www.igcmonterrey.org/conferencias/200612/Como%20aprovechar%20mi%20presupuesto%20navideno.pdf'),
(122, 'PDF', 'http://www.igcmonterrey.org/conferencias/200612/Que%20puedo%20hacer%20para%20mejorar%20la%20unidad%20familiar.pdf'),
(123, 'PDF', 'http://www.igcmonterrey.org/conferencias/200612/Puedo%20reconciliarme%20con%20otros.pdf'),
(124, 'PDF', 'http://www.igcmonterrey.org/conferencias/200612/Cual%20es%20el%20Significado%20de%20la%20Navidad.pdf'),
(125, 'PDF', 'http://www.igcmonterrey.org/conferencias/200612/Como%20Podemos%20Despedir%20al%20Viejo%202006.pdf'),
(126, 'PDF', 'http://www.igcmonterrey.org/conferencias/200701/Decisiones%20en%20tus%20habitos.pdf'),
(127, 'PDF', 'http://www.igcmonterrey.org/conferencias/200701/Decisiones%20en%20tus%20finanzas.pdf'),
(128, 'PDF', 'http://www.igcmonterrey.org/conferencias/200701/Decisiones%20en%20tus%20familia.pdf'),
(129, 'PDF', 'http://www.igcmonterrey.org/conferencias/200702/Decisiones%20con%20tu%20tiempo.pdf'),
(130, 'PDF', 'http://www.igcmonterrey.org/conferencias/200702/El enemigo del amor.pdf'),
(131, 'PDF', 'http://www.igcmonterrey.org/conferencias/200702/Amor a prueba.pdf'),
(132, 'PDF', 'http://www.igcmonterrey.org/conferencias/200703/Heroes...Abraham.pdf'),
(133, 'PDF', 'http://www.igcmonterrey.org/conferencias/200703/Heroes...Jose.pdf'),
(134, 'PDF', 'http://www.igcmonterrey.org/conferencias/200703/Heroes...%20Nehemias.pdf'),
(135, 'PDF', 'http://www.igcmonterrey.org/conferencias/200704/Heroes,%20Jesus.pdf'),
(136, 'PDF', 'http://www.igcmonterrey.org/conferencias/200704/Heroes,%20Carlos.pdf'),
(137, 'PDF', 'http://www.igcmonterrey.org/conferencias/200704/Heroes,%20Claudia.pdf'),
(138, 'PDF', 'http://www.igcmonterrey.org/conferencias/200706/Estres_En_Nuestras_Finanzas.pdf'),
(139, 'PDF', 'http://www.igcmonterrey.org/conferencias/200706/Evolucion_vs_Creacion.pdf');

-- --------------------------------------------------------

--
-- Table structure for table `medios_audio`
--

CREATE TABLE `medios_audio` (
  `id_medio` int(10) UNSIGNED NOT NULL,
  `M3U` varchar(256) NOT NULL,
  `duracion` time NOT NULL DEFAULT '00:00:00',
  `largo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `medios_audio`
--

INSERT INTO `medios_audio` (`id_medio`, `M3U`, `duracion`, `largo`) VALUES
(1, 'http://www.igcmonterrey.org/conferencias/200705/estres-dia-dia-ed-SH-06-may-07.m3u', '00:00:00', 0),
(2, 'http://www.igcmonterrey.org/conferencias/200705/estres-en-nuestro-trabajo-ed-SH-13-May-07.m3u', '00:00:00', 0),
(3, 'http://www.igcmonterrey.org/conferencias/200705/estres-en-lafamilia-OG-20-may-07-ed.m3u', '00:00:00', 0),
(4, 'http://www.igcmonterrey.org/conferencias/200705/estre-en-finanzas-SH-27-may-07-ed.m3u', '00:00:00', 0),
(5, 'http://www.igcmonterrey.org/conferencias/200706/evolucion-creacion-ed-SH-03-jun-07.m3u', '00:00:00', 0),
(6, 'http://www.igcmonterrey.org/conferencias/200706/la%20biblia%20un%20libro%20mas-10-JUN-07-OG-ed.m3u', '00:00:00', 0),
(7, 'http://www.igcmonterrey.org/conferencias/200706/Si-Dios-%20es-%20bueno-porque%20permite%20el%20sufrimiento.m3u', '00:00:00', 0),
(8, 'http://www.igcmonterrey.org/conferencias/200706/Quien%20es%20Jesus-SH-ed.m3u', '00:00:00', 0),
(9, 'http://www.igcmonterrey.org/conferencias/200709/poder_con_la_biblia_SH_ed.m3u', '00:00:00', 0),
(10, 'http://www.igcmonterrey.org/conferencias/200709/poder_atraves_de_la_oracion_OG_ed.m3u', '00:00:00', 0),
(11, 'http://www.igcmonterrey.org/conferencias/200709/poder_en_la_humildad_AH_ed.m3u', '00:00:00', 0),
(12, 'http://www.igcmonterrey.org/conferencias/200710/lo_que_no_hare_en_el_cielo%2020071007_SH-ed.m3u', '00:00:00', 0),
(13, 'http://www.igcmonterrey.org/conferencias/200710/Que_piensa_Dios_de_la_magia_20071014_SH-ed.m3u', '00:00:00', 0),
(14, 'http://www.igcmonterrey.org/conferencias/200710/que_tan_bueno_debo_ser-para_salvarme_20071021_OG_ed.m3u', '00:00:00', 0),
(15, 'http://www.igcmonterrey.org/conferencias/200711/confiado%20o%20estresado%204%20nov%2007%20SG%20ed.m3u', '00:00:00', 0),
(16, 'http://www.igcmonterrey.org/conferencias/200711/amor%20o%20egoismo%2011%20no%2007%20OG%20ed.m3u', '00:00:00', 0),
(17, 'http://www.igcmonterrey.org/conferencias/200711/adorador%20o%20fariseo%2018%20nov%2007%20SG%20ed.m3u', '00:00:00', 0),
(18, 'http://www.igcmonterrey.org/conferencias/200711/alegre%20o%20quejumbrozo%2025%20nov%2007%20sg%20ed.m3u', '00:00:00', 0),
(19, 'http://www.igcmonterrey.org/conferencias/200712/verde-esperanza-02-dic-2007-sg%20ed.m3u', '00:00:00', 0),
(20, 'http://www.igcmonterrey.org/conferencias/200712/dorado%209%20de%20dic%2007%20sh%20ed.m3u', '00:00:00', 0),
(21, 'http://www.igcmonterrey.org/conferencias/200712/colores%20de%20la%20navidad%20Blanco%2023%20dic%20OG%20ed.m3u', '00:00:00', 0),
(22, 'http://www.igcmonterrey.org/conferencias/200712/en%20sus%20marcas%2030%20dic%20sg%20ed.m3u', '00:00:00', 0),
(23, 'http://www.igcmonterrey.org/conferencias/200801/dejando%20viejas%20ideas%206%20ene%202008%20sg%20ed.m3u', '00:00:00', 0),
(24, 'http://www.igcmonterrey.org/conferencias/200801/nueva%20vision%20evangelismo%2013%20ene%2008%20sg%20ed.m3u', '00:00:00', 0),
(25, 'http://www.igcmonterrey.org/conferencias/200801/relaciones%20interpersonales%2020%20enero%2008%20og%20ED.m3u', '00:00:00', 0),
(26, 'http://www.igcmonterrey.org/conferencias/200801/vision%202015%20enero%2027-08%20sg%20ED.m3u', '00:00:00', 0),
(27, 'http://www.igcmonterrey.org/conferencias/200802/amor%20incomparable%2003%20feb%20del%2008%20SG%20ed.m3u', '00:00:00', 0),
(28, 'http://www.igcmonterrey.org/conferencias/200802/amor%20increible%2010%20feb%202008%20sg%20ED.m3u', '00:00:00', 0),
(29, 'http://www.igcmonterrey.org/conferencias/200802/amor%20inconmovible%2017%20feb%2008%20OG%20Eed.m3u', '00:00:00', 0),
(30, 'http://www.igcmonterrey.org/conferencias/200802/amor%20imparable%2024%20feb%2008%20sg%20ed.m3u', '00:00:00', 0),
(31, 'http://www.igcmonterrey.org/conferencias/200803/jesus%20su%20fama%2002%20marz%2008%20sg%20ed.m3u', '00:00:00', 0),
(32, 'http://www.igcmonterrey.org/conferencias/200803/jesus%20su%20resureccion%2030%20marz%2008%20OG%20ed.m3u', '00:00:00', 0),
(33, 'http://www.igcmonterrey.org/conferencias/200803/Jesus%20su%20poder%209%20marzo%2008%20sh%20ed.m3u', '00:00:00', 0),
(34, 'http://www.igcmonterrey.org/conferencias/200803/su%20muerte%20Oscar%2016%20marzo%202008%20OG%20ed.m3u', '00:00:00', 0),
(35, 'http://www.igcmonterrey.org/conferencias/200804/pareciendome%20a%20jesus%206%20abril%2008%20sg%20ed.m3u', '00:00:00', 0),
(36, 'http://www.igcmonterrey.org/conferencias/200804/aprend%20a%20disfrutar%20la%20vida%20sh%2013%20abril%2008%20ed.m3u', '00:00:00', 0),
(37, 'http://www.igcmonterrey.org/conferencias/200804/temperamentos-colerico%2020%20abr%2008%20sg%20ed.m3u', '00:00:00', 0),
(38, 'http://www.igcmonterrey.org/conferencias/200804/temperamento-sanguinio%2027%20abril%2008%20sg%20ed.m3u', '00:00:00', 0),
(39, 'http://www.igcmonterrey.org/conferencias/200805/melancolico-genio-depresivo%2004%20may%20o8%20sg%20ed.m3u', '00:00:00', 0),
(40, 'http://www.igcmonterrey.org/conferencias/200805/flematico-paciente-conformista-may-11%20sg%20ed.m3u', '00:00:00', 0),
(41, 'http://www.igcmonterrey.org/conferencias/200805/temperamento-test-18-may-08-sg%20ed.m3u', '00:00:00', 0),
(42, 'http://www.igcmonterrey.org/conferencias/200805/tus-suenos-25-mayo-2008.m3u', '00:00:00', 0),
(43, 'http://www.igcmonterrey.org/conferencias/200806/senales_antes_del_fin_de_los_tiempos_jun_08.m3u', '00:00:00', 0),
(44, 'http://www.igcmonterrey.org/conferencias/200806/desaparecidos%2008%20de%20jun%202008%20sg%20ed.m3u', '00:00:00', 0),
(45, 'http://www.igcmonterrey.org/conferencias/200806/anticristo%2015%20jun%202008%20sg%20ed.m3u', '00:00:00', 0),
(46, 'http://www.igcmonterrey.org/conferencias/200806/armagedon%2022%20jun%202008%20ed%20sg.m3u', '00:00:00', 0),
(47, 'http://www.igcmonterrey.org/conferencias/200806/sistema%20perfecto%2029%20jun%2008%20sg%20ED.m3u', '00:00:00', 0),
(48, 'http://www.igcmonterrey.org/conferencias/200807/mas%20alla%20de%20nuestros%20limites%2006%20jul%2008%20sg%20ed.m3u', '00:00:00', 0),
(49, 'http://www.igcmonterrey.org/conferencias/200807/empresa%20mas%20desafiante%20%2013%20jul%2008%20sh%20ed.m3u', '00:00:00', 0),
(50, 'http://www.igcmonterrey.org/conferencias/200807/logrando%20lo%20imposible%2020%20jul%2008%20sg%20ed.m3u', '00:00:00', 0),
(51, 'http://www.igcmonterrey.org/conferencias/200807/excelencia%2027%20de%20jul%2008%20og%20ed.m3u', '00:00:00', 0),
(52, 'http://www.igcmonterrey.org/conferencias/200808/beneficio%20de%20leer%20la%20biblia%20sg%2003%20agost%2008%20ed.m3u', '00:00:00', 0),
(53, 'http://www.igcmonterrey.org/conferencias/200808/el%20beneficio%20de%20orar%2010%20agot%2008%20og%20ed.m3u', '00:00:00', 0),
(54, 'http://www.igcmonterrey.org/conferencias/200808/el%20beneficio%20de%20servir%20dom%2017%20og%20ed.m3u', '00:00:00', 0),
(55, 'http://www.igcmonterrey.org/conferencias/200808/el%20beneficio%20de%20reunirse%2024%20agost%202008%20sg%20ed.m3u', '00:00:00', 0),
(56, 'http://www.igcmonterrey.org/conferencias/200808/beneficio%20de%20dar%2031%20agost%2008%20sg%20ed.m3u', '00:00:00', 0),
(57, 'http://www.igcmonterrey.org/conferencias/200809/estoy%20deprimido%2007%20sept%202008%20sg%20ed.m3u', '00:00:00', 0),
(58, 'http://www.igcmonterrey.org/conferencias/200809/ya%20no%20te%20soporto%2007%20sept%202008%20sg%20ed.m3u', '00:00:00', 0),
(59, 'http://www.igcmonterrey.org/conferencias/200809/estoy%20preocupado%2021%20sept%2008%20sg%20ed.m3u', '00:00:00', 0),
(60, 'http://www.igcmonterrey.org/conferencias/200809/conflicto%20familiar%2028%20de%20sept%2008%20OG%20ed.m3u', '00:00:00', 0),
(61, 'http://www.igcmonterrey.org/conferencias/200810/quien%20eres%2012%20oct%2008%20sg%20ed.m3u', '00:00:00', 0),
(62, 'http://www.igcmonterrey.org/conferencias/200810/como%20se%20forma%20un%20pirata%2019oct08%20SG%20ed.m3u', '00:00:00', 0),
(63, 'http://www.igcmonterrey.org/conferencias/200810/como%20ser%20original%2026%20oct%2008%20OG%20ed.m3u', '00:00:00', 0),
(64, 'http://www.igcmonterrey.org/conferencias/200811/autoestima%20solida%2002%20nov%2008%20sg%20ed.m3u', '00:00:00', 0),
(65, 'http://www.igcmonterrey.org/conferencias/200811/chisme%209%20nov%2008%20sg%20ed.m3u', '00:00:00', 0),
(66, 'http://www.igcmonterrey.org/conferencias/200811/lujuria%20ruin%2016%20nov%2008%20sg%20ed.m3u', '00:00:00', 0),
(67, 'http://www.grancomision.org.mx/conferencias/200811/Insensatez%202%20ed.m3u', '00:00:00', 0),
(68, 'http://www.grancomision.org.mx/conferencias/200812/celebrando%20la%20navidad%20turboman%20sg%20ed.m3u', '00:00:00', 0),
(69, 'http://www.igcmonterrey.org/conferencias/200812/santa%20claus%2014%20dic%2008%20ed.m3u', '00:00:00', 0),
(70, 'http://www.igcmonterrey.org/conferencias/200812/posadas%2021%20dic%2008%20sg%20ed.m3u', '00:00:00', 0),
(71, 'http://www.grancomision.org.mx/conferencias/200901/como%20superar%20la%20crisis%2004%20enero%202009%20sg%20ed.m3u', '00:00:00', 0),
(72, 'http://igcmty.aeortiz.com/conferencias/200901/los%20buenos%20de%20la%20pelicula%2011%20enero%2009%20sg%20ed.m3u', '00:00:00', 0),
(73, 'http://igcmty.aeortiz.com/conferencias/200901/listos%20para%20el%20triunfo%2018%20enero%2009%20sg%20ed.m3u', '00:00:00', 0),
(74, 'http://igcmty.aeortiz.com/conferencias/200901/los%20malos%20de%20la%20pelicula%2025%20enero%2009%20sg%20ed.m3u', '00:00:00', 0),
(75, 'http://igcmty.aeortiz.com/conferencias/200902/logrando%20el%20triunfo%2001%20febrero%2009%20og%20ed.m3u', '00:00:00', 0),
(140, 'http://www.grancomision.org.mx/conferencias/200902/el%20comienzo%20del%20%20cambio%2008%20de%20feb%2009%20sg%20ed.m3u', '00:00:00', 0),
(141, 'http://www.grancomision.org.mx/conferencias/200902/cambio%20de%20habito%2015%20feb%2009%20sg%20ed.m3u', '00:00:00', 0),
(142, 'http://www.grancomision.org.mx/conferencias/200902/cambio%20en%20la%20familia%2022%20feb%2009%20sg%20ed.m3u', '00:00:00', 0),
(143, 'http://www.grancomision.org.mx/conferencias/200903/cambio-entre-padres-e-hijos-01-mar-2009-og-ed.m3u', '00:00:00', 0),
(144, 'http://www.grancomision.org.mx/conferencias/200903/pornografia%208%20marz%2009%20sh%20ed.m3u', '00:00:00', 0),
(145, 'http://igcmty.aeortiz.com/conferencias/200903/homosexualismo%2015%20marz%2009%20sg%20ed.mp3', '00:00:00', 0),
(146, 'http://www.grancomision.org.mx/conferencias/200903/Materialismo%2022%20mar%2009%20sg%20ed.mp3', '00:00:00', 0),
(147, 'http://www.grancomision.org.mx/conferencias/200903/irrespetuoso%2029%20marz%2009%20og%20ed.mp3', '00:00:00', 0),
(148, 'http://www.grancomision.org.mx/conferencias/200904/vida%20%205%20abril%2009%20sg%20ed.mp3', '00:00:00', 0),
(149, 'http://www.grancomision.org.mx/conferencias/200904/dinero%2019%20abril%2009%20sg%20ed.mp3', '00:00:00', 0),
(150, 'http://www.grancomision.org.mx/conferencias/200904/dinero%2019%20abril%2009%20sg%20ed.mp3', '00:00:00', 0),
(151, 'http://www.grancomision.org.mx/conferencias/200905/como%20lidiar%20con%20grandes%20olas%2010%20mar%2009%20sg%20ed.mp3', '00:00:00', 0),
(152, 'http://www.grancomision.org.mx/conferencias/200905/contra%20elviento%2017%20may%2009%20sg%20ed.mp3', '00:00:00', 0),
(153, 'http://www.grancomision.org.mx/conferencias/200905/enfrentando%20el%20naufraugio%2024%20may%2009%20sg%20ed.mp3', '00:00:00', 0),
(154, 'http://www.grancomision.org.mx/conferencias/200905/La%20salida%20ante%20las%20pruebas.mp3', '00:00:00', 0),
(155, 'http://www.grancomision.org.mx/conferencias/200906/paz%20a%20la%20manera%20de%20Dios%207%20jun%2009%20sg%20ed.mp3', '00:00:00', 0),
(156, 'http://www.grancomision.org.mx/conferencias/200906/paz%20con%20los%20hombres%20dom21%20de%20jun%2009%20sg%20ED.mp3', '00:00:00', 0),
(157, 'http://www.grancomision.org.mx/conferencias/200906/paz%20en%20el%20mundo%20dom28%20de%20jun%2009%20sg%20ed.mp3', '00:00:00', 0),
(158, 'http://www.grancomision.org.mx/conferencias/200907/camino%20a%20la%20grandeza%20dom05%20jul%2009%20sg%20ED.mp3', '00:00:00', 0),
(159, 'http://www.grancomision.org.mx/conferencias/200907/ejemplo%20de%20un%20grande%20jul%2013%2009%20sg%20ED.mp3', '00:00:00', 0),
(160, 'http://www.grancomision.org.mx/conferencias/200907/cada%20miembro%20un%20ministro%2019%20jul%2009%20og%20ED.mp3', '00:00:00', 0),
(161, 'http://www.grancomision.org.mx/conferencias/200907/el%20desconosido%20que%20ayudo%2026%20jul%20og%20ED.mp3', '00:00:00', 0),
(162, 'http://www.grancomision.org.mx/conferencias/200908/dios%20con%20el%20extranjero%202%20agosto%2009%20sg%20ED.mp3', '00:00:00', 0),
(163, 'http://www.grancomision.org.mxm/conferencias/200908/Dios%20con%20el%20carcelero%2009%20ogos%2009%20sg%20ED.mp3', '00:00:00', 0),
(164, 'http://www.grancomision.org.mx/conferencias/200908/Dios%20con%20maria%20magdalena%2016%20agos%2009%20sg%20ED.mp3', '00:00:00', 0),
(165, 'http://www.grancomision.org.mx/conferencias/200908/Dios%20con%20pablo%2023%20agosto%2009%20OG%20ED.mp3', '00:00:00', 0),
(166, 'http://www.grancomision.org.mx/conferencias/200908/Dios%20con%20nosotros%2030%20agost%2009%20SG%20ED.mp3', '00:00:00', 0),
(167, 'http://www.grancomision.org.mx/conferencias/200909/yo%20hare%20que%20todo%20te%20ayude%20para%20bien%206%20sept%2009%20sh%20ED.mp3', '00:00:00', 0),
(168, 'http://www.grancomision.org.mx/conferencias/200909/yo%20hare%20de%20ti%20una%20obra%20maestra%2013%20sept%2009%20SH%20ED.mp3', '00:00:00', 0),
(169, 'http://www.grancomision.org.mx/conferencias/200909/yo%20te%20dare%20gracia%20atraves%20de%20la%20fe%2020%20sep%2009%20sh%20ED.mp3', '00:00:00', 0),
(170, 'http://www.grancomision.org.mx/conferencias/200910/tu%20familia%2004%20oct%2009%20sh%20ED.mp3', '00:00:00', 0),
(171, 'http://www.grancomision.org.mx/conferencias/200909/Invencible%2026%20sept%2009%20NG%20ED.mp3', '00:00:00', 0),
(172, 'http://www.grancomision.org.mx/conferencias/200909/JC%20Irresistible%20NG%2027%20SEP-09%20ED.mp3', '00:00:00', 0),
(173, 'http://www.grancomision.org.mx/conferencias/200909/insuperable%2027%20sep%2009%20SH%20ED.mp3', '00:00:00', 0),
(174, 'http://www.grancomision.org.mx/conferencias/200909/JC%20Infinito%2027%20sept%2009%20NG%20ED.mp3', '00:00:00', 0),
(175, 'http://www.grancomision.org.mx/conferencias/200910/receta%20para%20una%20paternidad%20exitosa%2011%20oct%2009%20sh%20ED.mp3', '00:00:00', 0),
(176, 'http://www.grancomision.org.mx/conferencias/200910/lidiando%20conuna%20familia%20imperfecta%2018%20oct%2009%20og%20ED.mp3', '00:00:00', 0),
(177, 'http://www.grancomision.org.mx/conferencias/200910/lidiando%20con%20una%20familia%20imperfecta2%2025%20oct%2009%20ED.mp3', '00:00:00', 0),
(178, 'http://www.grancomision.org.mx/conferencias/200911/el%20orgulloso%2001%20nov%2009%20sg%20ED.mp3', '00:00:00', 0),
(179, 'http://www.grancomision.org.mx/conferencias/200911/el%20mentiroso%208%20%20nov%2009%20sg%20ED.mp3', '00:00:00', 0),
(180, 'http://www.grancomision.org.mx/conferencias/200911/el%20violento%2015%20nov%2009%20sg%20ED.mp3', '00:00:00', 0),
(181, 'http://www.grancomision.org.mx/conferencias/200911/el%20malvado%2022%20nov%2009%20sg%20ED.mp3', '00:00:00', 0),
(182, 'http://www.grancomision.org.mx/conferencias/200911/el%20chismoso%2029%20nov%2009%20OG%20ED.mp3', '00:00:00', 0),
(183, 'http://www.grancomision.org.mx/conferencias/200912/un%20regalo%2006%20dic%2009%20SG%20ED.mp3', '00:00:00', 0),
(184, 'http://www.grancomision.org.mx/conferencias/201001/Defineindo%20meta%20espiritual%2010%20enero%2010%20SH%20ED.mp3', '00:00:00', 0),
(185, 'http://www.grancomision.org.mx/conferencias/201001/domingo%2017%20enero%202010%20SH%20ED.mp3', '00:00:00', 0),
(186, 'http://www.grancomision.org.mx/conferencias/201001/Definiendo%20la%20Meta%20Financiera%20-%2024%20Enero%202010%20SH%20ED.mp3', '00:00:00', 0),
(187, 'http://igcmty.aeortiz.com/conferencias/201002/amor%20incondicional%2021%20feb%2010%20og%20ED.mp3', '00:00:00', 0),
(188, 'http://igcmty.aeortiz.com/conferencias/201001/Alcanzando%20mis%20metas%20-%2031%20Enero%202010%20%20Mandy%20ED.mp3', '00:00:00', 0),
(189, 'http://igcmty.aeortiz.com/conferencias/201002/amor%20sacrificado%2028%20feb%2020110%20SG%20ED.mp3', '00:00:00', 0),
(190, 'http://igcmty.aeortiz.com/conferencias/201001/Compartiendo%20a%20Cristo%20P1%20Mandi%20F%20ED.mp3', '00:00:00', 0),
(191, 'http://igcmty.aeortiz.com/conferencias/201001/Compartiendo%20a%20Cristo%20P2%20Mandi%20F%20ED.mp3', '00:00:00', 0),
(192, 'http://igcmty.aeortiz.com/conferencias/201003/el%20encuentro%20con%20mi%20mejor%20amigo%207%20marz%202010%20hudy%20ED.mp3', '00:00:00', 0),
(193, 'http://igcmty.aeortiz.com/conferencias/201003/el%20encuentro%20su%20vida%2014%20marz%202010%20sg%20ED.mp3', '00:00:00', 0),
(194, 'http://www.grancomision.org.mx/conferencias/201003/el%20encuentro%20sus%20seguidores%2021%20marz%202010%20sg%20ED.mp3', '00:00:00', 0),
(195, 'http://www.grancomision.org.mx/conferencias/201003/el%20encuentro%20su%20muerte%2028%20marzo%202010%20sg%20ED.mp3', '00:00:00', 0),
(196, 'http://www.grancomision.org.mx/conferencias/201004/en%20pos%20de%20la%20vision%2011%20de%20abril%202010%20sg%20ED.mp3', '00:00:00', 0),
(197, 'http://www.grancomision.org.mx/conferencias/201004/sin%20miedo%20a%20la%20inseguridad%2018%20may%202010%20sg%20ED.mp3', '00:00:00', 0),
(198, 'http://www.grancomision.org.mx/conferencias/201004/sin%20miedo%20a%20la%20cricis%2025%20abril%202010%20EDsg.mp3', '00:00:00', 0),
(199, 'http://www.grancomision.org.mx/conferencias/201005/Milagros%20Asi%20Funciona%20La%20Fe%20sg%202%20mayo%202010%20ED.mp3', '00:00:00', 0),
(203, 'http://www.grancomision.org.mx/conferencias/201005/No%20se%20a%20Donde%20Ir%209%20mayo%202010%20sg%20ED.mp3', '00:00:00', 0),
(204, 'http://www.grancomision.org.mx/conferencias/201005/No%20se%20a%20Donde%20Ir%209%20mayo%202010%20sg%20ED.mp3', '00:00:00', 0),
(205, 'http://www.grancomision.org.mx/conferencias/201005/no%20tengo%20un%20futuro%20prometedor%2016%20may%202010%20sg%20ED.mp3', '00:00:00', 0),
(206, 'http://www.grancomision.org.mx/conferencias/201005/deseo%20comensar%20de%20nuevo%2023%20may%202010%20og%20ED.mp3', '00:00:00', 0),
(207, 'http://grancomision.org.mx/conferencias/201005/El%20Milagro%20debe%20de%20ser%20Hoy%202010%20sg%20ed.mp3', '00:00:00', 0),
(208, 'http://www.grancomision.org.mx/conferencias/201006/Del%20Caos%20a%20la%20Madurez%206%20junio%202010%20sg%20ED.mp3', '00:00:00', 0),
(209, 'http://www.grancomision.org.mx/conferencias/201006/controlando%20el%20enojo%2013%20junio%20og%20%202010%20ED.mp3', '00:00:00', 0),
(210, 'http://www.grancomision.org.mx/conferencias/201006/el%20secreto%20para%20un%20matrimonio%20feliz%2020%20jun%202010%20sg%20ed.mp3', '00:00:00', 0),
(211, 'http://www.grancomision.org.mx/conferencias/201006/amor%20o%20carne%20asada%2027%20jun%202010%20sg%20ed.mp3', '00:00:00', 0),
(212, 'http://www.grancomision.org.mx/conferencias/201007/que%20haria%20jesus%20con%20su%20corazon%203%20jul%202010%20sg%20ED.mp3', '00:00:00', 0),
(213, 'http://www.grancomision.org.mx/conferencias/201007/Que%20haria%20Jesus%20con%20el%20estres%2011%20jul%202010%20sg%20ED.mp3', '00:00:00', 0),
(217, 'http://www.grancomision.org.mx/conferencias/201007/que%20haria%20jesus%20para%20ayudar%20a%20otros%2018%20jul%20og%20ED.mp3', '00:00:00', 0),
(219, 'http://www.grancomision.org.mx/conferencias/201007/que%20haria%20jesus%20Con%20la%20misi%f3n%20encomendada%2025%20jul%202010%20og%20ED.mp3', '00:00:00', 0),
(220, 'http://www.grancomision.org.mx/conferencias/201008/puedes%20dar%2001%20agost%202010%20sg%20ED.mp3', '00:00:00', 0),
(221, 'http://www.grancomision.org.mx/conferencias/201008/puedo%20serviles%2008%20agost%202010%20OG%20ed.mp3', '00:00:00', 0),
(224, 'http://www.grancomision.org.mx/conferencias/201008/puedes%20amarlos%2022%20agot%202010%20sg%20ed.mp3', '00:00:00', 0),
(225, 'http://www.grancomision.org.mx/conferencias/201008/puedes%20crecer%2015%20agost%202010%20sg%20ED.mp3', '00:00:00', 0),
(226, 'http://www.grancomision.org.mx/conferencias/201008/triunfar%20sobre%20la%20Crisis%2029%20agt%202010%20sg%20ED.mp3', '00:00:00', 0),
(228, 'http://www.grancomision.org.mx/conferencias/201009/crisis%20familiar%205%20sept%20sg%20ED.mp3', '00:00:00', 0),
(231, 'http://www.grancomision.org.mx/conferencias/201009/crisis%20familiares%2012%20sep%202010%20OG%20ed.mp3', '00:00:00', 0),
(232, 'http://www.grancomision.org.mx/conferencias/201009/trinfar%20sobre%20las%20finanzas%2019%20sept%202010%20sg%20ED.mp3', '00:00:00', 0),
(237, 'http://www.grancomision.org.mx/conferencias/201010/Jose%20En%20medio%20de%20la%20amargura%203%20oct%2010%20sg%20ED.mp3', '00:00:00', 0),
(238, 'http://www.grancomision.org.mx/conferencias/201010/David%20En%20Medio%20del%20Dolor%2017%202010%20ED%20sg.mp3', '00:00:00', 0),
(239, 'http://www.grancomision.org.mx/conferencias/201010/Nehemias%20%20Aguas%20Turbulentas%2010%20oct%202010%20sg%20ed.mp3', '00:00:00', 0),
(240, 'http://www.grancomision.org.mx/conferencias/201010/abraham%20decision%20contra%20toda%20esperanza%2024%20oct%20AH%20ED.mp3', '00:00:00', 0),
(243, 'http://www.grancomision.org.mx/conferencias/201010/Rut%20Cambio%20Generaciones%2031%20oct%202010%20sg%20ed.mp3', '00:00:00', 0),
(244, 'http://www.grancomision.org.mx/conferencias/201011/yo%20quiero%20tener%20la%20unidad%207%20nov%202010%20og%20ED.mp3', '00:00:00', 0),
(246, 'http://www.grancomision.org.mx/conferencias/201011/yo%20quiero%20ser%20humilde%2014%20nov%20sgED.mp3', '00:00:00', 0),
(248, 'http://www.grancomision.org.mx/conferencias/201012/navidad%20en%20paz%20%20que%20hacer%205%20dic%202010%20sg%20ED.mp3', '00:00:00', 0),
(250, 'http://www.grancomision.org.mx/conferencias/201012/navidad%20en%20paz%202%2012%20dic%202010%20sg%20ED.mp3', '00:00:00', 0),
(251, 'http://www.grancomision.org.mx/conferencias/201011/yo%20quiero%20tener%20buen%20caracter%2021%20nov%2010%20ogED.mp3', '00:00:00', 0),
(252, 'http://www.grancomision.org.mx/conferencias/201011/yo%20quiero%20honrarte%2028%20nov%202010%20sg%20ED.mp3', '00:00:00', 0),
(253, 'http://www.grancomision.org.mx/conferencias/201101/futuro%20inesperado%202%20enero%202011%20sg%20ed.mp3', '00:00:00', 0),
(255, 'http://www.grancomision.org.mx/conferencias/201101/como%20lograr%20mi%20sue%f1o%209%20ene%202011sg%20ED.mp3', '00:00:00', 0),
(256, 'http://www.grancomision.org.mx/conferencias/201101/haciendo%20mi%20sue%f1o%20una%20realidad%2016%20enero%2011%20sg%20ED.mp3', '00:00:00', 0),
(259, 'http://www.grancomision.org.mx/conferencias/201101/como%20desarrollar%20habitos%20saludables%2023%2001%2011%20sg%20ed.mp3', '00:00:00', 0),
(261, 'http://www.grancomision.org.mx/conferencias/201101/los%20habitos%20del%20exito%2030%20enero%2011%20og%20ED.mp3', '00:00:00', 0),
(264, 'http://www.grancomision.org.mx/conferencias/201102/Un%20viaje%20atraves%20de%20la%20musica%2013%20feb%2011%20sg%20ED.mp3', '00:00:00', 0),
(265, 'http://www.grancomision.org.mx/conferencias/201102/un%20pacto%20demencial%2020%20feb%202011%20sg%20ed.mp3', '00:00:00', 0),
(266, 'http://www.grancomision.org.mx/conferencias/201102/el%20uno%20para%20el%20otro%2027%20feb%202011%20og%20ed.mp3', '00:00:00', 0),
(267, 'http://www.grancomision.org.mx/conferencias/201103/sin%20condenacion%206%20marz%202011%20sg%20ED.mp3', '00:00:00', 0),
(269, 'http://www.grancomision.org.mx/conferencias/201103/adoptados%20y%20no%20mas%20esclavos%2013%20mar%2011%20sg%20ed.mp3', '00:00:00', 0),
(270, 'http://www.grancomision.org.mx/conferencias/201103/un%20presente%20perfecto%2020%20marz%202011%20sg%20ed.mp3', '00:00:00', 0),
(272, 'http://www.grancomision.org.mx/conferencias/201104/la%20vida%20es%20una%20carga%2003%20abril%202011%20sg%20ed.mp3', '00:00:00', 0),
(273, 'http://www.grancomision.org.mx/conferencias/201103/mas%20que%20vencedores%2027%20marz%202011%20joh%20ed.mp3', '00:00:00', 0),
(274, 'http://www.grancomision.org.mx/conferencias/201104/tengo%20envidia%20de%20la%20buena%2010%20ab%202011%20og%20ed.mp3', '00:00:00', 0),
(275, 'http://www.grancomision.org.mx/conferencias/201104/nunca%20lo%20boy%20a%20lograr%2017%20abril%202011%20sg%20ed.mp3', '00:00:00', 0),
(276, 'http://www.grancomision.org.mx/conferencias/201105/destino%2001%20mayo%20sg%20es%20tu%20camnino%20el%20correcto%20ED.mp3', '00:00:00', 0),
(277, 'http://www.grancomision.org.mx/conferencias/201105/el%20destino%20del%20seguidor%208%20mayo%202011%20sg%20ed.mp3', '00:00:00', 0),
(278, 'http://www.grancomision.org.mx/conferencias/201105/una%20vision%20un%20destino%2015%20may%202011%20sg%20ed.mp3', '00:00:00', 0),
(279, 'http://www.grancomision.org.mx/conferencias/201105/el%20destino%20en%20la%20familia%2022%20mayo%202011%20og%20ed.mp3', '00:00:00', 0),
(282, 'http://www.grancomision.org.mx/conferencias/201106/que%20tal%20si%205%20junio%202011%20ed.mp3', '00:00:00', 0),
(283, 'http://www.grancomision.org.mx/conferencias/201106/aprendiendo%20haciendo%2012%20jun%202011%20sg%20ed.mp3', '00:00:00', 0),
(284, 'http://www.grancomision.org.mx/conferencias/201106/armas%20divinas%2019%20jul%202011%20og%20ed.mp3', '00:00:00', 0),
(285, 'http://www.grancomision.org.mx/conferencias/201106/venciendo%20el%20miedo%2026%20jun%202011%20sg%20ed.mp3', '00:00:00', 0),
(286, 'http://www.grancomision.org.mx/conferencias/201107/fidelidad%20de%20Dios%2003%20de%20jul%202011%20OG%20ed.mp3', '00:00:00', 0),
(287, 'http://www.grancomision.org.mx/conferencias/201107/su%20gracia%2010%20de%20jul%202011%20AH%20ed.mp3', '00:00:00', 0),
(288, 'http://www.grancomision.org.mx/conferencias/201107/misericordia%2017%20jul%202011%20sg%20ED.mp3', '00:00:00', 0),
(289, 'http://www.grancomision.org.mx/conferencias/201107/su%20poder%2024%20jul%202011%20ED%20sg.mp3', '00:00:00', 0),
(290, 'http://www.grancomision.org.mx/conferencias/201108/el%20valor%20de%20una%20vida%207%20agos%202011%20sg%20ed.mp3', '00:00:00', 0),
(291, 'http://www.grancomision.org.mx/conferencias/201108/21%20Agosto%20-%20Salvando%20una%20vida%20OG%20ed.mp3', '00:00:00', 0),
(292, 'http://www.grancomision.org.mx/conferencias/201108/la%20tarea%20mas%20maravillosa%2028%20ago%202011%20sg%20ed.mp3', '00:00:00', 0),
(293, 'http://grancomision.org.mx/conferencias/201109/mejora%20tu%20vida%201%20click%2004%20sept%202011%20sg%20ED.mp3', '00:00:00', 0),
(296, 'http://grancomision.org.mx/conferencias/201109/como%20tener%20paz%20y%20esperanza%20en%20un%20mundo%20violento%2011%20sept%202011%20sg%20ed.mp3', '00:00:00', 0),
(297, 'http://www.grancomision.org.mx/conferencias/201109/son%20mis%20amigos%20buenos%20amigos%2018%20sep%202011%20og%20ed.mp3', '00:00:00', 0),
(298, 'http://grancomision.org.mx/conferencias/201110/un%20matrimonio%20estable%202%20oct%202011%20sg%20ed.mp3', '00:00:00', 0),
(299, 'http://grancomision.org.mx/conferencias/201110/una%20buena%20relacion%20con%20mi%20hijo%2016%20oct%202011%20sg%20ED.mp3', '00:00:00', 0),
(300, 'http://grancomision.org.mx/conferencias/201110/una%20amistad%20real%2023%20oct%202011%20alla%20handal%20ed.mp3', '00:00:00', 0),
(301, 'http://www.grancomision.org.mx/conferencias/201110/amar%20al%20dificil%20de%20amar%2030%20oct%20sg%20ed.mp3', '00:00:00', 0),
(302, 'http://www.grancomision.org.mx/conferencias/201111/la%20primavera%20un%20romanse%20inolvidable%206%20nov%202011%20sg%20ED.mp3', '00:00:00', 0),
(303, 'http://www.grancomision.org.mx/conferencias/201111/formando%20un%20hogar%2013%20nov%202011%20sg%20ed.mp3', '00:00:00', 0),
(304, 'http://www.grancomision.org.mx/conferencias/201111/De%20heroe%20a%20villano%2020%20nov%202011%20sg%20ED.mp3', '00:00:00', 0),
(305, 'http://www.grancomision.org.mx/conferencias/201111/una%20vida%20trascendente%2027%20nov%202011%20og%20ed.mp3', '00:00:00', 0),
(306, 'http://www.grancomision.org.mx/conferencias/201112/preparados%20para%20partir%204%20dic%202011%20sg%20ed.mp3', '00:00:00', 0),
(307, 'http://www.grancomision.org.mx/conferencias/201112/tiempo%20de%20dar%2011%20dic%202011%20OG%20ed.mp3', '00:00:00', 0),
(308, 'http://grancomision.org.mx/conferencias/201112/hacia%20una%20noche%20de%20paz%20SG%2018%20dic%202011%20ed.mp3', '00:00:00', 0),
(309, 'http://grancomision.org.mx/conferencias/201201/2012%20%20el%20a%f1o%20de%20mi%20vida%2001%20enero%202012%20sg%20ed.mp3', '00:00:00', 0),
(310, 'http://grancomision.org.mx/conferencias/201201/estudio%20de%20las%20escrituras%208%20enero%202012%20sg%20ED.mp3', '00:00:00', 0),
(311, 'http://grancomision.org.mx/conferencias/201201/meditar%20en%20las%20escrituras%2015%20enero%202012%20og%20ed.mp3', '00:00:00', 0),
(312, 'http://grancomision.org.mx/conferencias/201201/oracionn%20diciplinas%2022%20enero%202012%20SG%20ed.mp3', '00:00:00', 0),
(313, 'http://grancomision.org.mx/conferencias/201201/como%20tener%20un%20devocinal%2029%20enero%202012%20og%20ed.mp3', '00:00:00', 0),
(314, 'http://grancomision.org.mx/conferencias/201202/servicio%20diciplinas%20espirituales%205%20de%20feb%202012%20ed.mp3', '00:00:00', 0),
(315, 'http://grancomision.org.mx/conferencias/201202/ayuno%20diciplinas%20espirituales%2012%20feb%202012%20SG%20ed.mp3', '00:00:00', 0),
(316, 'http://grancomision.org.mx/conferencias/201202/adoracion%2019%20feb%202012%20allan%20H%20ed.mp3', '00:00:00', 0),
(317, 'http://grancomision.org.mx/conferencias/201203/el%20enojo%2011%20marz%202012%20sg%20ed.mp3', '00:00:00', 0),
(318, 'http://grancomision.org.mx/conferencias/201203/dominar%20los%20celos%20ed.mp3', '00:00:00', 0),
(319, 'http://grancomision.org.mx/conferencias/201204/un%20caracter%20problematico%20Og%2029%20abril%202012%20%20ed.mp3', '00:00:00', 0),
(320, 'http://grancomision.org.mx/conferencias/201205/vox%20dei%206%20abril%202012%20SG%20ed.mp3', '00:00:00', 0),
(321, 'http://grancomision.org.mx/conferencias/201205/Reconociendo%20la%20voz%20de%20Dios%2013%20may%202012%20sg%20ed.mp3', '00:00:00', 0),
(322, 'http://grancomision.org.mx/conferencias/201205/la%20voz%20de%20Dios%20en%20momentos%20dificiles%2020%20may%202012%20OG%20ed.mp3', '00:00:00', 0),
(323, 'http://grancomision.org.mx/conferencias/201205/Dios%20ya%20no%20se%20comunica%20con%20migo%2027%20may%202012%20sg%20ed.mp3', '00:00:00', 0),
(324, 'http://grancomision.org.mx/conferencias/201206/por%20que%20estamos%20aqui%203%20jun%202012%20sg%20ed.mp3', '00:00:00', 0),
(325, 'http://grancomision.org.mx/conferencias/201206/la%20verdaderes%20felicidad%2017%20junio%202012%20og%20ed.mp3', '00:00:00', 0),
(326, 'http://grancomision.org.mx/conferencias/201206/la%20satifaccion%20de%20vivir%2010%20jun%202012%20sg%20ed.mp3', '00:00:00', 0),
(327, 'http://grancomision.org.mx/conferencias/201206/en%20pos%20de%20una%20verdadera%20pasion%2024%20jun%202012%20sg%20ed.mp3', '00:00:00', 0),
(328, 'http://grancomision.org.mx/conferencias/201207/una%20nacion%20para%20Dios%2001%20jul%202012%20sg%20ed.mp3', '00:00:00', 0),
(329, 'http://grancomision.org.mx/conferencias/201207/el%20comienso%20del%20camino%2008%20jul%2012%20sg%20ed.mp3', '00:00:00', 0),
(330, 'http://grancomision.org.mx/conferencias/201207/haciendo%20el%20camino%2015%20jul%202012%20sg%20ed.mp3', '00:00:00', 0),
(331, 'http://grancomision.org.mx/conferencias/201207/trabajando%20en%20el%20camino%2022%20jul%202012%20og%20ed.mp3', '00:00:00', 0),
(332, 'http://www.grancomision.org.mx/conferencias/201207/ense%f1ando%20el%20camino%20a%20otros%2029%20jul%202012%20sg%20ed.mp3', '00:00:00', 0),
(333, 'http://grancomision.org.mx/conferencias/201208/la%20gran%20comision%20en%20el%20mundo%20%205%20agosto%202012%20sg%20ed.mp3', '00:00:00', 0),
(334, 'http://grancomision.org.mx/conferencias/201208/viviendo%20la%20gran%20comision%2012%20agt%202012%20sg%20ed.mp3', '00:00:00', 0),
(335, 'http://grancomision.org.mx/conferencias/201208/la%20gran%20comision%20en%20el%20mundo%2019%20agt%202012%20og%20ed.mp3', '00:00:00', 0),
(336, 'http://grancomision.org.mx/conferencias/201208/iglesia%20para%20los%20que%20no%20tienen%20iglesia%2026%20agot%202012%20steve%20ed.mp3', '00:00:00', 0),
(337, 'http://grancomision.org.mx/conferencias/201209/antidoto%20contra%20el%20temor%2009%20sept%202012%20sg%20ed.mp3', '00:00:00', 0),
(338, 'http://grancomision.org.mx/conferencias/201209/antidoto%20contra%20el%20estres%2016%20sp%202012%20sg%20ed.mp3', '00:00:00', 0),
(339, 'http://grancomision.org.mx/conferencias/201209/antidoto%20contra%20la%20tristeza%20og%2023%20sept%202012%20ed.mp3', '00:00:00', 0),
(340, 'http://grancomision.org.mx/conferencias/201210/las%20iglesias%20y%20loa%20criatianos%20son%20aburridos%207%20oct%202012%20sg%20%20ed.mp3', '00:00:00', 0),
(341, 'http://grancomision.org.mx/conferencias/201210/la%20iglesia%20esta%20llena%20de%20fanaticos%2014%20oct%202012%20AH%20ed.mp3', '00:00:00', 0),
(342, 'http://grancomision.org.mx/conferencias/201210/los%20cristianos%20son%20negativos%20y%20criticones%2021%20oct%202012%20ah%20y%20ar%20ed.mp3', '00:00:00', 0),
(343, 'http://grancomision.org.mx/conferencias/201210/a%20los%20cristianos%20los%20obligan%20a%20dar%20dinero%2028%20oct%202012%20sg%20ED.mp3', '00:00:00', 0),
(344, 'http://www.grancomision.org.mx/conferencias/201211/muy%20original%20tu%20combinacion%2004%20nov%202012%20sg%20ed.mp3', '00:00:00', 0),
(345, 'http://grancomision.org.mx/conferencias/201211/muy%20original%20tu%20humildad%2011%20nov%20sg%202012%20ed.mp3', '00:00:00', 0),
(346, 'http://grancomision.org.mx/conferencias/201211/tu%20amabilidad%2018%20nov%202012%20ed.mp3', '00:00:00', 0),
(347, 'http://grancomision.org.mx/conferencias/201211/tu%20cristianismo%2025%20nov%202012%20sg%20ed.mp3', '00:00:00', 0),
(348, 'http://grancomision.org.mx/conferencias/201212/Ellos%20querian%20estar%20ahi%2002%20dic2012%20sg%20MP3%20ed.mp3', '00:00:00', 0),
(349, 'http://grancomision.org.mx/conferencias/201212/ellos%20se%20alegraron%209%20dic%202012%20sg%20ed.mp3', '00:00:00', 0),
(350, 'http://grancomision.org.mx/conferencias/201212/ellos%20le%20reconocieron%20como%20rey%20alln%20handal%2016%20dic%202012%20ed.mp3', '00:00:00', 0),
(351, 'http://grancomision.org.mx/conferencias/201301/el%20poder%20de%20un%20sue%f1o%2013%20enero%202013%20sg%20ed.mp3', '00:00:00', 0),
(352, 'http://grancomision.org.mx/conferencias/201212/sabiduria%20para%20el%202013%206%20enero%202013%20sg%20ed.mp3', '00:00:00', 0),
(353, 'http://grancomision.org.mx/conferencias/201301/en%20pos%20de%20un%20sue%f1o%2020%20enero%202013%20sg%20ed.mp3', '00:00:00', 0),
(354, 'http://www.grancomision.org.mx/conferencias/201302/borrar%20no%20se%f1alar%203%20feb%202013%20sg%20ed.mp3', '00:00:00', 0),
(355, 'http://grancomision.org.mx/conferencias/201302/restaurar%20no%20juzgar%2010%20feb%202013%20sg%20ed.mp3', '00:00:00', 0),
(356, 'http://grancomision.org.mx/conferencias/201302/admirar%20no%20envidiar%2017%20feb%202013%20sg%20ed.mp3', '00:00:00', 0),
(357, 'http://grancomision.org.mx/conferencias/201302/actuar%20no%20hablar%2024%20feb%202013%20sg%20ed.mp3', '00:00:00', 0),
(358, 'http://www.grancomision.org.mx/conferencias/201303/Amor%20Autentico%20Nuestros%20ejemplos%20de%20amor%203%20Marzo%202013%20sg%20ed.mp3', '00:00:00', 0),
(360, 'http://grancomision.org.mx/conferencias/201303/amor%20indestructible%2017%20marz%202013%20sg%20ed.mp3', '00:00:00', 0),
(361, 'http://www.grancomision.org.mx/conferencias/201304/El%20puente%20que%20extend%ed%20salvo%20a%20muchos%207%20abril%202013%20sg.mp3', '00:00:00', 0),
(362, 'http://www.grancomision.org.mx/conferencias/201304/el%20trabajo%20ideal%20de%20Dios%20para%20ti%20%2021%20de%20Abril%202013%20sg.mp3', '00:00:00', 0),
(363, 'http://grancomision.org.mx/conferencias/201305/28%20abril%202013%20haciendo%20decisiones%20sabias%20en%20el%20trabajo%20ed.mp3', '00:00:00', 0),
(364, 'http://grancomision.org.mx/conferencias/201305/como%20destacarme%20en%20el%20trabajo%205%20may%202013%20sh%20ed.mp3', '00:00:00', 0),
(365, 'http://grancomision.org.mx/conferencias/201305/como%20ser%20un%20seguidor%2012%20mayo%202013%20sg.mp3', '00:00:00', 0),
(366, 'http://grancomision.org.mx/conferencias/201305/La%20fuerza%20interna%20del%20seguidor%2019%20may%202013%20AH.mp3', '00:00:00', 0),
(367, 'http://grancomision.org.mx/conferencias/201306/El%20camino%20diario%20del%20Seguidor%2002%20Jun%20SH%20ed.mp3', '00:00:00', 0),
(370, 'http://grancomision.org.mx/conferencias/201306/como%20ser%20una%20buena%20esposa%2023%20junio%202013%20SH%20ED.mp3', '00:00:00', 0),
(371, 'http://grancomision.org.mx/conferencias/201306/aprendiendo%20a%20ser%20un%20buen%20esposo%209%20junio%202013%20sg%20ed.mp3', '00:00:00', 0),
(372, 'http://grancomision.org.mx/conferencias/201306/aprendiendo%20a%20ser%20un%20buen%20padre%2016%20jun%202013%20sg%20ED.mp3', '00:00:00', 0),
(373, 'http://grancomision.org.mx/conferencias/201306/aprendiendo%20a%20ser%20un%20buen%20hijo%2030%20%202013%20sg%20ED.mp3', '00:00:00', 0),
(374, 'http://grancomision.org.mx/conferencias/201307/aprendiendo%20a%20ser%20un%20buen%20empleado%207%20de%20julio%202013%20sg%20ed.mp3', '00:00:00', 0),
(375, 'http://grancomision.org.mx/conferencias/201307/como%20ser%20buen%20jefe%2014%20julio%202013%20sg%20ed.mp3', '00:00:00', 0),
(376, 'http://grancomision.org.mx/conferencias/201307/el%20corazon%20de%20un%20aprendiz%2028%20jul%20013%20AH%20ed.mp3', '00:00:00', 0),
(377, 'http://grancomision.org.mx/conferencias/201307/aprendiendo%20a%20ser%20un%20buen%20compa%f1ero%2021%20jul%202013%20IP%20ed.mp3', '00:00:00', 0),
(378, 'http://grancomision.org.mx/conferencias/201308/gracia%20en%20ella%20somos%20rescatados%204%20agost%202013%20sg%20ed.mp3', '00:00:00', 0),
(379, 'http://grancomision.org.mx/conferencias/201308/gracia%20por%20ella%20somo%20aceptados%2011%20agt%202013%20sg%20ed.mp3', '00:00:00', 0),
(380, 'http://grancomision.org.mx/conferencias/201308/Gracia%20por%20ella%20somos%20Salvos%2018%20Agosto%20AR%20ed.mp3', '00:00:00', 0),
(381, 'http://grancomision.org.mx/conferencias/201308/Gracias%20Por%20ella%20somos%20comisionados%2025%20Agosto%202013%20SH%20ed.mp3', '00:00:00', 0),
(382, 'http://grancomision.org.mx/conferencias/201309/como%20vivir%20bien%20cuando%20las%20cosas%20ban%20mal%201%20sep%20dr%20andres%20%20p%20ED.mp3', '00:00:00', 0),
(383, 'http://grancomision.org.mx/conferencias/201309/Estoy%20condenado%20a%20vivir%20eternamente%20endeudado%208%20sep%202013%20SG.mp3', '00:00:00', 0),
(384, 'http://grancomision.org.mx/conferencias/201310/Inspiracion%20para%20cuando%20ya%20no%20hay%20fuerzas%202013%20ed.mp3', '00:00:00', 0),
(385, 'http://grancomision.org.mx/conferencias/201310/Inspiracion%20para%20seguir%20adelnte%20Oct.%2013%202012%20ed.mp3', '00:00:00', 0),
(386, 'http://grancomision.org.mx/conferencias/201310/una%20vision%20q%20te%20lleva%20a%20grandes%20cosas%2020%20oct%202013%20adrian%20ED.mp3', '00:00:00', 0),
(387, 'http://grancomision.org.mx/conferencias/201309/comprar%20o%20no%20comprar%2022%20sep%202013%20sh%20ed.mp3', '00:00:00', 0),
(388, 'http://grancomision.org.mx/conferencias/201309/dos%20caminos%20para%20mejorar%20finanzas%20AH%2015%20sept%202013%20ed.mp3', '00:00:00', 0),
(389, 'http://grancomision.org.mx/conferencias/201311/Primera%20joya%20Par%e1metros%20para%20una%20sana%20conversaci%f3n%203%20nov%202013%20sh.mp3', '00:00:00', 0),
(390, 'http://grancomision.org.mx/conferencias/201309/El%20poder%20de%20Dios%20en%20Accion%20(Revolucion%20del%20espiritu)%20Coloquio%20Conferencia%20%236%2029sep%2013.mp3', '00:00:00', 0),
(391, 'http://grancomision.org.mx/conferencias/201309/conf%2027%20sep%20campamento%20SH%20revolucion%20del%20Espiritu%20cf1%20ED.mp3', '00:00:00', 0),
(392, 'http://grancomision.org.mx/conferencias/201309/un%20enemigo%20silencioso%20EL%20ORGULLO%20ED%20PACO%20MORALES.mp3', '00:00:00', 0),
(393, 'http://grancomision.org.mx/conferencias/201309/la%20voz%20del%20Espiritu%20Santo%20Denny%20Chavarria%2028%20sep%202013%20campamento%20ed.mp3', '00:00:00', 0),
(394, 'http://grancomision.org.mx/conferencias/201309/reconociendo%20y%20ganando%20la%20batalla%20en%20ti%20kurt%2029%20sept%202013%20ed.mp3', '00:00:00', 0),
(395, 'http://grancomision.org.mx/conferencias/201309/las%20trampas%20del%20diablo%20Kurt%2028%20sept%202013%20ed.mp3', '00:00:00', 0),
(396, 'http://www.grancomision.org.mx/conferencias/201311/Tercera%20joya%20El%20papel%20de%20una%20esposa%2017%20nov%20%202013%20ah%20ed.mp3', '00:00:00', 0),
(397, 'http://grancomision.org.mx/conferencias/201311/Segunda%20joya%20Aprovechando%20el%20tiempo%2010%20nov%202013%20sh%20ed.mp3', '00:00:00', 0),
(398, 'http://grancomision.org.mx/conferencias/201311/Cuarta%20Joyas%20%20(%20El%20papel%20de%20un%20Esposo.)%2024%20nov%2013%20SH%20ed.mp3', '00:00:00', 0),
(399, 'http://grancomision.org.mx/conferencias/201312/la%20navidad%20y%20el%20pobre%201%20dic%202013%20sh%20ed.mp3', '00:00:00', 0),
(400, 'http://grancomision.org.mx/conferencias/201312/La%20Navidad%20y%20mi%20familia%2008%20dic%202013%20sh%20ed.mp3', '00:00:00', 0),
(401, 'http://grancomision.org.mx/conferencias/201312/La%20Navidad%20y%20la%20Paz%2015%20dic%202013%20sh%20ed.mp3', '00:00:00', 0),
(402, 'http://www.grancomision.org.mx/conferencias/201312/navidad%20segun%20la%20biblia%2022%20dic%20213%20sh%20ed.mp3', '00:00:00', 0),
(403, 'http://grancomision.org.mx/conferencias/201401/Persistencia%20un%20Principio%20de%20Exito%2012%20ene%202014%20sg%20ed.mp3', '00:00:00', 0),
(404, 'http://grancomision.org.mx/conferencias/201401/persistencia%20en%20la%20familia%2019%20enero%202014%20sg%20ed.mp3', '00:00:00', 0),
(405, 'http://grancomision.org.mx/conferencias/201401/Persistecia%20en%20las%20Finanzas%2026%20enero%202014%20sg%20ed.mp3', '00:00:00', 0),
(406, 'http://grancomision.org.mx/conferencias/201402/tipos%20de%20amigos%202%20feb%202014%20sg%20ed.mp3', '00:00:00', 0),
(407, 'http://grancomision.org.mx/conferencias/201402/Cuates%20para%20Siempre%20(El%20tunel%20del%20Caos)%2009%20feb2014%20ed.mp3', '00:00:00', 0),
(408, 'http://grancomision.org.mx/conferencias/201402/cuates%20a%20prueba%20de%20fuego%2016%20feb%202014%20sg%20ed.mp3', '00:00:00', 0),
(409, 'http://grancomision.org.mx/conferencias/201402/Cuates%20para%20Siempre%20(Amores%20que%20Matan%2023%20feb%202014%20sg.mp3', '00:00:00', 0),
(415, 'http://grancomision.org.mx/conferencias/201403/porque%20ser%20generosos%202%20marz%202014%20sg%20ed.mp3', '00:00:00', 0),
(416, 'http://grancomision.org.mx/conferencias/201403/por%20que%20orar%209%20marz%202013%20sg%20ed.mp3', '00:00:00', 0),
(417, 'http://grancomision.org.mx/conferencias/201403/porque%20servir%2016%20marz%202014%20sg%20ed.mp3', '00:00:00', 0),
(418, 'http://grancomision.org.mx/conferencias/201403/por%20que%20leer%20la%20biblia%2023%20marz%202014%20sg%20ed.mp3', '00:00:00', 0),
(419, 'http://grancomision.org.mx/conferencias/201403/porque%20evangelizar%2030%20marz%202014%20sg%20ed.mp3', '00:00:00', 0),
(420, 'http://grancomision.org.mx/conferencias/201404/porque%20diso%20permite%20el%20sufrimiento%206%20marz%2014%20ED.mp3', '00:00:00', 0),
(421, 'http://grancomision.org.mx/conferencias/201404/si%20jesus%20tenia%20tanto%20poder%20por%20que%20escogio%20morir%2013%20abril%2014%20sg%20ed.mp3', '00:00:00', 0),
(422, 'http://www.grancomision.org.mx/conferencias/201405/por%20que%20congregarme%20en%20una%20iglesia%2027%20abril%202014%20sg%20ED.mp3', '00:00:00', 0),
(423, 'http://grancomision.org.mx/conferencias/201405/Todos%20los%20seres%20humanos%20tienen%20fe%204%20mayo%2014%20sg%20ed.mp3', '00:00:00', 0),
(424, 'http://grancomision.org.mx/conferencias/201405/esperanza%20para%20todos%2011%20may%202014%20sg%20ED.mp3', '00:00:00', 0),
(425, 'http://grancomision.org.mx/conferencias/201405/las%20mas%20grandes%20de%20las%20motivaciones%2018%20may%2014%20allan%20h%20ed.mp3', '00:00:00', 0),
(426, 'http://grancomision.org.mx/conferencias/201405/ponte%20en%20sus%20zapatos%2025%20may%202014%20nelson%20g%20ed.mp3', '00:00:00', 0),
(427, 'http://grancomision.org.mx/conferencias/201407/victoria%20sobre%20u%20corazon%20herido%206%20jul%2014%20sg%20ed.mp3', '00:00:00', 0),
(428, 'http://grancomision.org.mx/conferencias/201406/el%20esta%20con%20migo%2001%20jun%2014%20sg%20ed.mp3', '00:00:00', 0),
(429, 'http://grancomision.org.mx/conferencias/201406/Valiente%20(Proclamacion%20Exponencial)%2008%20jun%202014%20sg%20ed.mp3', '00:00:00', 0),
(430, 'http://grancomision.org.mx/conferencias/201407/victoria%20sobre%20la%20envidia%2013%20jul%2014%20sg%20ed.mp3', '00:00:00', 0),
(431, 'http://grancomision.org.mx/conferencias/201407/Victorias%20Privadas%20(%20Victoria%20sobre%20las%20quejas%2020%20jul%2014%20sg%20ED.mp3', '00:00:00', 0),
(432, 'http://grancomision.org.mx/conferencias/201407/victorias%20privadas%20para%20decir%20que%20No%2027%20jl%2014%20sg%20ed.mp3', '00:00:00', 0),
(433, 'http://grancomision.org.mx/conferencias/201408/Victorias%20privada(Victoria%20sobre%20el%20Orgullo%2003082014%20sg%20ed.mp3http://', '00:00:00', 0),
(434, 'http://grancomision.org.mx/conferencias/201408/Victoria%20sobre%20el%20enojo%2017%20de%20agosto%20Isaac%20P%20ED.mp3', '00:00:00', 0),
(435, 'http://grancomision.org.mx/conferencias/201408/Victoria%20Sobre%20el%20Descontrol%20personal%2024-08-14%20SG%20ED.mp3', '00:00:00', 0),
(436, 'http://grancomision.org.mx/conferencias/201409/por%20que%20dar%20el%20mensaje%207%20sept%202014%20sg%20ed.mp3', '00:00:00', 0),
(437, 'http://grancomision.org.mx/conferencias/201409/como%20dar%20el%20mensaje%2014%20sep%2014%20Allan%20H%20ED.mp3', '00:00:00', 0),
(438, 'http://grancomision.org.mx/conferencias/201409/y%20despues%20que%2021%20sept%202014%20SH%20ed.mp3', '00:00:00', 0),
(439, 'http://grancomision.org.mx/conferencias/201411/Como%20ser%20Feliz%20(Cuando%20mi%20Vida%20no%20tiene%20sentido%202%20nov%2014%20SG.mp3', '00:00:00', 0),
(440, 'http://grancomision.org.mx/conferencias/201411/cuando%20me%20siento%20solo%209%20nov%2014%20sg.mp3', '00:00:00', 0),
(441, 'http://grancomision.org.mx/conferencias/201410/como%20tener%20buenos%20hijos%205%20oct%202014%20sh.mp3', '00:00:00', 0),
(442, 'http://grancomision.org.mx/conferencias/201410/caballeros%20a%20la%20medida%2019-10-2014.mp3', '00:00:00', 0),
(443, 'http://grancomision.org.mx/conferencias/201411/Como%20ser%20Feliz%20%20Cuando%20no%20soy%20Exitoso%2023%20nov%2014%20SG%20ed.mp3', '00:00:00', 0),
(444, 'http://grancomision.org.mx/conferencias/201411/cuando%20me%20siento%20rechazado%2016%20nov%2014%20AH%20ed.mp3', '00:00:00', 0),
(445, 'http://grancomision.org.mx/conferencias/201411/pase%20lo%20que%20pase%20Como%20ser%20Feliz%2030%20nov%202014%20sg%20ed.mp3', '00:00:00', 0),
(446, 'http://grancomision.org.mx/conferencias/201412/Los%203%20Regalos%20de%20Navidad%2007%20dic%202014%20sg%20ed.mp3', '00:00:00', 0),
(447, 'http://grancomision.org.mx/conferencias/201412/Los%203%20Regalos%20de%20Navidad%20la%20generocidad%2014%20dic%2014%20SG%20ED.mp3', '00:00:00', 0),
(449, 'http://grancomision.org.mx/conferencias/201501/Primero%20lo%20primero%204%20enero%202015%20ed.mp3', '00:00:00', 0),
(450, 'http://grancomision.org.mx/conferencias/201501/Permanecer%2011%20Enero%202015%20ed.mp3', '00:00:00', 0),
(451, 'http://grancomision.org.mx/conferencias/201412/La%20esperanza%2021%20Diciembre%202014%20sg%20ed.mp3', '00:00:00', 0),
(452, 'http://grancomision.org.mx/conferencias/201501/El%20plan%20de%20mis%20finanzas%2025%20enero%202015%20eed%20sg.mp3', '00:00:00', 0),
(453, 'http://grancomision.org.mx/conferencias/201501/La%20vision%20que%20nos%20mueve%2018%20de%20Enero%202015%20ed.mp3', '00:00:00', 0),
(454, 'http://grancomision.org.mx/conferencias/201502/la%20esperanza%20del%20mundo%201%20feb%202015%20sg%20ed.mp3', '00:00:00', 0),
(455, 'http://grancomision.org.mx/conferencias/201502/tiempo%20de%20sembrar%208%20feb%202015%20sg%20ed.mp3', '00:00:00', 0),
(456, 'http://www.grancomision.org.mx/conferencias/201502/mas%20alla%20de%20nosotros%20mismos%2015%20fb%202015%20sg%20ed.mp3', '00:00:00', 0),
(457, 'http://www.grancomision.org.mx/conferencias/201502/una%20vision%20global%2022%20de%20feb%202015%20sg%20ed.mp3', '00:00:00', 0),
(458, 'http://grancomision.org.mx/conferencias/201503/El%20A%20B%20C%20de%20la%20vida%208%20marz%202015%20sg%20ed.mp3', '00:00:00', 0),
(459, 'http://grancomision.org.mx/conferencias/201503/ley%20de%20la%20siembra%20y%20cosecha%2001%20marzo%202015%20sg%20ed.mp3', '00:00:00', 0),
(460, 'http://www.grancomision.org.mx/conferencias/201503/Beneficiar%20a%20otros%2015%20marzo%202015%20%20sg%20ed.mp3', '00:00:00', 0),
(461, 'http://grancomision.org.mx/conferencias/201503/compartir%20el%20amor%20de%20Dios%2022%20marzo%202015%20sg%20ed.mp3', '00:00:00', 0),
(463, 'http://grancomision.org.mx/conferencias/201503/Demostrar%20Gracia%2029-03-2015%20SH%20ED.mp3', '00:00:00', 0),
(464, 'http://grancomision.org.mx/conferencias/201504/Selfie%20crisis%20de%20identidad%2019%20abril%202015%20sg%20ED.mp3', '00:00:00', 0),
(465, 'http://grancomision.org.mx/conferencias/201504/Selfie%20una%20mejor%20selfie%2026%20abril%202015%20SG%20ED.mp3', '00:00:00', 0),
(466, 'http://grancomision.org.mx/conferencias/201505/Nuevo%20enfoque%20nuevo%20proposito%203%20may%202015%20SG%20ED.mp3', '00:00:00', 0),
(467, 'http://grancomision.org.mx/conferencias/201505/la%20mejor%20de%20todas%2010%20may%202015%20sg%20ed.mp3', '00:00:00', 0),
(468, 'http://grancomision.org.mx/conferencias/201505/el%20esposo%2017%20may%202015%20sg%20ed.mp3', '00:00:00', 0),
(469, 'http://grancomision.org.mx/conferencias/201505/La%20Esposa%2024%20may%2015%20ed%20adrian.mp3', '00:00:00', 0),
(470, 'http://grancomision.org.mx/conferencias/201505/los%20hijos%2031%20may%202015%20sg%20ed.mp3', '00:00:00', 0),
(471, 'http://grancomision.org.mx/conferencias/201506/tabu%20en%20el%20amor%20sg%2007%20junio%2015%20ED.mp3', '00:00:00', 0),
(472, 'http://grancomision.org.mx/conferencias/201506/tabu%20en%20las%20citas%2014%20junio%202015%20%20ed.mp3', '00:00:00', 0),
(473, 'http://grancomision.org.mx/conferencias/201506/tabu%20en%20el%20matrimonio%2019%20juni%20Allan%20H%20ed.mp3', '00:00:00', 0),
(474, 'http://grancomision.org.mx/conferencias/201506/tabu%20en%20el%20sexo%2028%20jun%2015%20isacc%20pineda%20ED.mp3', '00:00:00', 0),
(475, 'http://grancomision.org.mx/conferencias/201507/Es%20la%20Biblia%20realmente%20la%20Palabra%20de%20Dios%2005-07-2015%20sg%20ed.mp3', '00:00:00', 0),
(476, 'http://grancomision.org.mx/conferencias/201507/porque%20Dios%20permite%20que%20a%20la%20gente%20buena%20le%20sucedan%20cosas%20malas%2012%20jul%2015%20sg%20ed.mp3', '00:00:00', 0),
(477, 'http://grancomision.org.mx/conferencias/201508/Vision%20Back%20to%20School%202%20ago%202015%20sg%20ed.mp3', '00:00:00', 0),
(478, 'http://grancomision.org.mx/conferencias/201507/para%20que%20exite%20la%20iglesia%20sg%20ed%2019-07-2015.mp3', '00:00:00', 0),
(479, 'http://grancomision.org.mx/conferencias/201507/Que%20es%20la%20Verdad%20sg%20ed%2026-07-2015.mp3', '00:00:00', 0),
(480, 'http://grancomision.org.mx/conferencias/201508/Generosidad%2009-08-2015%20sg%20ED.mp3', '00:00:00', 0),
(481, 'http://grancomision.org.mx/conferencias/201508/Back%20to%20school%20(%20Evangelismo)%2016-08-2015%20sg%20ed.mp3', '00:00:00', 0),
(483, 'http://grancomision.org.mx/conferencias/201508/Back%20to%20school%20(Discipulado)%2023-08-2015%20sg%20ED.mp3', '00:00:00', 0),
(484, 'http://grancomision.org.mx/conferencias/201508/Back%20to%20school%20voluntariado30%20sept%202015%20sg%20ed.mp3', '00:00:00', 0),
(486, 'http://grancomision.org.mx/conferencias/201509/un%20lugar%20para%20los%20enfermos%206%20sep%202015%20sg%20ED.mp3', '00:00:00', 0),
(487, 'http://grancomision.org.mx/conferencias/201509/ponte%20la%20camiseta%2020%20sept%2015%20sg%20ED.mp3', '00:00:00', 0);
INSERT INTO `medios_audio` (`id_medio`, `M3U`, `duracion`, `largo`) VALUES
(488, 'http://grancomision.org.mx/conferencias/201510/Un%20Final%20de%20Pelicula%20(%20Un%20Final%20Epico)%2011-10-2015%20sg%20ed.mp3', '00:00:00', 0),
(489, 'http://grancomision.org.mx/conferencias/201510/Un%20Final%20dePelicula%20un%20final%20en%20paz%2018%20oct%202015%20sg%20ed.mp3', '00:00:00', 0),
(490, 'http://grancomision.org.mx/conferencias/201509/no%20se%20trata%20de%20mi%2013%20sept%202015%20sg%20ed.mp3', '00:00:00', 0),
(491, 'http://www.grancomision.org.mx/conferencias/201510/Un%20Final%20de%20Pelicula%20(Un%20Final%20Final%20Feliz)%2025-10-2015%20ed.mp3', '00:00:00', 0),
(492, 'http://grancomision.org.mx/conferencias/201510/Conferencia%201%20Mandy%20Fernandez%202%20oct%202015%20campamento%20ed.mp3', '00:00:00', 0),
(493, 'http://grancomision.org.mx/conferencias/201510/conferencia%205%20sabado%203%20oct%20adrian%20y%20allan%20campamento%20Gracia%20ed.mp3', '00:00:00', 0),
(494, 'http://grancomision.org.mx/conferencias/201510/conferencia%202%20%200ct%20Mandy%20Fernandez%20%20campamento%20Gracia%20ed.mp3', '00:00:00', 0),
(495, 'http://grancomision.org.mx/conferencias/201510/Conferencia%203%20Mandy%20Fernandez%20sabado%203%20oct%20campamento%20Gracia%20ed.mp3', '00:00:00', 0),
(496, 'http://grancomision.org.mx/conferencias/201510/conferencia%204%20dom%204%20oct%20Sergio%20Handal%20campamento%20Gracia.mp3', '00:00:00', 0),
(497, 'http://grancomision.org.mx/conferencias/201511/La%20Vida%20despues%20de%20la%20Vida%2001-11-2015%20ed.mp3', '00:00:00', 0),
(498, 'http://grancomision.org.mx/conferencias/201511/decidi%20empezar%20%208%20nov%202015%20Allan%20H%20ed.mp3', '00:00:00', 0),
(499, 'http://grancomision.org.mx/conferencias/201511/mi%20historia%20decidi%20parar%20isaac%2015%20nov%2015%20ed.mp3', '00:00:00', 0),
(500, 'http://grancomision.org.mx/conferencias/201511/Mi%20historia%20Decidi%20quedarme%2022%20nov%202015%20sg%20ed.mp3', '00:00:00', 0),
(501, 'http://grancomision.org.mx/conferencias/201511/MI%20Historia%20Decidi%20ir%2029%20Nov%2015%20ed.mp3', '00:00:00', 0),
(502, 'http://grancomision.org.mx/conferencias/201512/Llego%20la%20Navidad%20Que%20no%20te%20lleguen%20las%20Discusiones%206%20dic%202015%20sg%20ed.mp3', '00:00:00', 0),
(503, 'http://grancomision.org.mx/conferencias/201601/Cambia%20al%20Mundo%20en%2031%20dias%20Primero%20lo%20primero%2017%20enero%2016%20sg%20ed.mp3', '00:00:00', 0),
(504, 'http://grancomision.org.mx/conferencias/201601/el%20poder%20de%20mi%20calendario%2024%20ene%2016%20sg%20ed.mp3', '00:00:00', 0),
(505, 'http://grancomision.org.mx/conferencias/201601/Cambiando%20el%20Mundo%20en%2031%20Exceso%20de%20Equipaje%2031%20enero%2016%20sg%20ed.mp3', '00:00:00', 0),
(506, 'http://grancomision.org.mx/conferencias/201602/Como%20ser%20Millonario%20de%20Corazon%2007%20feb%202016%20isaac.mp3', '00:00:00', 0),
(507, 'http://grancomision.org.mx/conferencias/201602/fechados%2014%20feb%2016%20AH%20ed.mp3', '00:00:00', 0),
(508, 'http://www.grancomision.org.mx/conferencias/201602/Tiempo%20de%20Esparcir%20(%20Como%20tener%20Dinero%20sin%20ser%20miserables)%2028%20feb%2016%20sg%20ed.mp3', '00:00:00', 0),
(509, 'http://www.grancomision.org.mx/conferencias/201603/Pascua%20(La%20Tumba%20Vacia)%2020-03-2016%20SO%20ED.mp3', '00:00:00', 0),
(510, 'http://www.grancomision.org.mx/conferencias/201604/la%20gran%20invitacion%2003%20marz%202016%20sg%20ed.mp3', '00:00:00', 0),
(511, 'http://www.grancomision.org.mx/conferencias/201604/La%20Maxima%20Invitacion%2010-04-2016%20sg%20ed.mp3', '00:00:00', 0),
(512, 'http://www.grancomision.org.mx/conferencias/201602/tiempo%20de%20esparcir%20Una%20visi%f3n%20cautivadora%2021%20feb%2016%20%20sg%20ed.mp3', '00:00:00', 0),
(513, 'http://www.grancomision.org.mx/conferencias/201604/Sentimientos%20Una%20emoti-conversacion%2017-04-2016%20sg%20ed.mp3', '00:00:00', 0),
(514, 'http://www.grancomision.org.mx/conferencias/201604/Sentimientos%20Enredos%20Sentimentales%2024-04-2016%20sg%20ed.mp3', '00:00:00', 0),
(515, 'http://www.grancomision.org.mx/conferencias/201605/Sentimientos%2001-05-2016%20Isac%20ed.mp3', '00:00:00', 0),
(516, 'http://grancomision.org.mx/conferencias/201605/amor%20de%20madres%208%20de%20may%2016%20sg%20ed.mp3', '00:00:00', 0),
(517, 'http://grancomision.org.mx/conferencias/201605/Una%20Familia%20Visionarioa%2015%20may%2016%20sg%20ed.mp3', '00:00:00', 0),
(518, 'http://www.grancomision.org.mx/conferencias/201605/una%20familia%20pura%2022%20may%2016%20Herry%20Kattan%20ed.mp3', '00:00:00', 0),
(519, 'http://www.grancomision.org.mx/conferencias/201605/Una%20Familia%20llena%20de%20Paz%20Mayo-29-2016%20sg%20ed.mp3', '00:00:00', 0),
(520, 'http://www.grancomision.org.mx/conferencias/201606/Los%20Primeros%20pasos%20Presencia%2005-06-2016%20SH%20ED.mp3', '00:00:00', 0),
(521, 'http://www.grancomision.org.mx/conferencias/201606/Primeros%20pasos%20(%20Pertenencia)%2012-06-16%20sg%20ed.mp3', '00:00:00', 0),
(522, 'http://www.grancomision.org.mx/conferencias/201606/festival%20de%20papa%2019%20jul%202016%20adrian%20ed.mp3', '00:00:00', 0),
(523, 'http://www.grancomision.org.mx/conferencias/201606/Los%20primeros%20pasos%20Generosidad%2026-06-2016%20sg%20ed.mp3', '00:00:00', 0),
(524, 'http://www.grancomision.org.mx/conferencias/201607/la%20maraton%20de%20tu%20vida%20sg%203%20jul%2016%20sg%20ed.mp3', '00:00:00', 0),
(525, 'http://www.grancomision.org.mx/conferencias/201607/Una%20Fe%20Olimpica%20(%20Medallas%20Eternas)%2010%20jul%202016%20Alex%20H%20ed.mp3', '00:00:00', 0),
(526, 'http://www.grancomision.org.mx/conferencias/201607/La%20Disciplina%20de%20un%20atleta%2017%20jul%202016%20SH%20ed.mp3', '00:00:00', 0),
(527, 'http://grancomision.org.mx/conferencias/201606/son%20todas%20las%20religiones%20iguales%2031%20jul%202016%20sg%20ed.mp3', '00:00:00', 0),
(528, 'http://grancomision.org.mx/conferencias/201606/Una%20Fe%20Olimpica%2024%20de%20julio%202016%20Descalificados%20AH.mp3', '00:00:00', 0),
(529, 'http://grancomision.org.mx/conferencias/201608/se%20acerca%20el%20fin%20del%20mundo%207%20agost%202016%20sg%20ed.mp3', '00:00:00', 0),
(530, 'http://grancomision.org.mx/conferencias/201608/por%20que%20crear%20contraversia%2014%20agst%202016%20Samy%20O%20ED.mp3', '00:00:00', 0),
(531, 'http://grancomision.org.mx/conferencias/201608/Que%20piensa%20Dios%20de%20los%20LGBT%2021-08-2016%20ed.mp3', '00:00:00', 0),
(532, 'http://grancomision.org.mx/conferencias/201608/por%20q%20el%20cristianismo%20prohibe%20tantas%20cosas%2028%20agost%202016%20sh%20ed.mp3', '00:00:00', 0),
(533, 'http://grancomision.org.mx/conferencias/201609/La%20Oveja%20Perdida%2004-09-2016%20SH%20ed.mp3', '00:00:00', 0),
(534, 'http://grancomision.org.mx/conferencias/201609/El%20vecino%20no%20deseado%2011-09-2016%20SH%20ed.mp3', '00:00:00', 0),
(535, 'http://grancomision.org.mx/conferencias/201610/Las%20Pruebas%20de%20la%20Vida%2002-Oct-2016%20sg%20ed.mp3', '00:00:00', 0),
(536, 'http://grancomision.org.mx/conferencias/201610/De%20Regreso%20al%20Futuro%2009-Oct-2016%20Isac%20P%20ed.mp3', '00:00:00', 0),
(537, 'http://grancomision.org.mx/conferencias/201610/de%20pelicula-%20al%20control%20de%20mis%20emociones.mp3', '00:00:00', 0),
(538, 'http://grancomision.org.mx/conferencias/201610/Una%20Batalle%20Epica%2023%20oct%2016%20sg%20ed.mp3', '00:00:00', 0),
(539, 'http://grancomision.org.mx/conferencias/201611/Identidad%2030-10-2016%20sg%20ed.mp3', '00:00:00', 0),
(540, 'http://grancomision.org.mx/conferencias/201611/Pertenecia%206%20nov%2016%20sg%20ed.mp3', '00:00:00', 0),
(541, 'http://grancomision.org.mx/conferencias/201611/servicio%2013%20nov%202016%20sg%20ed.mp3', '00:00:00', 0),
(542, 'http://www.grancomision.org.mx/conferencias/201611/Mi%20Nuevo%20Yo%20(%20Influencia)%2020%20nov%202016%20SO%20ed.mp3', '00:00:00', 0),
(543, 'http://www.grancomision.org.mx/conferencias/201611/Poder%2027%20nov%202016%20sh%20ed.mp3', '00:00:00', 0),
(544, 'http://www.grancomision.org.mx/conferencias/201612/Los%20Fantasmas%20de%20las%20Navidades%20Pasadas%2004-12-2016%20sh%20ed.mp3', '00:00:00', 0),
(545, 'http://www.grancomision.org.mx/conferencias/201612/Superando%20la%20falta%20de%20Generosidad%2011-12-2016%20SH%20ed.mp3', '00:00:00', 0),
(546, 'http://www.grancomision.org.mx/conferencias/201612/Los%20Fantasmas%20de%20las%20Navidades%20Pasadas%2018-12-2016%20SH%20ED.mp3', '00:00:00', 0),
(547, 'http://www.grancomision.org.mx/conferencias/201701/El%20llamado%20es%20para%20Ti%208%20Enero%2017%20sg%20edi.mp3', '00:00:00', 0),
(548, 'http://www.grancomision.org.mx/conferencias/201701/Que%20tan%20grande%20es%20tu%20vision%201%20enero%2017%20sg%20ed.mp3', '00:00:00', 0),
(549, 'http://www.grancomision.org.mx/conferencias/201701/llamado%20a%20ser%20y%20crecer%2029%20enero%2017%20sg%20ed.mp3', '00:00:00', 0),
(550, 'http://grancomision.org.mx/conferencias/201701/Llamado%20a%20ser%20amado%2015%20enero%2017%20sg%20ed.mp3', '00:00:00', 0),
(552, 'http://www.grancomision.org.mx/conferencias/201701/Llamado%20a%20ser%20y%20crecer%2022%20enero%2017%20sg%20ed.mp3', '00:00:00', 0),
(553, 'http://www.grancomision.org.mx/conferencias/201702/Descubriendo%20mi%20llamado-%20Llamado%20a%20servir%2005-02-2017%20sg%20Ed.mp3', '00:00:00', 0),
(554, 'http://www.grancomision.org.mx/conferencias/201702/llamado%20a%20ser%20enviado%2012%20febrero%202017%20ed.mp3', '00:00:00', 0),
(555, 'http://www.grancomision.org.mx/conferencias/201702/llamado%20a%20Resistir%2019-02-2017.mp3', '00:00:00', 0),
(556, 'http://www.grancomision.org.mx/conferencias/201702/Llamado%20a%20Trascender%2026%20Febrero%202017%20AH%20ED.mp3', '00:00:00', 0),
(557, 'http://www.grancomision.org.mx/conferencias/201703/menos%20es%20mas%205%20marz%202017%20sg%20ED.mp3', '00:00:00', 0),
(558, 'http://www.grancomision.org.mx/conferencias/201703/superando%20mis%20tristezas%20y%20temores%2019%20de%20marz%2017%20sg%20ed.mp3', '00:00:00', 0),
(559, 'http://www.grancomision.org.mx/conferencias/201703/Generosidad%20Irracional%2012-03-2017%20sg%20ed.mp3', '00:00:00', 0),
(560, 'http://www.grancomision.org.mx/conferencias/201703/La%20prueba%20del%20Dinero%2026-03-2017%20IP%20ed.mp3', '00:00:00', 0),
(561, 'http://www.grancomision.org.mx/conferencias/201704/Considera%20a%20Jesus%2009-04-2017%20sg%20ed.mp3', '00:00:00', 0),
(562, 'http://grancomision.org.mx/conferencias/201704/Mas%20de%20lo%20mismo%2023%20de%20abril%2017%20sg%20ed.mp3', '00:00:00', 0),
(563, 'http://grancomision.org.mx/conferencias/201704/el%20problema%20es%20el%20patron%2030%20de%20abril%2017%20sg%20ed.mp3', '00:00:00', 0),
(564, 'http://grancomision.org.mx/conferencias/201705/Especial%20Celebrando%20a%20Mam%c3%a1%207%20Mayo%202017%20ed.mp3', '00:00:00', 0),
(565, 'http://grancomision.org.mx/conferencias/201705/El%20secreto%20del%20%c3%a9xito%20sustentable%2014-05-2017%20ed.mp3', '00:00:00', 0),
(566, 'http://grancomision.org.mx/conferencias/201705/El%20poder%20de%20lo%20mismo%20-%20El%20Proceso%20de%20Recorte%20-%2021%20mayo%202017%20%20ed.mp3', '00:00:00', 0),
(567, 'http://grancomision.org.mx/conferencias/201704/Nueva%20Perspectiva%20(Como%20ser%20rico)%2002-04-2017%20ed.mp3', '00:00:00', 0),
(568, 'http://grancomision.org.mx/conferencias/201706/el%20guarda%20espalda%2011%20JUNIO%2017%20sg%20ed.mp3', '00:00:00', 0),
(569, 'http://grancomision.org.mx/conferencias/201706/El%20Heroe%20Anonimo%2004-06-2017%20ed.mp3', '00:00:00', 0),
(570, 'http://grancomision.org.mx/conferencias/201706/el%20rey%20humilde%2018%20jun%2017%20sg%20ed.mp3', '00:00:00', 0),
(571, 'http://grancomision.org.mx/conferencias/201706/Un%20legado%20permanente%2025%20junio%20sg%20ed.mp3', '00:00:00', 0),
(572, 'http://grancomision.org.mx/conferencias/201706/recuperandolo%20todo%20SO%2002-jul-17%20ed.mp3', '00:00:00', 0),
(573, 'http://grancomision.org.mx/conferencias/201707/compruebalo%20tu%20mismo%209%20jul%202017%20sh%20ed.mp3', '00:00:00', 0),
(574, 'http://grancomision.org.mx/conferencias/201707/Ense%c3%b1anza%20Pr%c3%a1ctica%2016%20julio%2017%20sg%20ed.mp3', '00:00:00', 0),
(575, 'http://grancomision.org.mx/conferencias/201707/diciplinas%20espirituales%2023%20jul%2017%20sg%20ed.mp3', '00:00:00', 0),
(576, 'http://grancomision.org.mx/conferencias/201707/compruebalo%20tu%20mismo%209%20jul%202017%20sh%20ed.mp3', '00:00:00', 0),
(577, 'http://grancomision.org.mx/conferencias/201708/Relaciones%20providenciales%206%20agos%2017%20sg%20ed.mp3', '00:00:00', 0),
(578, 'http://grancomision.org.mx/conferencias/201708/circuntancias%20cruciales%2013%20ago%20AH%20ed.mp3', '00:00:00', 0),
(579, 'http://grancomision.org.mx/conferencias/201708/Color%20de%20esperanza%2020%20agosto%2017%20SG%20ed.mp3', '00:00:00', 0),
(580, 'http://www.grancomision.org.mx/conferencias/201708/Mi%20Reflejo%2027%20ag%2017%20sg%20ed.mp3', '00:00:00', 0),
(581, 'http://www.grancomision.org.mx/conferencias/201709/corazon%20roto%2003%20sept%2017%20isaac%20ed.mp3', '00:00:00', 0),
(582, 'http://grancomision.org.mx/conferencias/201709/Yo%20solo%20quiero%2010%20sep%2017%20SG%20ed.mp3', '00:00:00', 0),
(583, 'http://grancomision.org.mx/conferencias/201709/Quien%20fue%20Jesus%2017%20Sep%202017%20ed.mp3', '00:00:00', 0),
(584, 'http://www.grancomision.org.mx/conferencias/201709/conferencia%20nelson%2022%20sep%20nelson%201er%20conf%20ed.mp3', '00:00:00', 0),
(585, 'http://www.grancomision.org.mx/conferencias/201709/conferencia%20Francisco%2023%20sep%202da%20conf%20ed.mp3', '00:00:00', 0),
(586, 'http://www.grancomision.org.mx/conferencias/201709/tercer%20conf%20edwyn%2023%20sep%2017%20ed.mp3', '00:00:00', 0),
(587, 'http://www.grancomision.org.mx/conferencias/201709/conferencia%204%20Kurt%2023%20sept%20ed.mp3', '00:00:00', 0),
(588, 'http://www.grancomision.org.mx/conferencias/201710/1%20de%20Octubre%20-%20Profundamente%20dependiente%20de%20Dios%20Sergio%20ed.mp3', '00:00:00', 0),
(589, 'http://www.grancomision.org.mx/conferencias/201710/Seguidor%20Sacrificado%2008%20oct%202017%20IP%20ed.mp3', '00:00:00', 0),
(590, 'http://www.grancomision.org.mx/conferencias/201709/conferencia%205%20dom%2024%20sep%2017%20%20nelson%20ed.mp3', '00:00:00', 0),
(591, 'http://www.grancomision.org.mx/conferencias/201709/conferencia%20de%20Nacho%20pecina%20campamento%20sept%202017%20ed.mp3', '00:00:00', 0),
(592, 'http://www.grancomision.org.mx/conferencias/201710/aprendiz%20de%20toda%20la%20vida%2015%20oct%2017%20hk%20ed.mp3', '00:00:00', 0),
(593, 'http://www.grancomision.org.mx/conferencias/201710/pescador%20de%20hombre%2022%20oct%2017%20sg%20ed.mp3', '00:00:00', 0),
(594, 'http://www.grancomision.org.mx/conferencias/201710/Siervo%20Abnegado%2029-10-2017%20sg%20ed.mp3', '00:00:00', 0),
(595, 'http://www.grancomision.org.mx/conferencias/201711/limites%20en%20el%20matrimonio%205%20nov%2017%20sg%20ed.mp3', '00:00:00', 0),
(596, 'http://www.grancomision.org.mx/conferencias/201711/limites%20en%20el%20trabajo%20allan%2012%20nov%20Allan%20H%20ed.mp3', '00:00:00', 0),
(597, 'http://www.grancomision.org.mx/conferencias/201711/limites%20con%20los%20hijos%2019%20nov%20sg%20ed.mp3', '00:00:00', 0),
(598, 'http://www.grancomision.org.mx/conferencias/201712/EXPECTANTE%20-%20El%20milagro%20no%20es%20el%20milagro%20-%203%20de%20diciembre%202017%20ed.mp3', '00:00:00', 0),
(599, 'http://www.grancomision.org.mx/conferencias/201712/Expectante%20angeles%20cantando%20estan%2010-12-17%20SO%20ed.mp3', '00:00:00', 0),
(600, 'http://www.grancomision.org.mx/conferencias/201712/Expetante%20un%20mundo%20mejor%2017%20dic%2017%20%20sg%20ed.mp3', '00:00:00', 0),
(601, 'http://www.grancomision.org.mx/conferencias/201801/Nuestra%20Vision%20para%20el%202018%20-%207%20Enero%202018%20ed%20sg.mp3', '00:00:00', 0),
(602, 'http://www.grancomision.org.mx/conferencias/201801/Comunicadores%20audaces%202018%20-%2014%20Enero%202018%20sg%20ed.mp3', '00:00:00', 0),
(603, 'http://www.grancomision.org.mx/conferencias/201801/Abnegado%20servidor%20de%20Cristo%2021%20Enero%202018%20sg%20ed.mp3', '00:00:00', 0),
(604, 'http://www.grancomision.org.mx/conferencias/201801/Voluntarios%20entregados%2028%20enero%2018%20IP%20ed.mp3', '00:00:00', 0),
(605, 'http://www.grancomision.org.mx/conferencias/201802/transplante%20de%20corazon%204%20febrero%2018%20sg%20ed.mp3', '00:00:00', 0),
(606, 'http://www.grancomision.org.mx/conferencias/201802/primero%20o%20primero%2011%20feb%2018%20IP%20ed.mp3', '00:00:00', 0),
(607, 'http://www.grancomision.org.mx/conferencias/201802/Liberate%20de%20Mamonas%2018%20febAH%20ED.mp3', '00:00:00', 0),
(608, 'http://www.grancomision.org.mx/conferencias/201804/viviendo%20para%20una%20causa%20eterna%208%20abril%2018%20sg%20ed.mp3', '00:00:00', 0),
(609, 'http://www.grancomision.org.mx/conferencias/201803/Si%20tan%20solo%20cambiara%20mar%204%20ed.mp3', '00:00:00', 0),
(610, 'http://www.grancomision.org.mx/conferencias/201803/Mis%20hijos%20me%20sacan%20de%20quicio%20mar%2011%20ed.mp3', '00:00:00', 0),
(611, 'http://www.grancomision.org.mx/conferencias/201803/Mis%20padres%20no%20me%20entienden%20sg%20ed.mp3', '00:00:00', 0),
(612, 'http://www.grancomision.org.mx/conferencias/201803/candil%20de%20la%20calle%2025%20marzo%2018%20isaac%20ed.mp3', '00:00:00', 0),
(613, 'http://www.grancomision.org.mx/conferencias/201804/Hablemos%20de%20Sexo%20Sg%2015%20abril%202018%20ed.mp3', '00:00:00', 0),
(614, 'http://www.grancomision.org.mx/conferencias/201804/Me%20enamoro%20por%20los%20ojos%2022%20abril%2018%20SH%20ed.mp3', '00:00:00', 0),
(615, 'http://www.grancomision.org.mx/conferencias/201804/El%20Mito%20de%20la%20persona%20Ideal%20ip%2029%20abril%202018%20ed.mp3', '00:00:00', 0),
(616, 'http://www.grancomision.org.mx/conferencias/201805/Resureccion%20Mito%20o%20Verdad%20sg%2013%20may%2018%20ed.mp3', '00:00:00', 0),
(617, 'http://www.grancomision.org.mx/conferencias/201805/La%20Biblia%20coleccion%20de%20cuentos%20o%20palabra%20de%20Dios%2020%20may%2018%20sg%20ed.mp3', '00:00:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `medios_imagen`
--

CREATE TABLE `medios_imagen` (
  `id_medio` int(10) UNSIGNED NOT NULL,
  `altura` int(11) NOT NULL,
  `ancho` int(11) NOT NULL,
  `texto_alterno` varchar(64) NOT NULL,
  `src` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `medios_imagen`
--

INSERT INTO `medios_imagen` (`id_medio`, `altura`, `ancho`, `texto_alterno`, `src`) VALUES
(200, 506, 605, 'Compartiendo a Cristo con tus Amigos, Parte 2', 'img/compartiendo_a_xto_2.jpg'),
(201, 480, 640, 'Reunión de Mujeres', 'img/reunion_mujeres.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `medios_texto`
--

CREATE TABLE `medios_texto` (
  `id_medio` int(11) UNSIGNED NOT NULL,
  `titulo` varchar(128) NOT NULL,
  `subtitulo` varchar(128) NOT NULL,
  `texto` mediumtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `medios_video`
--

CREATE TABLE `medios_video` (
  `id_medio` int(10) UNSIGNED NOT NULL,
  `embed` varchar(4096) NOT NULL,
  `video_url` varchar(512) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `medios_video`
--

INSERT INTO `medios_video` (`id_medio`, `embed`, `video_url`) VALUES
(202, '<object width=\"640\" height=\"385\"><param name=\"movie\" value=\"http://www.youtube.com/v/a62hqdG5LmI&hl=en_US&fs=1&\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"http://www.youtube.com/v/a62hqdG5LmI&hl=en_US&fs=1&\" type=\"application/x-shockwave-flash\" allowscriptaccess=\"always\" allowfullscreen=\"true\" width=\"640\" height=\"385\"></embed></object>', ''),
(214, '<object width=\"640\" height=\"360\"><param name=\"allowfullscreen\" value=\"true\" /><param name=\"allowscriptaccess\" value=\"always\" /><param name=\"movie\" value=\"http://vimeo.com/moogaloop.swf?clip_id=13391374&server=vimeo.com&show_title=1&show_byline=0&show_portrait=0&color=00ADEF&fullscreen=1\" /><embed src=\"http://vimeo.com/moogaloop.swf?clip_id=13391374&server=vimeo.com&show_title=1&show_byline=0&show_portrait=0&color=00ADEF&fullscreen=1\" type=\"application/x-shockwave-flash\" allowfullscreen=\"true\" allowscriptaccess=\"always\" width=\"640\" height=\"360\"></embed></object>', ''),
(215, '<object width=\"640\" height=\"360\"><param name=\"allowfullscreen\" value=\"true\" /><param name=\"allowscriptaccess\" value=\"always\" /><param name=\"movie\" value=\"http://vimeo.com/moogaloop.swf?clip_id=13205814&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=0&amp;show_portrait=0&amp;color=00ADEF&amp;fullscreen=1\" /><embed src=\"http://vimeo.com/moogaloop.swf?clip_id=13205814&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=0&amp;show_portrait=0&amp;color=00ADEF&amp;fullscreen=1\" type=\"application/x-shockwave-flash\" allowfullscreen=\"true\" allowscriptaccess=\"always\" width=\"640\" height=\"360\"></embed></object>', ''),
(216, '<object width=\"640\" height=\"360\"><param name=\"allowfullscreen\" value=\"true\" /><param name=\"allowscriptaccess\" value=\"always\" /><param name=\"movie\" value=\"http://vimeo.com/moogaloop.swf?clip_id=13620943&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=0&amp;show_portrait=0&amp;color=00ADEF&amp;fullscreen=1\" /><embed src=\"http://vimeo.com/moogaloop.swf?clip_id=13620943&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=0&amp;show_portrait=0&amp;color=00ADEF&amp;fullscreen=1\" type=\"application/x-shockwave-flash\" allowfullscreen=\"true\" allowscriptaccess=\"always\" width=\"640\" height=\"360\"></embed></object>', ''),
(218, '<object width=\"640\" height=\"360\"><param name=\"allowfullscreen\" value=\"true\" /><param name=\"allowscriptaccess\" value=\"always\" /><param name=\"movie\" value=\"http://vimeo.com/moogaloop.swf?clip_id=13885038&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=0&amp;show_portrait=0&amp;color=00ADEF&amp;fullscreen=1&amp;autoplay=0&amp;loop=0\" /><embed src=\"http://vimeo.com/moogaloop.swf?clip_id=13885038&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=0&amp;show_portrait=0&amp;color=00ADEF&amp;fullscreen=1&amp;autoplay=0&amp;loop=0\" type=\"application/x-shockwave-flash\" allowfullscreen=\"true\" allowscriptaccess=\"always\" width=\"640\" height=\"360\"></embed></object>', ''),
(227, '<object width=\"640\" height=\"360\"><param name=\"allowfullscreen\" value=\"true\" /><param name=\"allowscriptaccess\" value=\"always\" /><param name=\"movie\" value=\"http://vimeo.com/moogaloop.swf?clip_id=14539343&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=0&amp;show_portrait=0&amp;color=00ADEF&amp;fullscreen=1&amp;autoplay=0&amp;loop=0\" /><embed src=\"http://vimeo.com/moogaloop.swf?clip_id=14539343&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=0&amp;show_portrait=0&amp;color=00ADEF&amp;fullscreen=1&amp;autoplay=0&amp;loop=0\" type=\"application/x-shockwave-flash\" allowfullscreen=\"true\" allowscriptaccess=\"always\" width=\"640\" height=\"360\"></embed></object>', ''),
(229, '<iframe src=\"http://player.vimeo.com/video/14856567?byline=0&amp;portrait=0\" width=\"640\" height=\"360\" frameborder=\"0\"></iframe>', ''),
(230, '<iframe src=\"http://player.vimeo.com/video/14884715?byline=0&amp;portrait=0\" width=\"640\" height=\"360\" frameborder=\"0\"></iframe>', ''),
(234, '<iframe src=\"http://player.vimeo.com/video/15119536?byline=0&amp;portrait=0\" width=\"640\" height=\"360\" frameborder=\"0\"></iframe>', ''),
(235, '<iframe src=\"http://player.vimeo.com/video/15572042?byline=0&amp;portrait=0\" width=\"640\" height=\"360\" frameborder=\"0\"></iframe>', ''),
(241, '<iframe src=\"http://player.vimeo.com/video/16352498?byline=0&amp;portrait=0\" width=\"640\" height=\"360\" frameborder=\"0\"></iframe>', ''),
(245, '<iframe src=\"http://player.vimeo.com/video/16687706?byline=0&amp;portrait=0\" width=\"640\" height=\"360\" frameborder=\"0\"></iframe>', ''),
(247, '<iframe src=\"http://player.vimeo.com/video/17111436?byline=0&amp;portrait=0\" width=\"640\" height=\"360\" frameborder=\"0\"></iframe>', ''),
(254, '<iframe src=\"http://player.vimeo.com/video/18987197?byline=0&amp;portrait=0\" width=\"640\" height=\"360\" frameborder=\"0\"></iframe>', ''),
(258, '<iframe src=\"http://player.vimeo.com/video/19204071?byline=0&amp;portrait=0\" width=\"640\" height=\"360\" frameborder=\"0\"></iframe>', ''),
(260, '<iframe src=\"http://player.vimeo.com/video/19339149?byline=0&amp;portrait=0\" width=\"640\" height=\"360\" frameborder=\"0\"></iframe>', ''),
(262, '<iframe src=\"http://player.vimeo.com/video/19649435?byline=0&amp;portrait=0\" width=\"640\" height=\"360\" frameborder=\"0\"></iframe>', ''),
(263, '<iframe src=\"http://player.vimeo.com/video/19893691?title=0&amp;byline=0&amp;portrait=0\" width=\"640\" height=\"360\" frameborder=\"0\"></iframe>', ''),
(268, '<iframe src=\"http://player.vimeo.com/video/20910313?title=0&amp;byline=0&amp;portrait=0\" width=\"640\" height=\"360\" frameborder=\"0\"></iframe>', ''),
(280, '<iframe src=\"http://player.vimeo.com/video/24374624?title=0&amp;byline=0&amp;portrait=0\" width=\"640\" height=\"360\" frameborder=\"0\"></iframe>', ''),
(281, '<iframe src=\"http://player.vimeo.com/video/24698771?title=0&amp;byline=0&amp;portrait=0\" width=\"640\" height=\"360\" frameborder=\"0\"></iframe>', ''),
(294, '<iframe src=\"http://player.vimeo.com/video/29026220?title=0&amp;byline=0&amp;portrait=0\" width=\"640\" height=\"360\" frameborder=\"0\" webkitAllowFullScreen allowFullScreen></iframe>', ''),
(295, '<iframe src=\"http://player.vimeo.com/video/29133761?title=0&amp;byline=0&amp;portrait=0\" width=\"640\" height=\"360\" frameborder=\"0\" webkitAllowFullScreen allowFullScreen></iframe>', '');

-- --------------------------------------------------------

--
-- Table structure for table `mensajes`
--

CREATE TABLE `mensajes` (
  `id_mensaje` int(11) UNSIGNED NOT NULL,
  `id_serie` int(10) UNSIGNED NOT NULL,
  `mensaje` varchar(64) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `resumen` longtext CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `id_expositor` int(11) NOT NULL DEFAULT '1',
  `fecha` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mensajes`
--

INSERT INTO `mensajes` (`id_mensaje`, `id_serie`, `mensaje`, `resumen`, `id_expositor`, `fecha`) VALUES
(1, 1, 'Más Grande que mis Decepciones', '', 1, NULL),
(2, 1, 'Más Grande que mis Heridas', '', 1, NULL),
(3, 2, 'Cómo Tratarla a Ella', '', 1, NULL),
(4, 2, 'Cómo Tratarlo a él', '', 1, NULL),
(5, 2, 'Como Tratarlos a Ellos', '', 1, NULL),
(6, 3, 'Cómo Super la Depresión', '', 1, NULL),
(7, 3, 'Cómo Manejar el Estrés', '', 1, NULL),
(8, 3, 'Cómo Manejar la Envidia', '', 1, NULL),
(9, 3, 'Cómo Controlar el Enojo', '', 1, NULL),
(10, 4, '¿Cómo Perdonar Al Que Me Ha Ofendido?', '', 1, NULL),
(11, 4, '¿Cómo Corregir Un Gran Error?', '', 1, NULL),
(12, 4, '¿Cómo Soportar a Una Persona Difícil', '', 1, NULL),
(13, 5, '¿Que pasa con nuestros familiares que se mueren?', '', 1, NULL),
(14, 6, 'Como Aprovechar Mi Presupuesto Navideño', '', 1, NULL),
(15, 6, 'Que Puedo Hacer Para Mejorar la Unidad Familiar', '', 1, NULL),
(16, 6, '¿Puedo Reconciliarme con Otros?', '', 1, NULL),
(17, 6, '¿Cual es el Significado de la Navidad?', '', 1, NULL),
(18, 6, '¿Cómo Podemos Despedir al Viejo 2006?', '', 1, NULL),
(19, 7, 'Decisiones en tus Hábitos', '', 1, NULL),
(20, 7, 'Decisiones en tus Finanzas', '', 1, NULL),
(21, 7, 'Decisiones en tu Familia', '', 1, NULL),
(22, 7, 'Decisiones en tu Tiempo', '', 1, NULL),
(23, 8, 'El Amor es una Decision', '', 1, NULL),
(24, 8, 'El Enemigo del Amor', '', 1, NULL),
(25, 8, 'Amor a Prueba', '', 1, NULL),
(26, 9, 'Abraham', '', 1, NULL),
(27, 9, 'Jose', '', 1, NULL),
(28, 9, 'Nehemías', '', 1, NULL),
(29, 9, 'Jesús', '', 1, NULL),
(30, 9, 'Carlos Garza', '', 1, NULL),
(31, 9, 'Claudia Garza', '', 1, NULL),
(32, 10, 'Estrés en Nuestro Día a Día', '', 1, NULL),
(33, 10, 'Estrés en Nuestro Trabajos', '', 1, '2007-05-13'),
(34, 10, 'Estrés en la Familia', '', 1, '2007-05-20'),
(35, 10, 'Estrés en Nuestras Finanzas', '', 1, '2007-05-27'),
(36, 11, 'Evolución y Creación, ¿Cuentos de Hadas?', '', 1, '2007-06-03'),
(37, 11, 'La Biblia, ¿Un Libro Más?', '', 1, '2007-06-10'),
(38, 11, 'Si Dios es Bueno, ¿Por Qué Permite el Sufrimiento?', '', 1, '2007-06-17'),
(39, 11, '¿Quien es Jesús?', '', 1, '2007-06-24'),
(40, 12, 'Poder a través de la Biblia', '', 1, '2007-09-02'),
(41, 12, 'Poder a través de la Oración', '', 1, '2007-09-09'),
(42, 12, 'Poder a través de la Humildad', '', 1, '2007-09-16'),
(43, 12, 'Poder a través del Amor', '', 1, NULL),
(44, 13, '¿Qué es lo único que no podrás hacer en el cielo?', '', 1, '2007-10-07'),
(45, 13, '¿Qué piensa Dios de la magia?', '', 1, '2007-10-14'),
(46, 13, '¿Qué tan bueno debo ser para salvarme?', '', 1, '2007-10-21'),
(47, 13, '¿Podemos hablar con los muertos?', '', 1, NULL),
(48, 14, '¿Confiado o Estresado?', '', 1, '2007-11-04'),
(49, 14, '¿Amoroso o Egoísta?', '', 1, '2007-11-11'),
(50, 14, '¿Adorador o Fariseo?', '', 1, '2007-11-18'),
(51, 14, '¿Agradecido o Quejumbroso?', '', 1, '2007-11-25'),
(52, 15, 'Verde: Esperanza', '', 1, '2007-12-02'),
(53, 15, 'Dorado: Para Hacerte Pensar en Grande', '', 1, '2007-12-09'),
(54, 15, 'Blanco: Verdadera Paz en Navidad', '', 1, '2007-12-23'),
(55, 15, 'Tema Especial: En Sus Marcas', '', 1, '2007-12-30'),
(56, 16, 'Un Nuevo Comienzo Espiritual', '', 1, '2008-01-06'),
(57, 16, 'Una Nueva Visión', '', 1, '2008-01-13'),
(58, 16, 'Relaciones Interpersonales', '', 1, '2008-01-20'),
(59, 16, 'Metas Para el 2015', '', 1, '2008-01-27'),
(60, 17, 'Amor Incomparable', '', 1, '2008-02-03'),
(61, 17, 'Amor Increíble', '', 1, '2008-02-10'),
(62, 17, 'Amor Inconmovible', '', 1, '2008-02-17'),
(63, 17, 'Amor Imparable', '', 1, '2008-02-24'),
(64, 18, 'Su Fama', '', 1, '2008-03-02'),
(65, 18, 'Jesús, Su Resurrección', '', 1, '2008-03-30'),
(66, 18, 'Su Poder', '', 1, '2008-03-09'),
(67, 18, 'Su Muerte', '', 1, '2008-03-16'),
(68, 19, 'Pareciéndome a Jesús', '', 1, '2008-04-06'),
(69, 19, 'Aprende a Disfrutar la Vida', '', 1, '2008-04-13'),
(70, 19, 'Temperamento Colérico', '', 1, '2008-04-20'),
(71, 19, 'Temperamento Sanguíneo', '', 1, '2008-04-27'),
(72, 19, 'El Genio Depresivo', '', 1, '2008-05-04'),
(73, 19, 'El Paciente Conformista', '', 1, '2008-05-11'),
(74, 19, 'Test de Temperamentos', '', 1, '2008-05-18'),
(75, 19, 'Tus Sueños', '', 1, '2008-05-25'),
(76, 20, 'Señales Antes del Fin de los Tiempos', '', 1, '2008-06-01'),
(77, 20, 'Desaparecidos', '', 1, '2008-06-08'),
(78, 20, 'El Anticristo', '', 1, '2008-06-15'),
(79, 20, 'Armagedón', '', 1, '2008-06-22'),
(80, 20, 'El Sistema Perfecto', '', 1, '2008-06-29'),
(81, 21, 'Más Allá de Nuestros Límites', '', 1, '2008-07-06'),
(82, 21, 'La Empresa Más Desafiante', '', 1, '2008-07-13'),
(83, 21, 'Logrando lo imposible', '', 1, '2008-07-20'),
(84, 21, 'La Excelencia', '', 1, '2008-07-27'),
(85, 22, 'El Beneficio de Leer la Biblia', '', 1, '2008-08-03'),
(86, 22, 'El Beneficio de Orar', '', 1, '2008-08-08'),
(87, 22, 'El Beneficio de Servir', '', 1, '2008-08-17'),
(88, 22, 'El Beneficio de Reunirse', '', 1, '2008-08-24'),
(89, 22, 'El Beneficio de Dar', '', 1, '2008-08-31'),
(90, 23, 'Estoy Deprimido', '', 1, '2008-09-14'),
(91, 23, 'Ya No Te Soporto', '', 1, '2008-09-07'),
(92, 23, 'Estoy Preocupado', '', 1, '2008-09-21'),
(93, 23, 'Conflicto Familiar', '', 1, '2008-09-28'),
(94, 24, '¿Quién Eres?', '', 1, '2008-10-12'),
(95, 24, 'Cómo Se Forma Un Pirata', '', 1, '2008-10-19'),
(96, 24, 'Cómo Ser Original', '', 1, '2008-10-26'),
(97, 24, 'Autoestima Sólida', '', 1, '2008-11-02'),
(98, 25, 'Chisme Dañino', '', 1, '2008-11-09'),
(99, 25, 'Lujuria Ruín', '', 1, '2008-11-16'),
(100, 25, 'Orgullo Tramposo', '', 1, '2008-11-23'),
(101, 25, 'Insensatez Perjudicial', '', 1, '2008-11-30'),
(102, 26, 'Navidad en Apuros', '', 1, '2008-12-07'),
(103, 26, 'Santa Claus', '', 1, '2008-12-14'),
(104, 26, 'Las Posadas', '', 1, '2008-12-21'),
(105, 26, 'Año Viejo, Año Nuevo', '', 1, '2008-12-28'),
(106, 27, 'Como Superar la Crisis', '', 1, '2009-01-04'),
(107, 27, 'Los Buenos de la Película', '', 1, '2009-01-11'),
(108, 27, 'Listos para el Triunfo', '', 1, '2009-01-18'),
(109, 27, 'Los Malos de la Película', '', 1, '2009-01-25'),
(110, 27, 'Logrando el Triunfo', '', 1, '2009-02-01'),
(111, 28, 'El Comienzo del Cambio', '', 1, '2009-02-08'),
(112, 28, 'Cambio en Tus Hábitos', '', 1, '2009-02-15'),
(113, 28, 'Cambio entre Cónyuges', '', 1, '2009-02-22'),
(114, 28, 'Cambio entre Padres e Hijos', '', 1, '2009-03-01'),
(115, 29, 'Pornografía: ¿Industria de Entretenimiento para Adultos?', '', 1, '2009-03-08'),
(116, 29, 'Homosexualismo: ¿Diversidad Sexual?', '', 1, '2009-03-15'),
(117, 29, 'Materialismo: ¿Bienestar Económico?', '', 1, '2009-03-20'),
(118, 29, 'Irrespeto a los Demás', '', 1, '2009-03-29'),
(119, 30, 'Vida', '', 1, '2009-04-05'),
(120, 30, 'Dinero', '', 1, '2009-04-19'),
(121, 30, 'Esperanza', '', 1, '2009-04-26'),
(122, 31, 'Como Lidiar Con Olas Grandes', '', 1, '2009-05-10'),
(123, 31, 'Con El Viento en Contra', '', 1, '2009-05-17'),
(124, 31, 'Enfrentando el Naufragio', '', 1, '2009-05-24'),
(125, 31, 'La Salida Ante Las Preubas', '', 1, '2009-05-31'),
(126, 32, 'Paz con Dios', '', 1, '2009-06-07'),
(127, 32, 'Paz con los Hombres', '', 1, '2009-06-21'),
(128, 32, 'Paz en la Tierra', '', 1, '2009-06-28'),
(129, 33, 'Camino a la Grandeza', '', 1, '2009-07-05'),
(130, 33, 'El Ejemplo de Un Grande', '', 1, '2009-07-12'),
(131, 33, 'Cada Miembro un Ministro', '', 1, '2009-07-19'),
(132, 33, 'El Desconocido que Cambió al Mundo', '', 1, '2009-07-26'),
(133, 34, 'Dios con el Extranjero', 'Dios rescató a un Etíope que visistaba Jerusalén y no entendía las profecías del Mesías', 1, '2009-08-02'),
(134, 34, 'Dios con el Carcelero', 'Dios se encuentra con el carcelero de una prisión Romana', 1, '2009-08-09'),
(135, 34, 'Dios con Maria Magdalena', 'Dios se encuentra con una mujer adúltera y la perdona', 1, '2009-08-16'),
(136, 34, 'Dios con Pablo', 'Dios rescato a un asesino y perseguidor de la iglesia y lo convirtió en su instrumento util.', 1, '2009-08-23'),
(137, 34, 'Dios con Nosotros', '', 1, '2009-08-30'),
(138, 35, 'Yo hare que todo te ayude para bien', '', 1, '2009-09-06'),
(139, 35, 'Yo Hare de Ti una Obra Maestra', '', 1, '2009-09-14'),
(140, 35, 'Yo te dare Gracia atraves de la Fe', '', 1, '2009-09-20'),
(141, 36, 'Una Familia Diferente', '', 1, '2009-10-04'),
(142, 37, 'JC Invencible', '', 1, '2009-09-26'),
(143, 37, 'JC Irresistible', '', 1, '2009-09-27'),
(144, 37, 'JC Insuperable', '', 1, '2009-09-27'),
(145, 37, 'JC Infinito', '', 1, '2009-09-27'),
(146, 36, 'Receta para una Paternidad Exitosa', '', 1, '2009-10-11'),
(147, 36, 'Lidiando con una Familia Imperfecta', '', 2, '2009-10-18'),
(148, 36, 'Lidiando con una Familia Imperfecta II', '', 2, '2009-10-25'),
(149, 38, 'El Orgullo', '', 1, '2009-11-01'),
(150, 38, 'El Mentiroso', '', 1, '2009-11-08'),
(151, 38, 'El Violento', '', 1, '2009-11-15'),
(152, 38, 'El Malvado', '', 1, '2009-11-22'),
(153, 38, 'El Chismoso', '', 2, '2009-11-29'),
(154, 39, 'Un Regalo', '', 1, '2009-12-06'),
(155, 40, 'Definiendo la Meta Espiritual', '', 1, '2010-01-10'),
(156, 40, 'Definindo Metas Personales y Familiares', '', 1, '2010-01-17'),
(157, 40, 'Definiendo Metas Economicas', '', 1, '2010-01-24'),
(158, 41, 'Amor Incondicional', '', 2, '2010-02-21'),
(159, 40, 'Como Cumplir Nuestras Metas', '', 1, '2010-01-31'),
(160, 41, 'Amor Sacrificado', '', 1, '2010-02-28'),
(161, 42, 'Compartiendo a Cristo Parte 1.1', '', 1, '2010-01-29'),
(162, 42, 'Compartiendo a Cristo Parte 1.2', '', 1, '2010-01-29'),
(163, 43, 'El Encuentro con mi Mejor Amigo', '', 1, '2010-03-07'),
(164, 43, 'Su Vida', '', 1, '2010-03-14'),
(165, 43, 'Su Vida', '', 1, '2010-03-14'),
(166, 43, 'El Encuentro, Sus Seguidores', '', 1, '2010-03-21'),
(167, 43, 'El Encuentro, Su Muerte', '', 1, '2010-03-28'),
(168, 43, 'En pos de la Vision', '', 1, '2010-04-11'),
(169, 44, 'Sin Miedo a la Inseguridad', '', 1, '2010-04-18'),
(170, 44, 'Sin Miedo a la Crisis', '', 1, '2010-04-25'),
(171, 45, 'Asi Funciona la Fe', '', 1, '2010-05-02'),
(172, 0, 'No se adonde Ir', '', 1, '2010-05-09'),
(173, 45, 'No se Adonde Ir', '', 1, '2010-05-10'),
(174, 45, 'No Tengo Un Futuro Prometedor', '', 1, '2010-05-16'),
(175, 45, 'Deseo Comenzar de Nuevo', '', 2, '2010-05-23'),
(176, 45, 'El Milagro debe de ser Hoy', '', 1, '2010-05-30'),
(177, 46, 'Del Caos a la Madurez', '', 1, '2010-06-06'),
(178, 46, 'Controlando el Enojo', '', 2, '2010-06-13'),
(179, 46, 'El Secreto para un Matrimonio Feliz', '', 1, '2010-06-20'),
(180, 46, 'Amor o Carne  Asada', '', 1, '2010-06-27'),
(181, 47, 'Que Haria Jesús Con su Corazón', '', 1, '2010-07-04'),
(182, 47, 'Que Haria Jesús con el Estrés', '', 1, '2010-07-11'),
(183, 47, 'Para Ayudar a Otros', '', 2, '2010-07-18'),
(184, 47, 'Con La Misión Encomendada', '', 2, '2010-07-25'),
(185, 48, 'Puedes Dar', '', 1, '2010-08-01'),
(186, 48, 'Puedes Servirles', '', 2, '2010-08-08'),
(193, 48, 'Puedes Amarlos', '', 1, '2010-08-22'),
(194, 48, 'Puedes Crecer', '', 1, '2010-08-15'),
(195, 49, 'Triunfar Sobre Mi Crisis', '', 1, '2010-08-29'),
(196, 49, 'Triunfar con mi Familia', '', 1, '2010-09-19'),
(197, 49, 'Triunfar con mi Matrimonio', '', 2, '2010-09-12'),
(198, 49, 'Triunfar sobre las Finanzas', '', 1, '2010-09-19'),
(203, 50, 'Rut: Influenciando Generaciones', '', 1, '2010-10-31'),
(205, 50, 'Jose: En medio de la amargura', '', 1, '2010-10-03'),
(206, 50, 'David: En Medio del Dolor', '', 1, '2010-10-17'),
(207, 50, 'Nehemias: Aguas Turbulentas', '', 1, '2010-10-10'),
(208, 50, 'Abraham: Contra Toda Esperanza', '', 3, '2010-10-24'),
(210, 51, 'Yo Quiero Tener Unidad', '', 2, '2010-11-07'),
(211, 51, 'Yo Quiero Ser Humilde', '', 1, '2010-11-14'),
(212, 51, 'Yo Quiero Tener Buen Caracter', '', 1, '2010-11-21'),
(213, 51, 'Yo Quiero Honrarte', '', 1, '2010-11-28'),
(214, 52, 'Navidad en Paz: Que Hacer', '', 1, '2010-12-05'),
(216, 52, 'Navidad en Paz: Como Hacerlo', '', 1, '2010-12-12'),
(217, 53, 'Un Futuro Inspirador', '', 1, '2011-01-02'),
(218, 53, 'Cómo Lograr Mis Sueños', '', 1, '2011-01-09'),
(219, 53, 'Haciendo Realidad mi Sueño', '', 1, '2011-01-16'),
(221, 53, 'Como Desarrollar Hábitos Saludables', '', 1, '2011-01-23'),
(222, 53, 'Los Hábitos del Éxito', '', 2, '2011-01-31'),
(223, 54, '¿Rechazada o Amada?', 'Rechazada por los hombres, amada por Dios', 1, '2011-02-06'),
(224, 54, 'Un Viaje a Través de la Música', '', 1, '2011-02-13'),
(225, 54, 'Un Pacto Demencial', '', 1, '2011-02-20'),
(226, 54, 'El Uno Para el Otro', '', 2, '2011-02-27'),
(227, 55, 'Sin Condena', '', 1, '2011-03-06'),
(228, 55, 'Adoptados, no esclavos', '', 1, '2011-03-13'),
(229, 55, 'Un Presente Perfecto', '', 1, '2011-03-20'),
(230, 55, 'Más que Vencedores', '', 5, '2011-03-27'),
(231, 56, 'La Vida es una Carga', '', 1, '2011-04-03'),
(232, 56, 'Tengo Envidia de la Buena', '', 2, '2011-04-10'),
(233, 56, 'Nunca lo Voy a Lograr', '', 1, '2011-04-17'),
(234, 57, '¿Es tu camino el correcto?', '', 1, '2011-05-01'),
(235, 57, 'El destino del seguidor', '', 1, '2011-05-08'),
(236, 57, 'Una vision, un destino', '', 1, '2011-05-15'),
(237, 57, 'El destino en la familia', '', 2, '2011-05-22'),
(238, 58, '¿Qué tal si....?', '', 1, '2011-06-05'),
(239, 58, 'Aprender haciendo', '', 1, '2011-06-12'),
(240, 58, 'Armas divinas', '', 2, '2011-06-19'),
(241, 58, 'Venciendo el miedo', '', 1, '2011-06-26'),
(242, 57, 'El destino de Gran Comision', '', 1, '2011-05-31'),
(243, 59, 'Su Fidelidad', '', 2, '2011-07-03'),
(244, 59, 'Su Gracia', '', 3, '2011-07-10'),
(245, 59, 'Su Misericordia', '', 1, '2011-07-17'),
(246, 59, 'Su Poder', '', 1, '2011-07-24'),
(247, 59, 'Su Amor', '', 1, '2011-07-31'),
(248, 60, 'El Valor de una Vida', '', 1, '2011-08-07'),
(249, 60, 'Conectándome con una Vida', '', 1, '2011-08-14'),
(250, 60, 'Salvando una Vida', '', 2, '2011-08-21'),
(251, 60, 'La Tarea Más Maravillosa', '', 1, '2011-08-28'),
(252, 61, 'Primer Click', '<h1>CLICK 1</h1>\r\n<h2>&iexcl;Y mejora tu vida!</h2>\r\n<h3>Romanos 3:23</h3>\r\n<p>&ldquo;por cuanto todos pecaron, y est&aacute;n destituidos de la gloria de Dios,&rdquo;</p>\r\n<p>Todos cometemos errores, conscientes o inconscientes; intencionales o no.</p>\r\n<h3>Romanos 6:23</h3>\r\n<p>&ldquo;Porque la paga del pecado es muerte, mas la d&aacute;diva de Dios es vida eterna en Cristo Jes&uacute;s Se&ntilde;or nuestro.&rdquo;</p>\r\n<p>Jam&aacute;s podr&iacute;amos pagar el precio.</p>\r\n<h3>Juan 3:16</h3>\r\n<p>&ldquo;Porque de tal manera am&oacute; Dios al mundo, que ha dado a su Hijo unig&eacute;nito, para que todo aquel que en &eacute;l cree, no se pierda, mas tenga vida eterna&rdquo;</p>\r\n<h3>Tito 3:5</h3>\r\n<p>&ldquo;Nos salv&oacute;, no por obras de justicia que nosotros hubi&eacute;ramos hecho, sino por su misericordia. . .&rdquo;</p>\r\n<h3>Efesios 2:8-9</h3>\r\n<p>&ldquo;Porque por gracia sois salvos por medio de la fe; y esto no de vosotros, pues es don de Dios; no por obras, para que nadie se glor&iacute;e.&rdquo;</p>\r\n<p>Las buenas obras son importantes, pero no para salvaci&oacute;n.</p>\r\n<h3>Romanos 3:28</h3>\r\n<p>&ldquo;CONCLUIMOS, pues, que el hombre es JUSTIFICADO POR FE sin las obras de la ley&rdquo;</p>\r\n<h3>Juan 6:47</h3>\r\n<p>&ldquo;De cierto, de cierto os digo: el que cree en m&iacute;, tiene vida eterna.&rdquo;</p>\r\n<p>Si crees hoy en Jes&uacute;s, puedes estar completamente seguro de ir al cielo el d&iacute;a que mueras.&rdquo;</p>\r\n<h3>1 Juan 5:13</h3>\r\n<p>&ldquo;Estas cosas os he escrito a vosotros que cre&eacute;is en el nombre del Hijo de Dios, para que sep&aacute;is que ten&eacute;is vida eterna, y para que cre&aacute;is en el nombre del Hijo de Dios.&rdquo;</p>', 1, '2011-09-04'),
(253, 61, 'Segundo Click', '<h1>SEGUNDO CLICK</h1>\r\n<h2>&iquest;Como tener paz y esperanza en un mundo violento?</h2>\r\n<p>&iquest;Como?</p>\r\n<h3>Filipenses 4:6-7</h3>\r\n<p>Por nada est&eacute;is afanosos, sino sean conocidas vuestras peticiones delante&nbsp;de Dios en toda oraci&oacute;n y ruego, con acci&oacute;n de gracias. Y la paz de Dios,&nbsp;que sobrepasa todo entendimiento, guardar&aacute; vuestros corazones y vuestros&nbsp;pensamientos en Cristo Jes&uacute;s.</p>\r\n<p>1-&nbsp;<span style=\"text-decoration: underline;\">Dando a conocer</span>&nbsp;tus peticiones a Dios. Esto es&nbsp;<span style=\"text-decoration: underline;\">orar</span>.</p>\r\n<p>Viene la&nbsp;<span style=\"text-decoration: underline;\">preocupaci&oacute;n</span>&nbsp;y te apartas a&nbsp;<span style=\"text-decoration: underline;\">conversar</span>&nbsp;con Dios.</p>\r\n<p>2- Buscando una&nbsp;<span style=\"text-decoration: underline;\">promesa</span>&nbsp;en la Biblia relacionada con tu&nbsp;<span style=\"text-decoration: underline;\">petici&oacute;n</span>.</p>\r\n<h3>Hebreos 10:24-25</h3>\r\n<p>Tratemos de ayudarnos unos a otros, y de amarnos y hacer lo bueno. No&nbsp;dejemos de reunirnos, como hacen algunos. Al contrario, anim&eacute;monos cada vez&nbsp;m&aacute;s a seguir confiando en Dios, y m&aacute;s a&uacute;n cuando ya vemos que se acerca el d&iacute;a&nbsp;en que el Se&ntilde;or juzgar&aacute; a todo el mundo.</p>\r\n<p>3-&nbsp;<span style=\"text-decoration: underline;\">Sirviendo</span>&nbsp;a otros</p>\r\n<p>4-&nbsp;<span style=\"text-decoration: underline;\">Asistiendo</span>&nbsp;a las&nbsp;<span style=\"text-decoration: underline;\">reuniones</span>&nbsp;de iglesia</p>\r\n<p>Si no tienes paz y esperanza, considera no continuar&nbsp;<span style=\"text-decoration: underline;\">haciendo lo mismo</span>.</p>\r\n<p><strong><span style=\"font-size: medium;\">&iexcl;Prueba el&nbsp;<span style=\"text-decoration: underline;\">cambio</span>!</span></strong></p>', 1, '2011-09-11'),
(254, 61, 'Tercer Click', '<div><strong><span style=\"font-size: medium;\">Tercer CLICK</span></strong></div>\r\n<div><strong><span style=\"font-size: medium;\">&iquest;Son mis amigos buenos amigos?</span></strong></div>\r\n<div>&nbsp;</div>\r\n<div>La iglesia tiene grupos de crecimiento donde puedes encontrar buenos amigos.</div>\r\n<div>&nbsp;</div>\r\n<div><strong>&iquest;Qu&eacute; es un grupo de crecimiento?</strong></div>\r\n<div>Es un grupo de amigos que se re&uacute;nen para aprender y compartir los principios b&iacute;blicos, de</div>\r\n<div>una manera pr&aacute;ctica y din&aacute;mica.</div>\r\n<div>&nbsp;</div>\r\n<div><strong><span style=\"text-decoration: underline;\">Salmo 133:1 (RV-95)</span></strong></div>\r\n<div>&iexcl;Mirad cu&aacute;n bueno y cu&aacute;n delicioso es que habiten los hermanos juntos en armon&iacute;a!</div>\r\n<div>&nbsp;</div>\r\n<div>&iquest;Cu&aacute;l es el prop&oacute;sito de un grupo de crecimiento?</div>\r\n<div>Formar personas para que sean seguidores de Jesucristo y que vivan para hacer la gran&nbsp;comisi&oacute;n.</div>\r\n<div>&nbsp;</div>\r\n<div><strong><span style=\"text-decoration: underline;\">Mateo 28:19</span></strong></div>\r\n<div>Por tanto, id y haced disc&iacute;pulos a todas las naciones, bautiz&aacute;ndolos en el nombre del&nbsp;Padre, del Hijo y del Esp&iacute;ritu Santo.</div>\r\n<div>&nbsp;</div>\r\n<div><img title=\"espiral-forum.jpg\" src=\"https://mail.google.com/mail/?ui=2&amp;ik=ba92beee8b&amp;view=att&amp;th=132793e1a7207ffe&amp;attid=0.0.1&amp;disp=emb&amp;realattid=ii_1327936875dfcef6&amp;zw\" alt=\"espiral-forum.jpg\" /></div>\r\n<div>&nbsp;</div>\r\n<div><strong>&iquest;Por qu&eacute; es importante un grupo de crecimiento?</strong></div>\r\n<div>&nbsp;</div>\r\n<div>1. Porque es la mejor manera de cuidar y guiar de una forma especial a cada&nbsp;miembro del grupo y al nuevo creyente.</div>\r\n<div>2. Porque aprendemos de otros a tener buenos h&aacute;bitos para nuestro crecimiento.</div>\r\n<div>&nbsp;</div>\r\n<div><strong><span style=\"text-decoration: underline;\">Lucas 11:1 (NTV)</span></strong></div>\r\n<div>Una vez, Jes&uacute;s estaba orando en cierto lugar. Cuando termin&oacute;, uno de sus disc&iacute;pulos se le&nbsp;acerc&oacute; y le dijo: &mdash;Se&ntilde;or, ens&eacute;&ntilde;anos a orar, as&iacute; como Juan les ense&ntilde;&oacute; a sus disc&iacute;pulos.</div>\r\n<div>&nbsp;</div>\r\n<div>Orar:&nbsp;<span style=\"text-decoration: underline;\">Platicar con Dios</span></div>\r\n<div>&nbsp;</div>\r\n<div><strong><span style=\"text-decoration: underline;\">1 Timoteo 4:11-13 (NTV)</span></strong></div>\r\n<div>Ense&ntilde;a esas cosas e insiste en que todos las aprendan. No permitas que nadie te&nbsp;subestime por ser joven. S&eacute; un ejemplo para todos los creyentes&nbsp;<span style=\"text-decoration: underline;\">en lo que dices</span>, en la&nbsp;forma en&nbsp;<span style=\"text-decoration: underline;\">que vives</span>, en tu&nbsp;<span style=\"text-decoration: underline;\">amor</span>, tu&nbsp;<span style=\"text-decoration: underline;\">fe</span>&nbsp;y tu&nbsp;<span style=\"text-decoration: underline;\">pureza</span>. Hasta que yo llegue, ded&iacute;cate a leer las&nbsp;Escrituras a la iglesia, y a animar y a ense&ntilde;arles a los creyentes.</div>\r\n<div>&nbsp;</div>\r\n<div>Lectura de la Palabra y de&nbsp;<span style=\"text-decoration: underline;\">Buen Testimonio</span></div>\r\n<div>&nbsp;</div>\r\n<div><strong><span style=\"text-decoration: underline;\">Hebreos 10:25 (NTV)</span></strong></div>\r\n<div>Y no dejemos de congregarnos, como lo hacen algunos, sino anim&eacute;monos unos a otros,&nbsp;sobre todo ahora que el d&iacute;a de su regreso se acerca.</div>\r\n<div>&nbsp;</div>\r\n<div>Reunirnos en la&nbsp;<span style=\"text-decoration: underline;\">iglesia</span>&nbsp;y en los grupos de&nbsp;<span style=\"text-decoration: underline;\">crecimiento</span></div>\r\n<div><span style=\"text-decoration: underline;\"><br /></span></div>', 2, '2011-09-18'),
(255, 62, 'Un Matrimonio Estable', '<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><span style=\"text-decoration: underline;\"><strong><span style=\"font-size: 24.0pt; font-family: Arial; mso-ansi-language: ES;\">Mis Retos</span></strong></span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 24.0pt; font-family: Arial; mso-ansi-language: ES;\">Un matrimonio estable</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-family: Arial; mso-ansi-language: ES;\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-family: Arial; mso-ansi-language: ES;\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 14.0pt; font-family: Arial; mso-ansi-language: ES;\">Efesios 5:31-33</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 14.0pt; font-family: Arial; mso-ansi-language: ES;\">Dice la Biblia:</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 14.0pt; font-family: Arial; mso-ansi-language: ES;\">&laquo;Por eso el hombre deja a su padre y a su madre, y se une a su mujer, para formar un solo cuerpo.&raquo;</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 14.0pt; font-family: Arial; mso-ansi-language: ES;\"><span style=\"font-size: 14.0pt; font-family: Arial; mso-ansi-language: ES;\"><br /></span></span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 14.0pt; font-family: Arial; mso-ansi-language: ES;\">&Eacute;sa es una verdad muy grande, y yo la uso para hablar de Cristo y de la iglesia.</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 14.0pt; font-family: Arial; mso-ansi-language: ES;\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 14.0pt; font-family: Arial; mso-ansi-language: ES;\">En todo caso, el esposo debe amar a su esposa, como si se tratara de s&iacute; mismo, y la esposa debe respetar a su esposo</span><span style=\"font-family: Arial; mso-ansi-language: ES;\">.</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-family: Arial; mso-ansi-language: ES;\"><br /></span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-family: Arial; mso-ansi-language: ES;\"><br /></span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-family: Arial; mso-ansi-language: ES;\"><br /></span></p>\r\n<p class=\"MsoNormal\"><span style=\"font-family: Arial; mso-ansi-language: ES;\"><img style=\"vertical-align: bottom; display: block; margin-left: auto; margin-right: auto;\" src=\"http://upload.wikimedia.org/wikipedia/commons/thumb/7/7f/Green_equilateral_triangle_point_up.svg/600px-Green_equilateral_triangle_point_up.svg.png\" alt=\"\" width=\"150\" height=\"130\" /></span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\">&nbsp;</p>', 1, '2011-10-02'),
(256, 62, 'Un Futuro Alentador', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 18.0pt; font-family: Arial;\" lang=\"ES-MX\">UN FUTURO ESPERANZADOR</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\"><span style=\"font-family: Arial;\" lang=\"ES-MX\">&nbsp;</span><span style=\"font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-family: Arial;\" lang=\"ES-MX\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-family: Arial;\" lang=\"ES-MX\">Esperamos un <span style=\"text-decoration: underline;\">castigo</span></span></strong></p>\r\n<p class=\"MsoNormal\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-family: Arial;\" lang=\"ES-MX\">Salmos 103:8-17</span></span></strong></p>\r\n<p class=\"MsoNormal\"><strong></strong><span style=\"font-family: Arial;\" lang=\"ES-MX\">Misericordioso y clemente es Jehov&aacute;; Lento para la ira, y grande en misericordia. No contender&aacute; para siempre, Ni para siempre guardar&aacute; el enojo. No ha hecho con nosotros conforme a nuestras iniquidades, Ni nos ha pagado conforme a nuestros pecados. Porque como la altura de los cielos sobre la tierra, Engrandeci&oacute; su misericordia sobre los que le temen. Cuanto est&aacute; lejos el oriente del occidente, Hizo alejar de nosotros nuestras rebeliones.</span></p>\r\n<p class=\"MsoNormal\"><span style=\"font-family: Arial;\" lang=\"ES-MX\">&nbsp;</span><span style=\"font-family: Arial;\" lang=\"ES-MX\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-family: Arial;\" lang=\"ES-MX\">Dios nos paga <span style=\"text-decoration: underline;\">con bien</span>.</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-family: Arial;\" lang=\"ES-MX\">&nbsp;</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-family: Arial;\" lang=\"ES-MX\">Nos sentimos <span style=\"text-decoration: underline;\">culpables</span></span></strong></p>\r\n<p class=\"MsoNormal\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-family: Arial;\" lang=\"ES-MX\">Colosenses 2:13-16</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-family: Arial;\" lang=\"ES-MX\">Y a vosotros, estando muertos en pecados y en la incircuncisi&oacute;n de vuestra carne, os dio vida juntamente con &eacute;l, perdon&aacute;ndoos todos los pecados, anulando el acta de los decretos que hab&iacute;a contra nosotros, que nos era contraria, quit&aacute;ndola de en medio y clav&aacute;ndola en la cruz, y despojando a los principados y a las potestades, los exhibi&oacute; p&uacute;blicamente, triunfando sobre ellos en la cruz. Por tanto, nadie os juzgue en comida o en bebida, o en cuanto a d&iacute;as de fiesta, luna nueva o d&iacute;as de reposo.</span></p>\r\n<p class=\"MsoNormal\"><span style=\"font-family: Arial;\" lang=\"ES-MX\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-family: Arial;\" lang=\"ES-MX\">En la cruz se termin&oacute; la <span style=\"text-decoration: underline;\">culpa</span>.</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-family: Arial;\" lang=\"ES-MX\">&nbsp;</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-family: Arial;\" lang=\"ES-MX\">Dejamos de <span style=\"text-decoration: underline;\">so&ntilde;ar</span> en <span style=\"text-decoration: underline;\">grande</span></span></strong></p>\r\n<p class=\"MsoNormal\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-family: Arial;\" lang=\"ES-MX\">2 Corintios 5:17</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-family: Arial;\" lang=\"ES-MX\">De modo que si alguno est&aacute; en Cristo, nueva criatura es; las cosas viejas pasaron; he aqu&iacute; todas son hechas nuevas.</span></p>\r\n<p class=\"MsoNormal\"><span style=\"font-family: Arial;\" lang=\"ES-MX\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-family: Arial;\" lang=\"ES-MX\">Lo m&aacute;s incre&iacute;ble de nuestra vida <span style=\"text-decoration: underline;\">viene en camino</span>.</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-family: Arial;\" lang=\"ES-MX\">&nbsp;</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-family: Arial;\" lang=\"ES-MX\">El libro de la historia de nuestra vida <span style=\"text-decoration: underline;\">no se ha concluido</span></span></strong></p>', 1, '2011-10-09'),
(257, 62, 'Una Buena Relación Con Mi Hijo', '<h2><span style=\"text-decoration: underline;\"><strong>Una buena relaci&oacute;n con mi hijo.</strong></span></h2>\r\n<p><span style=\"text-decoration: underline;\"><strong>Efesios 6:4</strong></span></p>\r\n<p>Y ustedes, padres, no hagan enojar a sus hijos,</p>\r\n<p>sino m&aacute;s bien ed&uacute;quenlos con la disciplina y la</p>\r\n<p>instrucci&oacute;n que quiere el Se&ntilde;or.</p>\r\n<p>&nbsp;</p>\r\n<p>Si se enoja por <span style=\"text-decoration: underline;\">limites</span>, esta <span style=\"text-decoration: underline;\">aprendiendo</span>.</p>\r\n<p>Si se enoja por una mala <span style=\"text-decoration: underline;\">relaci&oacute;n</span>, se esta <span style=\"text-decoration: underline;\">alejando</span>.</p>\r\n<p>&nbsp;</p>\r\n<p>Un padre inteligente ha aprendido a discernir cuando</p>\r\n<p>es <span style=\"text-decoration: underline;\">hostigamiento</span> y cuando es <span style=\"text-decoration: underline;\">entrenamiento</span>.</p>\r\n<p>&nbsp;</p>\r\n<p><strong>Esta es la meta:</strong> Que nuestros hijos traspasen la</p>\r\n<p>linea imaginaria que separa el <span style=\"text-decoration: underline;\">servicio a Dios</span> de <span style=\"text-decoration: underline;\">una</span></p>\r\n<p><span style=\"text-decoration: underline;\">vida sin principios</span>, no por ti, no por la presi&oacute;n social</p>\r\n<p>y familiar, sino por <span style=\"text-decoration: underline;\">ellos mismos</span>.</p>', 1, '2011-10-16'),
(258, 62, 'Una Amistad Real', '<p style=\"text-align: center;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 22.0pt; font-family: Arial; mso-fareast-font-family: \'Times New Roman\'; mso-font-kerning: .5pt; mso-ansi-language: ES; mso-fareast-language: AR-SA; mso-bidi-language: AR-SA;\">Una Amistad Real</span></span></strong></p>\r\n<p style=\"text-align: center;\"><img src=\"http://a3.sphotos.ak.fbcdn.net/hphotos-ak-snc7/318404_2568262968850_1322460177_33033651_1534611281_n.jpg\" alt=\"\" width=\"373\" height=\"272\" /></p>\r\n<p style=\"text-align: left;\">&nbsp;</p>\r\n<p style=\"text-align: left;\">&nbsp;</p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">HAY PERSONAS QUE POR SUS MALAS AMISTADES TEMINAN MAL</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">Proverbios 18:24 (NVI)</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">Hay amigos que llevan a la ruina, y hay amigos m&aacute;s fieles que un hermano.</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">Proverbios 6:1-5 (NVI)</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">Hijo m&iacute;o, si has salido fiador de tu vecino, si has hecho tratos para responder por otro, si verbalmente te has comprometido, enred&aacute;ndote con tus propias palabras, entonces has ca&iacute;do en manos de tu pr&oacute;jimo.</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">Si quieres librarte, hijo m&iacute;o, &eacute;ste es el camino: Ve corriendo y hum&iacute;llate ante &eacute;l; procura deshacer tu compromiso.</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">No permitas que se duerman tus ojos; no dejes que tus p&aacute;rpados se cierren. L&iacute;brate, como se libra del cazador la gacela, como se libra de la trampa el ave.</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">&iquest;COMO ES EL MAL AMIGO?</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">1. HABLA MAL DE OTROS</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"text-decoration: underline;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">Proverbios 16:28b (NVI)</span></span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">El chismoso divide a los buenos amigos.</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">\"EL MAL AMIGO ES CHISMOSO\"</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">Proverbios 27:6 (NVI)</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">M&aacute;s confiable es el amigo que hiere que el enemigo que besa.</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">2. ES CONDICIONAL</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">Proverbios 17:17 (NVI)</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">En todo tiempo ama el amigo; para ayudar en la adversidad naci&oacute; el hermano</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">Lucas 7:33-35 (NVI)</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">Porque vino Juan el Bautista, que no com&iacute;a pan ni beb&iacute;a vino, y ustedes dicen: \"Tiene un demonio. </span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">&nbsp;</span><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">&ldquo;Vino el Hijo del hombre, que come y bebe, y ustedes dicen: \"&Eacute;ste es un glot&oacute;n y un borracho, amigo de recaudadores de impuestos y de pecadores.</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">3. TE QUITA VALOR</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><strong></strong><span style=\"font-size: 13.0pt; font-family: \'Courier New\'; mso-fareast-font-family: \'Courier New\'; mso-ansi-language: ES;\"><span>&diams;<span style=\"font: 7.0pt \'Times New Roman\';\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">TE DESANIMA BUSCAR A DIOS</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 13.0pt; font-family: \'Courier New\'; mso-fareast-font-family: \'Courier New\'; mso-ansi-language: ES;\"><span>&diams;<span style=\"font: 7.0pt \'Times New Roman\';\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">TE ENSE&Ntilde;A COSAS INAPROPIADAS</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 13.0pt; font-family: \'Courier New\'; mso-fareast-font-family: \'Courier New\'; mso-ansi-language: ES;\"><span>&diams;<span style=\"font: 7.0pt \'Times New Roman\';\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">TU TERMINAS SIENDO PEOR PERSONA</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">Juan 15:15b (NVI)</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><span style=\"font-size: 13.0pt; font-family: Arial; mso-ansi-language: ES;\">Los he llamado amigos, porque todo lo que a mi Padre le o&iacute; decir se lo he dado a conocer a</', 3, '2011-10-23'),
(259, 62, 'Amar al Dificil de Amar', '<h1><strong>Amar al que es dif&iacute;cil de amar.</strong></h1>\r\n<p>&nbsp;</p>\r\n<p><span style=\"text-decoration: underline;\"><strong>Romanos 15:2-3</strong></span></p>\r\n<p>Todos debemos apoyar a los dem&aacute;s, y buscar su&nbsp;bien. As&iacute; los ayudaremos a confiar m&aacute;s en Dios.&nbsp;Porque ni aun Cristo pensaba s&oacute;lo en lo que le&nbsp;agradaba a &eacute;l. Como Dios dice en la Biblia: &laquo;Me siento&nbsp;ofendido cuando te ofenden a ti. &raquo;</p>\r\n<p>&nbsp;</p>\r\n<p><em>\" La discriminaci&oacute;n es la &uacute;nica arma que tienen los&nbsp;mediocres para sobresalir\"</em></p>\r\n<p style=\"text-align: right;\">G Gapel</p>\r\n<p>&nbsp;</p>\r\n<h3 style=\"text-align: center;\">Jes&uacute;s <span style=\"text-decoration: underline;\">sufre</span> cuando <span style=\"text-decoration: underline;\">maltratan</span> a las personas.</h3>\r\n<p>&nbsp;</p>\r\n<p><span style=\"text-decoration: underline;\"><strong>Romanos 15:7</strong></span></p>\r\n<p>Por eso, es necesario que se acepten unos a otros tal&nbsp;y como son, as&iacute; como Cristo los acept&oacute; a ustedes. As&iacute;,&nbsp;todos alabar&aacute;n a Dios.</p>\r\n<p>&nbsp;</p>\r\n<p><em>\"Que dos y dos sean necesariamente cuatro, es una&nbsp;opini&oacute;n que muchos compartimos. Pero si alguien&nbsp;sinceramente piensa otra cosa, que lo diga. Aqu&iacute; no&nbsp;nos asombramos de nada\"</em></p>\r\n<p style=\"text-align: right;\">Antonio Machado (1875-1939) Poeta espa&ntilde;ol.</p>', 1, '2011-10-30'),
(260, 63, 'La Mano de Dios nos Guía', '', 6, '2011-09-25'),
(261, 63, 'La Mano de Dios pelea por Nosotros', '', 1, '2011-09-25'),
(262, 63, 'Las Cuatro  C  para El Matrimonio', '', 6, '2011-09-25'),
(263, 63, 'La Mano de Dios nos Purifica', '', 2, '2011-09-25'),
(264, 63, 'La Mano de Dios nos Guía en Mexico', '', 6, '2011-09-25');
INSERT INTO `mensajes` (`id_mensaje`, `id_serie`, `mensaje`, `resumen`, `id_expositor`, `fecha`) VALUES
(265, 64, 'La primavera: Un romance inolvidable', '<p class=\"Body1\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">LAS ESTACIONES DE LA VIDA.</span></span></strong><strong></strong></p>\r\n<p class=\"Body1\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">La primavera: Un romance inolvidable</span></span></strong><strong></strong></p>\r\n<p class=\"Body1\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><br /></span></strong></p>\r\n<p class=\"Body1\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><br /></span></strong></p>\r\n<p class=\"Body1\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">2 Corintios 6:14-15</span></span></strong><strong></strong></p>\r\n<p class=\"Body1\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">No se unan ustedes en un mismo yugo con los que no creen. Porque </span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; font-family: \'Arial Unicode MS\'; mso-ascii-font-family: Helvetica;\">&iquest;</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">qu</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; font-family: \'Arial Unicode MS\'; mso-ascii-font-family: Helvetica;\">&eacute;</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\"> tienen en com</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; font-family: \'Arial Unicode MS\'; mso-ascii-font-family: Helvetica;\">&uacute;</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">n la justicia y la injusticia? </span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; font-family: \'Arial Unicode MS\'; mso-ascii-font-family: Helvetica;\">&iquest;</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">O c</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; font-family: \'Arial Unicode MS\'; mso-ascii-font-family: Helvetica;\">&oacute;</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">mo puede la luz ser compa</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; font-family: \'Arial Unicode MS\'; mso-ascii-font-family: Helvetica;\">&ntilde;</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">era de la oscuridad? No puede haber armon</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; font-family: \'Arial Unicode MS\'; mso-ascii-font-family: Helvetica;\">&iacute;</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">a entre Cristo y Belial, ni entre un creyente y un incr</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; font-family: \'Arial Unicode MS\'; mso-ascii-font-family: Helvetica;\">&eacute;</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">dulo.</span></p>\r\n<p class=\"Body1\"><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt;\">&nbsp;</span></p>\r\n<p class=\"Body1\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">Cantar de los Cantares 1:5-6</span></span></strong></p>\r\n<p class=\"Body1\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; font-family: \'Arial Unicode MS\'; mso-ascii-font-family: Helvetica;\">&iexcl;</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">Mujeres de Jerusal</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; font-family: \'Arial Unicode MS\'; mso-ascii-font-family: Helvetica;\">&eacute;</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">n!</span></p>\r\n<p class=\"Body1\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">Yo soy morena, s</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; font-family: \'Arial Unicode MS\'; mso-ascii-font-family: Helvetica;\">&iacute;</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">,</span></p>\r\n<p class=\"Body1\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">como las tiendas de Quedar.</span></p>\r\n<p class=\"Body1\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">Y soy tambi</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; font-family: \'Arial Unicode MS\'; mso-ascii-font-family: Helvetica;\">&eacute;</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">n hermosa,</span></p>\r\n<p class=\"Body1\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">como las cortinas de Salom</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; font-family: \'Arial Unicode MS\'; mso-ascii-font-family: Helvetica;\">&oacute;</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">n.</span></p>\r\n<p class=\"Body1\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">&nbsp;</span></p>\r\n<p class=\"Body1\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">No se fijen en mi piel morena,</span></p>\r\n<p class=\"Body1\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">pues el sol la requem</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; font-family: \'Arial Unicode MS\'; mso-ascii-font-family: Helvetica;\">&oacute;</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">.</span></p>\r\n<p class=\"Body1\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">Mis hermanos se enojaron contra m</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; font-family: \'Arial Unicode MS\'; mso-ascii-font-family: Helvetica;\">&iacute;</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">,</span></p>\r\n<p class=\"Body1\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">y me obligaron a cuidar sus vi</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; font-family: \'Arial Unicode MS\'; mso-ascii-font-family: Helvetica;\">&ntilde;</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">as,</span></p>\r\n<p class=\"Body1\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; font-family: \'Arial Unicode MS\'; mso-ascii-font-family: Helvetica;\">&iexcl;</span><span style=\"font-size: 14.0pt; mso-bidi-font-size: 10.0pt; mso-hansi-font-family: \'Arial Unicode MS\';\">y a', 1, '2011-11-06'),
(266, 64, 'La primavera: Formando un hogar', '<h1>La primavera: Formando un hogar</h1>\r\n<p>&nbsp;</p>\r\n<p><span style=\"text-decoration: underline;\"><strong>Proverbios 22:6</strong></span></p>\r\n<p>Educa a tu hijo desde ni&ntilde;o,</p>\r\n<p>y aun cuando llegue a viejo&nbsp;seguir&aacute; tus ense&ntilde;anzas.</p>\r\n<p>&nbsp;</p>\r\n<h3><span style=\"text-decoration: underline;\">La moda</span> es cambiante, pero <span style=\"text-decoration: underline;\">la Palabra de Dios</span> no lo es.</h3>\r\n<p>&nbsp;</p>\r\n<p><strong><span style=\"text-decoration: underline;\">Proverbios 22:15</span></strong></p>\r\n<p>La necedad est&aacute; ligada en el coraz&oacute;n del muchacho;</p>\r\n<p>Mas la vara de la correcci&oacute;n la alejar&aacute; de &eacute;l.</p>\r\n<p>&nbsp;</p>\r\n<p>Los hijos deben obedecer:</p>\r\n<p>&nbsp;</p>\r\n<p>1- <span style=\"text-decoration: underline;\">R&aacute;pidamente</span></p>\r\n<p>&nbsp;</p>\r\n<p>2- <span style=\"text-decoration: underline;\">Gozosamente</span></p>\r\n<p>&nbsp;</p>\r\n<p>3- <span style=\"text-decoration: underline;\">Completamente.</span></p>\r\n<p>&nbsp;</p>\r\n<p><strong><span style=\"text-decoration: underline;\">Proverbios 23:15</span></strong></p>\r\n<p>No reh&uacute;ses corregir al muchacho;</p>\r\n<p>Porque si lo castigas con vara, no morir&aacute;.</p>\r\n<p>&nbsp;</p>\r\n<h3 style=\"text-align: center;\">Entrenar a un hijo es <span style=\"text-decoration: underline;\">un acto de amor</span>, tanto para <span style=\"text-decoration: underline;\">el hijo como para</span> Dios.</h3>', 1, '2011-11-13'),
(267, 64, 'El verano: De héroe a villano', '<h1>El verano: De h&eacute;roe a villano</h1>\r\n<p>&nbsp;</p>\r\n<p><span style=\"text-decoration: underline;\"><strong>Exodo 20:12</strong></span></p>\r\n<p>&raquo;Obedezcan y cuiden a su padre y a su madre. As&iacute; podr&aacute;n vivir muchos a&ntilde;os en</p>\r\n<p>el pa&iacute;s que les voy a dar.</p>\r\n<p>&nbsp;</p>\r\n<p><span style=\"text-decoration: underline;\"><strong>Efesios 6:1-3</strong></span></p>\r\n<p>1 Hijos, obedezcan a sus padres. Ustedes son de Cristo, y eso es lo que les</p>\r\n<p>corresponde hacer. 2 El primer mandamiento que va acompa&ntilde;ado de una promesa</p>\r\n<p>es el siguiente: &laquo;Obedezcan y cuiden a su padre y a su madre. 3 As&iacute; les ir&aacute; bien, y</p>\r\n<p>podr&aacute;n vivir muchos a&ntilde;os en la tierra. &raquo;</p>\r\n<p>&nbsp;</p>\r\n<p>La promesa va acompa&ntilde;ada de dos beneficios maravillosos:</p>\r\n<p>&nbsp;</p>\r\n<p>1- Te va a<span style=\"text-decoration: underline;\"> ir bien.</span></p>\r\n<p>&nbsp;</p>\r\n<p>2- Te a&ntilde;ade<span style=\"text-decoration: underline;\"> a&ntilde;os de vida.</span></p>\r\n<p>&nbsp;</p>\r\n<h3 style=\"text-align: center;\">Espera de tus hijos <span style=\"text-decoration: underline;\">lo mismo que estas haciendo</span> con tus padres.</h3>', 1, '2011-11-20'),
(268, 64, 'El otoño: Una vida trascendente', '<h1><strong>Las Estaciones de la Vida</strong></h1>\r\n<h1><strong>Oto&ntilde;o: Una Vida Trascendente</strong></h1>\r\n<p>&nbsp;</p>\r\n<p><span style=\"text-decoration: underline;\"><strong>1 Corintios 11:1 (NTV)</strong></span></p>\r\n<p>Y ustedes deber&iacute;an imitarme a m&iacute;, as&iacute; como yo imito a Cristo.</p>\r\n<p>&nbsp;</p>\r\n<h3><strong>&iquest;Qu&eacute; elementos contribuyen para dejar un legado espiritual?</strong></h3>\r\n<p>&nbsp;</p>\r\n<p>1) <span style=\"text-decoration: underline;\">Dios</span></p>\r\n<p>&nbsp;</p>\r\n<p>Dios debe ser el centro de nuestra vida</p>\r\n<p>&nbsp;</p>\r\n<p><span style=\"text-decoration: underline;\"><strong>Juan 14:6 (NTV)</strong></span></p>\r\n<p>Jes&uacute;s le contest&oacute;: &mdash;Yo soy el camino, la verdad y la vida; nadie puede ir al</p>\r\n<p>Padre si no es por medio de m&iacute;.</p>\r\n<p>&nbsp;</p>\r\n<p>2) <span style=\"text-decoration: underline;\">El amor</span></p>\r\n<p>Si nuestros hijos, nuestros amigos, no se sienten amados entonces dejaremos</p>\r\n<p>un legado lleno de dolor, odio, rencor y amargura.</p>\r\n<p>&nbsp;</p>\r\n<p><strong><span style=\"text-decoration: underline;\">1 Tesalonicenses 3:12 (NTV)</span></strong></p>\r\n<p>Y que el Se&ntilde;or haga crecer y sobreabundar el amor que tienen unos por otros y</p>\r\n<p>por toda la gente, tanto como sobreabunda nuestro amor por ustedes.</p>\r\n<p>&nbsp;</p>\r\n<p>3) <span style=\"text-decoration: underline;\">La fe</span></p>\r\n<p>&nbsp;</p>\r\n<p>Si no crecemos en fe estaremos dejando un legado d&eacute;bil que f&aacute;cilmente puede</p>\r\n<p>ser remplazado por otras creencias.</p>\r\n<p>&nbsp;</p>\r\n<p><span style=\"text-decoration: underline;\"><strong>2 Timoteo 1:5 (NTV)</strong></span></p>\r\n<p>Me acuerdo de tu fe sincera, pues t&uacute; tienes la misma fe de la que primero</p>\r\n<p>estuvieron llenas tu abuela Loida y tu madre, Eunice, y s&eacute; que esa fe sigue</p>\r\n<p>firme en ti.</p>\r\n<p>&nbsp;</p>\r\n<p>4) <span style=\"text-decoration: underline;\">Conducta</span></p>\r\n<p>Si queremos dejar un legado que perdure en esta vida es necesario que nuestra</p>\r\n<p>conducta se parezca al modelo que nos dejo Jesucristo.</p>\r\n<p>&nbsp;</p>\r\n<p><span style=\"text-decoration: underline;\"><strong>2 Corintios 6:3 (RV-95)</strong></span></p>\r\n<p>No damos a nadie ninguna ocasi&oacute;n de tropiezo, para que nuestro ministerio no</p>\r\n<p>sea desacreditado.</p>\r\n<p>&nbsp;</p>\r\n<p>5) <span style=\"text-decoration: underline;\">Tiempo</span></p>\r\n<p>Invirtamos nuestro tiempo en lo que es de beneficio para mi vida:</p>\r\n<p>&bull; Dedicar tiempo para la lectura</p>\r\n<p>&bull; Dedicar tiempo para orar</p>\r\n<p>&bull; Dedicar tiempo para reunirte</p>\r\n<p>&bull; Dedicar tiempo para tu familia</p>\r\n<p>&bull; Dedicar tiempo para ense&ntilde;arle a tus amigos</p>\r\n<p>&nbsp;</p>\r\n<p><span style=\"text-decoration: underline;\"><strong>Eclesiast&eacute;s 3:1 (NTV)</strong></span></p>\r\n<p>Hay una temporada para todo, un tiempo para cada actividad bajo el cielo.</p>\r\n<p>&nbsp;</p>\r\n<h3 style=\"text-align: right;\">\"Lo que hacemos en la vida tiene un eco en la eternidad\"</h3>\r\n<h3 style=\"text-align: right;\">Russel Crowe- Gladiador</h3>', 2, '2011-11-27'),
(269, 64, 'El invierno: Preparados para partir', '<h2>Las estaciones de la vida.</h2>\r\n<h2>Tema: El invierno: Preparados para partir</h2>\r\n<p>&nbsp;</p>\r\n<h3>&iquest;QUE SIGNIFICA ESTAR PREPARADOS PARA PARTIR?</h3>\r\n<p>&nbsp;</p>\r\n<p><span style=\"text-decoration: underline;\"><strong>Ruth 1:3-6</strong></span></p>\r\n<p style=\"text-align: justify;\">Poco tiempo despu&eacute;s de haber llegado a Moab, Elim&eacute;lec muri&oacute;, as&iacute;&nbsp;que Noem&iacute; y sus hijos se quedaron solos.&nbsp;Pas&oacute; el tiempo, y Mahl&oacute;n y Quili&oacute;n se casaron con muchachas&nbsp;de ese pa&iacute;s. Una de ellas se llamaba Orf&aacute; y la otra, Rut. Pero pasados&nbsp;unos diez a&ntilde;os, murieron Mahl&oacute;n y Quili&oacute;n, por lo que Noem&iacute; qued&oacute;&nbsp;desamparada, sin hijos y sin marido.</p>\r\n<p>&nbsp;</p>\r\n<p><strong>1- <span style=\"text-decoration: underline;\">Dejar todo listo</span> en caso de que nos ausentemos.</strong></p>\r\n<p>&nbsp;</p>\r\n<p><span style=\"text-decoration: underline;\"><strong>Lucas 16:19-31</strong></span></p>\r\n<p style=\"text-align: justify;\">Jes&uacute;s tambi&eacute;n dijo:&nbsp;&laquo;Hab&iacute;a una vez un hombre muy rico, que vest&iacute;a ropas muy lujosas. Hac&iacute;a fiestas todos los d&iacute;as, y serv&iacute;a las comidas m&aacute;s caras. En&nbsp;cambio, junto a la entrada de su casa hab&iacute;a un hombre pobre, llamado&nbsp;L&aacute;zaro, que ten&iacute;a la piel llena de llagas. Unas personas lo sentaban&nbsp;siempre all&iacute;, y los perros ven&iacute;an a lamerle las llagas.</p>\r\n<p style=\"text-align: justify;\">&nbsp;</p>\r\n<p style=\"text-align: justify;\">Este pobre&nbsp;hombre ten&iacute;a tanta hambre que deseaba comer, por lo menos, las&nbsp;sobras que ca&iacute;an de la mesa del hombre rico.&nbsp;&raquo;Un d&iacute;a, el hombre pobre muri&oacute; y los &aacute;ngeles lo pusieron en el sitio&nbsp;de honor, junto a su antepasado Abraham. Despu&eacute;s muri&oacute; tambi&eacute;n el&nbsp;hombre rico, y lo enterraron. 23 Cuando ya estaba en el infierno, donde&nbsp;sufr&iacute;a much&iacute;simo, el que hab&iacute;a sido rico vio a lo lejos a Abraham, y a&nbsp;L&aacute;zaro sentado junto a &eacute;l.</p>\r\n<p style=\"text-align: justify;\">&nbsp;</p>\r\n<p style=\"text-align: justify;\">&raquo;Entonces llam&oacute; a Abraham y le dijo: \" &iexcl;Abraham, antepasado m&iacute;o,&nbsp;compad&eacute;cete de m&iacute;! Ord&eacute;nale a L&aacute;zaro que moje la punta de su dedo&nbsp;en agua, y me refresque la lengua. Sufro much&iacute;simo con este fuego.\"&nbsp;Pero Abraham le respondi&oacute;: \" T&uacute; eres mi descendiente, pero recuerda&nbsp;que, cuando ustedes viv&iacute;an, a ti te iba muy bien y a L&aacute;zaro le iba muy&nbsp;mal. Ahora, &eacute;l es feliz aqu&iacute;, mientras que a ti te toca sufrir. &nbsp;Adem&aacute;s,&nbsp;a ustedes y a nosotros nos separa un gran abismo, y nadie puede&nbsp;pasar de un lado a otro.</p>\r\n<p style=\"text-align: justify;\">&nbsp;</p>\r\n<p style=\"text-align: justify;\">\"El hombre rico dijo: \" Abraham, te ruego&nbsp;entonces que mandes a L&aacute;zaro a la casa de mi familia. Que avise a&nbsp;mis cinco hermanos que, si no dejan de hacer lo malo, vendr&aacute;n a este&nbsp;horrible lugar.\" Pero Abraham le contest&oacute;: \" Tus hermanos tienen la&nbsp;Biblia. &iquest;Por qu&eacute; no la leen? &iquest;Por qu&eacute; no la obedecen?\" El hombre&nbsp;rico respondi&oacute;: \" Abraham, querido antepasado, &iexcl;eso no basta! Pero si&nbsp;alguno de los muertos va y habla con ellos, te aseguro que se volver&aacute;n&nbsp;a Dios.\" Abraham le dijo: \" Si no hacen caso de lo que dice la Biblia,&nbsp;tampoco le har&aacute;n caso a un muerto que vuelva a vivir.\" &raquo;</p>\r\n<p style=\"text-align: justify;\">&nbsp;</p>\r\n<p style=\"text-align: justify;\"><strong>No habr&aacute; <span style=\"text-decoration: underline;\">otro momento</span>, sino hoy, <span style=\"text-decoration: underline;\">para ayudar</span> y predicar a los tuyos y&nbsp;a otras personas.</strong></p>\r\n<p style=\"text-align: justify;\">&nbsp;</p>\r\n<p style=\"text-align: justify;\"><strong>2- Aceptar a Jes&uacute;s como tu Salvador personal.</strong></p>\r\n<p style=\"text-align: justify;\">&nbsp;</p>\r\n<p style=\"text-align: justify;\"><span style=\"text-decoration: underline;\"><strong>Romanos 1:16-17</strong></span></p>\r\n<p style=\"text-align: justify;\">Porque no me averg&uuml;enzo del evangelio, porque es poder de Dios&nbsp;para salvaci&oacute;n a todo aquel que cree; al jud&iacute;o primeramente, y tambi&eacute;n&nbsp;al griego. Porque en el evangelio la justicia de Dios se revela por fe y&nbsp;para fe, como est&aacute; escrito: Mas el justo por la fe vivir&aacute;.</p>\r\n<p style=\"text-align: justify;\">&nbsp;</p>\r\n<h2 style=\"text-align: center;\">Nadie estar&aacute; listo <span style=\"text-decoration: underline;\">para partir de este mundo sin aceptar</span> a Jes&uacute;s.</h2>', 1, '2011-12-04'),
(270, 64, 'El invierno: Es tiempo de dar', '', 2, '2011-12-11'),
(271, 66, 'Hacia una noche de paz', '<h1>Hacia una noche de paz.</h1>\r\n<p>&nbsp;</p>\r\n<p><span style=\"text-decoration: underline;\"><span><strong>Isa&iacute;as</strong></span><strong>&nbsp;9:6-7</strong></span></p>\r\n<p>&raquo;Nos ha nacido un ni&ntilde;o,&nbsp;Dios nos ha dado un hijo:&nbsp;a ese ni&ntilde;o se le ha dado&nbsp;el poder de gobernar;&nbsp;y se le dar&aacute;n estos nombres:&nbsp;Consejero admirable, Dios invencible,&nbsp;Padre eterno, Pr&iacute;ncipe de paz.</p>\r\n<p>&nbsp;</p>\r\n<h3>1- La paz <span style=\"text-decoration: underline;\">con Dios.</span></h3>\r\n<p>&nbsp;</p>\r\n<p><strong><span style=\"text-decoration: underline;\">Romanos 6:23</span></strong></p>\r\n<p>El pago que da el pecado es la muerte, pero el don de Dios es&nbsp;vida eterna en uni&oacute;n con Cristo Jes&uacute;s, nuestro Se&ntilde;or.</p>\r\n<p>&nbsp;</p>\r\n<h3>2- La paz <span style=\"text-decoration: underline;\">de Dios.</span></h3>\r\n<p>&nbsp;</p>\r\n<p><span style=\"text-decoration: underline;\"><strong>Juan 14:27</strong></span></p>\r\n<p>&raquo;Les doy la paz, mi propia paz, que no es como la paz que se&nbsp;desea en este mundo. No se preocupen ni tengan miedo por lo que&nbsp;pronto va a pasar.</p>\r\n<p>&nbsp;</p>\r\n<p><span style=\"text-decoration: underline;\"><strong>Filipenses 4:6-7</strong></span></p>\r\n<p>No se preocupen por nada. M&aacute;s bien, oren y p&iacute;danle a Dios todo&nbsp;lo que necesiten, y sean agradecidos. As&iacute; Dios les dar&aacute; su paz,&nbsp;esa paz que la gente de este mundo no alcanza a comprender, pero&nbsp;que protege el coraz&oacute;n y el entendimiento de los que ya son de&nbsp;Cristo.</p>\r\n<p>&nbsp;</p>\r\n<p><span style=\"text-decoration: underline;\"><strong>Isa&iacute;as 43:1-2</strong></span></p>\r\n<p>&laquo;Ahora, pueblo de Israel,&nbsp;Dios tu creador te dice:&nbsp;\" No tengas miedo.&nbsp;Yo te he liberado;&nbsp;te he llamado por tu nombre&nbsp;y t&uacute; me perteneces.&nbsp;Aunque tengas graves problemas,&nbsp;yo siempre estar&eacute; contigo;&nbsp;cruzar&aacute;s r&iacute;os y no te ahogar&aacute;s,&nbsp;caminar&aacute;s en el fuego y no te quemar&aacute;s</p>\r\n<p>&nbsp;</p>\r\n<h3>3-La paz <span style=\"text-decoration: underline;\">con otros.</span></h3>\r\n<p>&nbsp;</p>\r\n<h3>No se puede gozar de una verdadera paz sin Jes&uacute;s</h3>', 1, '2011-12-18'),
(272, 67, '¡2012, el año de mi vida!', '<p>&nbsp;</p>\r\n<h1>Disciplinas Espirituales:&nbsp;&iexcl;2012, el a&ntilde;o de mi vida!</h1>\r\n<h1>&nbsp;</h1>\r\n<h1><a title=\"&iexcl;2012, el a&ntilde;o de mi vida!\" href=\"http://es.youversion.com/events/66377\" target=\"_blank\">Ingresa al Estudio Aqui</a></h1>\r\n<p>&nbsp;</p>', 1, '2012-01-01'),
(273, 67, 'Estudio de las Escrituras', '<h1>Disciplinas Espirituales: Estudio de las Escituras</h1>\r\n<p>&nbsp;</p>\r\n<h1><a title=\"Estudio de las Escrituras\" href=\"http://www.youversion.com/events/65579\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2012-01-08'),
(274, 67, 'Meditación', '<h1>Disciplinas Espirituales: Meditaci&oacute;n</h1>\r\n<h1><a title=\"Disciplinas Espirituales: Meditaci&oacute;n\" href=\"http://www.youversion.com/events/63427\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 2, '2012-01-15'),
(275, 67, 'Oración', '<h1>Disciplinas Espirituales: Oraci&oacute;n</h1>\r\n<h1><a title=\"Disciplinas Espirituales: Oraci&oacute;n \" href=\"http://es.youversion.com/events/65545\" target=\"_blank\">Ingresa al Estudio Aqui</a></h1>', 1, '2012-01-22'),
(276, 67, 'Devocional', '<h1 style=\"margin-top: 0em; margin-right: 0em; margin-bottom: 1em; margin-left: 0em; padding-top: 0px; padding-right: 0px; padding-bottom: 12px; padding-left: 0px; letter-spacing: -0.07em; font-family: \'Myriad Pro\', Mako, \'Trebuchet MS\', sans-serif; font-weight: normal; font-size: 26px;\">Disciplinas Espirituales: Devocional</h1>\r\n<h1 style=\"margin-top: 0em; margin-right: 0em; margin-bottom: 1em; margin-left: 0em; padding-top: 0px; padding-right: 0px; padding-bottom: 12px; padding-left: 0px; letter-spacing: -0.07em; font-family: \'Myriad Pro\', Mako, \'Trebuchet MS\', sans-serif; font-weight: normal; font-size: 26px;\"><a title=\"Disciplinas Espirituales: Devocional\" href=\"http://es.youversion.com/events/67544\" target=\"_blank\">Ingresa al Estudio Aqui</a></h1>', 2, '2012-01-29'),
(277, 67, 'Servicio', '<h1 style=\"margin-top: 0em; margin-right: 0em; margin-bottom: 1em; margin-left: 0em; padding-top: 0px; padding-right: 0px; padding-bottom: 12px; padding-left: 0px; letter-spacing: -0.07em; font-family: \'Myriad Pro\', Mako, \'Trebuchet MS\', sans-serif; font-weight: normal; font-size: 26px;\">Disciplinas Espirituales: Servicio</h1>\r\n<h1 style=\"margin-top: 0em; margin-right: 0em; margin-bottom: 1em; margin-left: 0em; padding-top: 0px; padding-right: 0px; padding-bottom: 12px; padding-left: 0px; letter-spacing: -0.07em; font-family: \'Myriad Pro\', Mako, \'Trebuchet MS\', sans-serif; font-weight: normal; font-size: 26px;\"><a title=\"Disciplinas Espirituales: Servicio\" href=\"http://es.youversion.com/events/68990\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2012-02-05'),
(278, 67, 'Ayuno', '<h1 style=\"margin-top: 0em; margin-right: 0em; margin-bottom: 1em; margin-left: 0em; padding-top: 0px; padding-right: 0px; padding-bottom: 12px; padding-left: 0px; letter-spacing: -0.07em; font-family: \'Myriad Pro\', Mako, \'Trebuchet MS\', sans-serif; font-weight: normal; font-size: 26px;\">Disciplinas Espirituales: Servicio</h1>\r\n<h1 style=\"margin-top: 0em; margin-right: 0em; margin-bottom: 1em; margin-left: 0em; padding-top: 0px; padding-right: 0px; padding-bottom: 12px; padding-left: 0px; letter-spacing: -0.07em; font-family: \'Myriad Pro\', Mako, \'Trebuchet MS\', sans-serif; font-weight: normal; font-size: 26px;\"><a title=\"Ayuno\" href=\"http://es.youversion.com/events/70776\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2012-02-12'),
(279, 67, 'Adoración', '<h1 style=\"margin-top: 0em; margin-right: 0em; margin-bottom: 1em; margin-left: 0em; padding-top: 0px; padding-right: 0px; padding-bottom: 12px; padding-left: 0px; letter-spacing: -0.07em; font-family: \'Myriad Pro\', Mako, \'Trebuchet MS\', sans-serif; font-weight: normal; font-size: 26px;\">Disciplinas Espirituales: Adoraci&oacute;n</h1>\r\n<h1 style=\"margin-top: 0em; margin-right: 0em; margin-bottom: 1em; margin-left: 0em; padding-top: 0px; padding-right: 0px; padding-bottom: 12px; padding-left: 0px; letter-spacing: -0.07em; font-family: \'Myriad Pro\', Mako, \'Trebuchet MS\', sans-serif; font-weight: normal; font-size: 26px;\"><a title=\"Adoraci&oacute;n\" href=\"http://es.youversion.com/events/72538\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 3, '2012-02-19'),
(280, 68, 'El Enojo', '<h1>Ingresa aqui al boletin.</h1>\r\n<p>&nbsp;</p>\r\n<h1><a title=\"El Enojo\" href=\"http://es.a.youversion.com/events/77581\" target=\"_blank\">El Enojo</a></h1>', 1, '2012-03-11'),
(281, 68, 'Los Celos', '<h1 style=\"margin-top: 0em; margin-right: 0em; margin-bottom: 1em; margin-left: 0em; padding-top: 0px; padding-right: 0px; padding-bottom: 12px; padding-left: 0px; letter-spacing: -0.07em; font-family: \'Myriad Pro\', Mako, \'Trebuchet MS\', sans-serif; font-weight: normal; font-size: 26px;\">Ingresa aqui al boletin.</h1>\r\n<p style=\"margin-top: 0px; margin-right: 0px; margin-bottom: 2em; margin-left: 0px; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\"><a title=\"Los Celos\" href=\"http://www.a.youversion.com/events/79444\" target=\"_blank\"><span style=\"font-family: \'Myriad Pro\', Mako, \'Trebuchet MS\', sans-serif; font-size: 26px; letter-spacing: -0.07em;\">Los Celos</span></a></p>', 1, '2012-03-18'),
(282, 68, 'La Culpa', '<h1 style=\"margin-top: 0em; margin-right: 0em; margin-bottom: 1em; margin-left: 0em; padding-top: 0px; padding-right: 0px; padding-bottom: 12px; padding-left: 0px; letter-spacing: -0.07em; font-family: \'Myriad Pro\', Mako, \'Trebuchet MS\', sans-serif; font-weight: normal; font-size: 26px;\">Ingresa aqui al boletin.</h1>\r\n<p style=\"margin-top: 0px; margin-right: 0px; margin-bottom: 2em; margin-left: 0px; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\"><a title=\"La Culpa\" href=\"http://es.a.youversion.com/events/80841\" target=\"_blank\"><span style=\"font-family: \'Myriad Pro\', Mako, \'Trebuchet MS\', sans-serif; font-size: 26px; letter-spacing: -0.07em;\">La Culpa</span></a></p>', 2, '2012-03-25'),
(283, 68, 'La Vía Dolorosa: El Camino al Amor', '', 2, '2012-04-01'),
(284, 69, 'Transformando una Relación Rota', '<h1 style=\"margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 24px; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; vertical-align: baseline; color: #7da768; line-height: 24px; border-width: 0px; padding: 0px;\">Transformando una Relaci&oacute;n Rota</h1>\r\n<h1>&nbsp;</h1>\r\n<h1><a title=\"Una Relaci&oacute;n Rota\" href=\"http://www.a.youversion.com/events/86178\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2012-04-15'),
(285, 69, 'Transformando los Limites del Noviazgo', '<h1>Transformando los Limites del Noviazgo</h1>\r\n<h1>&nbsp;</h1>\r\n<h1><a title=\"Noviazgo\" href=\"http://www.a.youversion.com/events/87902\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2012-04-22'),
(286, 69, 'Transformando un Caracter Problemático', '', 2, '2012-04-29'),
(287, 70, '¿Se comunica Dios hoy en día?', '<h1>&iquest;Se comunica Dios hoy en d&iacute;a?</h1>\r\n<h1>&nbsp;</h1>\r\n<h1><a title=\"&iquest;Se comunica Dios hoy en d&iacute;a?\" href=\"http://www.a.youversion.com/events/91488\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2012-05-06'),
(288, 70, 'Reconociendo la voz de Dios', '<p class=\"MsoNormal\" style=\"text-align: left;\" align=\"center\"><strong><span style=\"font-size: 18.0pt; font-family: Arial; mso-ansi-language: ES;\">Reconociendo la voz de Dios</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: left;\" align=\"center\"><strong><span style=\"font-size: 18.0pt; font-family: Arial; mso-ansi-language: ES;\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: left;\" align=\"center\"><a title=\"Reconociendo la voz de Dios\" href=\"http://www.a.youversion.com/events/93084\" target=\"_blank\"><strong><span style=\"font-size: 18.0pt; font-family: Arial; mso-ansi-language: ES;\">Ingresa al mensaje aqui</span></strong></a></p>', 1, '2012-05-13'),
(289, 70, 'La voz de Dios en momentos difíciles', '<p><strong><span style=\"font-size: 17.0pt; font-family: Arial; mso-ansi-language: ES;\">La voz de Dios en los momentos m&aacute;s dif&iacute;ciles de mi vida </span></strong></p>\r\n<p><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Oscar Guti&eacute;rrez</span></p>\r\n<p><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\"><br /></span></p>\r\n<h1><a title=\"Momentos Dificiles\" href=\"http://bible.us/e/OeB\" target=\"_blank\"><strong><span style=\"font-size: 10pt; font-family: Arial;\">Ingresa al estudio aqui</span></strong></a></h1>', 2, '2012-05-20'),
(290, 70, '¿Que hacer cuando siento que Dios ya no se comunica?', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 16.0pt; font-family: Arial; mso-ansi-language: ES;\">&iquest;Que hacer cuando siento que </span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 16.0pt; font-family: Arial; mso-ansi-language: ES;\">Dios ya no se comunica conmigo?</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\"><br /></span></p>\r\n<h1 class=\"MsoNormal\" style=\"text-align: left;\" align=\"right\"><a title=\"&iquest;Que hacer?\" href=\"http://www.a.youversion.com/events/96673\" target=\"_blank\"><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Ingresa al estudio aqui</span></a></h1>', 1, '2012-05-27'),
(291, 71, '¿Por que estamos aquí?', '<p>&nbsp;</p>\r\n<h1 style=\"margin: 0px 0px 0em; padding: 0px; border: 0px; outline: 0px; font-size: 18px; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; vertical-align: baseline; color: #333333; line-height: 24px; width: 400px;\">Una Vida Apasionada: Prop&oacute;sito</h1>\r\n<h1 style=\"margin: 0px 0px 0em; padding: 0px; border: 0px; outline: 0px; font-size: 18px; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; vertical-align: baseline; color: #333333; line-height: 24px; width: 400px;\">&iquest;Porque estamos aqui?&nbsp;</h1>\r\n<p>Pastor Sergio Handal</p>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<h2><a title=\"Prop&oacute;sito\" href=\"http://www.a.youversion.com/events/98435\" target=\"_blank\">Igresa aqui al estudio</a></h2>', 1, '2012-06-03'),
(292, 71, 'La satisfacción de vivir', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 20pt; font-family: Arial; background-color: white; background-position: initial initial; background-repeat: initial initial;\" lang=\"ES-MX\">La satisfacci&oacute;n de vivir</span><strong></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\"><br /></span></p>\r\n<h1 class=\"MsoNormal\" style=\"text-align: left;\" align=\"right\"><a title=\"Satisfacci&oacute;n \" href=\"http://www.a.youversion.com/events/100221\" target=\"_blank\"><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Ingresa aqui al estudio</span></a></h1>', 1, '2012-06-10'),
(293, 71, 'La verdadera felicidad', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 22.0pt; font-family: Arial; mso-ansi-language: ES;\">La Verdadera Felicidad</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Oscar Guti&eacute;rrez</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\"><br /></span></p>\r\n<h1 class=\"MsoNormal\" style=\"text-align: left;\" align=\"right\"><a title=\"La Verdadera Felicidad\" href=\"http://www.a.youversion.com/events/101850\" target=\"_blank\"><strong><span style=\"font-size: 10pt; font-family: Arial;\">Ingresa al estudio aqui</span></strong></a></h1>', 2, '2012-06-17'),
(294, 71, 'En pos de una verdadera pasión', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 17.0pt; font-family: Arial; mso-ansi-language: ES;\">En pos de una verdadera pasi&oacute;n</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\"><br /></span></p>\r\n<h1><a title=\"En pos de una verdadera pasi&oacute;n\" href=\"http://www.a.youversion.com/events/103422\" target=\"_blank\"><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Ingresa al estudio aqui</span></a></h1>', 1, '2012-06-24'),
(295, 71, 'Una nación para Dios', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 24.0pt; font-family: Arial; mso-ansi-language: ES;\">Una Naci&oacute;n para Dios</span></strong><strong></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\"><br /></span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: left;\" align=\"center\"><a title=\"Una Naci&oacute;n para Dios\" href=\"http://www.a.youversion.com/events/104808\" target=\"_blank\"><span style=\"font-size: 24.0pt; font-family: Arial; mso-ansi-language: ES;\">Ingresa al mensaje aqui</span></a></p>\r\n<p class=\"MsoNormal\" align=\"right\"><span style=\"font-family: Arial; font-size: x-small;\"><br /></span></p>', 1, '2012-07-01'),
(296, 72, 'El principio del camino', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 24.0pt; font-family: Arial; mso-ansi-language: ES;\">El Principio del Camino</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\"><br /></span></p>\r\n<h2 class=\"MsoNormal\" style=\"text-align: left;\" align=\"right\"><a title=\"El Principio del Camino\" href=\"http://www.a.youversion.com/events/106464\" target=\"_blank\"><strong><span style=\"font-size: 24.0pt; font-family: Arial; mso-ansi-language: ES;\">Ingresa al estudio aqui</span></strong></a></h2>', 1, '2012-07-08'),
(297, 72, 'Haciendo camino', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 24.0pt; font-family: Arial; mso-ansi-language: ES;\">Haciendo camino</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: left;\" align=\"right\"><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\"><br /></span></p>\r\n<p><a title=\"Haciendo Camino\" href=\"http://www.a.youversion.com/events/108902\" target=\"_blank\"><strong><span style=\"font-size: 10pt; font-family: Arial;\">Ingresa al estudio aqui</span></strong></a></p>', 1, '2012-07-15'),
(298, 72, 'Trabajando en el camino', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 22.0pt; font-family: Arial; mso-ansi-language: ES;\">Trabajando en el Camino</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Oscar Guti&eacute;rrez</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">22 / Julio / 2012</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: left;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: left;\" align=\"right\"><a title=\"Trabajando en el camino\" href=\"http://www.a.youversion.com/events/109641\" target=\"_blank\"><strong><span style=\"font-size: 18.0pt; font-family: Arial; mso-fareast-font-family: \'Times New Roman\'; mso-font-kerning: .5pt; mso-ansi-language: ES; mso-fareast-language: AR-SA; mso-bidi-language: AR-SA;\">Ingresa al estudio aqu&iacute;</span></strong></a></p>', 2, '2012-07-22'),
(299, 72, 'Enseñando el camino a otros', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 19.0pt; font-family: Arial; mso-ansi-language: ES;\">Ense&ntilde;ando el camino a otros</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">29 de Julio 2012</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 14.0pt; font-family: Arial; mso-ansi-language: ES;\"><a title=\"Ense&ntilde;ando el camino a otros\" href=\"http://www.a.youversion.com/events/111280\" target=\"_blank\">Ingresa al estudio aqui</a></span></span></strong></p>', 1, '2012-07-29'),
(300, 73, 'La Gran Comisión en el mundo.', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 18.0pt; font-family: Arial; mso-ansi-language: ES;\">La Gran Comisi&oacute;n en el mundo</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">5 de Agosto&nbsp;</span></strong></p>\r\n<p>&nbsp;</p>\r\n<h1><a title=\"La Gran Comisi&oacute;n en el mundo\" href=\"http://www.a.youversion.com/events/112917\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2012-08-05'),
(301, 73, 'Viviendo la Gran Comisión', '<h1 style=\"text-align: center;\">Hasta el fin del Mundo:</h1>\r\n<h1 style=\"text-align: center;\">Viviendo la Gran Comisi&oacute;n</h1>\r\n<p class=\"MsoNormal\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">12 de Agosto 2012</span></strong></p>\r\n<p class=\"MsoNormal\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\"><br /></span></strong></p>\r\n<h1 style=\"text-align: left;\"><a title=\"Viviendo la Gran Comisi&oacute;n\" href=\"http://www.a.youversion.com/events/114557\" target=\"_blank\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Ingresa al estudio aqu&iacute;</span></strong></a></h1>', 1, '2012-08-12'),
(302, 73, '¿Es La Gran Comisión un mandato para hoy?', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 19.0pt; font-family: Arial; mso-ansi-language: ES;\"><span style=\"text-decoration: underline;\">&iquest;Es la Gran Comisi&oacute;n un mandato para hoy?</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Oscar Guti&eacute;rrez</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">18/Agosto/2012&nbsp;</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><a title=\"&iquest;Un mandato para hoy?\" href=\"http://www.a.youversion.com/events/116127\" target=\"_blank\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 14.0pt; font-family: Arial; mso-ansi-language: ES;\">Ingresa al estudio aqui</span></span></strong></a></p>', 2, '2012-08-19'),
(303, 73, 'Una iglesia para los que no tienen iglesia.', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 20.0pt; font-family: Arial; mso-ansi-language: ES;\">Una iglesia para los que&nbsp;no tienen iglesia</span></strong><strong></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Steve Hutmacher</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 14.0pt; font-family: Arial; mso-ansi-language: ES;\"><a title=\"Para los que no tienen iglesia\" href=\"http://www.a.youversion.com/events/118249\" target=\"_blank\">Ingresa aqui al estudio</a></span></span></strong></p>', 7, '2012-08-26'),
(304, 74, 'José el Soñador', '', 1, '2012-09-02'),
(305, 75, 'El Antídoto contra el TEMOR', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 20.0pt; font-family: \'Eras Light ITC\'; mso-bidi-font-family: Arial; letter-spacing: 1.2pt; mso-font-kerning: 20.0pt; mso-ansi-language: ES;\">ANT&Iacute;DOTO&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 20.0pt; font-family: \'Eras Light ITC\'; mso-bidi-font-family: Arial; letter-spacing: 1.2pt; mso-font-kerning: 20.0pt; mso-ansi-language: ES;\">Contra el Temor </span><strong></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">9 de Septiembre de 2012</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: left;\" align=\"right\"><a title=\"Ant&iacute;doto contra el Temor\" href=\"http://www.a.youversion.com/events/121893\" target=\"_blank\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 14.0pt; font-family: Arial; mso-fareast-font-family: \'Times New Roman\'; mso-font-kerning: .5pt; mso-ansi-language: ES; mso-fareast-language: AR-SA; mso-bidi-language: AR-SA;\">Ingresa al estudio aqui</span></span></strong></a></p>', 1, '2012-09-09'),
(306, 75, 'El Antídoto contra el ESTRÉS', '<h1>El ANT&Iacute;DOTO CONTRA EL ESTR&Eacute;S</h1>\r\n<p>&nbsp;</p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">16 de Septiembre de 2012</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: left;\" align=\"right\"><a title=\"Estres\" href=\"http://www.a.youversion.com/events/123564\" target=\"_blank\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Ingresa al estudio aqui</span></strong></a></p>', 1, '2012-09-16'),
(307, 75, 'El Antídoto contra la TRISTEZA', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 18.0pt; font-family: \'Eras Light ITC\'; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">EL ANTIDOTO CONTRA LA TRISTEZA</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Oscar Guti&eacute;rrez</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: left;\" align=\"center\"><strong><a title=\"Tristeza\" href=\"http://www.a.youversion.com/events/125812\" target=\"_blank\"><span style=\"font-size: 18pt; font-family: \'Eras Light ITC\'; letter-spacing: 0.6pt;\">Ingresa al estudio aqui</span></a></strong></p>', 2, '2012-09-23');
INSERT INTO `mensajes` (`id_mensaje`, `id_serie`, `mensaje`, `resumen`, `id_expositor`, `fecha`) VALUES
(309, 76, '¡Las iglesias... y los cristianos son aburridos!', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 26.0pt; font-family: WoW-plexus; mso-bidi-font-family: Arial; letter-spacing: .3pt; mso-font-kerning: 26.0pt; mso-ansi-language: ES;\">Leyendas<br /> Urbanas</span><strong></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 14.5pt; font-family: \'Eras Light ITC\'; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">&iexcl;Las iglesias y los cristianos son aburridos!</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">07 de Octubre de 2012</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\">&nbsp;</p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\">&nbsp;</p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><a title=\"Las iglesias y los cristianos son aburridos\" href=\"http://www.a.youversion.com/events/129604\" target=\"_blank\"><span style=\"font-family: Arial;\"><span style=\"font-size: 19px;\"><strong><span style=\"text-decoration: underline;\">Ingresa al estudio aqui</span></strong></span></span></a></p>', 1, '2012-10-07'),
(310, 76, '¡La iglesia esta llena de fanáticos!', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 26.0pt; font-family: WoW-plexus; mso-bidi-font-family: Arial; letter-spacing: .3pt; mso-font-kerning: 26.0pt; mso-ansi-language: ES;\">Leyendas<br /> Urbanas</span><strong></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 18.0pt; font-family: \'Eras Light ITC\'; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">&iexcl;La iglesia esta llena de fan&aacute;ticos!</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Allan Handal</span></strong></p>\r\n<h1 class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-family: Arial; mso-ansi-language: ES;\"><a title=\"&iexcl;La iglesia esta llena de fan&aacute;ticos!\" href=\"http://www.a.youversion.com/events/131515\" target=\"_blank\">Ingrese al estudio aqui</a></span></span></strong></h1>', 3, '2012-10-14'),
(311, 76, '¡Los cristianos son negativos y criticones!', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 26.0pt; font-family: WoW-plexus; mso-bidi-font-family: Arial; letter-spacing: .3pt; mso-font-kerning: 26.0pt; mso-ansi-language: ES;\">Leyendas<br /> Urbanas</span><strong></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 14.0pt; font-family: \'Eras Light ITC\'; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">&iexcl;Los cristianos son negativos y criticones!</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"center\"><strong><span style=\"font-size: 14.0pt; font-family: \'Eras Light ITC\'; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">21 de Octubre</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"center\"><strong><span style=\"font-size: 14.0pt; font-family: \'Eras Light ITC\'; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: left;\" align=\"center\"><a title=\"Negativos y Criticones\" href=\"Entonces%20Jes&uacute;s%20le%20dijo:%20&mdash;Ni%20yo%20te%20condeno;%20vete%20y%20no%20peques%20m&aacute;s.%20\" target=\"_blank\"><strong><span style=\"font-size: 14.0pt; font-family: \'Eras Light ITC\'; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">Ingresa al estudio aqui</span></strong></a></p>', 3, '2012-10-21'),
(312, 76, '¡A los cristianos les obligan a dar dinero!', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 26.0pt; font-family: WoW-plexus; mso-bidi-font-family: Arial; letter-spacing: .3pt; mso-font-kerning: 26.0pt; mso-ansi-language: ES;\">Leyendas<br /> Urbanas</span><strong></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 14.0pt; font-family: Calibri; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">&iexcl;A los cristianos los obligan a dar dinero!</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">28 de Octubre de 2012</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">&nbsp;</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 14.0pt; font-family: Arial; mso-ansi-language: ES;\"><a title=\"&iexcl;A los cristianos los obligan a dar dinero!\" href=\"http://www.a.youversion.com/events/135751\" target=\"_blank\">Ingresa al estudio aqui</a></span></span></strong></p>', 8, '2012-10-28'),
(313, 77, 'Tu Combinación', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 36.0pt; font-family: \'Nova SOLID\'; mso-bidi-font-family: Arial; letter-spacing: .3pt; mso-font-kerning: 26.0pt; mso-ansi-language: ES;\">Muy original</span><strong></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 16.0pt; font-family: Calibri; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">Tu Combinaci&oacute;n</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">4 de Noviembre</span></strong></p>\r\n<p><a title=\"Tu Combinaci&oacute;n\" href=\"http://www.a.youversion.com/events/137536\" target=\"_blank\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Ingresa al estudio aqui</span></strong></a></p>', 1, '2012-11-04'),
(314, 77, 'Tu Humildad', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 29.0pt; font-family: \'Nova SOLID\'; mso-bidi-font-family: Arial; letter-spacing: .3pt; mso-font-kerning: 26.0pt; mso-ansi-language: ES;\">Muy original</span></p>\r\n<table cellspacing=\"0\" cellpadding=\"0\">\r\n<tbody>\r\n<tr>\r\n<td style=\"vertical-align: top;\" width=\"383\" height=\"74\"><!--[endif]--><!--[if !mso]--><span style=\"position: absolute; mso-ignore: vglayout; left: 0pt; z-index: 1;\"><br /> </span><!--[endif]--><!--[if !mso & !vml]-->&nbsp;<!--[endif]--><!--[if !vml]--></td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p class=\"MsoNormal\" align=\"center\"><!--[endif]--><strong><span style=\"font-size: 14.0pt; font-family: Calibri; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">Tu Humildad</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-family: Arial; font-size: x-small;\"><strong>11 de Noviembre de 2012</strong></span></p>\r\n<h1 class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-family: Arial; mso-ansi-language: ES;\"><a title=\"Tu Humildad\" href=\"http://www.a.youversion.com/events/139468\" target=\"_blank\">Ingresa al estudio aqui</a></span></span></strong></h1>', 1, '2012-11-11'),
(315, 77, 'Tu Amabilidad', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 34.0pt; font-family: \'Nova SOLID\'; mso-bidi-font-family: Arial; letter-spacing: .3pt; mso-font-kerning: 26.0pt; mso-ansi-language: ES;\">Muy original</span><strong></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 18.0pt; font-family: Calibri; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">Tu Amabilidad</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">18 de Noviembre de 2012 &nbsp;</span></strong></p>\r\n<p><a title=\"Tu Amabilidad\" href=\"http://www.a.youversion.com/events/141512\" target=\"_blank\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 14.0pt; font-family: Arial; mso-fareast-font-family: \'Times New Roman\'; mso-font-kerning: .5pt; mso-ansi-language: ES; mso-fareast-language: AR-SA; mso-bidi-language: AR-SA;\">Ingresa al estudio aqui</span></span></strong></a></p>', 8, '2012-11-18'),
(316, 77, 'Tu Cristianismo', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><span style=\"font-size: 34.0pt; font-family: \'Nova SOLID\'; mso-bidi-font-family: Arial; letter-spacing: .3pt; mso-font-kerning: 26.0pt; mso-ansi-language: ES;\">Muy original</span><strong></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 18.0pt; font-family: Calibri; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">Tu Cristianismo</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-family: Arial; font-size: x-small;\"><strong>25 de Noviembre de 2012</strong></span></p>\r\n<p class=\"MsoNormal\"><span style=\"font-size: 14.0pt; font-family: Arial;\" lang=\"ES-MX\"><a title=\"Tu Cristianismo\" href=\"http://www.a.youversion.com/events/143134\" target=\"_blank\">Ingresa al estudio aqui</a></span></p>', 8, '2012-11-21'),
(317, 78, '¡Ellos querían estar ahí!', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 24.0pt; font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">UNA SABIA NAVIDAD</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 16.0pt; font-family: Calibri; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">&iexcl;Los reyes magos quer&iacute;an estar ah&iacute;!</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">2 de Diciembre de 2012</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 14.0pt; font-family: Arial; mso-ansi-language: ES;\"><a title=\"Mensaje\" href=\"http://www.a.youversion.com/events/145165\" target=\"_blank\">Ingresa al estudio aqui</a></span></span></strong></p>', 8, '2012-12-02'),
(318, 78, '¡Ellos se alegraron!', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 24.0pt; font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">UNA SABIA NAVIDAD</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 16.0pt; font-family: Calibri; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">&iexcl;Ellos se regocijaron!</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 14.0pt; font-family: Arial;\" lang=\"ES-MX\"><a title=\"Ellos se alegraron\" href=\"http://www.a.youversion.com/events/147050\" target=\"_blank\">Ingresa al estudio aqui</a></span></span></strong></p>', 1, '2012-12-09'),
(319, 78, '¡Ellos lo reconocieron como Rey!', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 24.0pt; font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">UNA SABIA NAVIDAD</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 16.0pt; font-family: Calibri; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">&iexcl;Ellos lo reconocieron como Rey!</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Allan Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">16 de Diciembre de 2012</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 14.0pt; font-family: Arial;\" lang=\"ES-MX\"><a title=\"&iexcl;Ellos lo reconocieron como Rey!\" href=\"http://www.a.youversion.com/events/148889\" target=\"_self\">Ingresa al estudio aqui</a></span></span></strong></p>', 3, '2012-12-16'),
(320, 78, '¡El rey ha llegado!', '<h1 style=\"text-align: center;\">Una Sabia Navidad</h1>\r\n<h1 style=\"text-align: center;\">&iexcl;El Rey ha llegado!</h1>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">&nbsp;</p>\r\n<h2><a title=\"&iexcl;El Rey ha llegado!\" href=\"http://es.a.youversion.com/events/150377\" target=\"_blank\">Ingresa al estudio aqui</a></h2>', 1, '2012-12-23'),
(321, 78, '¡Sabiduría para el 2013!', '<p class=\"MsoNormal\" style=\"text-align: center;\"><strong><span style=\"font-size: 24.0pt; font-family: \'Arial\',\'sans-serif\'; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\" lang=\"ES\">UNA SABIA NAVIDAD</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 16.0pt; font-family: \'Calibri\',\'sans-serif\'; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\" lang=\"ES\">&iexcl;Sabidur&iacute;a para el 2013!</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">6 de Enero del 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 14.0pt; font-family: \'Arial\',\'sans-serif\';\" lang=\"ES-MX\"><a title=\"Sabidur&iacute;a para el 2013\" href=\"http://es.a.youversion.com/events/153430\" target=\"_blank\">Ingresa al estudio aqu&iacute;.</a></span></span></strong></p>', 1, '2013-01-06'),
(322, 79, 'El poder de un sueño', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"font-size: 18.0pt; font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">COMO CREAR Y CUMPLIR TUS SUE&Ntilde;OS</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 16.0pt; font-family: Calibri; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">EL PODER DE UN SUE&Ntilde;O</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">13 de Enero de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">&nbsp;</span></strong></p>\r\n<p><a title=\"El Poder de un Sue&ntilde;o\" href=\"http://www.a.youversion.com/events/156270\" target=\"_blank\"><span style=\"text-decoration: underline;\"><span style=\"font-size: 14.0pt; font-family: Arial; mso-fareast-font-family: \'Times New Roman\'; mso-font-kerning: .5pt; mso-ansi-language: ES-MX; mso-fareast-language: AR-SA; mso-bidi-language: AR-SA;\" lang=\"ES-MX\">Ingresa al estudio aqui&nbsp;</span></span></a></p>', 1, '2013-01-13'),
(323, 79, ' El poder de caminar en pos de un sueño', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 18.0pt; font-family: Calibri; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">EL PODER DE CAMINAR </span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 18.0pt; font-family: Calibri; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">EN POS DE UN SUE&Ntilde;O</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">20 de Enero de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">&nbsp;</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 14.0pt; font-family: Arial;\" lang=\"ES-MX\"><a title=\"El poder de caminar en pos de un sue&ntilde;o\" href=\"http://www.a.youversion.com/events/186445\" target=\"_blank\">Ingresa al estudio aqu&iacute;</a></span></span></strong></p>', 1, '2013-01-20'),
(324, 80, 'Borrar, no señalar', '<p class=\"MsoNormal\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 48pt; font-family: Calibri; letter-spacing: 0.6pt; background-position: initial initial; background-repeat: initial initial;\" lang=\"ES-MX\">SI &amp; NO</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 18.0pt; font-family: Calibri; mso-bidi-font-family: Arial; letter-spacing: .6pt; mso-font-kerning: 22.0pt; mso-ansi-language: ES;\">Borrar, no se&ntilde;alar</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">3 de Febrero de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: Arial; mso-ansi-language: ES;\">&nbsp;</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: justify;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 14.0pt; font-family: Arial;\" lang=\"ES-MX\"><a title=\"Borrar, no se&ntilde;alar\" href=\"http://www.a.youversion.com/events/191129\" target=\"_blank\">Ingresa al estudio aqui</a></span></span></strong></p>', 1, '2013-02-03'),
(325, 80, 'Restaurar, no juzgar', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 48pt; font-family: Calibri; letter-spacing: 0.6pt;\" lang=\"ES-MX\">SI &amp; NO</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 18pt; font-family: Calibri; letter-spacing: 0.6pt;\">Restaurar, no juzgar</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial;\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial;\">10 de Febrero de 2013</span></strong></p>\r\n<h1><a title=\"Restaurar, no juzgar\" href=\"http://www.a.youversion.com/events/193471\" target=\"_blank\"><strong><span style=\"font-size: 10pt; font-family: Arial;\">Ingresa al estudio aqui</span></strong></a></h1>', 1, '2013-02-10'),
(326, 80, 'Admirar, no envidiar', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 48pt; font-family: Calibri; letter-spacing: 0.6pt;\" lang=\"ES-MX\">SI &amp; NO</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Calibri; font-size: large;\"><span style=\"line-height: 19.1875px;\"><strong><span style=\"text-decoration: underline;\">Admirar, no envidiar</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial;\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial;\">17 de Febrero de 2013</span></strong></p>\r\n<h1><a title=\"Admirar, no envidiar\" href=\"http://es.a.youversion.com/events/195796\" target=\"_blank\"><strong><span style=\"font-size: 10pt; font-family: Arial;\">Ingresa al estudio aqui</span></strong></a></h1>', 1, '2013-02-17'),
(327, 80, 'Actuar, no hablar', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 48pt; font-family: Calibri; letter-spacing: 0.6pt;\" lang=\"ES-MX\">SI &amp; NO</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Calibri; font-size: large;\"><span><strong><span style=\"text-decoration: underline;\">Actuar, no hablar</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial;\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial;\">24 de Febrero de 2013</span></strong></p>\r\n<h1><a title=\"Actuar, no hablar\" href=\"http://es.a.youversion.com/events/198067\" target=\"_blank\"><strong><span style=\"font-size: 10pt; font-family: Arial;\">Ingresa al estudio aqui</span></strong></a></h1>', 1, '2013-02-24'),
(328, 81, 'Nuestros ejemplos de amor', '<h1 style=\"text-align: center;\">AMOR</h1>\r\n<h1 style=\"text-align: center;\">AUTENTICO</h1>\r\n<p class=\"MsoNormal\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 16.0pt; font-family: \'Calibri\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">&ldquo;Nuestros ejemplos de amor&rdquo;</span></span></strong></p>\r\n<p style=\"text-align: right;\"><span style=\"font-family: Calibri, sans-serif;\"><span style=\"font-size: 21px;\">Pastor Sregio Handal</span></span></p>\r\n<p style=\"text-align: right;\"><span style=\"font-family: Calibri, sans-serif;\"><span style=\"font-size: 21px;\">3 de Marzo del 2013</span></span></p>\r\n<p style=\"text-align: left;\"><a title=\"Nuestros ejemplos de amor\" href=\"http://es.a.youversion.com/events/199807\" target=\"_blank\"><span style=\"font-family: Calibri, sans-serif;\"><span style=\"font-size: 21px;\">Ingrese al estudio aqu&iacute;</span></span></a></p>', 1, '2013-03-03'),
(329, 81, 'Amor indestructible ', '<h1 style=\"text-align: center;\">AMOR</h1>\r\n<h1 style=\"text-align: center;\">AUTENTICO</h1>\r\n<p class=\"MsoNormal\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 16.0pt; font-family: \'Calibri\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">&ldquo;Amor Indestructibel&rdquo;</span></span></strong></p>\r\n<p style=\"text-align: right;\"><span style=\"font-family: Calibri, sans-serif;\"><span style=\"font-size: 21px;\">Pastor Sregio Handal</span></span></p>\r\n<p style=\"text-align: right;\"><span style=\"font-family: Calibri, sans-serif;\"><span style=\"font-size: 21px;\">17 de Marzo del 2013</span></span></p>\r\n<p><a title=\"Amor Indestructible\" href=\"http://es.a.youversion.com/events/205066\" target=\"_blank\"><span style=\"font-family: Calibri, sans-serif;\"><span style=\"font-size: 21px;\">Ingrese al estudio aqu&iacute;</span></span></a></p>', 1, '2013-03-17'),
(330, 81, 'Amor sin palabras', '<h1 style=\"margin: 0em 0em 1em; padding: 0px 0px 12px; font-weight: normal; font-family: \'Myriad Pro\', Mako, \'Trebuchet MS\', sans-serif; text-align: center;\">AMOR</h1>\r\n<h1 style=\"margin: 0em 0em 1em; padding: 0px 0px 12px; font-weight: normal; font-family: \'Myriad Pro\', Mako, \'Trebuchet MS\', sans-serif; text-align: center;\">AUTENTICO</h1>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 16pt; font-family: Calibri, sans-serif;\" lang=\"ES\">&ldquo;Nuestros ejemplos de amor&rdquo;</span></span></strong></p>\r\n<p style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\"><span style=\"font-family: Calibri, sans-serif;\"><span style=\"font-size: 21px;\">Pastor Sregio Handal</span></span></p>\r\n<p style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\"><span style=\"font-family: Calibri, sans-serif;\"><span style=\"font-size: 21px;\">10 de Marzo del 2013</span></span></p>\r\n<p style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\"><a title=\"Amor sin palabras\" href=\"http://es.a.youversion.com/events/202789\" target=\"_blank\"><span style=\"font-family: Calibri, sans-serif;\"><span style=\"font-size: 21px;\">Ingrese al estudio aqu&iacute;</span></span></a></p>', 1, '2013-03-10'),
(331, 81, 'El puente que extendí salvo a muchos', '<h1 style=\"margin: 0em 0em 1em; padding: 0px 0px 12px; font-weight: normal; font-family: \'Myriad Pro\', Mako, \'Trebuchet MS\', sans-serif; text-align: center;\"><span style=\"font-size: 18.0pt; mso-bidi-font-size: 14.0pt; font-family: \'Arial\',\'sans-serif\'; mso-fareast-font-family: \'Times New Roman\'; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA;\" lang=\"ES\">EL PUENTE QUE EXTEND&Iacute; SALVO A MUCHOS</span></h1>\r\n<p style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\"><span style=\"font-family: Calibri, sans-serif;\"><span style=\"font-size: 21px;\">Pastor Sregio Handal</span></span></p>\r\n<p style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\"><span style=\"font-family: Calibri, sans-serif;\"><span style=\"font-size: 21px;\">17 de Abril del 2013</span></span></p>\r\n<p style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\"><a title=\"El Puente\" href=\"http://es.a.youversion.com/events/211799\" target=\"_blank\"><span style=\"font-family: Calibri, sans-serif;\"><span style=\"font-size: 21px;\">Ingrese al estudio aqu&iacute;</span></span></a></p>', 1, '2013-04-07'),
(333, 82, 'El trabajo ideal de Dios para ti', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif; font-size: large;\"><strong><span style=\"text-decoration: underline;\">DIOS Y MIS NEGOCIOS</span></strong></span></p>\r\n<p class=\"MsoNormal\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 18.0pt; mso-bidi-font-size: 16.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">EL TRABAJO IDEAL DE DIOS PARA TI</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; font-size: x-small;\">21 de Abril</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; font-size: x-small;\"><br /></span></p>\r\n<h1><a title=\"El trabajo ideal\" href=\"http://es.a.youversion.com/events/216427\" target=\"_blank\"><span style=\"font-family: Arial, sans-serif; font-size: x-small;\">Ingresa al estudio aqui</span></a></h1>', 1, '2013-04-21'),
(334, 82, 'Haciendo decisiones sabias en el trabajo', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif; font-size: large;\"><strong><span style=\"text-decoration: underline;\">DIOS Y MIS NEGOCIOS</span></strong></span></p>\r\n<p class=\"MsoNormal\" align=\"center\"><span style=\"font-family: Arial, sans-serif; font-size: large;\"><strong><span style=\"text-decoration: underline;\">Haciendo decisiones sabias en el trabajo</span></strong></span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; font-size: x-small;\">28 de Abril</span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; font-size: x-small;\"><br /></span></p>\r\n<h1><a title=\"Decisiones sabias\" href=\"http://es.a.youversion.com/events/218805\" target=\"_blank\"><span style=\"font-family: Arial, sans-serif; font-size: x-small;\">Ingresa al estudio aqui</span></a></h1>', 1, '2013-04-28'),
(335, 82, '¿Cómo destacarse en el trabajo?', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 18.0pt; mso-bidi-font-size: 16.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">Como destacarse en el trabajo</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">Domingo 5 de Mayo 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: left;\" align=\"center\"><a title=\"Como destacarse en el trabajo\" href=\"http://es.a.youversion.com/events/220749\" target=\"_blank\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 18.0pt; mso-bidi-font-size: 16.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">Ingresa al estudio aqui</span></span></strong></a></p>', 1, '2013-05-05'),
(336, 82, 'El propósito de trabajar', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif; font-size: large;\"><strong><span style=\"text-decoration: underline;\">DIOS Y MIS NEGOCIOS</span></strong></span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 18.0pt; mso-bidi-font-size: 16.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">EL PROPOSITO DE TRABAJAR</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; font-size: x-small;\"><strong>14 de Abril</strong></span></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; font-size: x-small;\"><strong><br /></strong></span></p>\r\n<h1><a title=\"El Prop&oacute;sito de trabajar\" href=\"http://es.a.youversion.com/events/214174\" target=\"_blank\"><span style=\"font-family: Arial, sans-serif; font-size: x-small;\"><strong>Ingresa al estudio aqui</strong></span></a></h1>', 1, '2013-04-14'),
(337, 83, 'La diferencia entre el fanático y el seguidor.', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 20.0pt; mso-bidi-font-size: 16.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">La Diferencia Entre el Fanatico y el Seguidor.</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">12 de Mayo de 2012</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: left;\" align=\"center\"><strong><span><span style=\"font-size: 20.0pt; mso-bidi-font-size: 16.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\"><a title=\"La diferencia\" href=\"http://es.a.youversion.com/events/222761\" target=\"_blank\">Ingresa al estudio aqui.</a></span></span></strong></p>\r\n<div><strong><span><br /></span></strong></div>', 1, '2013-05-12'),
(338, 83, 'La fuerza interna del seguidor.', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 20.0pt; mso-bidi-font-size: 16.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">La Fuerza Interna del Seguidor.</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">Alan Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">19 de Mayo de 2012</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: left;\" align=\"center\"><a title=\"La Fuerza Interna del Seguidor\" href=\"http://es.a.youversion.com/events/225501\" target=\"_blank\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 20.0pt; mso-bidi-font-size: 16.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">Ingresa al estudio aqui.</span></span></strong></a></p>\r\n<p class=\"MsoNormal\" align=\"right\">&nbsp;</p>', 3, '2013-05-19'),
(339, 83, '¿Cómo vive el seguidor?', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 20.0pt; mso-bidi-font-size: 16.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">&iquest;C&oacute;mo vive el Seguidor?</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">26 de Mayo de 2012</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: left;\" align=\"center\"><strong><span><span style=\"font-size: 20.0pt; mso-bidi-font-size: 16.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\"><a title=\"&iquest;C&oacute;mo vive el seguidor?\" href=\"http://es.a.youversion.com/events/227610\" target=\"_blank\">Ingresa al estudio aqui.</a></span></span></strong></p>\r\n<div><strong><span><br /></span></strong></div>', 1, '2013-05-26'),
(340, 83, 'El camino diario del seguidor.', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 20.0pt; mso-bidi-font-size: 16.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">El camino diario del seguidor</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">2 de Junio de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20.0pt; mso-bidi-font-size: 16.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\"><a title=\"El camino diario del seguidor\" href=\"http://es.a.youversion.com/events/230126\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>\r\n<div><strong><br /></strong></div>', 1, '2013-06-02'),
(341, 84, 'Aprendiendo a ser un buen esposo', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 20.0pt; mso-bidi-font-size: 16.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">Aprendiendo a ser un buen esposo</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">9 de Junio de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: left;\" align=\"center\"><a title=\"Un buen esposo\" href=\"http://es.a.youversion.com/events/232151\" target=\"_blank\"><strong><span style=\"font-size: 20.0pt; mso-bidi-font-size: 16.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">Ingresa al estudio aqui.</span></strong></a></p>\r\n<div><strong><br /></strong></div>', 1, '2013-06-09'),
(342, 84, 'Aprendiendo a ser una buena esposa', '<p class=\"MsoNormal\" style=\"text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 20.0pt; mso-bidi-font-size: 16.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">Aprendiendo a ser una buena esposa</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\">23 de Junio de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20.0pt; mso-bidi-font-size: 16.0pt; font-family: \'Arial\',\'sans-serif\'; mso-ansi-language: ES;\" lang=\"ES\"><a title=\"Una buena esposa\" href=\"http://es.a.youversion.com/events/236228\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>\r\n<div><strong><br /></strong></div>', 1, '2013-06-23'),
(343, 84, 'Aprendiendo a ser un buen padre', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\">Aprendiendo a ser un buen padre</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">16 de Junio de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"Un buen padre\" href=\"http://es.a.youversion.com/events/234444\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>\r\n<div><strong><br /></strong></div>', 1, '2013-06-16');
INSERT INTO `mensajes` (`id_mensaje`, `id_serie`, `mensaje`, `resumen`, `id_expositor`, `fecha`) VALUES
(344, 84, 'Aprendiendo a ser un buen hijo', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\">Aprendiendo a ser un buen hijo</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">30 de Junio de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"Un buen hijo.\" href=\"http://es.a.youversion.com/events/238534\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>', 1, '2013-06-30'),
(345, 84, 'Aprendiendo a ser un buen empleado', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\">Aprendiendo a ser un buen empleado</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">7 de Julio de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"Un buen empleado\" href=\"http://es.a.youversion.com/events/240261\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>', 1, '2013-07-07'),
(346, 84, 'Aprendiendo a ser un buen jefe', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\">Aprendiendo a ser un buen jefe</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">14 de Julio de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"Un buen jefe\" href=\"http://es.a.youversion.com/events/242435\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>', 1, '2013-07-14'),
(347, 84, 'Aprendiendo a ser un buen compañero', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\">Aprendiendo a ser un buen compa&ntilde;ero</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Isaac Pineda</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">21 de Julio de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><a title=\"Un buen compa&ntilde;ero\" href=\"http://es.a.youversion.com/events/244243\" target=\"_blank\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\">Ingresa al estudio aqui.</span></strong></a></p>\r\n<div><strong><br /></strong></div>', 9, '2013-07-21'),
(348, 84, 'El corazón de un aprendiz', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px; line-height: 19.1875px;\"><strong><span style=\"text-decoration: underline;\">El coraz&oacute;n de un aprendiz</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Allan Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">28 de Julio de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"El coraz&oacute;n de un aprendiz\" href=\"http://es.a.youversion.com/events/246397\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>\r\n<div><strong><br /></strong></div>', 3, '2013-07-28'),
(349, 85, 'Por ella somos: Rescatados', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px; line-height: 19.1875px;\"><strong><span style=\"text-decoration: underline;\">GRACIA - Por ella somos: Rescatados&nbsp;</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">4 de Agosto de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"Rescatados\" href=\"http://es.a.youversion.com/events/248597\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>', 1, '2013-08-04'),
(350, 85, 'Por ella somos: Aceptados', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">GRACIA - Por ella somos: Aceptados&nbsp;</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">11 de Agosto de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"Aceptados\" href=\"http://es.a.youversion.com/events/250611\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>\r\n<div><strong><br /></strong></div>', 1, '2013-08-11'),
(351, 85, 'Por ella somos: Salvos', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">GRACIA - Por ella somos: Salvos&nbsp;</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Adri&aacute;n Rivera</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">18 de Agosto de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"Salvos\" href=\"http://es.a.youversion.com/events/252805\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>\r\n<div style=\"font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\"><strong><br /></strong></div>', 10, '2013-08-18'),
(352, 85, 'Por ella somos: Comisionados', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">GRACIA - Por ella somos: Comisionados&nbsp;</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">25 de Agosto de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><a title=\"Comisionados\" href=\"http://es.a.youversion.com/events/255024\" target=\"_blank\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\">Ingresa al estudio aqui.</span></strong></a></p>\r\n<div style=\"text-align: left;\"><strong><br /></strong></div>', 1, '2013-08-25'),
(353, 86, 'Nosotros y las Finanzas', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">NOSOTROS Y LAS FINANZA$</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">Como vivir BIEN cuando las cosas van Mal</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Dr. Andres Panasiuk</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">1 de Septiembre de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><a title=\"BIEN cuando las cosas van Mal\" href=\"http://www.a.youversion.com/events/256844\" target=\"_blank\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\">Ingresa al estudio aqui.</span></strong></a></p>\r\n<div style=\"text-align: left;\"><strong><br /></strong></div>', 11, '2013-09-01'),
(354, 86, 'Dos caminos probados para mejorar las finanzas.', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">NOSOTROS Y LAS FINANZA$</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">Dos caminos probados</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\"> para mejorar las finalzas</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Alla Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">15 de Septiembre de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"Mejorar las finanzas\" href=\"http://es.a.youversion.com/events/261693\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>', 3, '2013-09-15'),
(355, 86, '¿Estoy condenado a vivir eternamente endeudado?', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">NOSOTROS Y LAS FINANZA$</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px; line-height: 19.1875px;\"><strong><span style=\"text-decoration: underline;\">&iquest;Estoy condenado </span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px; line-height: 19.1875px;\"><strong><span style=\"text-decoration: underline;\">a vivir eternamente endeudado?</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">8 de Septiembre de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"&iquest;Eternamente endeudado?\" href=\"http://es.a.youversion.com/events/259186\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>\r\n<div><strong><br /></strong></div>', 1, '2013-09-08'),
(356, 86, '¿Comprar o no comprar?', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">NOSOTROS Y LAS FINANZA$</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">&iquest;Comprar o no comprar</span></strong></span></span><strong style=\"font-size: 27px; font-family: Arial, sans-serif; line-height: 1.6em;\"><span style=\"text-decoration: underline;\">?</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">22 de Septiembre de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"&iquest;Comprar o no comprar?\" href=\"http://es.a.youversion.com/events/264233\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>', 1, '2013-09-22'),
(357, 87, 'Inspiración para cuando ya no hay fuerzas', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">INSPIRACI&Oacute;N</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">Para cuando ya no hay fuerzas</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">6 de Octubre de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><a title=\"Para cuando ya no hay fuerzas\" href=\"http://es.a.youversion.com/events/269077\" target=\"_blank\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\">Ingresa al estudio aqui.</span></strong></a></p>', 1, '2013-10-06'),
(358, 87, 'Ejemplos que inspiran', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">INSPIRACI&Oacute;N</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">Ejemplos que inspiran</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Isaac Pineda</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">13 de Octubre de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><a title=\"Ejemplos que inpiran\" href=\"http://es.a.youversion.com/events/271385\" target=\"_blank\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\">Ingresa al estudio aqui.</span></strong></a></p>\r\n<div><strong><br /></strong></div>', 9, '2013-10-13'),
(359, 87, 'Una visión que te lleva a grandes cosas', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">INSPIRACI&Oacute;N</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px; line-height: 19.1875px;\"><strong><span style=\"text-decoration: underline;\">Una visi&oacute;n que te lleva a grandes cosas</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Adrian Rivera</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">20 de Octubre de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"Visi&oacute;n que te lleva a grandes cosas\" href=\"http://es.a.youversion.com/events/273595\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>\r\n<div><strong><br /></strong></div>', 10, '2013-10-20'),
(360, 87, 'Inspirando a otros', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">INSPIRACI&Oacute;N</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">Inspirando a otros</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">27 de Octubre de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"Inspirando a otros\" href=\"http://es.a.youversion.com/events/275647\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>\r\n<div><strong><br /></strong></div>', 1, '2013-10-27'),
(361, 88, 'Primera joya: Parámetros para una sana conversación', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px; line-height: 19.1875px;\"><strong><span style=\"text-decoration: underline;\">JOYAS</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px; line-height: 19.1875px;\"><strong><span style=\"text-decoration: underline;\">Par&aacute;metros para una sana conversaci&oacute;n</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">3 de Noviembre de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"Una sana conversaci&oacute;n\" href=\"http://es.a.youversion.com/events/278243\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>', 1, '2013-11-03'),
(362, 88, 'Segunda joya: Aprovechando el tiempo', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">JOYAS</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">Aporvechando el tiempo</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">10 de Noviembre de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"Aprovechando el tiempo\" href=\"http://es.a.youversion.com/events/280218\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>\r\n<div><strong><br /></strong></div>', 1, '2013-11-10'),
(363, 88, 'Tercera joya: El papel de una esposa', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">JOYAS</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">El papel de una esposa</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Allan Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">17 de Noviembre de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"El papel de una esposa\" href=\"http://es.a.youversion.com/events/282291\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>', 3, '2013-11-17'),
(364, 88, 'Cuarta joya: El papel de un esposo', '<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">JOYAS</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: center;\" align=\"center\"><span style=\"font-family: Arial, sans-serif;\"><span style=\"font-size: 27px;\"><strong><span style=\"text-decoration: underline;\">El papel de un esposo</span></strong></span></span></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">24 de Noviembre de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"El papel de un esposo\" href=\"http://es.a.youversion.com/events/284904\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>\r\n<div><strong><br /></strong></div>', 1, '2013-11-24'),
(365, 89, 'Las Trampas del Diablo', '', 13, '2013-09-28'),
(366, 89, 'Revolución del Espíritu', '', 1, '2013-09-27'),
(367, 89, 'Las Trampas del Diablo', '', 13, '2013-09-28'),
(368, 89, 'La Voz del Espíritu Santo', '', 12, '2013-09-28'),
(369, 89, 'Un Enemigo Silencioso: El Orgullo', '', 14, '2013-09-28'),
(370, 89, 'Reconociendo y Ganando la Batalla Interior', '', 13, '2013-09-28'),
(371, 89, 'El poder de Dios en Acción (Coloquio)', '', 1, '2013-09-29'),
(372, 90, 'La Navidad y el pobre', '<h1 style=\"margin: 12px 0px 0em; padding: 0px; border: 0px; outline: 0px; font-size: 30px; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; width: 700px !important; text-align: center;\">EL IMPERIO DE LA PAZ</h1>\r\n<h1 style=\"margin: 12px 0px 0em; padding: 0px; border: 0px; outline: 0px; font-size: 30px; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; width: 700px !important; text-align: center;\"><strong style=\"font-size: 27px; font-family: Arial, sans-serif; line-height: 1.6em; color: #000000;\"><span style=\"text-decoration: underline;\">La navidad y el pobre</span></strong></h1>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">1 de Diciembre de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><a title=\"La navidad y el pobre\" href=\"http://es.a.youversion.com/events/286737\" target=\"_blank\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\">Ingresa al estudio aqui.</span></strong></a></p>\r\n<div><a title=\"La navidad y el pobre\" href=\"http://es.a.youversion.com/events/286737\" target=\"_blank\"><strong><br /></strong></a></div>', 1, '2013-12-01'),
(373, 90, 'La Navidad y mi familia ', '<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\">EL IMPERIO DE LA PAZ</h1>\r\n<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\"><strong style=\"font-size: 27px; font-family: Arial, sans-serif; line-height: 1.6em; color: #000000;\"><span style=\"text-decoration: underline;\">La navidad y mi familia</span></strong></h1>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">8 de Diciembre de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"Mi Familia\" href=\"http://es.a.youversion.com/events/288743\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>', 1, '2013-12-08');
INSERT INTO `mensajes` (`id_mensaje`, `id_serie`, `mensaje`, `resumen`, `id_expositor`, `fecha`) VALUES
(374, 90, 'La Navidad y la paz', '<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\">EL IMPERIO DE LA PAZ</h1>\r\n<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\"><strong style=\"font-size: 27px; font-family: Arial, sans-serif; line-height: 1.6em; color: #000000;\"><span style=\"text-decoration: underline;\">La navidad y la paz</span></strong></h1>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">15 de Diciembre de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><a title=\"La Navidad y la paz\" href=\"http://es.a.youversion.com/events/291326\" target=\"_blank\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\">Ingresa al estudio aqui.</span></strong></a></p>', 1, '2013-12-15'),
(375, 90, 'El imperio de la paz ', '<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\">EL IMPERIO DE LA PAZ</h1>\r\n<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\"><strong style=\"font-size: 27px; font-family: Arial, sans-serif; line-height: 1.6em; color: #000000;\"><span style=\"text-decoration: underline;\">El imperio de la paz</span></strong></h1>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">22 de Diciembre de 2013</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"El imperio de la paz\" href=\"http://www.a.youversion.com/events/293431\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>', 1, '2013-12-22'),
(376, 91, '¿Visión o Confusión?', '<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\">PERSISTENCIA</h1>\r\n<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\"><strong style=\"font-size: 27px; font-family: Arial, sans-serif; line-height: 1.6em; color: #000000;\"><span style=\"text-decoration: underline;\">&iquest;Visi&oacute;n o Confusi&oacute;n?</span></strong></h1>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">5 de Enero de 2014</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"&iquest;Visi&oacute;n o Confusi&oacute;n?\" href=\"http://es.a.youversion.com/events/296966\" target=\"_blank\">Ingresa al estudio aqui.</a></span></strong></p>', 1, '2014-01-05'),
(377, 91, 'Persistencia al Éxito', '<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\">PERSISTENCIA</h1>\r\n<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\"><strong style=\"font-size: 27px; font-family: Arial, sans-serif; line-height: 1.6em; color: #000000;\"><span style=\"text-decoration: underline;\">Persistencia al &eacute;xito</span></strong></h1>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">12 de Enero de 2014</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><a title=\"&Eacute;xito \" href=\"http://es.a.youversion.com/events/299147\" target=\"_blank\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\">Ingresa al estudio aqu&iacute;.</span></strong></a></p>\r\n<div><strong><br /></strong></div>', 1, '2014-01-12'),
(378, 91, 'Persistencia en la Familia', '<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\">PERSISTENCIA</h1>\r\n<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\"><strong style=\"font-size: 27px; font-family: Arial, sans-serif; line-height: 1.6em; color: #000000;\"><span style=\"text-decoration: underline;\">Persistencia en la familia</span></strong></h1>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">19 de Enero de 2014</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"Persistencia en la familia.\" href=\"http://es.a.youversion.com/events/301669\" target=\"_blank\">Ingresa al estudio aqu&iacute;.</a></span></strong></p>', 1, '2014-01-19'),
(379, 91, 'Persistencia en mis Finanzas', '<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\">PERSISTENCIA</h1>\r\n<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\"><strong style=\"font-size: 27px; font-family: Arial, sans-serif; line-height: 1.6em; color: #000000;\"><span style=\"text-decoration: underline;\">Persistencia en mis finanzas</span></strong></h1>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">26 de Enero de 2014</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"Finanzas\" href=\"http://es.a.youversion.com/events/304592\" target=\"_blank\">Ingresa al estudio aqu&iacute;.</a></span></strong></p>', 1, '2014-01-26'),
(381, 92, 'Los tipos de amigos', '<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\">CUATES PARA SIEMPRE</h1>\r\n<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\"><strong style=\"font-size: 27px; font-family: Arial, sans-serif; line-height: 1.6em; color: #000000;\"><span style=\"text-decoration: underline;\">Tipos de amigos</span></strong></h1>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">2 de Febrero de 2014</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"Tipos de amigos\" href=\"http://es.a.youversion.com/events/307163\" target=\"_blank\">Ingresa al estudio aqu&iacute;.</a></span></strong></p>', 1, '2014-02-02'),
(382, 92, 'El túnel del caos', '<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\">CUATES PARA SIEMPRE</h1>\r\n<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\"><strong style=\"font-size: 27px; font-family: Arial, sans-serif; line-height: 1.6em; color: #000000;\"><span style=\"text-decoration: underline;\">El t&uacute;nel del caos</span></strong></h1>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">9 de Febrero de 2014</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"El T&uacute;nel del caos\" href=\"http://es.a.youversion.com/events/309258\" target=\"_blank\">Ingresa al estudio aqu&iacute;.</a></span></strong></p>', 1, '2014-02-09'),
(383, 92, 'Cuates a prueba de fuego', '<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\">CUATES PARA SIEMPRE</h1>\r\n<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\"><strong style=\"font-size: 27px; font-family: Arial, sans-serif; line-height: 1.6em; color: #000000;\"><span style=\"text-decoration: underline;\">Cuates a prueba de fuego</span></strong></h1>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">16 de Febrero de 2014</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"Cuates a prueba de fuego\" href=\"http://es.a.youversion.com/events/312189\" target=\"_blank\">Ingresa al estudio aqu&iacute;.</a></span></strong></p>', 1, '2014-02-16'),
(384, 92, 'Amores que matan', '<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\">CUATES PARA SIEMPRE</h1>\r\n<h1 style=\"margin: 12px 0px 0em; padding: 0px; font-weight: normal; font-family: HelveticaNeue-Light, HelveticaNeue, \'Helvetica Neue Light\', \'Helvetica Neue\', Helvetica, Arial, sans-serif; border: 0px; outline: 0px; font-size: 30px; vertical-align: baseline; letter-spacing: -0.04em; color: #333333; line-height: 30px; text-align: center; width: 700px !important;\"><strong style=\"font-size: 27px; font-family: Arial, sans-serif; line-height: 1.6em; color: #000000;\"><span style=\"text-decoration: underline;\">Amores que matan</span></strong></h1>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">Pastor Sergio Handal</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\" align=\"right\"><strong></strong><strong style=\"line-height: 1.6em;\"><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\">23 de Febrero de 2014</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px;\" align=\"right\"><strong><span style=\"font-size: 10pt; font-family: Arial, sans-serif;\" lang=\"ES\"><br /></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: left;\" align=\"center\"><strong><span style=\"font-size: 20pt; font-family: Arial, sans-serif;\" lang=\"ES\"><a title=\"Amores que matan\" href=\"http://es.a.youversion.com/events/314718\" target=\"_blank\">Ingresa al estudio aqu&iacute;.</a></span></strong></p>', 1, '2014-02-23'),
(390, 93, 'Por Que Ser Generosos', '', 1, '2014-03-02'),
(391, 93, 'Por que orar', '', 1, '2014-03-09'),
(392, 93, 'Por que servir a otros', '', 1, '2014-03-16'),
(393, 93, 'Por que leer la Biblia', '', 1, '2014-03-23'),
(394, 93, 'Por que hablar de Jesus a Otros', '', 1, '2014-03-30'),
(395, 93, 'Por que Dios permite el sufrimiento', '', 15, '2014-04-06'),
(396, 93, 'Si Jesus tenia tanto poder, Por que escogio morir', '', 1, '2014-04-13'),
(397, 93, 'NO HAY REUNION', '', 8, '2014-04-20'),
(398, 93, 'Por que congregarme en una iglesia', '', 1, '2014-04-27'),
(399, 94, 'Todos los seres humanos tienen fe', '<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 24pt; font-family: Arial, sans-serif;\" lang=\"ES-TRAD\">C O N E X I O N</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: center;\" align=\"center\"><strong><span style=\"font-size: 18pt; font-family: Arial, sans-serif; position: relative; top: 1pt;\">Todos los seres humanos tienen fe</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; position: relative; top: 1pt;\">Pastor Sergio Handal</span></p>\r\n<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; position: relative; top: 1pt;\">4 de Mayo de 2014</span></p>\r\n<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; position: relative; top: 1pt;\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; position: relative; top: 1pt;\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; position: relative; top: 1pt;\">&nbsp;</span></p>\r\n<p><a title=\"Todos loe seres humanos tienen fe\" href=\"http://es.a.youversion.com/events/340348\" target=\"_blank\"> <span style=\"font-size: 18pt; font-family: Arial, sans-serif; position: relative; top: 1pt;\">Ingresa al estudio aqui&nbsp;</span></a></p>', 1, '2014-05-04'),
(400, 94, 'Esperanza para todos', '<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 24pt; font-family: Arial, sans-serif;\" lang=\"ES-TRAD\">C O N E X I O N</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: center;\" align=\"center\"><strong><span style=\"font-size: 18pt; font-family: Arial, sans-serif; position: relative; top: 1pt;\">Esperanza para todos</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; position: relative; top: 1pt;\">Pastor Sergio Handal</span></p>\r\n<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; position: relative; top: 1pt;\">11 de Mayo de 2014</span></p>\r\n<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; position: relative; top: 1pt;\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; position: relative; top: 1pt;\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; position: relative; top: 1pt;\">&nbsp;</span></p>\r\n<p><a title=\"Esperanza para todos\" href=\"http://es.a.youversion.com/events/342832\" target=\"_blank\"><span style=\"font-size: 18pt; font-family: Arial, sans-serif; position: relative; top: 1pt;\">Ingresa al estudio aqui&nbsp;</span></a></p>', 1, '2014-05-11'),
(401, 94, 'La mas grande de las motivaciones', '<h1><a title=\"La mas grande de las motivaciones\" href=\"http://es.a.youversion.com/events/345282\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 3, '2014-05-18'),
(402, 94, 'Ponte en sus zapatos', '<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: center;\" align=\"center\"><strong><span style=\"text-decoration: underline;\"><span style=\"font-size: 24pt; font-family: Arial, sans-serif;\" lang=\"ES-TRAD\">C O N E X I O N</span></span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: center;\" align=\"center\"><strong><span style=\"font-size: 18pt; font-family: Arial, sans-serif; position: relative; top: 1pt;\">Esperanza para todos</span></strong></p>\r\n<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; position: relative; top: 1pt;\">Pastor Nelson Guerra</span></p>\r\n<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; position: relative; top: 1pt;\">25 de Mayo de 2014</span></p>\r\n<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; position: relative; top: 1pt;\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; position: relative; top: 1pt;\">&nbsp;</span></p>\r\n<p class=\"MsoNormal\" style=\"margin-left: 18.8pt; text-align: right;\" align=\"right\"><span style=\"font-family: Arial, sans-serif; position: relative; top: 1pt;\">&nbsp;</span></p>\r\n<p><a title=\"Ponte en sus zapatos\" href=\"http://es.a.youversion.com/events/347759\" target=\"_blank\"><span style=\"font-size: 18pt; font-family: Arial, sans-serif; position: relative; top: 1pt;\">Ingresa al estudio aqui&nbsp;</span></a></p>', 4, '2014-05-25'),
(403, 95, 'El esta conmigo', '<p style=\"line-height: 1; margin-top: 0pt; margin-bottom: 0pt; text-align: center;\" dir=\"ltr\"><span style=\"font-size: 32px; font-family: Arial; color: #000000; background-color: transparent; font-weight: bold; font-style: normal; font-variant: normal; text-decoration: underline; vertical-align: baseline; white-space: pre-wrap;\">VALIENTE</span></p>\r\n<p style=\"line-height: 1; margin-top: 0pt; margin-bottom: 0pt; text-align: center;\" dir=\"ltr\"><span style=\"font-size: 32px; font-family: Arial; color: #000000; background-color: transparent; font-weight: normal; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;\">El esta conmigo</span></p>\r\n<p style=\"line-height: 1; margin-top: 0pt; margin-bottom: 0pt; text-align: right;\" dir=\"ltr\"><span style=\"font-size: 13px; font-family: Arial; color: #000000; background-color: transparent; font-weight: normal; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;\">Pastor Sergio Handal</span></p>\r\n<p style=\"line-height: 1; margin-top: 0pt; margin-bottom: 0pt; text-align: right;\" dir=\"ltr\"><span style=\"font-size: 13px; font-family: Arial; color: #000000; background-color: transparent; font-weight: normal; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;\">1 de Junio de 2014</span></p>\r\n<p><span id=\"docs-internal-guid-78a75b9b-5743-bbb6-245f-0adcb82b80a9\"><br /></span></p>\r\n<p style=\"line-height: 1; margin-top: 0pt; margin-bottom: 0pt;\" dir=\"ltr\"><a title=\"El esta conmigo\" href=\"http://es.a.youversion.com/events/350181\" target=\"_blank\"><span style=\"font-size: 24px; font-family: Arial; color: #000000; background-color: transparent; font-weight: normal; font-style: normal; font-variant: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;\">Ingresa al estudio aqui</span></a></p>', 1, '2014-06-01'),
(404, 95, 'Proclamacion Valiente', '<h1 style=\"text-align: center;\"><span style=\"text-decoration: underline;\"><strong>V A L I E N T E</strong></span></h1>\r\n<h1 style=\"text-align: center;\">Proclamacion Valiente</h1>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">8 de Junio del 1014</p>\r\n<p style=\"text-align: left;\">&nbsp;</p>\r\n<h1 style=\"text-align: left;\"><a title=\"Proclamacion Valiente\" href=\"http://es.a.youversion.com/events/352729\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2014-06-08'),
(405, 95, 'Coraje y valor para cada dia', '', 1, '2014-06-15'),
(406, 95, 'Victorias Inesperadas ', '<h1 style=\"text-align: center;\"><strong>V A L I E N T E</strong></h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Victorias Inesperadas</span></h2>\r\n<p style=\"text-align: right;\">Allan Handal</p>\r\n<p style=\"text-align: right;\">22 de Junio de 2014</p>\r\n<h1 style=\"text-align: left;\"><a title=\"Victorias Inesperadas\" href=\"http://es.a.youversion.com/events/357718\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 3, '2014-06-22'),
(407, 95, 'Creyendo en cosas GRANDES (Solo hoy unica reunion 5:00 pm)', '<h1 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">V A L I E N T E</span></h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Creyendo en cosas GRANDES</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">29 de Junio de 2014</p>\r\n<h1 style=\"text-align: left;\">5:00 pm</h1>\r\n<p>&nbsp;</p>\r\n<h1><a title=\"Creyendo en cosas GRANDES\" href=\"http://es.a.youversion.com/events/359957\" target=\"_blank\"><span style=\"text-decoration: underline;\">Ingresa al estudio aqui.&nbsp;</span></a></h1>', 1, '2014-06-29'),
(408, 96, 'Victoria sobre un Corazon Herido', '<h1 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">VICTORIAS PRIVADAS</span></h1>\r\n<h2 style=\"text-align: center;\">Victoria sobre un Corazon Herido</h2>\r\n<p style=\"text-align: right;\">&nbsp;</p>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">6 de Julio de 2014</p>\r\n<p style=\"text-align: left;\">&nbsp;</p>\r\n<h1 style=\"text-align: left;\"><a title=\"Victoria sobre un Corazon Herido\" href=\"http://www.a.youversion.com/events/362262\" target=\"_blank\">Ingresar a la predica aqui</a></h1>', 1, '2014-07-06'),
(409, 96, 'Victoria sobre la Envidia', '', 8, '2014-07-13'),
(410, 96, 'Victoria sobre las Quejas', '<h1 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">VICTORIAS PRIVADAS</span></h1>\r\n<h2 style=\"text-align: center;\">Victoria sobre las Quejas</h2>\r\n<p style=\"text-align: right;\">&nbsp;</p>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">20 de Julio de 2014</p>\r\n<p>&nbsp;</p>\r\n<h1><a title=\"Victoria sobre las Quejas\" href=\"http://es.a.youversion.com/events/367136\" target=\"_blank\">Ingresar a la predica aqui</a></h1>', 1, '2014-07-20'),
(411, 96, 'Victoria sobre la incapacidad para decir NO', '<h1 style=\"text-align: center;\"><strong><span style=\"text-decoration: underline;\">VICTORIAS PRIVADAS</span></strong></h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Victoria sobre la incapacidad para decir NO</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">27 de julio 2014</p>\r\n<p style=\"text-align: right;\">&nbsp;</p>\r\n<p style=\"text-align: right;\">&nbsp;</p>\r\n<h1 style=\"text-align: left;\"><a title=\"Victoria sobre la incapacidad para decir NO\" href=\"http://es.a.youversion.com/events/369351\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2014-07-27'),
(412, 96, 'Victoria sobre el Orgullo', '<h1 style=\"text-align: center;\"><strong>VICTORIAS PRIVADAS</strong></h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Victoria sobre el Orgullo</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">3 de Agosto de 2014</p>\r\n<p style=\"text-align: right;\">&nbsp;</p>\r\n<h1><a title=\"Victoria sobre el orgullo\" href=\"http://es.a.youversion.com/events/371711\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2014-08-03'),
(413, 96, 'Victoria sobre la Lengua floja', '<h1 style=\"text-align: center;\"><strong>VICTORIAS PRIVADAS</strong></h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Victoria Sobre la Lengua Floja</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">10 de Agosto de 2014</p>\r\n<p style=\"text-align: right;\">&nbsp;</p>\r\n<h1><a title=\"Victoria sobre la lengua floja\" href=\"http://es.a.youversion.com/events/374139\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2014-08-10'),
(414, 96, 'Victoria sobre el Enojo', '<h1 style=\"text-align: center;\"><strong>VICTORIAS PRIVADAS</strong></h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Victoria Sobre el Enojo</span></h2>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: right;\">17 de Agosto de 2014</p>\r\n<p style=\"text-align: right;\">&nbsp;</p>\r\n<h1><a title=\"Victoria sobre el enojo\" href=\"http://www.a.youversion.com/events/376353\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 9, '2014-08-17'),
(415, 96, 'Victoria sobre el Descontrol Personal', '<h1 style=\"text-align: center;\">VICTORIAS PRIVADAS</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Victoria Sobre el Descontrol Personal</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">24 de Agosto del 2014</p>\r\n<p>&nbsp;</p>\r\n<h1><a title=\"Victoria sobre el descontrol personal\" href=\"http://es.a.youversion.com/events/378964\" target=\"_blank\"><span style=\"text-decoration: underline;\">Ingresa al estudio aqui&nbsp;</span></a></h1>', 8, '2014-08-24'),
(416, 96, 'Victoria sobre Asuntos no Resueltos', '<h1 style=\"text-align: center;\">VICTORIAS PRIVADAS</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Victoria sobre asuntos no resueltos</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">31 de Agosto de 2014</p>\r\n<h1 style=\"text-align: left;\"><a title=\"Victoria sobre asuntos no resueltos\" href=\"http://www.a.youversion.com/events/380835\" target=\"_blank\"><span style=\"text-decoration: underline;\">Ingresa al estudio aqui</span></a></h1>', 1, '2014-08-31'),
(417, 97, 'POR QUE DAR EL MENSAJE?', '<h1 style=\"text-align: center;\">MENSAJE</h1>\r\n<h3 style=\"text-align: center;\">QUE CAMBIA AL MUNDO</h3>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\"><strong>POR QUE DAR EL MENSAJE?</strong></span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">7 de Septiembre de 2014</p>\r\n<h1><a title=\"Por que dar el mensaje?\" href=\"http://es.a.youversion.com/events/383869\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2014-09-07'),
(418, 97, 'COMO DAR EL MENSAJE?', '', 8, '2014-09-14'),
(419, 97, 'Y DESPUES QUE?', '<h1 style=\"text-align: center;\">MENSAJE</h1>\r\n<h3 style=\"text-align: center;\">QUE CAMBIA AL MUNDO</h3>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\"><strong>Y despues que?</strong></span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">21 de Septiembre de 2014</p>\r\n<h1><a title=\"Y despues que\" href=\"http://es.a.youversion.com/events/389299\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2014-09-21'),
(420, 97, 'ESTAREMOS EN EL CAMPAMENTO \"EXPONENCIAL\"', '', 8, '2014-09-28'),
(421, 98, 'Como rescatar a un hijo perdido', '<h1 style=\"text-align: center;\">Mejorando mi Familia</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Como rescatar a un hijo perdido</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sregio Handal</p>\r\n<p style=\"text-align: right;\">12 de Octubre de 2014</p>\r\n<p style=\"text-align: right;\">&nbsp;</p>\r\n<h1 style=\"text-align: left;\"><a title=\"Como rescatar a un hijo perdido\" href=\"http://es.a.youversion.com/events/395915\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2014-10-12'),
(423, 98, 'Caballero a la medida', '<p>&nbsp;</p>\r\n<div id=\"texto_ma\">\r\n<div id=\"encabezado_ma\">&nbsp;</div>\r\n<h1 style=\"text-align: center;\">Mejorando mi Familia</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Caballero a la medida</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sregio Handal</p>\r\n<p style=\"text-align: right;\">129 de Octubre de 2014</p>\r\n<p style=\"text-align: right;\">&nbsp;</p>\r\n<h1 style=\"text-align: left;\"><a href=\"http://bible.com/e/1ft6\" target=\"_blank\">Ingresa al estudio aqui</a></h1>\r\n<br />\r\n<h2>&nbsp;</h2>\r\n</div>', 1, '2014-10-19'),
(424, 98, 'Esposa, ahi esta el detalle', '<h1 style=\"text-align: center;\">Mejorando a mi familia</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Esposa, ahi esta el detalle</span></h2>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: right;\">26 de Octubre de 2014</p>\r\n<h1><a title=\"Esposa, ahi esta el detalle\" href=\"http://es.a.youversion.com/events/402232\" target=\"_blank\">Ingresa la estudio aqui</a></h1>', 9, '2014-10-26'),
(425, 98, 'Como tener buenos hijos', '<h1 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">MEJORANDO MI FAMILIA</span></h1>\r\n<h3 style=\"text-align: center;\"><strong style=\"font-size: 1.5em;\">Como tener buenos hijos</strong></h3>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">5 de Octubre de 2014</p>\r\n<h1><a title=\"Como tener buenos hijos\" href=\"http://es.a.youversion.com/events/394577\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2014-10-05'),
(426, 99, 'Cuando mi vida no tiene sentido', '<h1 style=\"text-align: center;\">COMO SER FELIZ</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Cuando mi vida no tiene sentido</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">2 de Noviembre de 2014</p>\r\n<h1><a title=\"Cuando mi vida no tiene sentido\" href=\"http://es.a.youversion.com/events/404733\" target=\"_blank\">Ingresa la estudio aqui</a></h1>', 1, '2014-11-02'),
(427, 99, 'Cuando me siento solo', '<h1 style=\"text-align: center;\">COMO SER FELIZ</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Como ser feliz cuando me siento solo</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">9 de noviembre 2014</p>\r\n<h1><a title=\"Como ser feliz cuando me siento solo\" href=\"http://es.a.youversion.com/events/406619\" target=\"_blank\">Ingresa al estudio aqui.</a></h1>', 1, '2014-11-09'),
(428, 99, 'Cuando me siento rechazado', '<h1 style=\"text-align: center;\"><strong>COMO SER FELIZ</strong></h1>\r\n<h2 style=\"text-align: center;\"><strong><span style=\"text-decoration: underline;\">Cuando me siento rechazado</span></strong></h2>\r\n<p style=\"text-align: right;\">Allan Handal</p>\r\n<p style=\"text-align: right;\">16 de Noviembre de 2014</p>\r\n<h1><a title=\"Como ser feliz cuando me siento rechazado\" href=\"http://es.a.youversion.com/events/409845\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 3, '2014-11-16'),
(429, 99, 'Cuando no soy exitoso', '<h1 style=\"text-align: center;\"><strong>COMO SER FELIZ</strong></h1>\r\n<h2 style=\"text-align: center;\"><strong><span style=\"text-decoration: underline;\">Cuando no soy exitoso</span></strong></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">23 de Noviembre de 2014</p>\r\n<h1><a title=\"Cuando no soy exitoso\" href=\"http://es.a.youversion.com/events/412541\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2014-11-23'),
(430, 99, 'Pase lo que Pase', '<h1 style=\"text-align: center;\">COMO SER FELIZ</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Pase lo que pase</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">30 de noviembre de 2014</p>\r\n<h1><a title=\"Pase lo que pase\" href=\"http://www.a.youversion.com/events/414429/\" target=\"_blank\">Ingrese al estudio aqui</a></h1>', 1, '2014-11-30'),
(431, 100, 'La Familia', '', 8, '2014-12-07'),
(432, 100, 'La Generosidad', '<h1 style=\"text-align: center;\"><strong>Los 3 Regalos de la Navidad</strong></h1>\r\n<h2 style=\"text-align: center;\">LA GENEROSIDAD</h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">14 de Diciembre de 2014</p>\r\n<h1><a title=\"La Generosidad\" href=\"http://www.a.youversion.com/events/419067/\" target=\"_blank\">Ingresa al estudio aqui.</a></h1>', 1, '2014-12-14'),
(433, 100, 'La Esperanza', '<h1 style=\"text-align: center;\">Los 3 Regalos de la Navidad</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">LA ESPERANZA</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">21 de Diciembre de 2014</p>\r\n<h1 style=\"text-align: left;\"><a title=\"La Esperanza\" href=\"http://www.a.youversion.com/events/421258\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2014-12-21'),
(434, 101, 'Primero lo primero', '<h1 style=\"text-align: center;\"><strong>CONQUITESMOS EL 2015</strong></h1>\r\n<h2 style=\"text-align: center;\"><strong><span style=\"text-decoration: underline;\">Primero lo primero</span></strong></h2>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: right;\">4 Enero 2015</p>\r\n<h1><a title=\"Primero lo primero\" href=\"http://www.a.youversion.com/events/425371\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 9, '2015-01-04'),
(435, 101, 'La vision que nos mueve', '<h1 style=\"text-align: center;\"><strong>Conquistemos el 2015</strong></h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">La vision que nos mueve</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">18 de Enero de 2015</p>\r\n<h1><a title=\"La vision que nos mueve\" href=\"http://es.a.youversion.com/events/430951\" target=\"_blank\"><span style=\"text-decoration: underline;\">Ingresa al estudio aqui</span></a></h1>', 1, '2015-01-18'),
(437, 101, 'El plan de mis finanzas', '<h1 style=\"text-align: center;\"><strong>CONQUISTEMOS EL 2015</strong></h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\"><strong>El plan de mis finanzas</strong></span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">25 de Enero de 2015</p>\r\n<h1><a title=\"El plan de mis finanzas\" href=\"http://es.a.youversion.com/events/433630\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-01-25'),
(438, 101, 'NO HAY REUNION', '', 8, '2014-12-28'),
(439, 101, 'Permanecer', '<h1 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">CONQUISTEMOS EL 2015</span></h1>\r\n<h2 style=\"text-align: center;\">Nunca nada cambiara sin la elecion de&nbsp;</h2>\r\n<h2 style=\"text-align: center;\">PERMANECER</h2>\r\n<p style=\"text-align: right;\">Pastor Jason Tucker</p>\r\n<p style=\"text-align: right;\">11 de Enero de 2015</p>\r\n<h1 style=\"text-align: left;\"><a title=\"Permanecer\" href=\"http://es.a.youversion.com/events/428103\" target=\"_blank\"><span style=\"text-decoration: underline;\">Ingresa al estudio aqui</span></a></h1>', 16, '2015-01-11'),
(440, 102, 'La esperanza del mundo', '<h1 style=\"text-align: center;\">Tiempo de Sembrar</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">La esperanza del mundo</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">1 de Febrerro de 2015</p>\r\n<h1 style=\"text-align: left;\"><a title=\"La esperanza del mundo\" href=\"http://es.a.youversion.com/events/436294\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-02-01'),
(441, 102, 'Tiempo de sembrar', '<h1 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Tiempo de Sembrar</span></h1>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">8 de Febrero de 2015</p>\r\n<h1 style=\"text-align: left;\"><a title=\"Tiempo de sembrar\" href=\"http://es.a.youversion.com/events/438459\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-02-08');
INSERT INTO `mensajes` (`id_mensaje`, `id_serie`, `mensaje`, `resumen`, `id_expositor`, `fecha`) VALUES
(442, 102, 'Mas alla de nosotros mismos', '<h1 style=\"text-align: center;\">Tiempo de Sembrar</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\"><strong>Mas alla de nosotros mismos</strong></span></h2>\r\n<p style=\"text-align: right;\">15 de Febrero de 2015</p>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<h1><a title=\"Mas alla de nosotros mismos.\" href=\"http://es.a.youversion.com/events/441408\" target=\"_blank\"><span style=\"text-decoration: underline;\"><strong>Ingresa al estudio aqui.</strong></span></a></h1>', 1, '2015-02-15'),
(443, 102, 'Una vision global', '<h1 style=\"text-align: center;\">Tiempo de Sembrar</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Una vision global</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">22 de Febrero de 2015</p>\r\n<h1><a title=\"Una vision global\" href=\"http://es.a.youversion.com/events/443645\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-02-22'),
(444, 103, 'Amar a Dios', '<h1 style=\"text-align: center;\">El ABC de la Vida</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\"><strong>Amar a Dios</strong></span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">8 de Marzo de 2015</p>\r\n<h1 style=\"text-align: left;\"><a title=\"Amar a Dios\" href=\"http://es.a.youversion.com/events/448512\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-03-08'),
(445, 103, 'Beneficiar a otros', '<h1 style=\"text-align: center;\">El ABC de la Vida</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Beneficiar a otros</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">15 de Marzo de 2015</p>\r\n<h1 style=\"text-align: left;\"><a title=\"Beneficiar a otros\" href=\"http://es.a.youversion.com/events/433630\" target=\"_blank\">Ingrese al estudio aqui</a></h1>', 1, '2015-03-15'),
(446, 103, 'Compartir el amor de Dios', '<h1 style=\"text-align: center;\">El ABC de la Vida</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Compartir el amor de Dios</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">22 de Marzo de 2015</p>\r\n<h1><a title=\"Compartir el amor de Dios\" href=\"http://es.a.youversion.com/events/454451\" target=\"_blank\"><span style=\"text-decoration: underline;\">Ingresa al estudio aqui</span></a></h1>', 1, '2015-03-22'),
(447, 103, 'Demostrar Gracia', '<h1 style=\"text-align: center;\"><strong>El ABC de la Vida</strong></h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\"><strong>Demostrar Gracia</strong></span></h2>\r\n<p style=\"text-align: right;\">29 de Marzo de 2015</p>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<h1 style=\"text-align: left;\"><a title=\"Demostrar Gracia\" href=\"http://es.a.youversion.com/events/456546\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-03-29'),
(448, 102, 'Ley de la Siembra y la Cosecha', '', 1, '2015-03-01'),
(449, 104, 'Crisis de identidad', '<h1 style=\"text-align: center;\">SELFIE</h1>\r\n<h2 style=\"text-align: center;\">Crisis de identidad</h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">19 de abril de 2015</p>\r\n<h1><a title=\"Crisis de identidad\" href=\"http://es.a.youversion.com/events/464138\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-04-19'),
(450, 104, 'Una Mejor Selfie', '<h1 style=\"text-align: center;\">SELFIE</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Una mejor selfie</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">26 de Abril de 2015</p>\r\n<h1><a title=\"Una mejor selfie\" href=\"http://es.a.youversion.com/events/466935\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-04-26'),
(451, 104, 'Nuevo enfoque, nuevo proposito', '<h1 style=\"text-align: center;\">SELFIE</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Nuevo Enfoque. Nuevo Proposito</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">3 de mayo de 2015</p>\r\n<h1><a title=\"Nuevo Enfoque Nuevo Proposito\" href=\"http://es.a.youversion.com/events/469651\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-05-03'),
(452, 105, 'La mejor de todas', '<h1 style=\"text-align: center;\">Celebraando a mama</h1>\r\n<h3 style=\"text-align: center;\">La mejor de todas</h3>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">10 de mayo de 2015</p>\r\n<h1><a title=\"La mejor de todas\" href=\"http://es.a.youversion.com/events/471692\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-05-10'),
(453, 106, 'La Esposa', '<h1 style=\"text-align: center;\">Una Familia Feliz</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">La Esposa</span></h2>\r\n<p style=\"text-align: right;\">Adrian Rivera</p>\r\n<p style=\"text-align: right;\">24 de mayo de 2015</p>\r\n<h1><a title=\"La Esposa\" href=\"http://es.a.youversion.com/events/476691\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 10, '2015-05-24'),
(454, 106, 'El Esposo', '<h1 style=\"text-align: center;\">Una Familia Feliz</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El Esposo</span></h2>\r\n<p style=\"text-align: right;\">17 de Mayo de 2015</p>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<h1><a title=\"El Esposo\" href=\"http://es.a.youversion.com/events/474253\" target=\"_blank\">Ingresa al estudio aqui&nbsp;</a></h1>', 1, '2015-05-17'),
(455, 106, 'Los Hijos', '<h1 style=\"text-align: center;\">Una Familia Feliz</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Los Hijos</span></h2>\r\n<p style=\"text-align: right;\">31 de mayo de 2015</p>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<h1 style=\"text-align: left;\"><a title=\"Los Hijos\" href=\"http://es.a.youversion.com/events/478876\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-05-31'),
(456, 107, 'En el amor', '<h1 style=\"text-align: center;\">TABU</h1>\r\n<h2 style=\"text-align: center;\">En el amor</h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">7 de junio de 2015</p>\r\n<h1><a title=\"En el amor\" href=\"http://es.a.youversion.com/events/480908\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-06-07'),
(457, 107, 'En las citas', '<h1 style=\"text-align: center;\">TABU</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">En las citas</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">14 de Junio de 2015</p>\r\n<h1><a title=\"En las citas\" href=\"http://es.a.youversion.com/events/483780\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-06-14'),
(458, 107, 'En el matrimonio', '<h1 style=\"text-align: center;\">TABU</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">En el matrimonio</span></h2>\r\n<p style=\"text-align: right;\">21 de junio de 2015</p>\r\n<p style=\"text-align: right;\">Allan Handal</p>\r\n<h1><a title=\"En el matrimonio\" href=\"http://es.a.youversion.com/events/485535\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 8, '2015-06-21'),
(459, 107, 'En el sexo', '<h1 style=\"text-align: center;\">TABU</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">En el sexo</span></h2>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: right;\">28 de junio de 2015</p>\r\n<h1><a title=\"En el sexo\" href=\"http://es.a.youversion.com/events/488249\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 9, '2015-06-28'),
(460, 108, 'Es la Biblia realmente la Palabra de Dios', '<h1 style=\"text-align: center;\">Las 4 piezas para una Fe solida</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Es la Biblia realmente la Palabra de Dios</span></h2>\r\n<p style=\"text-align: right;\">5 de julio de 2015</p>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<h1><a title=\"Es la Biblia realmente la Palabra de Dios\" href=\"http://es.a.youversion.com/events/489950\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-07-05'),
(461, 108, 'Por que Dios permite cosas malas a las personas buenas', '<h1 style=\"text-align: center;\">Las 4 piezas para una Fe solida</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Por que Dios permite cosas malas a las personas buenas</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">12 de julio de 2015</p>\r\n<h1 style=\"text-align: left;\"><a title=\"Por que Dios permite cosas malas a las personas buenas\" href=\"http://es.a.youversion.com/events/492625\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-07-12'),
(462, 108, 'Para que existe la iglesia', '<h1 style=\"text-align: center;\">Las 4 piezas para una Fe solida</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Para que existe la iglesia</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">19 de julio de 2015</p>\r\n<h1><a title=\"Para que existe la iglesia\" href=\"http://es.a.youversion.com/events/494516\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-07-19'),
(463, 108, 'Que es la verdad', '<h1 style=\"text-align: center;\">Las 4 piezas para una Fe solida</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Que es la verdad</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">26 de Julio de 2015</p>\r\n<h1><a title=\"Que es la verdad\" href=\"http://es.a.youversion.com/events/496810\" target=\"_blank\">Ingresa al estudio aqui.</a></h1>', 1, '2015-07-26'),
(464, 109, 'Vision', '<h1 style=\"text-align: center;\">Back to School</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Vision</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">2 de agosto de 2015</p>\r\n<h1><a title=\"Vision\" href=\"http://es.a.youversion.com/events/499020\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-08-02'),
(465, 109, 'Generosidad', '<h1 style=\"text-align: center;\">Back to School</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Generosidad</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">9 de Agosto de 2015</p>\r\n<h1><a title=\"Generosidad\" href=\"http://es.a.youversion.com/events/500879\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-08-09'),
(466, 109, 'Evangelismo', '<h1 style=\"text-align: center;\">Back to School</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Evangelismo</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">16 de agosto de 2015</p>\r\n<h1><a title=\"Evangelismo\" href=\"http://es.a.youversion.com/events/503211\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-08-16'),
(467, 109, 'Discipulado', '<h1 style=\"text-align: center;\">Back to School</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Discipulado</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">23 de Agosto de 2015</p>\r\n<h1><a title=\"Discipulado\" href=\"http://es.a.youversion.com/events/506176\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-08-23'),
(468, 109, 'Voluntariado', '<h1 style=\"text-align: center;\">Back to School</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Voluntariado</span></h2>\r\n<p style=\"text-align: right;\">30 de agosto de 2015</p>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<h1><a title=\"Voluntariado\" href=\"http://es.a.youversion.com/events/508429/\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-08-30'),
(469, 110, 'Un lugar para los enfermos', '<h1 style=\"text-align: center;\">#SomosGranComision</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Un lugar para los enfermos</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">6 de septiembre de 2015</p>\r\n<h1><a title=\"Un lugar para los enfermos \" href=\"http://es.a.youversion.com/events/510627\" target=\"_blank\">Ingresa al estudio aqui.</a></h1>', 1, '2015-09-06'),
(470, 110, 'No se trate de mi', '<h1 style=\"text-align: center;\">#SomosGranComision</h1>\r\n<h2 style=\"text-align: center;\"><strong><span style=\"text-decoration: underline;\">No se trata de mi</span></strong></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">13 de septiembre de 2015</p>\r\n<h1><a title=\"No se trata de mi\" href=\"http://es.a.youversion.com/events/513374\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-09-13'),
(471, 110, 'Ponte la camiseta', '<h1 style=\"text-align: center;\">#SomosGranComision</h1>\r\n<h1 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Ponte la camiseta</span></h1>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">20 de Septiembre de 2015</p>\r\n<h1><a title=\"Ponte la camiseta\" href=\"http://es.a.youversion.com/events/516149\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-09-20'),
(472, 110, 'Maravillosa Gracia', '<h1 style=\"text-align: center;\">#SomosGranComsision</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Maravillosa Gracia</span></h2>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: right;\">27 de septiembre de 2015</p>\r\n<h1><a title=\"Maravillosa Gracia\" href=\"http://es.a.youversion.com/events/517678\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 9, '2015-09-27'),
(473, 111, 'Un Final Epico', '<h1 style=\"text-align: center;\">Un Final de Pelicula</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Un Final Epico</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">11 de octubre de 2015</p>\r\n<h1><a title=\"Un Final Epico\" href=\"http://es.a.youversion.com/events/523088\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-10-11'),
(474, 111, 'Un Final en Paz', '<h1 style=\"text-align: center;\">Un Final de Pelicula</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Un Final en Paz</span></h2>\r\n<p style=\"text-align: right;\">18 de octubre de 2015</p>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<h1><a title=\"Un Final en Paz\" href=\"http://es.a.youversion.com/events/526045\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-10-18'),
(475, 111, 'Un Final Feliz', '<h1 style=\"text-align: center;\">Un Final de Pelicula</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Un Final Feliz</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">25 de octubre de 2015</p>\r\n<h1><a title=\"Un Final Feliz\" href=\"http://es.a.youversion.com/events/528365\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-10-25'),
(476, 112, '1 La Gracia de Dios', '', 17, '2015-10-02'),
(477, 112, '2 Elementos de la Gracia', '', 3, '2015-10-03'),
(478, 112, '3 El Regalo de Dios: Justicia', '', 17, '2015-10-03'),
(481, 112, '4 El Cristiano Lleno de Gracia', '', 17, '2015-10-03'),
(482, 112, '5 Mostrar Gracia en la Relacion con los Hermanos', '', 1, '2015-10-04'),
(483, 113, 'Vida Despues de la Vida', '<h1 style=\"text-align: center;\">La Vida Despues de la Vida</h1>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">1 de noviembre de 2015</p>\r\n<h1><a title=\"La Vida Despues de la Vida\" href=\"http://es.a.youversion.com/events/530422\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-11-01'),
(484, 114, 'Decidi empezar', '<h1 style=\"text-align: center;\">MI HISTORIA</h1>\r\n<h2 style=\"text-align: center;\">Decidi empezar</h2>\r\n<p style=\"text-align: right;\">Allan Handal</p>\r\n<p style=\"text-align: right;\">8 de noviembre de 2015</p>\r\n<h1><a title=\"Decidi empezar  \" href=\"http://es.a.youversion.com/events/533181\" target=\"_blank\">Ingresa al estudio aqui&nbsp;</a></h1>', 3, '2015-11-08'),
(485, 114, 'Decidi parar', '<h1 style=\"text-align: center;\">MI HSITORIA</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">DECIDI PARAR</span></h2>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: right;\">15 de noviembre de 2015</p>\r\n<h1><a title=\"Decidi Parar\" href=\"http://es.a.youversion.com/events/535641\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 9, '2015-11-15'),
(486, 114, 'Decidi quedarme', '<h1 style=\"text-align: center;\"><strong>MI HISTORIA</strong></h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">DECIDI QUEDARME</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">22 de noviembre de 2015</p>\r\n<h1><a title=\"Decidi Quedarme\" href=\"http://es.a.youversion.com/events/537811/\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-11-22'),
(487, 114, 'Decidi ir', '<h1 style=\"text-align: center;\">MI HISTORIA</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Decidi ir</span></h2>\r\n<p style=\"text-align: right;\">29 de noviembre de 2015</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1 style=\"text-align: left;\"><a title=\"Decidi ir\" href=\"http://es.a.youversion.com/events/540044\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-11-29'),
(488, 115, 'Que No Te Lleguen Las Discusiones', '', 1, '2015-12-06'),
(489, 115, 'Que No Te Lleguen Las Deudas', '<p style=\"text-align: center;\">Llego Navidad</p>\r\n<p style=\"text-align: center;\">Que no te lleguen las deudas</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">13 de diciembre de 2015</p>\r\n<h1><a title=\"Que no te lleguen las deudas\" href=\"http://es.a.youversion.com/events/544540\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-12-13'),
(490, 115, 'Navidad: La verdadera historia', '<h1 style=\"text-align: center;\">Navidad</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">La verdadera hostoria</span></h2>\r\n<p style=\"text-align: right;\">20 de diciembre de 2015</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1><a title=\"La verdadera historia\" href=\"http://es.a.youversion.com/events/546473\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2015-12-20'),
(491, 115, 'Héroes Comunes y Corrientes que Transformaron el Mundo', '<h1 style=\"text-align: center;\">Cambia el Mundo en 31 D&iacute;as</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">H&eacute;roes Comunes y Corrientes que Transformaron el Mundo</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">3 de enero de 2016</p>\r\n<h1><a title=\"H&eacute;roes Comunes y Corrientes que Transformaron el Mundo\" href=\"http://es.a.youversion.com/events/549192\" target=\"_blank\">Ingresa al estudio aqu&iacute;</a></h1>', 1, '2016-01-03'),
(492, 115, 'Mi Verdadero Norte', '<h1 style=\"text-align: center;\">Cambia el Mundo en 31 D&iacute;as</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Mi verdadero norte</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">10 de enero de 2016</p>\r\n<h1><a title=\"Mi verdadero norte\" href=\"http://es.a.youversion.com/events/553005\" target=\"_blank\">Ingresa al estudio aqu&iacute;</a></h1>', 1, '2016-01-10'),
(493, 115, 'Primero lo Primero', '<h1 style=\"text-align: center;\">Cambiando el Mundo en 31 di&iacute;as</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Primero lo primero</span></h2>\r\n<p style=\"text-align: right;\">17 de enero de 2016</p>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<h1><a title=\"Primero lo primero\" href=\"http://es.a.youversion.com/events/555597\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2016-01-17'),
(494, 115, 'El Poder de mi Calendario', '<h1 style=\"text-align: center;\">Cambia el Mundo en 31 d&iacute;as</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El poder de mi calendario</span></h2>\r\n<p style=\"text-align: right;\">24 de enero de 2016</p>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<h1><a title=\"El poder de mi calendario\" href=\"http://es.a.youversion.com/events/558262\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2016-01-24'),
(495, 115, 'Exceso de Equipaje', '<h1 style=\"text-align: center;\">Cambia el mundo en 31 d&iacute;as</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Exceso de Equipaje</span></h2>\r\n<p style=\"text-align: right;\">Pastor Sergio Handal</p>\r\n<p style=\"text-align: right;\">31 de enero de 2016</p>\r\n<h1><a title=\"Exceso de equipaje\" href=\"http://es.a.youversion.com/events/560793\" target=\"_blank\">Ingresa al estudio aqu&iacute;</a></h1>', 1, '2016-01-31'),
(496, 116, '¿Cómo ser Millonario de Corazón?', '<h1 style=\"text-align: center;\">&iquest;C&oacute;mo ser Millonario de Coraz&oacute;n?</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Las Leyes de la Siembra y la Cosecha</span></h2>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: right;\">7 de febrero de 2016</p>\r\n<h1><a title=\"&iquest;C&oacute;mo ser Millonario de Coraz&oacute;n?\" href=\"http://es.a.youversion.com/events/563088\" target=\"_blank\">Ingresa al estudio aqu&iacute;</a></h1>', 9, '2016-02-07'),
(497, 117, 'Amores que perduran', '<h1 style=\"text-align: center;\">FLECHADOS</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">&iquest;C&oacute;mo saber si esa persona es la que Dios tiene para ti?</span></h2>\r\n<p style=\"text-align: right;\">Allan Handal</p>\r\n<p style=\"text-align: right;\">14 de febrero de 2016</p>\r\n<h1><a title=\"FLECHADOS\" href=\"http://es.a.youversion.com/events/565912\" target=\"_blank\">Ingresa al estudio aqu&iacute;</a></h1>', 3, '2016-02-14'),
(498, 118, 'Una visión cautivadora', '<h1 style=\"text-align: center;\"><strong>Tiempo de Esparcir</strong></h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Una visi&oacute;n cautivadora</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">21 de febrero de 2016</p>\r\n<h1><a title=\"Una visi&oacute;n cautivadora \" href=\"http://es.a.youversion.com/events/568178\" target=\"_blank\">Ingresa al estudio aqu&iacute;</a></h1>', 1, '2016-02-21'),
(499, 118, 'Como tener dinero sin ser miserable.', '<h1 style=\"text-align: center;\">Tiempo de Esparcir</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Como tener dinero sin ser miserable</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">28 de febrerro de 2016</p>\r\n<h1><a title=\"Como tener dinero sin ser miserable\" href=\"http://es.a.youversion.com/events/570722\" target=\"_blank\">Ingresa al estudio aqu&iacute;</a></h1>', 1, '2016-02-28'),
(500, 118, 'Una nueva esperanza', '<h1 style=\"text-align: center;\">Tiempo de Esparcir</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Una nueva esperanza</span></h2>\r\n<p style=\"text-align: right;\">6 de marzo de 2016</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1><a title=\"Una nueva esperanza\" href=\"http://es.a.youversion.com/events/573368\" target=\"_blank\">Ingresa al estudio aqu&iacute;&nbsp;</a></h1>', 1, '2016-03-06'),
(501, 118, 'Penetrando la oscuridad', '<h1 style=\"text-align: center;\">Tiempo de Esparcir</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Penetrando la ocuridad</span></h2>\r\n<p style=\"text-align: right;\">13 de marzo de 2016</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1><a title=\"Penetrando la oscuridad\" href=\"http://es.a.youversion.com/events/576135\" target=\"_blank\">Ingresa al estudio aqui</a></h1>', 1, '2016-03-13'),
(502, 119, 'Tumba Vacía', '', 18, '2016-03-20'),
(503, 120, 'Una Emoti-conversación', '<h1 style=\"text-align: center;\">SENTIMIENTOS</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Una Emoti-Conversaci&oacute;n</span></h2>\r\n<p style=\"text-align: right;\">17 de abril de 2016</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1><a title=\"Una Emoti-Conversaci&oacute;n\" href=\"http://bible.com/events/21739\" target=\"_blank\">Ingresa al estudio aqu&iacute;</a></h1>', 1, '2016-04-17'),
(504, 121, 'Atendiendo el llamado', '', 1, '2016-04-03'),
(505, 121, 'La máxima invitación', '', 1, '2016-04-10'),
(506, 120, 'Enredos sentimentales', '<h1 style=\"text-align: center;\">SENTIMIENTOS</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Enredos Sentimentales</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">24 de abril de 2016</p>\r\n<h1><a title=\"Enredos sentimentales\" href=\"http://bible.com/events/25145\" target=\"_blank\">Ingresa al estudio aqu&iacute;</a></h1>', 1, '2016-04-24'),
(507, 120, 'Un boost de animo', '', 8, '2016-05-01'),
(508, 122, 'Celebración día de la madre ', '', 1, '2016-05-08'),
(509, 123, 'Una familia visionaria', '<h1 style=\"text-align: center;\">BENDICE ESTE HOGAR</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Una familia visionaria</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">15 de mayo de 2016</p>\r\n<h1><a title=\"Una familia visionaria\" href=\"http://bible.com/events/36006\" target=\"_blank\">Ingresa al estudio aqu&iacute;</a></h1>', 1, '2016-05-15'),
(510, 123, 'Una familia pura', '<h1 style=\"text-align: center;\">Bendice este hogar</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Una familia pura</span></h2>\r\n<p style=\"text-align: right;\">22 de mayo de 2016</p>\r\n<p style=\"text-align: right;\">Hanry Kattan</p>\r\n<h1><a title=\"Una familia pura\" href=\"http://bible.com/events/39077\" target=\"_blank\">Ingresa al estudio aqu&iacute;</a></h1>', 19, '2016-05-22'),
(511, 123, 'Una familia llena de paz', '<h1 style=\"text-align: center;\">Bendice este hogar</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Una familia llena de paz</span></h2>\r\n<p style=\"text-align: right;\">29 de mayo de 2016</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1><a title=\"Una familia llena de paz\" href=\"http://bible.com/events/42622\" target=\"_blank\">Ingresa al estudio aqu&iacute;</a></h1>', 1, '2016-05-29'),
(512, 124, 'Presencia', '<h1 style=\"text-align: center;\">LOS PRIMESOS PASOS</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Presencia</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">5 de junio de 2016</p>\r\n<h1><a title=\"Presencia\" href=\"http://bible.com/events/46521\" target=\"_blank\">Ingresa al estudio aqu&iacute;</a></h1>', 1, '2016-06-05'),
(513, 124, 'Pertenencia', '<h1 style=\"text-align: center;\">LOS PRIMEROS PASOS</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Pertenencia</span></h2>\r\n<p style=\"text-align: right;\">12 de junion de 2016</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1 style=\"text-align: left;\"><a title=\"Pertenencia\" href=\"http://bible.com/events/49634\" target=\"_blank\">Ingresa al estudio aqu&iacute;</a></h1>', 1, '2016-06-12'),
(514, 124, 'Festival para Papá', '<h1 style=\"text-align: center;\">D&iacute;a del Padre 2016</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El Reencuentro</span></h2>\r\n<p style=\"text-align: right;\">Adrian Rivera</p>\r\n<p style=\"text-align: right;\">19 de junio de 2016</p>\r\n<h1><a title=\"El Reencuentro\" href=\"http://bible.com/events/53603\" target=\"_blank\">Ingresa al estudio aqu&iacute;</a></h1>', 10, '2016-06-19'),
(515, 124, 'Generosidad', '<h1 style=\"text-align: center;\">Los Primeros Pasos</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Generosidad</span></h2>\r\n<p style=\"text-align: right;\">26 de junio de 2016</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1 style=\"text-align: left;\"><a title=\"Generosidad\" href=\"http://bible.com/events/55914\" target=\"_blank\">Ingresa al estudio aqu&iacute;</a></h1>', 1, '2016-06-26'),
(516, 125, 'La maratón de tu vida', '<h1 style=\"text-align: center;\">Una Fe Ol&iacute;mpica</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">La marat&oacute;n de tu vida</span></h2>\r\n<p style=\"text-align: right;\">3 de julio de 2016</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1><a title=\"La marat&oacute;n de tu vida\" href=\"http://bible.com/events/59746\" target=\"_blank\">Ingresa al estudio aqu&iacute;&nbsp;</a></h1>', 1, '2016-07-03'),
(517, 125, 'Medallas Eternas', '<h1 style=\"text-align: center;\">UNA FE OL&Iacute;MPICA</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Medallas Eternas</span></h2>\r\n<p style=\"text-align: right;\">10 de julio de 2016</p>\r\n<p style=\"text-align: right;\">Alejandro Handal</p>\r\n<h2 style=\"text-align: left;\">Dos opciones para ingresal al estudio:</h2>\r\n<h1><a title=\"Medallas Eternas\" href=\"https://notes.subsplash.com/fill-in/view?doc=5q4TDg2Pkl\" target=\"_blank\">Gran Comision App</a></h1>\r\n<h1 style=\"text-align: left;\"><a title=\"Medallas Eternas\" href=\"http://bible.com/events/62747\" target=\"_blank\">Bible App</a></h1>\r\n<h1>&nbsp;</h1>', 20, '2016-07-10'),
(518, 125, 'La Disciplina de un Atleta', '<h1 style=\"text-align: center;\">Una Fe Ol&iacute;mpica</h1>\r\n<h2 style=\"text-align: center;\">La Disciplina de un Atleta</h2>\r\n<p style=\"text-align: right;\">17 de julio de 2016</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h2>2 opciones para ingresar al estudio:</h2>\r\n<h1><a title=\"La Disciplina de un Atleta\" href=\"https://notes.subsplash.com/fill-in/view?doc=Zmxh35K86Z\" target=\"_blank\">Granco Mty App</a></h1>\r\n<h1><a title=\"La Disciplina de un Atleta\" href=\"http://bible.com/events/66215\" target=\"_blank\">The Bible App</a></h1>', 1, '2016-07-17'),
(519, 125, 'Descalificados', '<h1 style=\"text-align: center;\">Una Fe Ol&iacute;mpica</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Descalificados</span></h2>\r\n<p style=\"text-align: right;\">24 de julio de 2016</p>\r\n<p style=\"text-align: right;\">Allan Handal</p>\r\n<h1>2 opciones para ingresar al estudio:</h1>\r\n<h1><a title=\"Descalificados\" href=\"https://notes.subsplash.com/fill-in/view?doc=JvluyOkJYX\" target=\"_blank\">GranCo Mty App</a></h1>\r\n<h1><a title=\"Descalificados\" href=\"http://bible.com/events/69759\" target=\"_blank\">The Bible App</a></h1>\r\n<p>&nbsp;</p>', 3, '2016-07-24'),
(520, 126, '¿Son todas las religiones iguales?', '<h1 style=\"text-align: center;\">PREGUNTAS FRECUENTES</h1>\r\n<h2 style=\"text-align: center;\">&iquest;Son todas las religiones iguales?</h2>\r\n<p style=\"text-align: right;\">31 de julio de 2016</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>2 opciones para ingresar al estudio:</h1>\r\n<h1><a title=\"&iquest;\" href=\"https://notes.subsplash.com/fill-in/view?doc=ovimZmmNw\" target=\"_blank\">App GranCo Mty</a></h1>\r\n<h1><a title=\"&iquest;Son todas las religiones iguales?\" href=\"http://bible.com/events/73383\" target=\"_blank\">Bible App</a></h1>', 1, '2016-07-31'),
(521, 126, '¿Se acerca el fin del mundo?', '<h1 style=\"text-align: center;\">PREGUNTAS FRECUENTES</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">&iquest;Se acerca el fin del mundo?</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">7 de agosto de 2016</p>\r\n<h1>2 opciones para ver el estudio</h1>\r\n<h1><a title=\"&iquest;Se acerca el fin del mundo?\" href=\"https://notes.subsplash.com/fill-in/view?doc=K2LCb4leG0\" target=\"_blank\">App Iglesia Gran Comision Mty</a></h1>\r\n<h1><a title=\"&iquest;Se acerca el fin del mundo?\" href=\"http://bible.com/events/76671\" target=\"_blank\">The Bible App</a></h1>', 1, '2016-08-07'),
(522, 126, '¿Por qué crear controversia? Cada quién con su creencia.', '<h1 style=\"text-align: center;\">PREGUNTAS FRECUENTES</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">&iquest;Para qu&eacute; tanta controversia? Cada quien con su creencia</span></h2>\r\n<p style=\"text-align: right;\">14 de agosto de 2014</p>\r\n<p style=\"text-align: right;\">Samuel Ortiz</p>\r\n<h1>2 opciones para ingresar al estudio</h1>\r\n<h1><a title=\"&iquest;Para qu&eacute; tanta controversia?\" href=\"https://notes.subsplash.com/fill-in/view?doc=qvLiom65RN\" target=\"_blank\">1.- App Iglesia Gran Comisi&oacute;n Monterrey</a></h1>\r\n<h1><a title=\"&iquest;Para qu&eacute; tanta controversia?\" href=\"http://bible.com/events/80182\" target=\"_blank\">2.- The Bible App</a></h1>', 18, '2016-08-14'),
(523, 126, '¿Qué piensa Dios de los LGBT?', '<h1 style=\"text-align: center;\">PREGUNTAS FRECUENTES</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">&iquest;Qu&eacute; piensa Dios de los LGTB?</span></h2>\r\n<p style=\"text-align: right;\">21 de agosto de 2014</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>2 opciones para ingresar al estudio</h1>\r\n<h1>1.- <a title=\"&iquest;Qu&eacute; piensa Dios de los LGTB?\" href=\"https://notes.subsplash.com/fill-in/view?doc=RXzsgNlebz\" target=\"_blank\">App Iglesia Gran Comisi&oacute;n Monterrey</a></h1>\r\n<h1>2.- <a title=\"&iquest;Qu&eacute; piensa Dios de los LGTB?\" href=\"http://bible.com/events/83413\" target=\"_blank\">The Bible App</a></h1>', 1, '2016-08-21'),
(525, 126, '¿Por qué el cristianismo prohíbe muchas cosas?', '<h1 style=\"text-align: center;\">PREGUNTAS FRECUENTES</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">&iquest;Por qu&eacute; el cristianismo proh&iacute;be muchas cosas?</span></h2>\r\n<p style=\"text-align: right;\">28 de agosto de 2016</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>Dos opciones para ver el estudio:</h1>\r\n<h1><a title=\"&iquest;Por qu&eacute; el cristianismo proh&iacute;be muchas cosas?\" href=\"https://notes.subsplash.com/fill-in/view?doc=XR3I5b46kD\" target=\"_blank\">App Iglesia Gran Comsision.</a></h1>\r\n<h1><a title=\"&iquest;Por qu&eacute; el cristianismo proh&iacute;be muchas cosas?\" href=\"http://bible.com/events/86859\" target=\"_blank\">The Bible App.</a></h1>', 1, '2016-08-28'),
(526, 127, 'La oveja perdida', '<h1 style=\"text-align: center;\">Historias de Jes&uacute;s</h1>\r\n<h2 style=\"text-align: center;\">La oveja perdida</h2>\r\n<p style=\"text-align: right;\">4 de septiembre de 2016</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1 style=\"text-align: left;\">2 opciones para ingresal al estudio:</h1>\r\n<h1><a title=\"La oveja perdida\" href=\"https://notes.subsplash.com/fill-in/view?doc=8AVH37R6zJ\" target=\"_blank\">App Iglesia Gran Comision Montrerrey</a></h1>\r\n<h1><a title=\"La oveja perdida\" href=\"http://bible.com/events/90915\" target=\"_blank\">The Bible App</a></h1>', 1, '2016-09-04'),
(527, 127, 'El vecino no deseado', '<h1 style=\"text-align: center;\">Historias de Jes&uacute;s</h1>\r\n<h2 style=\"text-align: center;\">El vecino no deseado</h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">11 de Septiembre de 2016</p>\r\n<h1 style=\"text-align: left;\">2 opciones para ver el estudio:</h1>\r\n<h1 style=\"text-align: left;\"><a title=\"El vecino no deseado\" href=\"https://notes.subsplash.com/fill-in/view?doc=oxxumk0Djq\" target=\"_blank\">App Iglesia Gran Comisi&oacute;n</a></h1>\r\n<h1 style=\"text-align: left;\"><a title=\"El vecino no deseado\" href=\"http://bible.com/events/94034\" target=\"_blank\">The Bible App</a></h1>', 1, '2016-09-11'),
(528, 127, 'El tesoro enterrado', '<h1 style=\"text-align: center;\">Historias de Jes&uacute;s</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El tesoro enterrado</span></h2>\r\n<p style=\"text-align: right;\">Allan Handal</p>\r\n<p style=\"text-align: right;\">18 de septiembre de 2016</p>\r\n<h1>2 opciones para acceder al estudio:</h1>\r\n<h1><a title=\"El tesoro enterrado\" href=\"https://notes.subsplash.com/fill-in/view?doc=7Z9CVY5N34\" target=\"_blank\">App Iglesia Gran Comisi&oacute;n Monterrey</a></h1>\r\n<h1><a title=\"El tesoro enterrado\" href=\"http://bible.com/events/97904\" target=\"_blank\">The Bible App&nbsp;</a></h1>', 3, '2016-09-18'),
(529, 128, 'Sesión 1', '', 15, '2016-09-23'),
(530, 128, 'Sesión 2', '', 15, '2016-09-24'),
(531, 128, 'Sesión 3', '', 15, '2016-09-24'),
(532, 128, 'Sesión 4', '', 1, '2016-09-25'),
(533, 129, 'Las Pruebas de la Vida', '<h1 style=\"text-align: center;\">De Pel&iacute;cula 2016</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Las Pruebas de la Vida</span></h2>\r\n<p style=\"text-align: right;\">3 de octubre de 2016</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>2 opciones para ver el estudio:</h1>\r\n<h1><a title=\"Las pruebas de la vida.\" href=\"https://notes.subsplash.com/fill-in/view?doc=XEmf58vZRm\" target=\"_blank\">App Iglesia Gran Comsi&oacute;n</a></h1>\r\n<h1><a title=\"Las pruebas de la vida.\" href=\"http://bible.com/events/105096\" target=\"_blank\">The Bible App</a></h1>', 1, '2016-10-02'),
(534, 129, 'De Regreso Al Futuro', '<h1 style=\"text-align: center;\">De Pelicula 2016</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">De Regreso al Futuro</span></h2>\r\n<p style=\"text-align: right;\">9 de octubre de 2016</p>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<h1>2 formas de ver el estudio:</h1>\r\n<h1><a title=\"De regreso al futuro\" href=\"https://notes.subsplash.com/fill-in/view?doc=1jkHGnxVqe\" target=\"_blank\">App Gran Comision Monterrey</a></h1>\r\n<h1><a title=\"De regreso al futuro\" href=\"http://bible.com/events/108994\" target=\"_blank\">The Bible App</a></h1>', 9, '2016-10-09'),
(535, 129, 'Al Control de mis Emociones', '', 1, '2016-10-16'),
(536, 129, 'La Batalla Épica de mi Vida', '<h1 style=\"text-align: center;\">De Pelicula 2016</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">La Batalla &Eacute;pica de mi Vida</span></h2>\r\n<p style=\"text-align: right;\">23 de octubre de 2016</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>Dos opciones para entrar al estudio:</h1>\r\n<h1><a title=\"La batalla &eacute;pica de mi vida\" href=\"https://notes.subsplash.com/fill-in/view?doc=35LfREYA7Z\" target=\"_blank\">App Iglesia Gran Comision.</a></h1>\r\n<h1><a title=\"La batalla &eacute;pica de mi vida\" href=\"http://bible.com/events/116464\" target=\"_blank\">The Bible App</a></h1>\r\n<p>&nbsp;</p>', 1, '2016-10-23'),
(537, 130, 'Identidad', '<h1 style=\"text-align: center;\">MI NUEVO YO</h1>\r\n<h2 style=\"text-align: center;\">Identidad</h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">30 de octubre de 2016</p>\r\n<h1>2 formas de ingresal al estudio:</h1>\r\n<h1><a title=\"Identidad\" href=\"https://notes.subsplash.com/fill-in/view?doc=EmKTNx6ej1\" target=\"_blank\">App Iglesia Gran Comisi&oacute;n</a></h1>\r\n<h1><a title=\"Identidad\" href=\"http://bible.com/events/119170\" target=\"_blank\">The Biblble App</a></h1>', 1, '2016-10-30'),
(538, 130, 'Pertenencia', '<h1 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Mi Nuevo Yo</span></h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Pertenencia</span></h2>\r\n<p style=\"text-align: right;\">6 de Noviembre de 2016</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1 style=\"text-align: left;\">Dos opciones para ver el estudio:</h1>\r\n<h1 style=\"text-align: left;\"><a title=\"Pertenencia\" href=\"https://notes.subsplash.com/fill-in/view?doc=aLxTAL39l4\" target=\"_blank\">App Iglesia Gran Comision</a></h1>\r\n<h1><a title=\"Pertenencia\" href=\"http://bible.com/events/123736\" target=\"_blank\">The Bible App</a></h1>', 1, '2016-11-06'),
(539, 130, 'Servicio', '<h1 style=\"text-align: center;\">Mi Nuevo Yo</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Servicio</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">13 de noviembre de 2016</p>\r\n<h1>2 opciones para ver la giuia:</h1>\r\n<h1><a title=\"Servicio\" href=\"https://notes.subsplash.com/fill-in/view?doc=J8sylbxgm\" target=\"_blank\">App Gran Comision.</a></h1>\r\n<h1 style=\"text-align: left;\"><a title=\"Servicio\" href=\"http://bible.com/events/126524\" target=\"_blank\">The Bible App.</a></h1>', 1, '2016-11-13'),
(540, 130, 'Influencia', '<h1 style=\"text-align: center;\">Mi Nuevo Yo</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Influencia</span></h2>\r\n<p style=\"text-align: right;\">Samuel Ortiz</p>\r\n<p style=\"text-align: right;\">20 de noviembre de 2016</p>\r\n<h1>Dos opciones para ver el estudio:</h1>\r\n<h1><a title=\"Influencia\" href=\"https://notes.subsplash.com/fill-in/view?doc=8OGi35884J\" target=\"_blank\">App Gran Comision Monterrey</a></h1>\r\n<h1><a title=\"Influencia\" href=\"http://bible.com/events/130226\" target=\"_blank\">The Bible App</a></h1>', 18, '2016-11-20'),
(541, 130, 'Poder', '<h1 style=\"text-align: center;\">Mi Nuevo Yo</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Poder</span></h2>\r\n<p style=\"text-align: right;\">27 de noviembre de 2016</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>Dos opciones para ver el mensaje</h1>\r\n<h1><a title=\"Poder\" href=\"https://notes.subsplash.com/fill-in/view?doc=w4EuDGZ9mX\" target=\"_blank\">App Gran Comisi&oacute;n</a></h1>\r\n<h1><a title=\"Poder\" href=\"http://bible.com/events/133133\" target=\"_blank\">The Bible App</a></h1>', 1, '2016-11-27'),
(542, 131, 'Superando las ofensas', '<h1 style=\"text-align: center;\">Los Fantasmas de las Navidades Pasadas</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Superando las ofensas</span></h2>\r\n<p style=\"text-align: right;\">4 de diciembre de 2016</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>2 opciones para acceder al estudio:</h1>\r\n<h1><a title=\"Superando las ofensas\" href=\"https://notes.subsplash.com/fill-in/view?doc=Ro9tgr1NK5\" target=\"_blank\">App Iglesia Gran Comisi&oacute;n</a></h1>\r\n<h1><a title=\"Superando las ofensas\" href=\"http://bible.com/events/136878\" target=\"_blank\">The Bible App</a></h1>', 1, '2016-12-04'),
(543, 131, 'Superando la falta de generosidad', '', 8, '2016-12-11'),
(544, 131, 'Perdonándome a mí mismo', '<h1 style=\"text-align: center;\">Los Fantasmas de las Navidades Pasadas</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Perdon&aacute;ndome a m&iacute; mismo</span></h2>\r\n<p style=\"text-align: right;\">18 de diciembre de 2016</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>Dos opciones para acceder al boletin:</h1>\r\n<h1><a title=\"Perdon&aacute;ndome a m&iacute; mismo\" href=\"https://notes.subsplash.com/fill-in/view?doc=0VPSl4e3KO\" target=\"_blank\">App Iglesia Gran Comision</a></h1>\r\n<h1><a title=\"Perdon&aacute;ndome a m&iacute; mismo\" href=\"http://bible.com/events/143236\" target=\"_blank\">The Bible App</a></h1>', 1, '2016-12-18'),
(545, 132, '¿Qué tan grande es tu visión?', '<h1 style=\"text-align: center;\">&iquest;Qu&eacute; tan grande es tu visi&oacute;n?</h1>\r\n<p style=\"text-align: right;\">1&deg; de Enero de 2017</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1 style=\"text-align: left;\">2 opciones para ver las notas el estudio:</h1>\r\n<h1 style=\"text-align: left;\"><a title=\"&iquest;Qu&eacute; tan grande es tu visi&oacute;n?\" href=\"https://notes.subsplash.com/fill-in/view?doc=plPtrba3ON\">App Gran Comsi&oacute;n</a></h1>\r\n<h1 style=\"text-align: left;\"><a title=\"&iquest;Qu&eacute; tan grande es tu visi&oacute;n?\" href=\"http://bible.com/events/148476\" target=\"_blank\">The Bible App</a></h1>', 1, '2017-01-01'),
(546, 133, 'El llamado es para ti', '<h1 style=\"text-align: center;\">DESCUBRIENDO MI LLAMADO</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El llamado es para ti</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">8 de enero de 2017</p>\r\n<h1>2 opciones para ver el mensaje</h1>\r\n<h1><a title=\"El llamado es para ti\" href=\"https://notes.subsplash.com/fill-in/view?doc=wVwFDLYeYJ\" target=\"_blank\">App Gran Comision</a></h1>\r\n<h1><a title=\"El llamado es para ti\" href=\"http://bible.com/events/151157\" target=\"_blank\">The Bible App</a></h1>', 1, '2017-01-08'),
(547, 133, 'Llamado a ser amado', '<h1 style=\"text-align: center;\">DESCUBRIENDO MI LLAMADO</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Llamado a ser amado</span></h2>\r\n<p style=\"text-align: right;\">15 de enero 2016</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>Dos opciones para ver el estudio:</h1>\r\n<h1><a title=\"Llamado a ser amado\" href=\"https://notes.subsplash.com/fill-in/view?doc=XRXT0ojPK2\" target=\"_blank\">App Iglesia Gran Comisi&oacute;n</a></h1>\r\n<h1><a title=\"http://bible.com/events/154988\" href=\"http://bible.com/events/154988\" target=\"_self\">The Bible App</a></h1>', 1, '2017-01-15'),
(548, 133, 'Llamado a ser y crecer', '<h1 style=\"text-align: center;\">DESCUBRIENDO MI LLAMADO</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Llamado a ser y creer</span></h2>\r\n<p style=\"text-align: right;\">29 de enero de 2017</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>Dos opciones para las notas del estudio:</h1>\r\n<h1>1) <a title=\"Llamado a ser y creer\" href=\"https://notes.subsplash.com/fill-in/view?doc=b2NUpzYlp6\" target=\"_blank\">App Iglesia Gran Comisi&oacute;n</a></h1>\r\n<h1>2) <a title=\"Llamado a ser y creer\" href=\"http://bible.com/events/162549\" target=\"_blank\">The Bible App</a></h1>', 1, '2017-01-29'),
(549, 133, 'Llamado a servir', '<h1 style=\"text-align: center;\">DESCUBRIENDO MI LLAMADO</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Llamado a servir</span></h2>\r\n<p style=\"text-align: right;\">5 de febrero de 2017</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1 style=\"text-align: left;\">Dos opciones para ver el mensaje</h1>\r\n<h1>1) <a title=\"Llamado a servir\" href=\"https://notes.subsplash.com/fill-in/view?doc=mkwtVoYPpL\" target=\"_blank\">App Iglesia Gran Comision</a></h1>\r\n<h1>2) <a title=\"Llamado a servir\" href=\"http://bible.com/events/166564\" target=\"_blank\">The Bible App</a></h1>', 1, '2017-02-05'),
(550, 133, 'Llamado a pertenecer', '<h1 style=\"text-align: center;\">DESCUBRIENDO MI LLAMADO</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Llamado a pertenecer</span></h2>\r\n<p style=\"text-align: right;\">21 de enero de 2017</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>Dos opciones para ver las notas:</h1>\r\n<h1>1) <a title=\"Llamado a pertenecer\" href=\"https://notes.subsplash.com/fill-in/view?doc=NRTm750YA\" target=\"_blank\">App Iglesia Gran Comisi&oacute;n</a></h1>\r\n<h1>2) The Bible App</h1>', 1, '2017-01-22');
INSERT INTO `mensajes` (`id_mensaje`, `id_serie`, `mensaje`, `resumen`, `id_expositor`, `fecha`) VALUES
(551, 133, 'Llamado a ser enviado', '<h1 style=\"text-align: center;\">DESCUBIRNDO MI LLAMADO</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Llamado a ser enviado</span></h2>\r\n<p style=\"text-align: right;\">12 de febrero de 2017</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"Llamado a ser enviado.\" href=\"https://notes.subsplash.com/fill-in/view?doc=8rLf4vb6Vy\" target=\"_blank\">Notas online App Iglesia Gran Comision</a></h1>\r\n<h1>2) <a title=\"Llamado a ser enviado.\" href=\"http://bible.com/events/170094\" target=\"_blank\">Notas en The Bible App</a></h1>', 1, '2017-02-12'),
(552, 133, 'Llamado a resistir', '<h1 style=\"text-align: center;\">DESCUBRIENO MI LLAMADO</h1>\r\n<p style=\"text-align: center;\">Llamado a resitir</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">19 de febrero de 2017</p>\r\n<h1>Dos opciones para acceder a las notas:</h1>\r\n<h1>1) <a title=\"Llamado a resistir\" href=\"https://notes.subsplash.com/fill-in/view?doc=0V7CJ3v32n\" target=\"_blank\">App Gran Comisi&oacute;n</a></h1>\r\n<h1>2) <a title=\"Llamado a resistir\" href=\"http://bible.com/events/173760\" target=\"_blank\">The Bible App</a></h1>', 1, '2017-02-19'),
(553, 133, 'Llamado a trascender ', '<h1 style=\"text-align: center;\">DESCUBRIENDO MI LLAMADO</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Llamado a trascender</span></h2>\r\n<p style=\"text-align: right;\">Allan Handal</p>\r\n<p style=\"text-align: right;\">26 de febrero de 2017</p>\r\n<h1>2 Opciones para ver las notas:</h1>\r\n<h1><a title=\"Llamado a trascender\" href=\"https://notes.subsplash.com/fill-in/view?doc=HyDkDklcx\" target=\"_blank\">App Gran Comision</a></h1>\r\n<h1><a title=\"Llamado a trascender\" href=\"http://bible.com/events/177385\" target=\"_blank\">The Bible App</a></h1>', 3, '2017-02-26'),
(554, 134, 'menos es MÁS', '<h1 style=\"text-align: center;\">NUEVA PER$PECTIVA</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">manos es M&Aacute;S</span></h2>\r\n<p style=\"text-align: right;\">5 de marzo de 2017</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>Dos opciones para ver las notas del estudio</h1>\r\n<h1><a title=\"menos es M&Agrave;S\" href=\"https://notes.subsplash.com/fill-in/view?doc=Bk2kaWK5l\" target=\"_blank\">1) App Iglesia Gran Comisi&oacute;n</a></h1>\r\n<h1><a title=\"menos es M&Agrave;S\" href=\"http://bible.com/events/181334\" target=\"_blank\">2) The Bible App</a></h1>', 1, '2017-03-05'),
(555, 134, 'La prueba del éxito.', '', 9, '2017-03-26'),
(556, 134, 'Generosidad Irracional.', '<h1 style=\"text-align: center;\">NUEVA PER$PECTIVA</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Generosidad irracional</span></h2>\r\n<p style=\"text-align: right;\">12 de marzo de 2017</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>Dos opciones para ver las notas del estudio</h1>\r\n<h1><a title=\"Generosidad irracional\" href=\"https://notes.subsplash.com/fill-in/view?doc=r1pHo3zie\" target=\"_blank\">1) App Iglesia Gran Comisi&oacute;n</a></h1>\r\n<h1><a title=\"Generosidad irracional\" href=\"http://bible.com/events/185488\" target=\"_blank\">2) The Bible App</a></h1>', 1, '2017-03-12'),
(557, 134, 'Superando tus Tristezas y Temores', '<h1 style=\"text-align: center;\">NUEVA PERSPECTIVA</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Superando tus Tristezas y Temores</span></h2>\r\n<p style=\"text-align: right;\">19 de marzo de 2017</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>Dos opciones para ver el la guia del estudio:</h1>\r\n<h1>1) <a title=\"Superando tus Tristezas y Temores\" href=\"https://notes.subsplash.com/fill-in/view?doc=BJgV1piix\" target=\"_blank\">App Gran Comision</a></h1>\r\n<h1>2) <a title=\"Superando tus Tristezas y Temores\" href=\"http://bible.com/events/189116\" target=\"_blank\">The bible App</a></h1>', 1, '2017-03-19'),
(558, 134, 'Como ser rico', '<h1 style=\"text-align: center;\">Nueva Per$pectiva</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Como ser rico</span></h2>\r\n<p style=\"text-align: right;\">2 de abril de 2017</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>Dos opciones para ver las notas del estudio</h1>\r\n<h1>1) <a title=\"Como ser rico\" href=\"https://notes.subsplash.com/fill-in/view?doc=S1IpPG02g\" target=\"_blank\">Notas online para llenado App Gran Comisi&oacute;n</a></h1>\r\n<h1>2) <a title=\"Como ser rico\" href=\"http://bible.com/events/196554\" target=\"_blank\">Notas, the Bible App</a></h1>', 1, '2017-04-02'),
(559, 136, 'Considera a Jesus', '', 8, '2017-04-09'),
(560, 137, 'Más de lo mismo', '<h1 style=\"text-align: center;\">El Poder de lo Mismo</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">M&aacute;s de lo mismo</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">23 de abril de 2017</p>\r\n<h1>2 Opciones para ver las notas</h1>\r\n<h1><a title=\"M&aacute;s de lo mismo\" href=\"https://notes.subsplash.com/fill-in/view?doc=Bkv_OiKRl\" target=\"_blank\">App Gran Comisi&oacute;n</a></h1>\r\n<h1><a title=\"M&aacute;s de lo mismo\" href=\"http://bible.com/events/207687\" target=\"_blank\">The Bible App</a></h1>', 1, '2017-04-23'),
(561, 137, 'El problema es el patrón ', '<h1 style=\"text-align: center;\">El Poder de lo Mismo</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El Problema es el Patr&oacute;n</span></h2>\r\n<p style=\"text-align: right;\">30 de abril de 2017</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>2 opciones para ver las notas</h1>\r\n<h1><a title=\"El problema es el patr&oacute;n\" href=\"https://notes.subsplash.com/fill-in/view?doc=SJR8S-7J-\" target=\"_blank\">1) App Gran Comisi&oacute;n</a></h1>\r\n<h1><a title=\"El problema es el patr&oacute;n\" href=\"http://bible.com/events/211391\" target=\"_blank\">2) The Bible App</a></h1>', 1, '2017-04-30'),
(562, 137, 'ESPECIAL: Celebrando a mamá', '<h1 style=\"text-align: center;\">Celebrando a mam&aacute;</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Un pilar en el hogar</span></h2>\r\n<p style=\"text-align: right;\">7 de mayo 2017</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>Dos opciones para ver el estudio:</h1>\r\n<h1><a title=\"Celebrando a mam&aacute;\" href=\"https://notes.subsplash.com/fill-in/view?doc=SyOBUZn1-\" target=\"_blank\">1) Notas para llenar online App Gran Comisi&oacute;n</a></h1>\r\n<h1><a title=\"Celebrando a mam&aacute;\" href=\"http://bible.com/events/214821\" target=\"_blank\">2) Notas The Bible App</a></h1>', 1, '2017-05-07'),
(563, 137, 'El secreto del éxito sustentable', '<h1 style=\"text-align: center;\">El Poder de lo Mismo</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El secreto del &eacute;xito sustentable</span></h2>\r\n<p style=\"text-align: right;\">14 de mayo 2017</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>2 opciones para ver las notas:</h1>\r\n<h1>1) <a title=\"El secreto del &eacute;xito sustentable\" href=\"https://notes.subsplash.com/fill-in/view?doc=ByhGA8reZ\" target=\"_blank\">Llenado online App Gran Comisi&oacute;n</a></h1>\r\n<h1>2) <a title=\"El secreto del &eacute;xito sustentable\" href=\"http://bible.com/events/218551\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2017-05-14'),
(564, 137, 'El proceso de recorte', '<h1 style=\"text-align: center;\">El Poder de lo Mismo</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El Proceso del Recorte</span></h2>\r\n<p style=\"text-align: right;\">21 de mayo 2017</p>\r\n<p style=\"text-align: right;\">Allan Handal</p>\r\n<h1>2 Opciones para las notas de la predica</h1>\r\n<h1><a title=\"El Proceso del Recorte\" href=\"https://notes.subsplash.com/fill-in/view?doc=BJ143OCgW\" target=\"_blank\">1) Notas para llenado online App Gran Comisi&oacute;n</a></h1>\r\n<p>&nbsp;</p>\r\n<h1><a title=\"El Proceso del Recorte\" href=\"http://bible.com/events/221847\" target=\"_blank\">2) Notas The Bible App</a></h1>', 3, '2017-05-21'),
(565, 138, 'El Menos Favorito', '<h1 style=\"text-align: center;\">Coraz&oacute;n de Oro</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El Menos Favorito</span></h2>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: right;\">28 de mayo de 2017</p>\r\n<h1>2 opciones para ver las notas:</h1>\r\n<h1>1) <a class=\"_970ef1-opened\" title=\"El menos favorito\" href=\"https://notes.subsplash.com/fill-in/view?doc=S1bsCTvZW\" target=\"_blank\">Notas para llenado online App Granco</a></h1>\r\n<h1>2) <a class=\"_970ef1-opened\" title=\"El menos favorito\" href=\"http://bible.com/events/225567\" target=\"_blank\">Notas The Bible App</a></h1>', 9, '2017-05-28'),
(566, 138, 'El Héroe Anónimo', '<h1 style=\"text-align: center;\">Coraz&oacute;n de Oro</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El H&eacute;roe An&oacute;nimo</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">4 de junio 2017</p>\r\n<h1>Dos opciones para ver las notas:</h1>\r\n<h1>1) <a class=\"_970ef1-opened\" title=\"El H&eacute;roe An&oacute;nimo \" href=\"https://notes.subsplash.com/fill-in/view?doc=HyL2MJbf-\" target=\"_blank\">Notas para llenado online App Granco</a></h1>\r\n<h1>2) <a class=\"_970ef1-opened\" title=\"El H&eacute;roe An&oacute;nimo \" href=\"http://bible.com/events/228839\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2017-06-04'),
(567, 138, 'El Guardaespaldas', '<h1 style=\"text-align: center;\">Coraz&oacute;n de Oro</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El Guardaespaldas</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">11 de junio 2017</p>\r\n<h1>Para ver las notas del estudio</h1>\r\n<h1><a class=\"_970ef1-opened\" title=\"El Guardaespaldas\" href=\"https://notes.subsplash.com/fill-in/view?doc=SJ9dNejMZ\" target=\"_blank\">1) Notas para llenado Online App Granco</a></h1>', 1, '2017-06-11'),
(568, 138, 'El Rey Humilde', '<h1 style=\"text-align: center;\">Coraz&oacute;n de Oro</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El Rey Humilde</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">18 de junio de 2017</p>\r\n<p style=\"text-align: right;\">&nbsp;</p>\r\n<h1 style=\"text-align: left;\">Dos opciones para ver las notas</h1>\r\n<h1><a title=\"El Rey Humilde\" href=\"https://notes.subsplash.com/fill-in/view?doc=HkrbQT7X-\" target=\"_blank\">1) Notas para llenado en linea App Granco</a></h1>\r\n<h1><a title=\"El Rey Humilde\" href=\"http://bible.com/events/236170\" target=\"_blank\">2) Notas The Bible App</a></h1>', 1, '2017-06-18'),
(569, 138, 'Un Legado Permanente', '<h1 style=\"text-align: center;\">Coraz&oacute;n de Oro</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Un Legado Permamante</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">25 de junio 2017</p>\r\n<h1>Dos opciones para ver el estudio</h1>\r\n<h1><a title=\"Un Legado Permanente\" href=\"https://notes.subsplash.com/fill-in/view?doc=ryp62QpQW\" target=\"_blank\">1) Notas Llenado Online App Granco</a></h1>\r\n<h1><a title=\"Un Legado Permanente\" href=\"http://bible.com/events/239831\" target=\"_blank\">2) Notas en The Bible App</a></h1>', 1, '2017-06-25'),
(570, 138, 'Recuperando Todo', '<h1 style=\"text-align: center;\">Coraz&oacute;n de Oro</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Recuperandolo Todo</span></h2>\r\n<p style=\"text-align: right;\">Samuel Ortiz</p>\r\n<p style=\"text-align: right;\">2 de julio de 2017</p>\r\n<h1>Dos opciones para ver las notas:</h1>\r\n<h1>1) <a class=\"_970ef1-opened\" title=\"Recuperandolo Todo\" href=\"https://notes.subsplash.com/fill-in/view?doc=SklPN0BVb\" target=\"_blank\">Notas para llenado online App Granco</a></h1>\r\n<h1>2) <a class=\"_970ef1-opened\" title=\"Recuperandolo Todo\" href=\"http://bible.com/events/242886\" target=\"_blank\">Notas the Bible App</a></h1>', 18, '2017-07-02'),
(571, 139, 'Compruébalo tu mismo', '<h1 style=\"text-align: center;\">5 Coasas que&nbsp;Dios Usa&nbsp;para Hacer Crecer Nuetra FE</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Compru&eacute;balo t&uacute; mismo</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">9 de junio de 2017</p>\r\n<p style=\"text-align: right;\">&nbsp;</p>\r\n<h1 style=\"text-align: left;\">Dos opciones para ver las notas del mensaje:</h1>\r\n<h1 style=\"text-align: left;\">1) <a class=\"_970ef1-opened\" title=\"Compru&eacute;balo t&uacute; mimso\" href=\"https://notes.subsplash.com/fill-in/view?doc=rJxzbjA4-\" target=\"_blank\">Notas para llenado oline App Granco</a></h1>\r\n<h1 style=\"text-align: left;\">2) <a class=\"_970ef1-opened\" title=\"Compru&eacute;balo t&uacute; mimso\" href=\"http://bible.com/events/245958\" target=\"_blank\">Notas the Bible App</a></h1>', 1, '2017-07-09'),
(572, 139, 'Enseñanza Práctica', '<h1 style=\"text-align: center;\">5 Cosas que Dios usa para hacer crecer nuetra FE</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Ense&ntilde;anza Practica</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">16 de julio de 2017</p>\r\n<h1 style=\"text-align: left;\">Dos opciones para ver la notas del estudio</h1>\r\n<h1 style=\"text-align: left;\">1) <a title=\"Ense&ntilde;anza Pr&aacute;ctica\" href=\"https://notes.subsplash.com/fill-in/view?doc=r1Q2iJKSZ\" target=\"_blank\">Notas llenado online App Granco Mty</a></h1>\r\n<h1 style=\"text-align: left;\">2) <a title=\"Ense&ntilde;anza Pr&aacute;ctica\" href=\"http://bible.com/events/250155\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2017-07-16'),
(573, 139, 'Disciplinas Espirituales', '<h1 style=\"text-align: center;\">5 Cosas que Dios Usa para Hacer Crecer Nuetra FE</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Disciplinas Espirituales</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">23 de julio de 2017</p>\r\n<h1>Dos opciones para las notas del estudio</h1>\r\n<h1>1) <a title=\"Disciplinas Espirituales\" href=\"https://notes.subsplash.com/fill-in/view?doc=BJmUOTW8W\" target=\"_blank\">Notas para llenado Online App GranCo Mty</a></h1>\r\n<h1>2) <a title=\"Disciplinas Espirituales\" href=\"http://bible.com/events/253157\" target=\"_blank\">Notas \"The Bibles App\"</a></h1>', 1, '2017-07-23'),
(574, 139, 'Ministerio Personal', '<h1 style=\"text-align: center;\">5 Coas que Dios Usa para Hacer Crecer Nuetra FE</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Ministerio Personal</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">30 de julio de 2017</p>\r\n<h1>Dos opcionespara ver la notas del mensaje:</h1>\r\n<h1>1) <a title=\"Ministerio Personal\" href=\"https://notes.subsplash.com/fill-in/view?doc=BkEFZgoLZ\" target=\"_blank\">Notas para llenado online App GranCo Mty</a></h1>\r\n<h1>2) <a title=\"Ministerio Personal\" href=\"http://bible.com/events/256432\" target=\"_blank\">Notas the Bible App&nbsp;</a></h1>', 1, '2017-07-30'),
(575, 139, 'Relaciones Providenciales', '<h1 style=\"text-align: center;\">5 Cosas que Dios Usa para Hacer Crecer Nuetra FE</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Relaciones Providenciales</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">6 de agosto de 2017</p>\r\n<h1>Dos opciones para ver las notas del estudio.</h1>\r\n<h1>1. <a title=\"Relaciones Providenciales\" href=\"https://notes.subsplash.com/fill-in/view?doc=HyIDwQ4PZ\" target=\"_blank\">Notas para llenado online App GranCo.</a></h1>\r\n<h1>2. <a title=\"Relaciones Providenciales\" href=\"http://bible.com/events/259855\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2017-08-06'),
(576, 139, 'Circunstancias Cruciales', '<h1 style=\"text-align: center;\">5 Cosas que Dios Usa para Hacer Crecre Nuestra Fe</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Circunatancias Cruciales</span></h2>\r\n<p style=\"text-align: right;\">13 de agosto de 2017</p>\r\n<p style=\"text-align: right;\">Allan Handal</p>\r\n<h1 style=\"text-align: left;\">Dos opciones para las notas del estudio:</h1>\r\n<h1 style=\"text-align: left;\">1) <a title=\"Circunstancias Cruciales\" href=\"https://notes.subsplash.com/fill-in/view?doc=BJhFHajvW\" target=\"_blank\">Notas llenado online App Granco</a></h1>\r\n<h1 style=\"text-align: left;\">2) <a title=\"Circunstancias Cruciales\" href=\"http://bible.com/events/262446\" target=\"_blank\">Notas The Bible App</a></h1>', 3, '2017-08-13'),
(577, 140, 'Color Esperanza', '<h1 style=\"text-align: center;\">Playlist</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Color esperanza</span></h2>\r\n<p style=\"text-align: right;\">Fecha: 20 de agosto de 2017</p>\r\n<p style=\"text-align: right;\">Segio Handal</p>\r\n<h1><a title=\"Color esperanza\" href=\"https://notes.subsplash.com/fill-in/view?doc=BJbb0QI_Z\" target=\"_blank\">1) Notas llenado online App GranCo</a></h1>\r\n<h1><a title=\"Color esperanza\" href=\"http://bible.com/events/266049\" target=\"_blank\">2) Notas The Bible App</a></h1>', 1, '2017-08-20'),
(578, 140, 'Reflejo', '<h1 style=\"text-align: center;\">Playlist</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Mi Reflejo</span></h2>\r\n<p style=\"text-align: right;\">Fecha: 27 de agosto de 2017</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1><a title=\"Mi Reflejo\" href=\"https://notes.subsplash.com/fill-in/view?doc=ByzBfikF-\" target=\"_blank\">1) Notas llenado online App GranCo</a></h1>\r\n<h1><a title=\"Mi Reflejo\" href=\"http://bible.com/events/270375%20\" target=\"_blank\">2) Notas The Bible App</a>&nbsp;&nbsp;</h1>', 1, '2017-08-27'),
(579, 140, 'Corazón Partío', '<h1 style=\"text-align: center;\">PLAYLIST</h1>\r\n<p style=\"text-align: center;\">Coraz&oacute;n Part&iacute;o</p>\r\n<p style=\"text-align: right;\">3 de deptiembre de 2017</p>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<h1>Dos opciones para ver las nots:</h1>\r\n<h1>1) <a title=\"Coraz&oacute;n Part&iacute;o\" href=\"https://notes.subsplash.com/fill-in/view?doc=B19wretKZ\" target=\"_blank\">Notas llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"Coraz&oacute;n Part&iacute;o\" href=\"http://bible.com/events/274183\" target=\"_blank\">Notas the Bible App</a></h1>\r\n<p>&nbsp;</p>', 9, '2017-09-03'),
(580, 140, 'Yo solo quiero...', '<h1 style=\"text-align: center;\">Playlist</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Yo s&oacute;lo quiero...</span></h2>\r\n<p style=\"text-align: right;\">Fecha: 10 de septiembre de 2017</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1><a title=\"Yo s&oacute;lo quiero\" href=\"https://notes.subsplash.com/fill-in/view?doc=B14D82M5Z\" target=\"_blank\">Notas llenado online App Granco</a></h1>\r\n<h1><a title=\"Yo s&oacute;lo quiero\" href=\"http://bible.com/events/278081\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2017-09-10'),
(581, 141, '¿Quién era Jesús?', '', 8, '2017-09-17'),
(582, 142, 'Conferencia 1 - Nelson Guerra', '', 4, '2017-09-22'),
(583, 142, 'Conferencia 2 - Francisco Morales', '', 14, '2017-09-23'),
(584, 142, 'Conferencia 3 - Edwing Carcamo', '', 15, '2017-09-23'),
(585, 142, 'Conferencia 4 - Kurt Jurgensmeier', '', 13, '2017-09-23'),
(586, 142, 'Conferencia 5 - Nelson Guerra', '', 4, '2017-09-24'),
(587, 142, 'Conferencia 6 - Ignacio Pecina', '', 21, '2017-09-24'),
(588, 143, 'Profundamente dependiente de Dios', '', 1, '2017-10-01'),
(589, 143, 'Seguidor sacrificado', '<h1 style=\"text-align: center;\">Diferente</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Seguidor sacrificado</span></h2>\r\n<p style=\"text-align: right;\">Fecha: 8 de octubre de 2017</p>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: left;\">&nbsp;</p>\r\n<h1><a title=\"Servidor sacrificado\" href=\"https://notes.subsplash.com/fill-in/view?doc=HyLPEovh-\" target=\"_blank\">1) Notas llenado online app Granco</a></h1>', 9, '2017-10-08'),
(590, 143, 'Aprendiz de toda la vida', '', 19, '2017-10-15'),
(591, 143, 'Pescador de hombres', '', 1, '2017-10-22'),
(593, 143, 'Siervo abnegado', '', 1, '2017-10-29'),
(594, 144, 'Límites en el Matrimonio', '<h1 style=\"text-align: center;\">L&Iacute;MITES</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">L&iacute;mites en el Matrimonio</span></h2>\r\n<p style=\"text-align: right;\">5 de noviembre de 2017</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1 style=\"text-align: left;\">Dos opciones para ver las notas del estudio:</h1>\r\n<h1 style=\"text-align: left;\">1) <a title=\"L&iacute;mites en el Matrimonio.\" href=\"https://notes.subsplash.com/fill-in/view?doc=r1P4ggnAZ\" target=\"_blank\">Notas App GranCo</a></h1>\r\n<h1 style=\"text-align: left;\">2) <a title=\"L&iacute;mites en el Matrimonio.\" href=\"http://bible.com/events/306376\" target=\"_blank\">Notas Bible App</a></h1>', 1, '2017-11-05'),
(595, 144, 'Limites en el Trabajo', '<h1 style=\"text-align: center;\">L&Iacute;MITES</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration-line: underline;\">L&iacute;mites en el Trabajo</span></h2>\r\n<p style=\"text-align: right;\">12 de noviembre de 2017</p>\r\n<p style=\"text-align: right;\">Allan Handal</p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1)&nbsp;<a title=\"L&iacute;mites en el Trabajo.\" href=\"https://notes.subsplash.com/fill-in/view?doc=H1DfCJU1M\" target=\"_blank\">Notas App GranCo</a></h1>\r\n<h1>2)&nbsp;<a title=\"L&iacute;mites en el Trabajo.\" href=\"http://bible.com/events/312255\" target=\"_blank\">Notas Bible App</a></h1>', 3, '2017-11-14'),
(596, 144, 'Límites con los Hijos', '<h1 style=\"text-align: center;\">L&Iacute;MITES</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration-line: underline;\">L&iacute;mites con los Hijos</span></h2>\r\n<p style=\"text-align: right;\">19 de noviembre de 2017</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1)&nbsp;<a title=\"L&iacute;mites con los Hijos\" href=\"https://notes.subsplash.com/fill-in/view?doc=ryzhrcRJM\" target=\"_blank\">Notas App GranCo</a></h1>\r\n<h1>2)&nbsp;<a title=\"L&iacute;mites con los Hijos\" href=\"http://bible.com/events/315485\" target=\"_blank\">Notas Bible App</a></h1>', 1, '2017-11-19'),
(597, 144, 'Límites con los Amigos', '<h1 style=\"text-align: center;\">L&Iacute;MITES</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">L&iacute;mites con los Amigos</span></h2>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: right;\">26 de noviembre de 2017</p>\r\n<h1>Dos ocpciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"L&iacute;mites con los Amigos\" href=\"https://notes.subsplash.com/fill-in/view?doc=HyKNS1ugM\" target=\"_blank\">Notas App Granco</a></h1>\r\n<h1>2) <a title=\"L&iacute;mites con los Amigos\" href=\"http://bible.com/events/318792\" target=\"_blank\">Notas Bible App</a></h1>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>', 9, '2017-11-26'),
(598, 145, 'El milagro no es el milagro', '<h1 style=\"text-align: center;\">EXPECTANTE</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El milagro no es el milagro</span></h2>\r\n<p style=\"text-align: right;\">3 de diciembre de 2017</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>Dos opciones para ver las notas:</h1>\r\n<h1>1) <a title=\"El milagro no es el milagro\" href=\"https://notes.subsplash.com/fill-in/view?doc=Bk4XuxWWG\" target=\"_blank\">Notas llenado online Granco App</a></h1>\r\n<h1>2) <a title=\"El milagro no es el milagro\" href=\"http://bible.com/events/322424\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2017-12-03'),
(599, 145, 'Ángeles cantando están', '<h1 style=\"text-align: center;\">EXPECTANTE</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">&iexcl;&Aacute;ngeles Cantando Est&aacute;n!</span></h2>\r\n<p style=\"text-align: right;\">10 de diciembre de 2017</p>\r\n<p style=\"text-align: right;\">Samuel Ortriz</p>\r\n<h1>Dos opciones para las notas:</h1>\r\n<h1>1) <a title=\"&iexcl;&Aacute;ngeles Cantando Est&aacute;n!\" href=\"https://notes.subsplash.com/fill-in/view?doc=Syqzq1jWG\" target=\"_blank\">Notas GranCo App</a>.</h1>\r\n<h1>2) <a title=\"&iexcl;&Aacute;ngeles Cantando Est&aacute;n!\" href=\"http://bible.com/events/326783\" target=\"_blank\">Notas Bible App</a></h1>', 18, '2017-12-10'),
(600, 145, 'Un mundo mejor', '<h1 style=\"text-align: center;\">Expectante</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration-line: underline;\">Un mundo mejor</span></h2>\r\n<p style=\"text-align: right;\">17 de diciembre de 2017</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1)&nbsp;<a title=\"Un mundo mejor\" href=\"https://notes.subsplash.com/fill-in/view?doc=rkhP1L7zf\" target=\"_blank\">Notas App GranCo</a></h1>\r\n<h1>2)&nbsp;<a title=\"Un mundo mejor\" href=\"http://bible.com/events/329387\" target=\"_blank\">Notas Bible App</a></h1>', 1, '2017-12-17'),
(601, 145, 'Dios con nosotros', '<h1 style=\"text-align: center;\">Expectante</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Dios con nosotros</span></h2>\r\n<p style=\"text-align: right;\">24 de diciembre de 2017</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"Dios con nosotros\" href=\"https://notes.subsplash.com/fill-in/view?doc=B1EoGA2MM\" target=\"_blank\">Notas App GranCo</a></h1>\r\n<h1>2) <a title=\"Dios con nosotros\" href=\"http://bible.com/events/333022\" target=\"_blank\">Notas Bible App</a></h1>', 1, '2017-12-24'),
(602, 146, 'Nuestra Visión para el 2018.', '<h1 style=\"text-align: center;\">EL ADN GranCo</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Nuestra Visi&oacute;n para el 2018</span></h2>\r\n<p style=\"text-align: right;\">7 de enero del 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1 style=\"text-align: left;\">2 opciones para ver las notas:</h1>\r\n<h1 style=\"text-align: left;\">1) <a title=\"Nuestra Visi&oacute;n para el 2018\" href=\"https://notes.subsplash.com/fill-in/view?doc=BkW5U7kNG\" target=\"_blank\">Notas Llenado online GranCo App</a></h1>\r\n<h1>2) <a title=\"Nuestra Visi&oacute;n para el 2018\" href=\"http://bible.com/events/339207\" target=\"_blank\">Notas Bibles App</a></h1>', 1, '2018-01-07'),
(603, 146, 'Comunicadores audaces de las Buenas Nuevas.', '<h1 style=\"text-align: center;\">El ADN GranCo</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Comunicadores audaces de las Buenas Nuevas</span></h2>\r\n<p style=\"text-align: right;\">14 de enero de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<h1>2 Opciones para ver las notas:</h1>\r\n<h1>1) <a title=\"Comunicadores audaces de las Buenas Nuevas\" href=\"https://notes.subsplash.com/fill-in/view?doc=HJURWSu4M\" target=\"_blank\">Notas Llenado Online App GranCo</a></h1>\r\n<h1>2) <a title=\"Comunicadores audaces de las Buenas Nuevas\" href=\"http://bible.com/events/342912\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2018-01-14'),
(604, 146, 'Abnegados seguidores de Cristo.', '', 1, '2018-01-21'),
(605, 146, 'Voluntarios entregados y sacrificados. ', '', 9, '2018-01-28'),
(606, 147, 'Trasplante de corazÃ³n', '<h1 style=\"text-align: center;\">Una Vida de Bendic&oacute;n</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Trasplante de Coraz&oacute;n</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<p style=\"text-align: right;\">4 de febrero de 2018</p>\r\n<h1>Dos opciones para ver las notas:</h1>\r\n<h1>1) <a title=\"Trasplante de coraz&oacute;n\" href=\"https://notes.subsplash.com/fill-in/view?doc=H1nf_kVLf\" target=\"_blank\">Notas llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"Trasplante de coraz&oacute;n\" href=\"http://bible.com/events/354863\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2018-02-04'),
(607, 147, 'Primero lo Primero', '<h1 style=\"text-align: center;\">Serie: Una Vida de Bendici&oacute;n</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Tema: Primero lo primero</span></h2>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"https://twitter.com/isaacpineda_\" target=\"_blank\">@isaacpineda_</a></p>\r\n<p style=\"text-align: right;\">11 de febrero de 2018</p>\r\n<h1>Dos opciones para ver las notas del estudio</h1>\r\n<h1>1) <a title=\"Primero lo Primero\" href=\"https://notes.subsplash.com/fill-in/view?doc=H1SIK6s8z\" target=\"_blank\">Notas llenado online GranCo App</a></h1>\r\n<h1>2) <a title=\"Primero lo Primero\" href=\"http://bible.com/events/358263\" target=\"_blank\">Notas The Bible App</a></h1>', 9, '2018-02-11'),
(608, 147, 'Liberate de \"Mamonas\"', '<h1 style=\"text-align: center;\">Una Vida de Bendic&oacute;n</h1>\r\n<h2 style=\"margin: 1.5em 0px 0px; padding: 0px; font-size: 19.68px; font-weight: normal; font-family: \'Myriad Pro\', Mako, \'Trebuchet MS\', sans-serif; text-align: center;\"><span style=\"text-decoration-line: underline;\">Lib&eacute;rate de \"Mamon&aacute;s\"</span></h2>\r\n<p style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\">Allan Handal</p>\r\n<p style=\"text-align: right;\"><a class=\"ProfileHeaderCard-screennameLink u-linkComplex js-nav\" style=\"background: #e6ecf0; color: #657786; font-family: \'Segoe UI\', Arial, sans-serif; font-size: 14px; font-weight: bold; text-align: left; text-decoration-line: none !important;\" href=\"https://twitter.com/Allan_Handal\"><span class=\"username u-dir\" style=\"unicode-bidi: embed; direction: ltr !important;\" dir=\"ltr\">@<span class=\"u-linkComplex-target\" style=\"font-weight: normal;\">Allan_Handal</span></span></a></p>\r\n<p style=\"margin: 0px 0px 2em; line-height: 1.6em; font-family: \'Lucida Grande\', sans-serif, Verdana, Arial; font-size: 12px; text-align: right;\">18 de febrero de 2018</p>\r\n<h1 style=\"margin: 0em 0em 1em; padding: 0px 0px 12px; font-weight: normal; font-family: \'Myriad Pro\', Mako, \'Trebuchet MS\', sans-serif;\">Dos opciones para ver las notas:</h1>\r\n<h1 style=\"margin: 0em 0em 1em; padding: 0px 0px 12px; font-weight: normal; font-family: \'Myriad Pro\', Mako, \'Trebuchet MS\', sans-serif;\">1)&nbsp;<a title=\"Lib&eacute;rate de &quot;Mamon&aacute;s&quot;\" href=\"https://notes.subsplash.com/fill-in/view?doc=HJuK4WHwz\" target=\"_blank\">Notas llenado online App GranCo</a></h1>\r\n<h1 style=\"margin: 0em 0em 1em; padding: 0px 0px 12px; font-weight: normal; font-family: \'Myriad Pro\', Mako, \'Trebuchet MS\', sans-serif;\">2)&nbsp;<a title=\"Lib&eacute;rate de &quot;Mamon&aacute;s&quot;\" href=\"http://bible.com/events/362888\" target=\"_blank\">Notas The Bible App</a></h1>', 3, '2018-02-18'),
(609, 147, '¿Realmente soy generoso?', '<h1 style=\"text-align: center;\">Serie: Una Vida de Bendici&oacute;n</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Tema: &iquest;Realmente soy generoso?</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<h1>Dos opciones para las notas del estudio</h1>\r\n<h1>1) <a title=\"&iquest;Realmente soy generoso?\" href=\"https://notes.subsplash.com/fill-in/view?doc=r1mJdEeuz\" target=\"_blank\">Notas Llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"&iquest;Realmente soy generoso?\" href=\"http://bible.com/events/367870\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2018-02-25'),
(610, 148, 'Si tan solo el/ella cambiara...', '<h1 style=\"text-align: center;\">Serie: Una Familia <span style=\"text-decoration: line-through;\">DIS</span>Funcional</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Tema: Si tan solo &eacute;l/ella cambiara...</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<p style=\"text-align: right;\">4 de marzo de 2018</p>\r\n<h1>Dos opciones para ver las notas del tema:</h1>\r\n<h1>1) <a title=\"Si tan solo &eacute;l/ella cambiara...\" href=\"https://notes.subsplash.com/fill-in/view?doc=B1nf60O_G\" target=\"_blank\">Notas Llenado Online GranCo App</a></h1>\r\n<h1>2) <a title=\"Si tan solo &eacute;l/ella cambiara...\" href=\"http://bible.com/events/371439\" target=\"_blank\">Notas The Bible App</a></h1>\r\n<p>&nbsp;</p>', 1, '2018-03-04'),
(611, 148, 'Mis hijos me sacan de quicio...', '<h1 style=\"text-align: center;\">Serie: Una Familia <span style=\"text-decoration: line-through;\">DIS</span>Funcional</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Tema: Mis hijos me sacam de quicio...</span></h2>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<p style=\"text-align: right;\">11 de marzo de 2018</p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"Mis hijos me sacan de quicio...\" href=\"https://notes.subsplash.com/fill-in/view?doc=rkWHO3ftM\" target=\"_blank\">Notas llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"Mis hijos me sacan de quicio...\" href=\"http://bible.com/events/376295\" target=\"_blank\">Notas The Bibles App</a></h1>', 1, '2018-03-11'),
(612, 148, 'Mis padres no me entienden...', '<h1 style=\"text-align: center;\">Serie: Una Familia <span style=\"text-decoration: line-through;\">DIS</span>Funcional</h1>\r\n<p style=\"text-align: center;\">Tema: Mis padres no me comprenden...</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<p style=\"text-align: right;\">18 de marzo de 2018</p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"Mis padres no me entienden...\" href=\"https://notes.subsplash.com/fill-in/view?doc=HkwhP_jFz\" target=\"_blank\">Notas llenado online GranCo App</a></h1>\r\n<h1>2) <a title=\"Mis padres no me entienden...\" href=\"http://bible.com/events/379868\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2018-03-18'),
(613, 148, 'Candil de la calle...', '<h1 style=\"text-align: center;\">Serie: Una Familia <span style=\"text-decoration: line-through;\">DIS</span>Funcional</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Tema: Candil de la calle...</span></h2>\r\n<p style=\"text-align: right;\">25 de marzo de 2018</p>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"https://twitter.com/isaacpineda_\" target=\"_blank\">@isaacpineda_</a></p>\r\n<h1>Dos opciones para ver las notas:</h1>\r\n<h1>1) <a title=\"Candil de la calle...\" href=\"https://notes.subsplash.com/fill-in/view?doc=rJRpY7B9G\" target=\"_blank\">Notas llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"Candil de la calle...\" href=\"http://bible.com/events/384284\" target=\"_blank\">Notas The Bible App</a></h1>', 9, '2018-03-25'),
(614, 149, 'Vivo Esta: La Resurreccion de Cristo', '<h1 style=\"text-align: center;\">VIVO ESTA</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">La Resureccion de Cristo</span></h2>\r\n<p style=\"text-align: right;\">1 de abril de 2018</p>\r\n<p style=\"text-align: right;\">Allan Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"https://twitter.com/Allan_Handal\" target=\"_blank\">@Allan_Handal</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"Vivo Esta\" href=\"https://notes.subsplash.com/fill-in/view?doc=HJG5FMRcz\" target=\"_blank\">Notas Llenado Online App GranCo</a></h1>\r\n<h1>2) <a title=\"Vivo Esta\" href=\"http://bible.com/events/388166\" target=\"_blank\">Notas The Bible App</a></h1>', 3, '2018-04-01'),
(615, 150, 'Viviendo para una Causa Eterna', '<h1 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Viviendo para una Causa Eterna</span></h1>\r\n<p style=\"text-align: right;\">7 de abril de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<h1 style=\"text-align: left;\">Dos opciones para las notas del tema:</h1>\r\n<h1 style=\"text-align: left;\">1) <a title=\"Viviendo para una Causa Eterna\" href=\"https://notes.subsplash.com/fill-in/view?doc=HyhT75SsM\" target=\"_blank\">Notas llenado online App GranCo</a></h1>\r\n<h1 style=\"text-align: left;\">2) <a title=\"Viviendo para una Causa Eterna\" href=\"http://bible.com/events/390893\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2018-04-08'),
(616, 151, 'Hablemos de sexo', '<h1 style=\"text-align: center;\">Amor, Sexo y Noviazgo</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Hablemos de sexo</span></h2>\r\n<p style=\"text-align: right;\">15 de abril de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<h1>Dos opciones para ver las notas:</h1>\r\n<h1>1) <a title=\"Hablemos de sexo\" href=\"https://notes.subsplash.com/fill-in/view?doc=HJKlMwx3M\" target=\"_blank\">Notas llenado Online App GranCo</a></h1>\r\n<h1>2) <a title=\"Hablemos de sexo\" href=\"http://bible.com/events/396190\" target=\"_blank\">Notas The Bible App</a>&nbsp;</h1>', 1, '2018-04-15'),
(617, 151, 'Me enamoro por los ojos', '<h1 style=\"text-align: center;\">Serie: Amor, sexo y noviazgo</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Tema: Me enamoro por los ojos</span></h2>\r\n<p style=\"text-align: right;\">22 de abril de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<h1>Dos opciones para ver las notas del tema:</h1>\r\n<h1>1) <a title=\"Me enamoro por los ojos\" href=\"https://notes.subsplash.com/fill-in/view?doc=rJ54KFthG\" target=\"_blank\">Notas llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"Me enamoro por los ojos\" href=\"http://bible.com/events/400111\" target=\"_blank\">Notas The Bible App</a></h1>\r\n<p>&nbsp;</p>', 1, '2018-04-22'),
(618, 151, 'El mito de la persona ideal', '<h1 style=\"text-align: center;\">Serie: Amor, Sexo y Noviazgo</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Tema: El mito de la persona ideal</span></h2>\r\n<p style=\"text-align: right;\">29 de abril 2018</p>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/isaacpineda_\" target=\"_blank\">@IsaacPineda_</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"El mito de la persona ideal.\" href=\"https://notes.subsplash.com/fill-in/view?doc=SyvZaFWpG\" target=\"_blank\">Notas llenado online GranCo App</a></h1>\r\n<h1>2) <a title=\"El mito de la persona ideal.\" href=\"http://bible.com/events/403179|\" target=\"_blank\">Notas The Bible App</a></h1>\r\n<p>&nbsp;</p>', 9, '2018-04-29'),
(619, 153, 'La resurreccion: Mito o verdad?', '<h1 style=\"text-align: center;\">Serie: Fe bajo fuego</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Tema: La resureccion: mito o realidad?</span></h2>\r\n<p style=\"text-align: right;\">13 de mayo de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<h1>Dos opciones para ver las notas del tema:</h1>\r\n<h1>1) <a title=\"La resureccion: mito o realidad?\" href=\"https://notes.subsplash.com/fill-in/view?doc=HJUAMBB0z\" target=\"_blank\">Notas llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"La resureccion: mito o realidad?\" href=\"http://bible.com/events/412124\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2018-05-13'),
(620, 153, 'La Biblia: coleccion de cuentos o Palabra de Dios?', '<h1 style=\"text-align: center;\">Serie: Cristianismo bajo fuego</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Tema: La Biblia: Coleccion de cuentos o Palabra de Dios?</span></h2>\r\n<p style=\"text-align: right;\">20 de mayo de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"La Biblia: Coleccion de cuentos o Palabra de Dios\" href=\"https://notes.subsplash.com/fill-in/view?doc=rkQdEuAAM\" target=\"_blank\">Notas llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"La Biblia: Coleccion de cuentos o Palabra de Dios\" href=\"http://bible.com/events/416051\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2018-05-20'),
(621, 153, 'Cristianismo bajo la lupa', '<h1 style=\"text-align: center;\">Fe bajo fuego</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Crsitianismo bajo la lupa</span></h2>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"https://twitter.com/grancomisionmty\" target=\"_blank\">@GranComisionMTY</a></p>\r\n<p style=\"text-align: right;\">27 de mayo de 2018</p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"Cristianismo bajo la lupa\" href=\"https://notes.subsplash.com/fill-in/view?doc=BJkAnTv17\" target=\"_blank\">Notas llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"Cristianismo bajo la lupa\" href=\"http://bible.com/events/419969\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2018-05-27'),
(623, 154, 'Inseguridad', '<h1 style=\"text-align: center;\">Tigres de papel</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Inseguridad</span></h2>\r\n<p style=\"text-align: right;\">3 de junio de 2018</p>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/isaacpineda_\" target=\"_blank\">@IsaacPineda_</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"Inseguridad\" href=\"https://notes.subsplash.com/fill-in/view?doc=ryWN6gZgQ\" target=\"_self\">Notas llenado online App GranCo.</a></h1>\r\n<h1>2) <a title=\"Inseguridad\" href=\"http://bible.com/events/423747\" target=\"_blank\">Notas The Bible App</a></h1>', 9, '2018-06-03'),
(624, 154, 'Soledad ', '<h1 style=\"text-align: center;\">Serie: Tigres de papel</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Tema: Soledad</span></h2>\r\n<p style=\"text-align: right;\">10 de junio de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"Soledad\" href=\"https://notes.subsplash.com/fill-in/view?doc=rycg-Ncem\" target=\"_blank\">Notas llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"Soledad\" href=\"http://bible.com/events/427606\" target=\"_blank\">Notas The Bible App&nbsp;</a></h1>', 1, '2018-06-10'),
(625, 154, 'Incertidumbre', '<h1 style=\"text-align: center;\">Tigres de papel</h1>\r\n<h2 style=\"text-align: center;\">Incertidumbre</h2>\r\n<p style=\"text-align: right;\">17 de junio de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<h1>Dos opciones para ver las notas del tema</h1>\r\n<h1>1) <a title=\"Incertidumbre\" href=\"https://notes.subsplash.com/fill-in/view?doc=HJjTeuQ-m\" target=\"_blank\">Notas llenado online App Granco</a></h1>\r\n<h1>2) <a title=\"Incertidumbre\" href=\"http://bible.com/events/431496\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2018-06-17'),
(626, 154, 'Fracaso ', '<h1 style=\"text-align: center;\">Tigres de papel</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Fracaso</span></h2>\r\n<p style=\"text-align: right;\">24 de junio de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"Fracaso\" href=\"https://notes.subsplash.com/fill-in/view?doc=BJy4Rwn-Q\" target=\"_blank\">Notas llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"Fracaso\" href=\"http://bible.com/events/434691\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2018-06-24'),
(628, 156, 'No eres una victima', '<h1 style=\"text-align: center;\">Victimismo</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">No eres una victima</span></h2>\r\n<p style=\"text-align: right;\">1 de julio de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"No eres una victima\" href=\"https://notes.subsplash.com/fill-in/view?doc=rJjUMyUf7\" target=\"_blank\">Notas de llanado online App Granco</a></h1>\r\n<h1>2) <a title=\"No eres una victima\" href=\"http://bible.com/events/438658\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2018-07-01'),
(629, 157, 'El Tranza', '<h1 style=\"text-align: center;\">Vampiros Relacionales</h1>\r\n<h2 style=\"text-align: center;\">El Tranza</h2>\r\n<p style=\"text-align: right;\">8 de julio de 2018</p>\r\n<p style=\"text-align: right;\">Allan Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"https://twitter.com/Allan_Handal\" target=\"_blank\">@Allan_Handal</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"El Tranza\" href=\"https://notes.subsplash.com/fill-in/view?doc=BJxqfeymX\" target=\"_blank\">Notas llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"El Tranza\" href=\"http://bible.com/events/441978\" target=\"_blank\">Notas The Bible App</a></h1>', 3, '2018-07-08'),
(630, 157, 'El Explosivo Cronico', '<h1 style=\"text-align: center;\">Vampiros Relacionales</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El Explosivo Cronico</span></h2>\r\n<p style=\"text-align: right;\">15 de julio de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<h1>Dos opciones para ver las notas del estuidio:</h1>\r\n<h1>1) <a title=\"El Explosivo Cronico\" href=\"https://notes.subsplash.com/fill-in/view?doc=ryAu8vO7X\" target=\"_blank\">Notas llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"El Explosivo Cronico\" href=\"http://bible.com/events/445889\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2018-07-15');
INSERT INTO `mensajes` (`id_mensaje`, `id_serie`, `mensaje`, `resumen`, `id_expositor`, `fecha`) VALUES
(631, 157, 'El Quejumbroso Compulsivo', '<h1 style=\"text-align: center;\">Vampiros Relacionales</h1>\r\n<h2 style=\"text-align: center;\">El Quejumbroso Compulsivo</h2>\r\n<p style=\"text-align: right;\">22 de julio de 2018</p>\r\n<p style=\"text-align: right;\">Alejandro Gonzalez</p>\r\n<h1>Dos opciones para ver las notas:</h1>\r\n<h1>1) <a title=\"El Quejumbroso Cronico\" href=\"https://notes.subsplash.com/fill-in/view?doc=HkjZx5WNm\" target=\"_blank\">Notas de llenado online App GranCo.</a></h1>\r\n<h1>2) <a title=\"El Quejumbroso Cronico\" href=\"http://bible.com/events/449528\" target=\"_blank\">Notas The Bible App.</a></h1>', 22, '2018-07-22'),
(632, 157, 'El Sentido', '<h1 style=\"text-align: center;\">Vampiros Relacionales</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El Sentido</span></h2>\r\n<p style=\"text-align: right;\">29 de julio de 2018</p>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/isaacpineda_\" target=\"_blank\">@IsaacPineda_</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"El Sentido\" href=\"https://notes.subsplash.com/fill-in/view?doc=BytsL3qVQ\" target=\"_blank\">Notas llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"El Sentido\" href=\"http://bible.com/events/453011\" target=\"_blank\">Notas The Bible App</a></h1>', 9, '2018-07-29'),
(633, 158, 'El Consejo', '<h1 style=\"text-align: center;\">Mejores Decisiones</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El Consejo</span></h2>\r\n<p style=\"text-align: right;\">5 de agosto de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"El Consejo\" href=\"https://notes.subsplash.com/fill-in/view?doc=H1Dt7gNrQ\" target=\"_blank\">Notas llenado Online App GranCo</a></h1>\r\n<h1>2) <a title=\"El Consejo\" href=\"http://bible.com/events/456815\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2018-08-05'),
(634, 158, 'Los Amigos', '<h1 style=\"text-align: center;\">Mejores Decisiones</h1>\r\n<h2 style=\"text-align: center;\">Los Amigos</h2>\r\n<p style=\"text-align: right;\">12 de agosto de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<h1>Dos opciones para ver las notas del tema:</h1>\r\n<h1>1) <a title=\"Los Amigos\" href=\"https://notes.subsplash.com/fill-in/view?doc=rJ-Xsjarm\" target=\"_blank\">Notas llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"Los Amigos\" href=\"http://bible.com/events/460927\" target=\"_blank\">Notas The Bible App&nbsp;</a></h1>', 1, '2018-08-12'),
(635, 158, 'Zafate!', '<h1 style=\"text-align: center;\">Mejores Decisiones</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Zafate!</span></h2>\r\n<p style=\"text-align: right;\">19 de agosto de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">@SergioHandal</p>\r\n<h1>Dos opciones para ver las notas del tema:</h1>\r\n<h1>1) <a title=\"Zafate!\" href=\"https://notes.subsplash.com/fill-in/view?doc=gKFnKuV6r3A\" target=\"_blank\">Notas de llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"Zafate!\" href=\"http://bible.com/events/464384\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2018-08-19'),
(636, 158, 'La Lengua', '<h1 style=\"text-align: center;\">Mejores Decisiones</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">La Lengua</span></h2>\r\n<p style=\"text-align: right;\">26 de agosto de 2018</p>\r\n<p style=\"text-align: right;\">Samuel Ortiz</p>\r\n<h1>Dos opciones para ver las notas del tema:</h1>\r\n<h1>1) <a title=\"La Lengua\" href=\"https://notes.subsplash.com/fill-in/view?doc=W-eUdvOjP7e\" target=\"_self\">Notas llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"La Lengua\" href=\"http://bible.com/events/468392\" target=\"_blank\">Notas The Bible App</a></h1>', 18, '2018-08-26'),
(637, 159, 'El Principio del Camino', '<h1 style=\"text-align: center;\">El Principio del Camnino</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Como llegar desde donde estas a donde quieres estar</span></h2>\r\n<p style=\"text-align: right;\">2 de septiembre de 2018</p>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/isaacpineda_\" target=\"_blank\">@IsaacPineda_</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"El Principio del Camino\" href=\"https://notes.subsplash.com/fill-in/view?doc=E6_udZ_cBs5\" target=\"_blank\">Notas llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"El Principio del Camino\" href=\"http://bible.com/events/472413\" target=\"_blank\">Notas The Bible App</a></h1>', 9, '2018-09-02'),
(638, 160, 'El Chisme', '<h1 style=\"text-align: center;\">UPS! NO QUISE DECIR ESO...</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El Chisme</span></h2>\r\n<p style=\"text-align: right;\">9 de Septiembre de 2018</p>\r\n<p style=\"text-align: right;\">Allan Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/allan_handal\" target=\"_blank\">@Allan_Handal</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1)&nbsp;<a title=\"El Chisme\" href=\"https://notes.subsplash.com/fill-in/view?doc=v8504wuY8cL\" target=\"_blank\">Notas de llenado online App GranCo</a></h1>\r\n<h1>2)&nbsp;<a title=\"El Chisme\" href=\"http://bible.com/events/476893\" target=\"_blank\">Notas The Bible App</a></h1>', 3, '2018-09-09'),
(639, 160, 'La Mentira', '<h1 style=\"text-align: center;\">UPS! NO QUISE DECIR ESO...</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">La Mentira</span></h2>\r\n<p style=\"text-align: right;\">16 de Septiembre de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"La Mentira\" href=\"https://notes.subsplash.com/fill-in/view?doc=GPS25rMIKPn\" target=\"_blank\">Notas de llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"La Mentira\" href=\"http://bible.com/events/481050\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2018-09-16'),
(640, 160, 'Habla lo que importa!', '', 8, '2018-09-23'),
(641, 161, 'La Vision de un Disci­pulo', '', 23, '2018-09-28'),
(642, 161, 'Los Pies de un Discipulo ', '', 9, '2018-09-29'),
(643, 161, 'El Corazon de un Discipulo ', '', 23, '2018-09-29'),
(644, 161, 'Las Manos de un Discipulo ', '', 21, '2018-09-30'),
(645, 161, 'La Voz de un Discipulo ', '', 1, '2018-09-30'),
(646, 162, 'Conexiones Divinas', '<h1 style=\"text-align: center;\">Conexiones Divinas</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Dios quiere conectarnos</span></h2>\r\n<p style=\"text-align: right;\">7 de octubre de 2018</p>\r\n<p style=\"text-align: right;\">Alejandro Gonzalez</p>\r\n<h1 style=\"text-align: left;\">Dos opciones para ver las notas del estudio:</h1>\r\n<h1 style=\"text-align: left;\">1) <a title=\"Conexiones Divinas\" href=\"https://notes.subsplash.com/fill-in/view?doc=dBD7GicTjwh\" target=\"_blank\">Notas de llenado online App GranCo</a></h1>\r\n<h1 style=\"text-align: left;\">2) <a title=\"Conexiones Divinas\" href=\"http://bible.com/events/492770\" target=\"_blank\">Notas The Bible App</a></h1>', 22, '2018-10-07'),
(647, 163, 'Para Dios no hay MISION IMPOSIBLE', '<h1 style=\"text-align: center;\">DE PELICULA</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Para Dios no hay MISION IMPOSIBLE</span></h2>\r\n<p style=\"text-align: right;\">14 de octubre de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">@SergioHandal</p>\r\n<h1>Dos opciones para ver las notas del tema:</h1>\r\n<h1>1) <a title=\"Mision Imposible\" href=\"https://notes.subsplash.com/fill-in/view?doc=XqL39tzpCu6\" target=\"_blank\">Notas de llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"Mision Imposible\" href=\"http://bible.com/events/496284\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2018-10-14'),
(648, 163, 'NO TAN SOLO', '<h1 style=\"text-align: center;\">DE PELICULA</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">NO TAN SOLO</span></h2>\r\n<p style=\"text-align: right;\">21 de octubre de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\">@SergioHandal</p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"NO TAN SOLO\" href=\"https://notes.subsplash.com/fill-in/view?doc=Wipl87f-9au\" target=\"_blank\">Notas de llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"NO TAN SOLO\" href=\"http://bible.com/events/500634\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2018-10-21'),
(649, 163, 'COCO: Mas alla de la muerte', '<h1 style=\"text-align: center;\">De Pelicula&nbsp;</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Coco: mas alla de la muerte</span></h2>\r\n<p style=\"text-align: right;\">28 de octubre de 2018</p>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/isaacpineda_\" target=\"_blank\">@IsaacPineda_</a></p>\r\n<h1>Dos opciones para ver el estudio:</h1>\r\n<h1>1) <a title=\"Coco: mas alla de la muerte\" href=\"https://notes.subsplash.com/fill-in/view?doc=WkvsHQ2m71_\" target=\"_blank\">Notas de llenado online App Granco</a></h1>\r\n<h1>2) <a title=\"Coco: mas alla de la muerte\" href=\"http://bible.com/events/504578\" target=\"_blank\">Notas The Bible App</a></h1>', 9, '2018-10-28'),
(650, 164, 'Casualidad u obra maestra?', '<h1 style=\"text-align: center;\">Rodo de Identidad</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Casualidad u obra maestra?</span></h2>\r\n<p style=\"text-align: right;\">4 de noviembre de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"Casualidad u obra maestra?\" href=\"https://notes.subsplash.com/fill-in/view?doc=wUeF0B1y9\" target=\"_blank\">Notas de llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"Casualidad u obra maestra?\" href=\"http://bible.com/events/508844\" target=\"_blank\">Notas The Bible App</a></h1>\r\n<p>&nbsp;</p>', 1, '2018-11-04'),
(651, 164, 'Huerfano o adoptado?', '<h1 style=\"text-align: center;\">Robo de Identidad</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Huerfano o adoptado?</span></h2>\r\n<p style=\"text-align: right;\">11 de noviembre de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<h1>Dos opciones para ver las notas del tema:</h1>\r\n<h1>1) <a title=\"Huerfano o adoptado?\" href=\"https://notes.subsplash.com/fill-in/view?doc=KtcljuNM8\" target=\"_blank\">Notas de llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"Huerfano o adoptado?\" href=\"http://bible.com/events/512410\" target=\"_self\">Notas The Bible App</a></h1>', 1, '2018-11-11'),
(652, 164, 'Prisionero o liberado?', '<p style=\"text-align: center;\">Robo de Identidad</p>\r\n<p style=\"text-align: center;\">Prisionero o liberado?</p>\r\n<p style=\"text-align: right;\">18 de noviembre de 2018</p>\r\n<p style=\"text-align: right;\">Henry Kattan</p>\r\n<p style=\"text-align: right;\">@hka87</p>\r\n<h1>Dos opciones para ver las notas de la predica</h1>\r\n<h1>1) <a title=\"Prisionero o liberado?\" href=\"https://notes.subsplash.com/fill-in/view?doc=VKeaKiq3ht\" target=\"_self\">Notas de llenado online App GranCo</a></h1>\r\n<h1 style=\"text-align: left;\">2) <a title=\"Prisionero o liberado?\" href=\"http://bible.com/events/516324\" target=\"_blank\">Notas the Bible App</a></h1>', 19, '2018-11-18'),
(653, 164, 'Miserable o heredero?', '<h1 style=\"text-align: center;\">Robo de Identidad</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Misarable o hererdero?</span></h2>\r\n<p style=\"text-align: right;\">25 de noviembre de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<h1>Dos opcionespara ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"Miserable o heredero?\" href=\"https://notes.subsplash.com/fill-in/view?doc=9BAZsb8at\" target=\"_blank\">Notas de llenado online app GranCo</a></h1>\r\n<h1>2) <a title=\"Miserable o heredero?\" href=\"http://bible.com/events/519537\" target=\"_blank\">Notas the Bible app</a></h1>', 1, '2018-11-25'),
(654, 165, 'En el valle.', '<h1 style=\"text-align: center;\">Dios con nosotros</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">En el valle</span></h2>\r\n<p style=\"text-align: right;\">2 de diciembre de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@SergioHandal</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"En el valle.\" href=\"https://notes.subsplash.com/fill-in/view?doc=CuQVyk5CI0\" target=\"_blank\">Notas llenado online app GranCo.</a></h1>\r\n<h1>2) <a title=\"En el valle.\" href=\"http://bible.com/events/524387\" target=\"_blank\">Notas the Bible App.</a></h1>', 1, '2018-12-02'),
(655, 165, 'En el desierto. ', '<h1 style=\"text-align: center;\"><span style=\"text-decoration-line: underline;\">Dios con nosotros</span></h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">En el desierto</span></h2>\r\n<p style=\"text-align: right;\">9 de diciembre de 2018</p>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/isaacpineda_\" target=\"_blank\">@isaacpineda_</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"En el desierto.\" href=\"https://notes.subsplash.com/fill-in/view?doc=Dn896d3jmm\" target=\"_blank\">Notas de llenado online App GranCo</a>.</h1>\r\n<h1>2) <a title=\"En el desierto.\" href=\"http://bible.com/events/527774\" target=\"_blank\">Notas The Bible App</a>.</h1>', 9, '2018-12-09'),
(656, 165, 'En la tormenta. ', '<h1 style=\"text-align: center;\">Dios con nosotros</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">En la tormenta</span></h2>\r\n<p style=\"text-align: right;\">16 de diciembre de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@sergiohandal</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1)&nbsp;<a title=\"En la tormenta\" href=\"https://notes.subsplash.com/fill-in/view?page=SgF9nk2MlW\" target=\"_blank\">Notas de llenado online App GranCo</a></h1>\r\n<h1>2)&nbsp;<a title=\"En la tormenta\" href=\"http://bible.com/events/531662\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2018-12-16'),
(657, 165, 'Con nosotros siempre.', '<h1 style=\"text-align: center;\">Dios con nosotros</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Con nosotros siempre</span></h2>\r\n<p style=\"text-align: right;\">23 de diciembre de 2018</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@sergiohandal</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"Con nosotros siempre.\" href=\"https://notes.subsplash.com/fill-in/view?page=Tx7tCx3-Eh\" target=\"_blank\">Notas llenado online App GranCo.</a></h1>\r\n<h1>2) <a title=\"Con nosotros siempre.\" href=\"http://bible.com/events/535528\" target=\"_blank\">Notas The Bible App.</a></h1>', 1, '2018-12-23'),
(658, 166, 'El poder para el cambio', '<h1 style=\"text-align: center;\">HABITOS</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El poder para el cambio</span></h2>\r\n<p style=\"text-align: right;\">6 de enero de 2019</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@sergiohandal</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"El poder para el cambio\" href=\"https://notes.subsplash.com/fill-in/view?page=B2MuTFR9F5\" target=\"_blank\">Notas de llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"El poder para el cambio\" href=\"http://bible.com/events/542957\" target=\"_blank\">Notas The Bible App&nbsp;</a></h1>', 1, '2019-01-06'),
(659, 166, 'El poder de la comunidad', '<h1 style=\"text-align: center;\">HABITOS</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El poder de la comunidad</span></h2>\r\n<p style=\"text-align: right;\">13 de enero de 2019</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@sergiohandal</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"El poder de la comunidad.\" href=\"https://notes.subsplash.com/fill-in/view?page=Crai_EAotT-\" target=\"_blank\">Notas de llenado online App GranCo.</a></h1>\r\n<h1>2) <a title=\"El poder de la comunidad.\" href=\"http://bible.com/events/546255\" target=\"_blank\">Notas The Bible App.</a></h1>', 1, '2019-01-13'),
(660, 166, 'El poder de la verdad', '<h1 style=\"text-align: center;\">HABITOS</h1>\r\n<h2 style=\"text-align: center;\">El poder de la verdad</h2>\r\n<p style=\"text-align: right;\">20 de enero de 2019</p>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/isaacpineda_\" target=\"_blank\">isaacpineda_</a></p>\r\n<h1>Dos opciones para ver el estudio:</h1>\r\n<h1>1) <a title=\"El poder de la verdad\" href=\"https://notes.subsplash.com/fill-in/view?page=F9wuWpwptn\" target=\"_blank\">Notas de llenado online App Granco</a></h1>\r\n<h1>2) <a title=\"El poder de la verdad\" href=\"http://bible.com/events/550869\" target=\"_blank\">Notas The Bible App</a></h1>', 9, '2019-01-20'),
(661, 166, 'El poder de servir', '<h1 style=\"text-align: center;\">HABITOS</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">El poder de servir</span></h2>\r\n<p style=\"text-align: right;\">27 de enero 2019</p>\r\n<p style=\"text-align: right;\">Alejandro Gonzalez</p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"El poder de servir\" href=\"https://notes.subsplash.com/fill-in/view?page=YjQadX9OjfP\" target=\"_blank\">Notas de llenado online app Granco.</a></h1>\r\n<h1>2) <a title=\"El poder de servir\" href=\"http://bible.com/events/554711\" target=\"_blank\">Notas The Bible app.</a></h1>', 22, '2019-01-27'),
(662, 167, 'Olvidado', '<h1 style=\"text-align: center;\">La Familia Real</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Olvidado</span></h2>\r\n<p style=\"text-align: right;\">3 de febrero de 2019</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@sergiohandal</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1) <a title=\"Olvidado\" href=\"https://notes.subsplash.com/fill-in/view?page=R5jt2OhK0ej\" target=\"_blank\">Notas de llenado online App Granco.</a></h1>\r\n<h1>2) <a title=\"Olvidado\" href=\"http://bible.com/events/559049\" target=\"_blank\">Notas The Bible App.</a></h1>', 1, '2019-02-03'),
(663, 167, 'Mi marido tiene familia', '<h1 style=\"text-align: center;\">La Familia Real</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration-line: underline;\">Mi marido tiene familia</span></h2>\r\n<p style=\"text-align: right;\">10 de febrero de 2019</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@sergiohandal</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1)&nbsp;<a title=\"Mi marido tiene familia.\" href=\"https://notes.subsplash.com/fill-in/view?page=BDsF82vwDRf\" target=\"_blank\">Notas de llenado online App Granco.</a></h1>\r\n<h1>2)&nbsp;<a title=\"Mi marido tiene familia.\" href=\"http://bible.com/events/563408\" target=\"_blank\">Notas The Bible App.</a></h1>', 1, '2019-02-10'),
(664, 167, 'Amor a segunda vista', '<h1 style=\"text-align: center;\">La Familia Real</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration-line: underline;\">Amor a segunda vista</span></h2>\r\n<p style=\"text-align: right;\">17 de febrero de 2019</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@sergiohandal</a></p>\r\n<h1>Dos opciones para ver las notas del estudio:</h1>\r\n<h1>1)&nbsp;<a title=\"Amor a segunda vista\" href=\"https://notes.subsplash.com/fill-in/view?page=LN_xZAFT3ei\" target=\"_blank\">Notas de llenado online App Granco.</a></h1>\r\n<h1>2)&nbsp;<a title=\"Amor a segunda vista\" href=\"http://bible.com/events/568143\" target=\"_self\">Notas The Bible App.</a></h1>', 1, '2019-02-17'),
(665, 167, 'Cuando tus hijos te rompen el corazon', '', 8, '2019-02-24'),
(666, 168, 'Una Gran Responsabilidad', '<h1 style=\"text-align: center;\">Creado para Servir</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Una Gran Resposnsabilidad</span></h2>\r\n<p style=\"text-align: right;\">3 de marzo de 2019</p>\r\n<p style=\"text-align: right;\">Isaac Pineda</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/isaacpineda_\" target=\"_blank\">@isaacpineda_</a></p>\r\n<h1>Dos opciones para ver las notas:</h1>\r\n<h1>1) <a title=\"Una gran responsabilidad\" href=\"https://notes.subsplash.com/fill-in/view?page=mNCpWdmNcJP\" target=\"_blank\">Notas llenado online App GranCo.</a></h1>\r\n<h1>2) <a title=\"Una gran responsabilidad\" href=\"http://bible.com/events/575969\" target=\"_blank\">Notas the Bible App</a></h1>', 9, '2019-03-03'),
(667, 168, 'Obra Maestra!', '<h1 style=\"text-align: center;\">Creado para Servir</h1>\r\n<h2 style=\"text-align: center;\"><span style=\"text-decoration: underline;\">Obra Maestra</span></h2>\r\n<p style=\"text-align: right;\">10 de marzo de 2019</p>\r\n<p style=\"text-align: right;\">Sergio Handal</p>\r\n<p style=\"text-align: right;\"><a title=\"Twitter\" href=\"twitter.com/sergiohandal\" target=\"_blank\">@sergiohandal</a></p>\r\n<h1>Dos opciones para ver las notas del estudio</h1>\r\n<h1>1) <a title=\"Obra Maestra\" href=\"https://notes.subsplash.com/fill-in/view?page=hxye10eka4c\" target=\"_self\">Notas llenado online App GranCo</a></h1>\r\n<h1>2) <a title=\"Obra Maestra\" href=\"http://bible.com/events/580945\" target=\"_blank\">Notas The Bible App</a></h1>', 1, '2019-03-10'),
(668, 168, 'Descubriendo mis dones espirituales - parte 1', '', 8, '2019-03-17'),
(669, 168, 'Descubriendo mis dones espirituales - parte 2', '', 8, '2019-03-24'),
(670, 168, 'Feria de Ministerios', '', 8, '2019-03-31'),
(671, 168, 'El latido de mi corazon', '', 8, '2019-04-07');

-- --------------------------------------------------------

--
-- Table structure for table `mensajes_claves`
--

CREATE TABLE `mensajes_claves` (
  `id_mensaje` int(11) UNSIGNED NOT NULL,
  `clave` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `mensajes_medios`
--

CREATE TABLE `mensajes_medios` (
  `id_mensaje` int(10) UNSIGNED NOT NULL,
  `id_medio` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mensajes_medios`
--

INSERT INTO `mensajes_medios` (`id_mensaje`, `id_medio`) VALUES
(32, 1),
(33, 2),
(34, 3),
(35, 4),
(36, 5),
(37, 6),
(38, 7),
(39, 8),
(40, 9),
(41, 10),
(42, 11),
(44, 12),
(45, 13),
(46, 14),
(48, 15),
(49, 16),
(50, 17),
(51, 18),
(52, 19),
(53, 20),
(54, 21),
(55, 22),
(56, 23),
(57, 24),
(58, 25),
(59, 26),
(60, 27),
(61, 28),
(62, 29),
(63, 30),
(64, 31),
(65, 32),
(66, 33),
(67, 34),
(68, 35),
(69, 36),
(70, 37),
(71, 38),
(72, 39),
(73, 40),
(74, 41),
(75, 42),
(76, 43),
(77, 44),
(78, 45),
(79, 46),
(80, 47),
(81, 48),
(82, 49),
(83, 50),
(84, 51),
(85, 52),
(86, 53),
(87, 54),
(88, 55),
(89, 56),
(90, 57),
(91, 58),
(92, 59),
(93, 60),
(94, 61),
(95, 62),
(96, 63),
(97, 64),
(98, 65),
(99, 66),
(101, 67),
(102, 68),
(103, 69),
(105, 70),
(106, 71),
(107, 72),
(108, 73),
(109, 74),
(110, 75),
(1, 76),
(2, 77),
(3, 78),
(4, 79),
(5, 80),
(6, 81),
(7, 82),
(8, 83),
(9, 84),
(10, 85),
(11, 86),
(12, 87),
(13, 88),
(14, 89),
(15, 90),
(16, 91),
(17, 92),
(18, 93),
(19, 94),
(20, 95),
(21, 96),
(22, 97),
(24, 98),
(25, 99),
(26, 100),
(27, 101),
(28, 102),
(29, 103),
(30, 104),
(31, 105),
(35, 106),
(36, 107),
(1, 108),
(2, 109),
(3, 110),
(4, 111),
(5, 112),
(6, 113),
(7, 114),
(8, 115),
(9, 116),
(10, 117),
(11, 118),
(12, 119),
(13, 120),
(14, 121),
(15, 122),
(16, 123),
(17, 124),
(18, 125),
(19, 126),
(20, 127),
(21, 128),
(22, 129),
(24, 130),
(25, 131),
(26, 132),
(27, 133),
(28, 134),
(29, 135),
(30, 136),
(31, 137),
(35, 138),
(36, 139),
(111, 140),
(113, 142),
(114, 143),
(115, 144),
(116, 145),
(117, 146),
(118, 147),
(119, 148),
(120, 149),
(121, 150),
(122, 151),
(123, 152),
(124, 153),
(125, 154),
(126, 155),
(127, 156),
(128, 157),
(129, 158),
(130, 159),
(131, 160),
(132, 161),
(133, 162),
(134, 163),
(135, 164),
(136, 165),
(137, 166),
(138, 167),
(139, 168),
(140, 169),
(141, 170),
(142, 171),
(143, 172),
(144, 173),
(145, 174),
(146, 175),
(147, 176),
(148, 177),
(149, 178),
(150, 179),
(151, 180),
(152, 181),
(153, 182),
(154, 183),
(155, 184),
(156, 185),
(157, 186),
(158, 187),
(159, 188),
(160, 189),
(161, 190),
(162, 191),
(163, 192),
(165, 193),
(166, 194),
(167, 195),
(168, 196),
(169, 197),
(170, 198),
(171, 199),
(172, 203),
(173, 204),
(174, 205),
(175, 206),
(176, 207),
(177, 208),
(178, 209),
(179, 210),
(180, 211),
(181, 212),
(182, 213),
(181, 214),
(180, 215),
(182, 216),
(183, 217),
(183, 218),
(184, 219),
(185, 220),
(186, 221),
(193, 224),
(194, 225),
(195, 226),
(186, 227),
(196, 228),
(194, 229),
(193, 230),
(197, 231),
(198, 232),
(195, 234),
(196, 235),
(205, 237),
(206, 238),
(207, 239),
(208, 240),
(198, 241),
(203, 243),
(210, 244),
(205, 245),
(211, 246),
(207, 247),
(214, 248),
(216, 250),
(212, 251),
(213, 252),
(217, 253),
(208, 254),
(218, 255),
(219, 256),
(221, 258),
(221, 259),
(203, 260),
(222, 261),
(222, 262),
(223, 263),
(224, 264),
(225, 265),
(226, 266),
(227, 267),
(225, 268),
(228, 269),
(229, 270),
(231, 272),
(230, 273),
(232, 274),
(233, 275),
(234, 276),
(235, 277),
(236, 278),
(237, 279),
(237, 280),
(242, 281),
(238, 282),
(239, 283),
(240, 284),
(241, 285),
(243, 286),
(244, 287),
(245, 288),
(246, 289),
(248, 290),
(250, 291),
(251, 292),
(252, 293),
(252, 294),
(253, 295),
(253, 296),
(254, 297),
(255, 298),
(257, 299),
(258, 300),
(259, 301),
(265, 302),
(266, 303),
(267, 304),
(268, 305),
(269, 306),
(270, 307),
(271, 308),
(272, 309),
(273, 310),
(274, 311),
(275, 312),
(276, 313),
(277, 314),
(278, 315),
(279, 316),
(280, 317),
(281, 318),
(286, 319),
(287, 320),
(288, 321),
(289, 322),
(290, 323),
(291, 324),
(293, 325),
(292, 326),
(294, 327),
(295, 328),
(296, 329),
(297, 330),
(298, 331),
(299, 332),
(300, 333),
(301, 334),
(302, 335),
(303, 336),
(305, 337),
(306, 338),
(307, 339),
(309, 340),
(310, 341),
(311, 342),
(312, 343),
(313, 344),
(314, 345),
(315, 346),
(316, 347),
(317, 348),
(318, 349),
(319, 350),
(322, 351),
(321, 352),
(323, 353),
(324, 354),
(325, 355),
(326, 356),
(327, 357),
(328, 358),
(330, 360),
(331, 361),
(333, 362),
(334, 363),
(335, 364),
(337, 365),
(338, 366),
(340, 367),
(342, 370),
(341, 371),
(343, 372),
(344, 373),
(345, 374),
(346, 375),
(348, 376),
(347, 377),
(349, 378),
(350, 379),
(351, 380),
(352, 381),
(353, 382),
(355, 383),
(357, 384),
(358, 385),
(359, 386),
(356, 387),
(354, 388),
(361, 389),
(371, 390),
(366, 391),
(369, 392),
(368, 393),
(370, 394),
(365, 395),
(363, 396),
(362, 397),
(364, 398),
(372, 399),
(373, 400),
(374, 401),
(375, 402),
(377, 403),
(378, 404),
(379, 405),
(381, 406),
(382, 407),
(383, 408),
(384, 409),
(390, 415),
(391, 416),
(392, 417),
(393, 418),
(394, 419),
(395, 420),
(396, 421),
(398, 422),
(399, 423),
(400, 424),
(401, 425),
(402, 426),
(408, 427),
(403, 428),
(404, 429),
(409, 430),
(410, 431),
(411, 432),
(412, 433),
(414, 434),
(415, 435),
(417, 436),
(418, 437),
(419, 438),
(426, 439),
(427, 440),
(425, 441),
(423, 442),
(429, 443),
(428, 444),
(430, 445),
(431, 446),
(432, 447),
(434, 449),
(439, 450),
(433, 451),
(437, 452),
(435, 453),
(440, 454),
(441, 455),
(442, 456),
(443, 457),
(444, 458),
(448, 459),
(445, 460),
(446, 461),
(447, 463),
(449, 464),
(450, 465),
(451, 466),
(452, 467),
(454, 468),
(453, 469),
(455, 470),
(456, 471),
(457, 472),
(458, 473),
(459, 474),
(460, 475),
(461, 476),
(464, 477),
(462, 478),
(463, 479),
(465, 480),
(466, 481),
(467, 483),
(468, 484),
(469, 486),
(471, 487),
(473, 488),
(474, 489),
(470, 490),
(475, 491),
(476, 492),
(477, 493),
(478, 494),
(481, 495),
(482, 496),
(483, 497),
(484, 498),
(485, 499),
(486, 500),
(487, 501),
(488, 502),
(493, 503),
(494, 504),
(495, 505),
(496, 506),
(497, 507),
(499, 508),
(502, 509),
(504, 510),
(505, 511),
(498, 512),
(503, 513),
(506, 514),
(507, 515),
(508, 516),
(509, 517),
(510, 518),
(511, 519),
(512, 520),
(513, 521),
(514, 522),
(515, 523),
(516, 524),
(517, 525),
(518, 526),
(520, 527),
(519, 528),
(521, 529),
(522, 530),
(523, 531),
(525, 532),
(526, 533),
(527, 534),
(533, 535),
(534, 536),
(535, 537),
(536, 538),
(537, 539),
(538, 540),
(539, 541),
(540, 542),
(541, 543),
(542, 544),
(543, 545),
(544, 546),
(546, 547),
(545, 548),
(548, 549),
(547, 550),
(550, 552),
(549, 553),
(551, 554),
(552, 555),
(553, 556),
(554, 557),
(557, 558),
(556, 559),
(555, 560),
(559, 561),
(560, 562),
(561, 563),
(562, 564),
(563, 565),
(564, 566),
(558, 567),
(567, 568),
(566, 569),
(568, 570),
(569, 571),
(570, 572),
(571, 573),
(572, 574),
(573, 575),
(574, 576),
(575, 577),
(576, 578),
(577, 579),
(578, 580),
(579, 581),
(580, 582),
(581, 583),
(582, 584),
(583, 585),
(584, 586),
(585, 587),
(588, 588),
(589, 589),
(586, 590),
(587, 591),
(590, 592),
(591, 593),
(593, 594),
(594, 595),
(595, 596),
(596, 597),
(598, 598),
(599, 599),
(600, 600),
(602, 601),
(603, 602),
(604, 603),
(605, 604),
(606, 605),
(607, 606),
(608, 607),
(615, 608),
(610, 609),
(611, 610),
(612, 611),
(613, 612),
(616, 613),
(617, 614),
(618, 615),
(619, 616),
(620, 617);

-- --------------------------------------------------------

--
-- Table structure for table `series`
--

CREATE TABLE `series` (
  `id_serie` int(10) UNSIGNED NOT NULL,
  `serie` varchar(64) NOT NULL,
  `subtitulo` varchar(64) NOT NULL,
  `descripcion` mediumtext NOT NULL,
  `imagen_archivo` varchar(64) NOT NULL,
  `imagen_altura` int(11) NOT NULL,
  `imagen_anchura` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `series`
--

INSERT INTO `series` (`id_serie`, `serie`, `subtitulo`, `descripcion`, `imagen_archivo`, `imagen_altura`, `imagen_anchura`) VALUES
(1, 'Más Grande Que', '', '', '', 0, 0),
(2, 'Hogar Dulce Hogar', '', '', '', 0, 0),
(3, 'Piratas', '', '', '', 0, 0),
(4, 'Amistades Fantásticas', '', '', '', 0, 0),
(5, 'Un Minuto Despues de la Muerte', '', '', '', 0, 0),
(6, 'Navidad sin Apuros', '', '', '', 0, 0),
(7, 'Tomando Buenas Decisiones', '', '', '', 0, 0),
(8, 'Amor y Orgullo', '', '', '', 0, 0),
(9, 'Héroes', '', '', '', 0, 0),
(10, 'Estrés o Paz Espiritual', '', '', '', 0, 0),
(11, 'Cristianismo Bajo Fuego', '', '', '', 0, 0),
(12, 'Obteniendo Poder Para Triunfar', '', '', '', 0, 0),
(13, 'Dimensión Desconocida', '', '', '', 0, 0),
(14, 'El Uno, El Otro', '', '', '', 0, 0),
(15, 'Colores de la Navidad', '', '', '', 0, 0),
(16, 'Un Nuevo Comienzo', '', '', '', 0, 0),
(17, 'Los Cuatro Versos del Amor', '', '', '', 0, 0),
(18, 'Jesús', '', '', '', 0, 0),
(19, 'Como Desarrollar una Personalidad Atractiva', '', '', '', 0, 0),
(20, 'Señales', '', '', '', 0, 0),
(21, 'Mas Allá de Nuestros Límites', '', '', '', 0, 0),
(22, 'Plan de Vuelo', '', '', '', 0, 0),
(23, 'Una Llamada de Auxilio', '', '', '', 0, 0),
(24, 'Juan Pirata vs. Juan Original', '', '', '', 0, 0),
(25, 'Los Farsantes', '', '', '', 0, 0),
(26, 'Celebrando la Navidad', '', '', '', 0, 0),
(27, 'Como Superar la Crisis', '', '', '', 0, 0),
(28, 'Cambio Ha Venido para tu Persona', '', '', '', 0, 0),
(29, '¿Cuanto Valen tus Valores?', '', '', '', 0, 0),
(30, 'Vida, Dinero, Esperanza', '', '', '', 0, 0),
(31, 'La Tormenta Perfecta', '', '', '', 0, 0),
(32, 'Paz', '', '', '', 0, 0),
(33, 'Grande', '', 'Un llamado al servicio voluntario.', '', 0, 0),
(34, 'Así se Conocieron', '', 'Una historia entre Dios y el hombre', '', 0, 0),
(35, 'Promesas', '', 'Promesas de Dios', '', 0, 0),
(36, 'Remodelando Tu Familia', '', '', '', 0, 0),
(37, 'Campamento Jesucristo', '', '', '', 0, 0),
(38, 'Angeles vs Demonios', '', '', '', 0, 0),
(39, 'Navidad es Mucho Mas ', '', '', '', 0, 0),
(40, 'Vencedor', '', '', '', 0, 0),
(41, 'Las 4 Caras del Amor', '', '', '', 0, 0),
(42, 'Evangelismo, Compartiendo a Cristo', '', 'Curso de Evangelismo', '', 0, 0),
(43, 'El Encuentro', '', '', '', 0, 0),
(44, 'No Tengo Miedo', '', '', '', 0, 0),
(45, 'Milagros', '', '', '', 0, 0),
(46, 'Madurez', '', '', '', 0, 0),
(47, 'Qué Haría Jesús', '', '', '', 0, 0),
(48, 'Puedes Hacerlo', 'No esperes mÃ¡s', '', '', 0, 0),
(49, 'Triunfar Sobre la Crisis', '', 'Vivimos en una época difícil donde las cosas parecen no ir bien, pero existe una forma de salir adelante de realmente TRIUNFAR.', '', 0, 0),
(50, 'Decisiones', 'Tomando las Mejores Decisiones', 'Las decisiones son parte de la vida. ¿Pero como poder tomar decisiones que hagan una diferencia positiva en nuestro futuro?\r\nVen y aprende de personajes que tomaron las mejores decisiones en momentos díficiles', '', 0, 0),
(51, 'Quiero Ser Tu Amigo', '', '', '', 0, 0),
(52, 'Navidad en Paz', '', '', '', 0, 0),
(53, 'Un Año Decisivo', 'Cómo Lograrlo', '', '201101-un-anio-decisivo.png', 750, 232),
(54, 'Historias de Amor', '', '', '201102-historias-de-amor-2.jpg', 750, 242),
(55, 'Victoria', '', '\"...estamos seguros de que Jesucristo, quien nos amó, nos dará la victoria total.\" Romanos 8:37b (BLA)', '201103-victoria.png', 750, 242),
(56, 'Frases no tan Célebres', '¿Cómo cambiarlas?', '', '201104-frases-no-tan-celebres.jpg', 750, 280),
(57, 'Destino', '', '', '201105-destino.jpg', 750, 232),
(58, 'Haciendo CRECER nuestra fe', '', '', '201106-fe.jpg', 750, 350),
(59, 'Simple', 'Conociendo a un Dios nada complicado', '', '201107-simple.png', 750, 232),
(60, 'El Valor de Una Vida', '', 'Ven y descubre cuánto realmente vale una vida, y cómo ésta puede hacer una gran diferencia en muchas otras.', '201108-el-valor-de-una-vida.jpg', 750, 250),
(61, 'Click', '', '', '', 0, 0),
(62, 'Mis Retos', '', 'Los retos que un creyente puede tener frente a la vida.', '201110-retos.jpg', 400, 750),
(63, 'Manus Dei', '', '', '', 300, 750),
(64, 'Las Estaciones de la Vida', '', '', '201111-estaciones.jpg', 293, 750),
(66, 'Hacia una noche de paz', '', '', 'invitaweb.jpg', 440, 750),
(67, 'Disciplinas Espirituales', 'Hacia un crecimiento espiritual autentico', '', 'diciespi.jpg', 444, 750),
(68, 'Cómo Dominar', '', '', 'dominarweb.jpg', 444, 750),
(69, 'Transformando a la Familia', '', '', 'transformandoweb.jpg', 444, 750),
(70, 'VOX DEI', 'La poderosa voz de Dios', '', 'voxdeiweb.jpg', 444, 750),
(71, 'Una Vida Apasionada', 'Propósito, satisfacción, aventura y felicidad.', '', 'vidaweb.jpg', 444, 750),
(72, 'El camino', '', '', 'caminoweb.jpg', 444, 750),
(73, 'Hasta el fin del mundo', '', '', 'finweb.png', 444, 750),
(74, 'José el Soñador', '', '', 'joseweb.jpg', 444, 750),
(75, 'Un virus se propaga, toma el...', '', '', 'antidotoweb.png', 444, 750),
(76, 'Parece que fueran verdad, pero son...', '', '', 'urbaweb.jpg', 444, 750),
(77, 'No eres igual a todos, eres...', '', '', 'arteweb.jpg', 444, 750),
(78, 'Una Sabia Navidad', '', '', 'sabiaweb.jpg', 444, 750),
(79, 'Cómo Crear y Cumplir tus Sueños', '', '', 'eneroweb.jpg', 444, 750),
(80, 'Sí y No', '', '', 'sinoweb.jpg', 444, 750),
(81, 'Amor Auténtico', '', '', 'amourweb.jpg', 444, 750),
(82, 'Dios y mis negocios', '', '', 'negociosweb.jpg', 444, 750),
(83, '¿Cómo ser un seguidor?', '...y nunca un fanático', '', '201305-como-ser-un-seguidor.jpg', 340, 739),
(84, 'El Aprendíz', '', '', 'aprendizweb.jpg', 444, 750),
(85, 'GRACIA', '', '', 'graciaweb.jpg', 444, 750),
(86, 'Nosotros y las finanzas ', '', '', 'negociosweb2.jpg', 444, 750),
(87, 'Inspiración', 'Para seguir adelante', '', 'inspiweb1.png', 444, 750),
(88, 'Las Cuatro Joyas', '', '', 'romboweb.png', 444, 750),
(89, 'Revolución del Espíritu', '', '', '', 1, 1),
(90, 'El Imperio de La Paz', '', '', 'naciweb.png', 444, 750),
(91, 'Persistencia ', '', '', 'persistenciaweb.jpg', 444, 750),
(92, 'Cuates para Siempre', '', '', 'cuatesweb.jpg', 444, 750),
(93, '¿Por Qué?', '', '', 'porqueweb.jpg', 444, 750),
(94, 'Conexion', '', '', 'conexionweb.jpg', 444, 750),
(95, 'Valiente', '', '', 'valienteweb.jpg', 444, 750),
(96, 'Victorias Privadas', '', '', 'vicweb.jpg', 444, 750),
(97, 'MENSAJE', 'QUE CAMBIA AL MUNDO', '', 'menweb.png', 444, 750),
(98, 'Mejorando mi Familia', '', '', 'milagrosweb.png', 444, 750),
(99, ' ', '', '', 'felizweb.png', 444, 750),
(100, 'Los 3 Regalos de la Navidad', '', '', 'dicweb.jpg', 444, 750),
(101, 'En enero', '', '', 'conweb.jpg', 444, 750),
(102, 'Tiempo de Sembrar', '', '', 'websem.png', 444, 750),
(103, 'ABC', '', '', 'selfweb.jpg', 444, 750),
(104, 'Selfie', '', '', 'selfweb.jpg', 444, 750),
(105, 'Celebrando a Mama', 'La mejor de todas', '', '', 800, 600),
(106, 'Una Familia Feliz', '', '', 'webfamilia.jpg', 444, 750),
(107, 'TABU', 'Hablemos de los que no se habla.', '', 'tabuweb.jpg', 444, 750),
(108, 'Las 4 piezas para una Fe solida', '', '', 'rompeweb.jpg', 444, 750),
(109, 'Back to School', '', '', 'backweb.jpg', 444, 750),
(110, '#Somos Gran Comision', '', '', 'somosweb.jpg', 444, 750),
(111, 'Un Final de Pelicula', '', '', 'webpeli.jpg', 444, 750),
(112, 'GRACIA', '#DiosenAccion', '', '', 100, 100),
(113, 'La Vida Despues de la Vida', '', '', 'vidaweb.jpg', 444, 750),
(114, 'Mi Historia', '', '', 'historiaweb.jpg', 444, 750),
(115, 'Cambia el Mundo en 31 días', '', '', 'Cambiaweb.jpg', 444, 750),
(116, '¿Cómo  ser Millonario de Corazón?', '', '', 'moneyweb.jpg', 444, 750),
(117, 'Flechados', '', '', 'flechaweb.jpg', 444, 750),
(118, 'Tiempo de Esparcir', '', '', 'tiempoweb.jpg', 444, 750),
(119, 'Pascua', '', '', 'pascuaweb.jpg', 444, 750),
(120, 'Sentimientos', '', '', 'sentiweb.jpg', 444, 750),
(121, 'La Gran Invitación ', '', '', '', 400, 300),
(122, 'Celebración día de la madre ', '', '', '', 300, 600),
(123, 'Bendice este hogar', '', '', 'bendiceweb.jpg', 444, 750),
(124, 'Los Primeros Pasos', '', '', 'primerosweb.jpg', 444, 750),
(125, 'Una Fe Olímpica', '', '', 'maraweb.jpg', 444, 750),
(126, 'PREGUNTAS FRECUENTES', '', '', '', 100, 300),
(127, 'Historias de Jesús', '', '', 'hisjesus.jpg', 444, 750),
(128, 'Conferencia Vertical 2016', '', '', '', 100, 300),
(129, 'De Película 2016', '', '', 'webpeli.jpg', 444, 750),
(130, 'Mi Nuevo Yo', '', '', 'minuevoweb.jpg', 444, 750),
(131, 'Los Fantasmas de las Navidades Pasadas', '', '', 'Pasaweb.jpg', 444, 750),
(132, '¿Qué tan grande es tu visión?', '', '', '2017web.jpg', 444, 750),
(133, 'DESCUBRIENDO MI LLAMADO', '', '', 'llamadoweb.jpg', 444, 750),
(134, 'Nueva Perspectiva', '', '', 'nuevaweb.jpg', 444, 750),
(136, 'Considera a Jesus', '', '', '', 444, 750),
(137, 'El Poder de lo Mismo', '', '', 'elpoderweb.jpg', 444, 750),
(138, 'Corazón de Oro', 'Una serie basada en la vida de David.', '', 'coraoro.jpg', 444, 750),
(139, '5 Cosas que Dios', 'Usa para Hacer Crecer Nuestra', '', '5cosasweb.jpg', 444, 750),
(140, 'PLAYLIST', '', '', 'playlistweb.jpg', 444, 750),
(141, '¿Quién era Jesús?', '', '', 'jesusweb.jpg', 444, 750),
(142, 'Vertical 2017 - Eleva Tu Pasión', 'Vertical 2017', '', '', 444, 750),
(143, 'Diferente', '', '', 'diferenteweb.jpg', 444, 750),
(144, 'Límites', '', '', 'limitesweb.jpg', 444, 750),
(145, 'Expectante', '', '', 'expectanteweb.jpg', 444, 750),
(146, 'El ADN GranCo', '', '', 'adnweb.jpg', 444, 750),
(147, 'Una vida de Bendición', '', '', 'bendiweb.jpg', 444, 750),
(148, 'Una familia disfuncional', '', '', 'famweb.jpg', 444, 750),
(149, 'Vivo Esta', 'La Resurreccion de Cristo', '', '', 100, 300),
(150, 'Viviendo para una Causa Eterna', '', '', '', 100, 300),
(151, 'Amor, sexo y noviazgo', '', '', 'amornoweb.jpg', 444, 750),
(152, 'Celebracion a mama', '', '', '', 100, 300),
(153, 'FE Bajo Fuego', '', '', 'febajoweb.jpg', 444, 750),
(154, 'Tigres de papel', '', '', 'tigreweb.jpg', 444, 750),
(156, 'Victimismo', '', '', '', 100, 300),
(157, 'Vampiros Relacionales', '', '', 'vampirosweb.jpg', 444, 750),
(158, 'Mejores Decisiones', '', '', 'mejoresweb.jpg', 444, 750),
(159, ' El Principio del Camino', 'Cómo llegar desde donde estás a donde quieres estar', '', '', 444, 750),
(160, 'UPS! ', 'No quise decir eso...', '', 'sept2018.jpg', 444, 750),
(161, 'VERTICAL 2018', 'SÍGUEME ', '', '', 444, 750),
(162, 'Conexiones Divinas', '', '', '', 444, 750),
(163, 'DE PELICULA ', '2018', '', '', 444, 750),
(164, 'Robo de Identidad', '', '', '', 444, 750),
(165, 'Dios con nosostros', '', '', '', 444, 750),
(166, 'HABITOS', '', '', '', 444, 750),
(167, 'La Familia Real', '', '', '', 444, 750),
(168, 'Creado para Servir', '', '', '', 444, 750);

-- --------------------------------------------------------

--
-- Table structure for table `series_bkup`
--

CREATE TABLE `series_bkup` (
  `id_serie` int(11) UNSIGNED NOT NULL,
  `serie` varchar(64) NOT NULL,
  `descripcion` mediumtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `series_bkup`
--

INSERT INTO `series_bkup` (`id_serie`, `serie`, `descripcion`) VALUES
(0, 'Más grande que', ''),
(1, 'Hogar Dulce Hogar', ''),
(3, 'Piratas', ''),
(4, 'Amistades Fantásticas', ''),
(5, 'Un Minuto Despues de la Muerte', ''),
(6, 'Navidad sin Apuros', ''),
(7, 'Tomando Buenas Decisiones', ''),
(8, 'Amor y Orgullo', ''),
(9, 'Héroes', ''),
(10, 'Estrés o Paz Espiritual', ''),
(11, 'Cristianismo Bajo Fuego', ''),
(12, 'Obteniendo Poder Para Triunfar', ''),
(13, 'Dimensión Desconocida', ''),
(14, 'El Uno, El Otro', ''),
(15, 'Colores de la Navidad', ''),
(16, 'Un Nuevo Comienzo', ''),
(17, 'Los Cuatro Versos del Amor', ''),
(18, 'Jesús', ''),
(19, 'Como Desarrollar una Personalidad Atractiva', ''),
(20, 'Señales', ''),
(21, 'Mas Allá de Nuestros Límites', ''),
(22, 'Plan de Vuelo', ''),
(23, 'Una Llamada de Auxilio', ''),
(24, 'Juan Pirata vs. Juan Original', ''),
(25, 'Los Farsantes', ''),
(26, 'Celebrando la Navidad', ''),
(27, 'Como Superar la Crisis', ''),
(28, 'Cambio Ha Venido para tu Persona', ''),
(29, '¿Cuanto Valen tus Valores?', ''),
(30, 'Vida, Dinero, Esperanza', ''),
(31, 'La Tormenta Perfecta', ''),
(32, 'Paz', ''),
(33, 'Grande', 'Un llamado al servicio voluntario.'),
(34, 'Así se Conocieron', 'Una historia entre Dios y el hombre'),
(35, 'Promesas', 'Promesas de Dios'),
(36, 'Remodelando Tu Familia', ''),
(37, 'Campamento Jesucristo', ''),
(38, 'Angeles vs Demonios', ''),
(39, 'Navidad es Mucho Mas ', ''),
(40, 'Vencedor', ''),
(41, 'Las 4 Caras del Amor', ''),
(42, 'Evangelismo, Compartiendo a Cristo', 'Curso de Evangelismo'),
(43, 'El Encuentro', ''),
(44, 'No Tengo Miedo', ''),
(45, 'Milagros', ''),
(46, 'Madurez', ''),
(47, 'Qué Haría Jesús', '');

-- --------------------------------------------------------

--
-- Table structure for table `series_claves`
--

CREATE TABLE `series_claves` (
  `id_serie` int(10) UNSIGNED NOT NULL,
  `clave` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `series_medios`
--

CREATE TABLE `series_medios` (
  `id_serie` int(10) UNSIGNED NOT NULL,
  `id_medio` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tipos_medio`
--

CREATE TABLE `tipos_medio` (
  `id_tipo_medio` int(11) UNSIGNED NOT NULL,
  `tipo_medio` varchar(64) NOT NULL,
  `tabla` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tipos_medio`
--

INSERT INTO `tipos_medio` (`id_tipo_medio`, `tipo_medio`, `tabla`) VALUES
(1, 'Audio', 'medios_audio'),
(2, 'Imagen', 'medios_imagen'),
(3, 'Texto', 'medios_texto'),
(4, 'Video', 'medios_video'),
(5, 'Archivo', 'medios_archivo');

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_eventos`
-- (See below for the actual view)
--
CREATE TABLE `v_eventos` (
`id_evento` int(11) unsigned
,`titulo_evento` varchar(64)
,`subtitulo_evento` varchar(64)
,`resumen_evento` mediumtext
,`fecha` date
,`an_o` int(4)
,`mes` int(2)
,`dia` int(2)
,`fecha_fin` date
,`an_o_fin` int(4)
,`mes_fin` int(2)
,`dia_fin` int(2)
,`horario` varchar(64)
,`lugar` varchar(64)
,`precio` decimal(10,2)
,`ocultar_precio` tinyint(1)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_expositores`
-- (See below for the actual view)
--
CREATE TABLE `v_expositores` (
`id_expositor` int(11) unsigned
,`nombres` varchar(64)
,`apellidos` varchar(64)
,`expositor` varchar(129)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_grupos`
-- (See below for the actual view)
--
CREATE TABLE `v_grupos` (
`id_grupo` int(10) unsigned
,`nombre` varchar(64)
,`ubicacion` mediumtext
,`dia_reunion` int(11)
,`hora_reunion` time
,`id_lider_grupo` int(11) unsigned
,`url` varchar(255)
,`lider_grupo` varchar(129)
,`nombres` varchar(64)
,`apellidos` varchar(64)
,`telefono` varchar(64)
,`email` varchar(64)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_grupos_lideres`
-- (See below for the actual view)
--
CREATE TABLE `v_grupos_lideres` (
`id_lider_grupo` int(10) unsigned
,`lider` varchar(129)
,`nombres` varchar(64)
,`apellidos` varchar(64)
,`telefono` varchar(64)
,`email` varchar(64)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_imagenes`
-- (See below for the actual view)
--
CREATE TABLE `v_imagenes` (
`id_serie` int(10) unsigned
,`serie` varchar(64)
,`id_medio` int(10) unsigned
,`altura` int(11)
,`ancho` int(11)
,`texto_alterno` varchar(64)
,`src` varchar(256)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_mensajes`
-- (See below for the actual view)
--
CREATE TABLE `v_mensajes` (
`id_mensaje` int(11) unsigned
,`id_serie` int(10) unsigned
,`mensaje` varchar(64)
,`resumen` longtext
,`id_expositor` int(11)
,`fecha` date
,`serie` varchar(64)
,`expositor_nombres` varchar(64)
,`expositor_apellidos` varchar(64)
,`expositor` varchar(129)
,`an_o` int(4)
,`mes` int(2)
,`dia` int(2)
,`id_medio_audio` decimal(10,0)
,`m3u` varchar(256)
,`id_medio_video` decimal(10,0)
,`video_embed` text
,`video_url` varchar(512)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_mensajes_medios_audio`
-- (See below for the actual view)
--
CREATE TABLE `v_mensajes_medios_audio` (
`id_mensaje` int(10) unsigned
,`id_medio` int(10) unsigned
,`M3U` varchar(256)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_mensajes_medios_video`
-- (See below for the actual view)
--
CREATE TABLE `v_mensajes_medios_video` (
`id_mensaje` int(10) unsigned
,`id_medio` int(10) unsigned
,`embed` varchar(4096)
,`video_url` varchar(512)
);

-- --------------------------------------------------------

--
-- Structure for view `v_eventos`
--
DROP TABLE IF EXISTS `v_eventos`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_eventos`  AS  select `eventos`.`id_evento` AS `id_evento`,`eventos`.`titulo_evento` AS `titulo_evento`,`eventos`.`subtitulo_evento` AS `subtitulo_evento`,`eventos`.`resumen_evento` AS `resumen_evento`,`eventos`.`fecha` AS `fecha`,year(`eventos`.`fecha`) AS `an_o`,month(`eventos`.`fecha`) AS `mes`,dayofmonth(`eventos`.`fecha`) AS `dia`,`eventos`.`fecha_fin` AS `fecha_fin`,year(`eventos`.`fecha_fin`) AS `an_o_fin`,month(`eventos`.`fecha_fin`) AS `mes_fin`,dayofmonth(`eventos`.`fecha_fin`) AS `dia_fin`,`eventos`.`horario` AS `horario`,`eventos`.`lugar` AS `lugar`,`eventos`.`precio` AS `precio`,`eventos`.`ocultar_precio` AS `ocultar_precio` from `eventos` WITH CASCADED CHECK OPTION ;

-- --------------------------------------------------------

--
-- Structure for view `v_expositores`
--
DROP TABLE IF EXISTS `v_expositores`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_expositores`  AS  select `expositores`.`id_expositor` AS `id_expositor`,`expositores`.`nombres` AS `nombres`,`expositores`.`apellidos` AS `apellidos`,concat(`expositores`.`nombres`,' ',`expositores`.`apellidos`) AS `expositor` from `expositores` WITH CASCADED CHECK OPTION ;

-- --------------------------------------------------------

--
-- Structure for view `v_grupos`
--
DROP TABLE IF EXISTS `v_grupos`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_grupos`  AS  select `g`.`id_grupo` AS `id_grupo`,`g`.`nombre` AS `nombre`,`g`.`ubicacion` AS `ubicacion`,`g`.`dia_reunion` AS `dia_reunion`,`g`.`hora_reunion` AS `hora_reunion`,`g`.`id_lider_grupo` AS `id_lider_grupo`,`g`.`url` AS `url`,concat(`gl`.`nombres`,' ',`gl`.`apellidos`) AS `lider_grupo`,`gl`.`nombres` AS `nombres`,`gl`.`apellidos` AS `apellidos`,`gl`.`telefono` AS `telefono`,`gl`.`email` AS `email` from (`grupos` `g` join `grupos_lideres` `gl` on((`gl`.`id_lider_grupo` = `g`.`id_lider_grupo`))) WITH CASCADED CHECK OPTION ;

-- --------------------------------------------------------

--
-- Structure for view `v_grupos_lideres`
--
DROP TABLE IF EXISTS `v_grupos_lideres`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_grupos_lideres`  AS  select `grupos_lideres`.`id_lider_grupo` AS `id_lider_grupo`,concat(`grupos_lideres`.`nombres`,' ',`grupos_lideres`.`apellidos`) AS `lider`,`grupos_lideres`.`nombres` AS `nombres`,`grupos_lideres`.`apellidos` AS `apellidos`,`grupos_lideres`.`telefono` AS `telefono`,`grupos_lideres`.`email` AS `email` from `grupos_lideres` WITH CASCADED CHECK OPTION ;

-- --------------------------------------------------------

--
-- Structure for view `v_imagenes`
--
DROP TABLE IF EXISTS `v_imagenes`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_imagenes`  AS  select `s`.`id_serie` AS `id_serie`,`s`.`serie` AS `serie`,`sm`.`id_medio` AS `id_medio`,`mi`.`altura` AS `altura`,`mi`.`ancho` AS `ancho`,`mi`.`texto_alterno` AS `texto_alterno`,`mi`.`src` AS `src` from ((`series` `s` join `series_medios` `sm` on((`s`.`id_serie` = `sm`.`id_serie`))) join `medios_imagen` `mi` on((`sm`.`id_medio` = `mi`.`id_medio`))) WITH CASCADED CHECK OPTION ;

-- --------------------------------------------------------

--
-- Structure for view `v_mensajes`
--
DROP TABLE IF EXISTS `v_mensajes`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_mensajes`  AS  select `m`.`id_mensaje` AS `id_mensaje`,`m`.`id_serie` AS `id_serie`,`m`.`mensaje` AS `mensaje`,`m`.`resumen` AS `resumen`,`m`.`id_expositor` AS `id_expositor`,`m`.`fecha` AS `fecha`,`s`.`serie` AS `serie`,`e`.`nombres` AS `expositor_nombres`,`e`.`apellidos` AS `expositor_apellidos`,concat(`e`.`nombres`,' ',`e`.`apellidos`) AS `expositor`,year(`m`.`fecha`) AS `an_o`,month(`m`.`fecha`) AS `mes`,dayofmonth(`m`.`fecha`) AS `dia`,ifnull(`v_mensajes_medios_audio`.`id_medio`,-(1)) AS `id_medio_audio`,ifnull(`v_mensajes_medios_audio`.`M3U`,'') AS `m3u`,ifnull(`v_mensajes_medios_video`.`id_medio`,-(1)) AS `id_medio_video`,ifnull(`v_mensajes_medios_video`.`embed`,'') AS `video_embed`,ifnull(`v_mensajes_medios_video`.`video_url`,'') AS `video_url` from ((((`mensajes` `m` join `series` `s` on((`s`.`id_serie` = `m`.`id_serie`))) join `expositores` `e` on((`e`.`id_expositor` = `m`.`id_expositor`))) left join `v_mensajes_medios_audio` on((`m`.`id_mensaje` = `v_mensajes_medios_audio`.`id_mensaje`))) left join `v_mensajes_medios_video` on((`m`.`id_mensaje` = `v_mensajes_medios_video`.`id_mensaje`))) ;

-- --------------------------------------------------------

--
-- Structure for view `v_mensajes_medios_audio`
--
DROP TABLE IF EXISTS `v_mensajes_medios_audio`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_mensajes_medios_audio`  AS  select `mensajes_medios`.`id_mensaje` AS `id_mensaje`,`mensajes_medios`.`id_medio` AS `id_medio`,`medios_audio`.`M3U` AS `M3U` from ((`mensajes_medios` join `medios` on((`mensajes_medios`.`id_medio` = `medios`.`id_medio`))) join `medios_audio` on((`medios`.`id_medio` = `medios_audio`.`id_medio`))) WITH CASCADED CHECK OPTION ;

-- --------------------------------------------------------

--
-- Structure for view `v_mensajes_medios_video`
--
DROP TABLE IF EXISTS `v_mensajes_medios_video`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_mensajes_medios_video`  AS  select `mensajes_medios`.`id_mensaje` AS `id_mensaje`,`mensajes_medios`.`id_medio` AS `id_medio`,`medios_video`.`embed` AS `embed`,`medios_video`.`video_url` AS `video_url` from ((`mensajes_medios` join `medios` on((`mensajes_medios`.`id_medio` = `medios`.`id_medio`))) join `medios_video` on((`medios`.`id_medio` = `medios_video`.`id_medio`))) WITH CASCADED CHECK OPTION ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `claves`
--
ALTER TABLE `claves`
  ADD PRIMARY KEY (`clave`);

--
-- Indexes for table `eventos`
--
ALTER TABLE `eventos`
  ADD PRIMARY KEY (`id_evento`);

--
-- Indexes for table `eventos_claves`
--
ALTER TABLE `eventos_claves`
  ADD PRIMARY KEY (`id_evento`,`clave`);

--
-- Indexes for table `eventos_medios`
--
ALTER TABLE `eventos_medios`
  ADD PRIMARY KEY (`id_evento`,`id_medio`),
  ADD KEY `id_medio` (`id_medio`);

--
-- Indexes for table `expositores`
--
ALTER TABLE `expositores`
  ADD PRIMARY KEY (`id_expositor`);

--
-- Indexes for table `expositores_medios`
--
ALTER TABLE `expositores_medios`
  ADD PRIMARY KEY (`id_medio`,`id_expositor`),
  ADD KEY `id_expositor` (`id_expositor`);

--
-- Indexes for table `grupos`
--
ALTER TABLE `grupos`
  ADD PRIMARY KEY (`id_grupo`);

--
-- Indexes for table `grupos_lideres`
--
ALTER TABLE `grupos_lideres`
  ADD PRIMARY KEY (`id_lider_grupo`);

--
-- Indexes for table `medios`
--
ALTER TABLE `medios`
  ADD PRIMARY KEY (`id_medio`),
  ADD KEY `id_tipo_medio` (`id_tipo_medio`);

--
-- Indexes for table `medios_archivo`
--
ALTER TABLE `medios_archivo`
  ADD PRIMARY KEY (`id_medio`);

--
-- Indexes for table `medios_audio`
--
ALTER TABLE `medios_audio`
  ADD PRIMARY KEY (`id_medio`);

--
-- Indexes for table `medios_imagen`
--
ALTER TABLE `medios_imagen`
  ADD PRIMARY KEY (`id_medio`);

--
-- Indexes for table `medios_texto`
--
ALTER TABLE `medios_texto`
  ADD PRIMARY KEY (`id_medio`);

--
-- Indexes for table `medios_video`
--
ALTER TABLE `medios_video`
  ADD PRIMARY KEY (`id_medio`);

--
-- Indexes for table `mensajes`
--
ALTER TABLE `mensajes`
  ADD PRIMARY KEY (`id_mensaje`);

--
-- Indexes for table `mensajes_claves`
--
ALTER TABLE `mensajes_claves`
  ADD PRIMARY KEY (`id_mensaje`,`clave`);

--
-- Indexes for table `mensajes_medios`
--
ALTER TABLE `mensajes_medios`
  ADD PRIMARY KEY (`id_mensaje`,`id_medio`),
  ADD KEY `id_medio` (`id_medio`);

--
-- Indexes for table `series`
--
ALTER TABLE `series`
  ADD PRIMARY KEY (`id_serie`);

--
-- Indexes for table `series_claves`
--
ALTER TABLE `series_claves`
  ADD PRIMARY KEY (`id_serie`,`clave`);

--
-- Indexes for table `series_medios`
--
ALTER TABLE `series_medios`
  ADD PRIMARY KEY (`id_serie`,`id_medio`),
  ADD KEY `id_medio` (`id_medio`);

--
-- Indexes for table `tipos_medio`
--
ALTER TABLE `tipos_medio`
  ADD PRIMARY KEY (`id_tipo_medio`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `eventos`
--
ALTER TABLE `eventos`
  MODIFY `id_evento` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=119;

--
-- AUTO_INCREMENT for table `expositores`
--
ALTER TABLE `expositores`
  MODIFY `id_expositor` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `grupos`
--
ALTER TABLE `grupos`
  MODIFY `id_grupo` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `grupos_lideres`
--
ALTER TABLE `grupos_lideres`
  MODIFY `id_lider_grupo` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `medios`
--
ALTER TABLE `medios`
  MODIFY `id_medio` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=618;

--
-- AUTO_INCREMENT for table `mensajes`
--
ALTER TABLE `mensajes`
  MODIFY `id_mensaje` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=672;

--
-- AUTO_INCREMENT for table `series`
--
ALTER TABLE `series`
  MODIFY `id_serie` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=169;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `eventos_medios`
--
ALTER TABLE `eventos_medios`
  ADD CONSTRAINT `eventos_medios_ibfk_1` FOREIGN KEY (`id_medio`) REFERENCES `medios` (`id_medio`),
  ADD CONSTRAINT `eventos_medios_ibfk_2` FOREIGN KEY (`id_evento`) REFERENCES `eventos` (`id_evento`);

--
-- Constraints for table `expositores_medios`
--
ALTER TABLE `expositores_medios`
  ADD CONSTRAINT `expositores_medios_ibfk_1` FOREIGN KEY (`id_expositor`) REFERENCES `expositores` (`id_expositor`) ON UPDATE CASCADE,
  ADD CONSTRAINT `expositores_medios_ibfk_2` FOREIGN KEY (`id_medio`) REFERENCES `medios` (`id_medio`) ON UPDATE CASCADE;

--
-- Constraints for table `medios`
--
ALTER TABLE `medios`
  ADD CONSTRAINT `medios_ibfk_1` FOREIGN KEY (`id_tipo_medio`) REFERENCES `tipos_medio` (`id_tipo_medio`) ON UPDATE CASCADE;

--
-- Constraints for table `medios_archivo`
--
ALTER TABLE `medios_archivo`
  ADD CONSTRAINT `medios_archivo_ibfk_1` FOREIGN KEY (`id_medio`) REFERENCES `medios` (`id_medio`);

--
-- Constraints for table `medios_audio`
--
ALTER TABLE `medios_audio`
  ADD CONSTRAINT `FK_medios_audio_1` FOREIGN KEY (`id_medio`) REFERENCES `medios` (`id_medio`) ON UPDATE CASCADE;

--
-- Constraints for table `medios_imagen`
--
ALTER TABLE `medios_imagen`
  ADD CONSTRAINT `medios_imagen_ibfk_1` FOREIGN KEY (`id_medio`) REFERENCES `medios` (`id_medio`) ON UPDATE CASCADE;

--
-- Constraints for table `medios_texto`
--
ALTER TABLE `medios_texto`
  ADD CONSTRAINT `medios_texto_ibfk_1` FOREIGN KEY (`id_medio`) REFERENCES `medios` (`id_medio`);

--
-- Constraints for table `medios_video`
--
ALTER TABLE `medios_video`
  ADD CONSTRAINT `medios_video_ibfk_1` FOREIGN KEY (`id_medio`) REFERENCES `medios` (`id_medio`);

--
-- Constraints for table `mensajes_medios`
--
ALTER TABLE `mensajes_medios`
  ADD CONSTRAINT `mensajes_medios_ibfk_1` FOREIGN KEY (`id_mensaje`) REFERENCES `mensajes` (`id_mensaje`) ON UPDATE CASCADE,
  ADD CONSTRAINT `mensajes_medios_ibfk_2` FOREIGN KEY (`id_medio`) REFERENCES `medios` (`id_medio`) ON UPDATE CASCADE;

--
-- Constraints for table `series_medios`
--
ALTER TABLE `series_medios`
  ADD CONSTRAINT `series_medios_ibfk_2` FOREIGN KEY (`id_medio`) REFERENCES `medios` (`id_medio`) ON UPDATE CASCADE,
  ADD CONSTRAINT `series_medios_ibfk_3` FOREIGN KEY (`id_serie`) REFERENCES `series` (`id_serie`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
