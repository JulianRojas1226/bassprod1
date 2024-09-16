-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 16-09-2024 a las 17:57:51
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bassprod`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_precios` ()   BEGIN
  UPDATE detalles_pedido dp
  JOIN aux_actualizacion_precio ap ON dp.Id_dpedido = ap.Id_dpedido
  JOIN producto p ON ap.Id_producto = p.id_producto
  SET dp.Precio_u = p.Precio;

  DELETE FROM aux_actualizacion_precio; 
END$$

DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalles_pedido`
--

CREATE TABLE `detalles_pedido` (
  `Id_orden` int(11) NOT NULL,
  `Id_dpedido` int(11) NOT NULL,
  `Id_producto` int(11) NOT NULL,
  `Cantidad` int(11) NOT NULL,
  `Precio_u` int(11) NOT NULL,
  `total_p` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalles_pedido`
--

INSERT INTO `detalles_pedido` (`Id_orden`, `Id_dpedido`, `Id_producto`, `Cantidad`, `Precio_u`, `total_p`) VALUES
(1, 5, 2, 6, 3500, 21000),
(1, 4, 5, 6, 4500, 27000);

--
-- Disparadores `detalles_pedido`
--
DELIMITER $$
CREATE TRIGGER `tri_monto_total` BEFORE INSERT ON `detalles_pedido` FOR EACH ROW BEGIN
    DECLARE precio_u int(11);
    SELECT precio INTO precio_u
    from producto
    WHERE id_producto = NEW.id_producto;
    SET NEW.total_p = NEW.cantidad * precio_u;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tri_precio_u` BEFORE INSERT ON `detalles_pedido` FOR EACH ROW BEGIN
    DECLARE precio_u DECIMAL(10, 2);  

    
    SELECT precio INTO precio_u
    FROM producto
    WHERE Id_producto = NEW.Id_producto;

    
    SET NEW.precio_u = precio_u;
END
$$
DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleado`
--

CREATE TABLE `empleado` (
  `Id` int(11) NOT NULL,
  `Nom_empeado` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `empleado`
--

INSERT INTO `empleado` (`Id`, `Nom_empeado`) VALUES
(10, 'julian');

-- ----------------------------------------------------------------------------------------------------------------

--
-- Estructura de tabla para la tabla `mesa`
--

CREATE TABLE `mesa` (
  `Id_mesa` int(11) NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'disponible'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `mesa`
--

INSERT INTO `mesa` (`Id_mesa`, `estado`) VALUES
(1, 'disponible'),
(2, 'ocupada'),
(3, 'reservada'),
(4, 'disponible');
(5, 'reservada');

-- ----------------------------------------------------------------------------------------------------------------

--
-- Estructura Stand-in para la vista `mesa_ocupada`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `mesa_ocupada` (
`mesa` int(11)
);

-- ----------------------------------------------------------------------------------------------------------------

--
-- Estructura de tabla para la tabla `orden`
--

CREATE TABLE `orden` (
  `Id_orden` int(11) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `mesa` int(11) NOT NULL,
  `Id_us` int(11) NOT NULL,
  `fecha_hora` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `orden`
--

INSERT INTO `orden` (`Id_orden`, `fecha`, `mesa`, `Id_us`, `fecha_hora`) VALUES
(1, '2024-09-10 06:17:12', 1, 10, NULL);

-- ----------------------------------------------------------------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `Id_pagos` int(11) NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `fecha_y_hora` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `Monto_pago` int(11) DEFAULT NULL,
  `Metodo` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `Id_producto` int(11) NOT NULL,
  `Nombre` varchar(50) NOT NULL,
  `Can_ml` int(50) NOT NULL,
  `Precio` int(11) NOT NULL,
  `Proveedor` varchar(50) NOT NULL,
  `Estado` varchar(20) NOT NULL DEFAULT 'Disponible',
  `Cantidad` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`Id_producto`, `Nombre`, `Can_ml`, `Precio`, `Proveedor`, `Estado`, `Cantidad`) VALUES
(1, 'Poker', 330, 3500, 'Wilson', 'disponible', '50'),
(2, 'Aguila', 330, 3500, 'Wilson', 'disponible', '50'),
(3, 'Aguila ligth', 330, 3500, 'Wilson', 'disponible', '40'),
(4, 'Andina', 330, 3000, 'Wilson', 'disponible', '10'),
(5, 'Club roja', 330, 4500, 'Wilson', 'disponible', '5'),
(6, 'Club dorada', 330, 4500, 'Wilson', 'disponible', '30'),
(7, 'Club negra', 330, 4500, 'Wilson', 'disponible', '16'),
(8, 'Heineken', 330, 4500, 'Wilson', 'disponible', '35'),
(9, 'Corona', 330, 5000, 'Wilson', 'disponible', '30'),
(10, 'Coronita', 210, 4000, 'Wilson', 'disponible', '45'),
(11, 'Budweiser', 330, 3500, 'Wilson', 'disponible', '20'),
(12, 'Costeña', 330, 3500, 'Wilson', 'disponible', '15'),
(13, 'Tecate', 330, 3500, 'Wilson', 'disponible', '10');

-- ----------------------------------------------------------------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor`
--

CREATE TABLE `proveedor` (
  `Nom_proveedor` varchar(50) NOT NULL,
  `Id_proveedor` int(11) NOT NULL,
  `Tel_proveedor` int(11) NOT NULL,
  `Id_producto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------------------------------------------------------

--
-- Estructura de tabla para la tabla `reservas`
--

CREATE TABLE `reservas` (
  `nombre` varchar(50) DEFAULT NULL,
  `id` int(10) NOT NULL,
  `correo` varchar(50) DEFAULT NULL,
  `tipo_re` varchar(50) DEFAULT NULL,
  `cantidad_p` int(11) DEFAULT NULL,
  `mesa_asig` int(11) NOT NULL,
  `numero_reserva` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------------------------------------------------------

--
-- Estructura Stand-in para la vista `vistaproductoagotado`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vistaproductoagotado` (
`nombre` varchar(50)
);

-- ----------------------------------------------------------------------------------------------------------------

--
-- Estructura Stand-in para la vista `vistaproductodisponible`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vistaproductodisponible` (
`nombre` varchar(50)
);
-- ----------------------------------------------------------------------------------------------------------------

--
-- Estructura para la vista `mesa_disponible`
--
DROP TABLE IF EXISTS `mesa_disponible`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `mesa_disponible`  AS SELECT `orden`.`mesa` AS `mesa` FROM (`orden` join `mesa` on(`orden`.`mesa` = `mesa`.`Id_mesa`)) ;

-- ----------------------------------------------------------------------------------------------------------------

--
-- Estructura para la vista `mesa_ocupada`
--
DROP TABLE IF EXISTS `mesa_ocupada`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `mesa_ocupada`  AS SELECT `orden`.`mesa` AS `mesa` FROM (`orden` join `mesa` on(`orden`.`mesa` = `mesa`.`Id_mesa`)) ;

-- ----------------------------------------------------------------------------------------------------------------

--
-- Estructura para la vista `mesa_ocupada`
--
DROP TABLE IF EXISTS `mesa_reserevada`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `mesa_reservada`  AS SELECT `orden`.`mesa` AS `mesa` FROM (`orden` join `mesa` on(`orden`.`mesa` = `mesa`.`Id_mesa`)) ;

-- ----------------------------------------------------------------------------------------------------------------
--
-- Estructura para la vista `vistaproductoagotado`
--
DROP TABLE IF EXISTS `vistaproductoagotado`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vistaproductoagotado`  AS SELECT `producto`.`Nombre` AS `nombre` FROM `producto` WHERE `producto`.`Cantidad` < 15 ;

-- ----------------------------------------------------------------------------------------------------------------

--
-- Estructura para la vista `vistaproductodisponible`
--
DROP TABLE IF EXISTS `vistaproductodisponible`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vistaproductodisponible`  AS SELECT `producto`.`Nombre` AS `nombre` FROM `producto` WHERE `producto`.`Cantidad` > 15 ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `detalles_pedido`
--
ALTER TABLE `detalles_pedido`
  ADD PRIMARY KEY (`Id_orden`,`Id_producto`,`Id_dpedido`) USING BTREE,
  ADD KEY `idproducto` (`Id_producto`);

--
-- Indices de la tabla `empleado`
--
ALTER TABLE `empleado`
  ADD PRIMARY KEY (`Id`);

--
-- Indices de la tabla `mesa`
--
ALTER TABLE `mesa`
  ADD PRIMARY KEY (`Id_mesa`);

--
-- Indices de la tabla `orden`
--
ALTER TABLE `orden`
  ADD PRIMARY KEY (`Id_orden`,`mesa`,`Id_us`),
  ADD KEY `idus` (`Id_us`),
  ADD KEY `idmesa` (`mesa`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`Id_pagos`,`id_pedido`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`Id_producto`) USING BTREE;

--
-- Indices de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD PRIMARY KEY (`Id_producto`);

--
-- Indices de la tabla `reservas`
--
ALTER TABLE `reservas`
  ADD PRIMARY KEY (`id`,`mesa_asig`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `Id_pagos` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalles_pedido`
--
ALTER TABLE `detalles_pedido`
  ADD CONSTRAINT `detalles_pedido_ibfk_2` FOREIGN KEY (`Id_producto`) REFERENCES `producto` (`Id_producto`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detalles_pedido_ibfk_3` FOREIGN KEY (`Id_orden`) REFERENCES `orden` (`Id_orden`);

--
-- Filtros para la tabla `orden`
--
ALTER TABLE `orden`
  ADD CONSTRAINT `orden_ibfk_1` FOREIGN KEY (`mesa`) REFERENCES `mesa` (`Id_mesa`),
  ADD CONSTRAINT `orden_ibfk_2` FOREIGN KEY (`Id_us`) REFERENCES `empleado` (`Id`);

--
-- Filtros para la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD CONSTRAINT `proveedor_ibfk_1` FOREIGN KEY (`Id_producto`) REFERENCES `producto` (`Id_producto`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
