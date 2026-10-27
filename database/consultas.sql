USE `dentalcare_bd`;

-- ============================================================================
-- CONSULTAS CRUD VERIFICADAS (COMPATIBLES CON LINUX Y dentalcare_bd_v2.sql)
-- ============================================================================

-- 1. usuario
INSERT INTO `usuario` (`id_rol`, `email`, `password_hash`, `estado`) 
VALUES (2, 'recepcion2@dentalcare.com', '$2a$10$QUOB1imQipamM.ht3H2rV.Jw4ywM8z81947SjJHnnBAsjwtppK80.', 'ACTIVO');
SELECT `id_usuario`, `email`, `estado` FROM `usuario` WHERE `email` = 'recepcion2@dentalcare.com';
UPDATE `usuario` SET `estado` = 'INACTIVO' WHERE `email` = 'recepcion2@dentalcare.com';
DELETE FROM `usuario` WHERE `email` = 'recepcion2@dentalcare.com';

-- 2. rol
INSERT INTO `rol` (`nombre_rol`, `descripcion`, `estado`) VALUES ('AUDITOR', 'Auditoría médica', 'ACTIVO');
SELECT * FROM `rol` WHERE `nombre_rol` = 'AUDITOR';
UPDATE `rol` SET `descripcion` = 'Auditoría interna de calidad' WHERE `nombre_rol` = 'AUDITOR';
DELETE FROM `rol` WHERE `nombre_rol` = 'AUDITOR';

-- 3. permiso
INSERT INTO `permiso` (`nombre_permiso`, `descripcion`) VALUES ('EXPORTAR_PDF', 'Exportación de informes');
SELECT * FROM `permiso` WHERE `nombre_permiso` = 'EXPORTAR_PDF';
UPDATE `permiso` SET `descripcion` = 'Exportación de reportes clínicos' WHERE `nombre_permiso` = 'EXPORTAR_PDF';
DELETE FROM `permiso` WHERE `nombre_permiso` = 'EXPORTAR_PDF';

-- 4. rol_permiso
INSERT INTO `rol_permiso` (`id_rol`, `id_permiso`) VALUES (2, 3);
SELECT r.`nombre_rol`, p.`nombre_permiso` FROM `rol_permiso` rp INNER JOIN `rol` r ON rp.`id_rol` = r.`id_rol` INNER JOIN `permiso` p ON rp.`id_permiso` = p.`id_permiso` WHERE rp.`id_rol` = 2 AND rp.`id_permiso` = 3;
DELETE FROM `rol_permiso` WHERE `id_rol` = 2 AND `id_permiso` = 3;

-- 5. personal
INSERT INTO `personal` (`id_usuario`, `tipo_documento`, `numero_documento`, `nombres`, `apellidos`, `cargo`, `telefono`) 
VALUES (2, 'CC', '1098765432', 'Mariana', 'Ríos', 'Recepcionista', '3008889900')
ON DUPLICATE KEY UPDATE `telefono` = '3008889900';
SELECT p.`id_personal`, CONCAT(p.`nombres`, ' ', p.`apellidos`) AS empleado, u.`email` FROM `personal` p INNER JOIN `usuario` u ON p.`id_usuario` = u.`id_usuario` WHERE p.`numero_documento` = '1098765432';
UPDATE `personal` SET `telefono` = '3009998877' WHERE `numero_documento` = '1098765432';
DELETE FROM `personal` WHERE `numero_documento` = '1098765432';

-- 6. especialista
SELECT e.`id_especialista`, CONCAT(p.`nombres`, ' ', p.`apellidos`) AS doctor, e.`especialidad`, e.`registro_medico` 
FROM `especialista` e INNER JOIN `personal` p ON e.`id_personal` = p.`id_personal`;
UPDATE `especialista` SET `especialidad` = 'Odontología General y Estética' WHERE `id_especialista` = 1;

-- 7. horario
INSERT INTO `horario` (`id_especialista`, `dia_semana`, `hora_inicio`, `hora_fin`) VALUES (1, 'Viernes', '08:00:00', '12:00:00');
SELECT * FROM `horario` WHERE `id_especialista` = 1 AND `dia_semana` = 'Viernes';
UPDATE `horario` SET `hora_fin` = '13:00:00' WHERE `id_especialista` = 1 AND `dia_semana` = 'Viernes';
DELETE FROM `horario` WHERE `id_especialista` = 1 AND `dia_semana` = 'Viernes';

-- 8. paciente
INSERT INTO `paciente` (`tipo_documento`, `numero_documento`, `nombres`, `apellidos`, `fecha_nacimiento`, `genero`, `telefono`, `email`, `direccion`, `eps_aseguradora`) 
VALUES ('CC', '1099999888', 'Valeria', 'Montoya', '1996-05-18', 'FEMENINO', '3128889900', 'valeria.montoya@email.com', 'Calle 10 # 40-20', 'Sura');
SELECT `id_paciente`, `numero_documento`, CONCAT(`nombres`, ' ', `apellidos`) AS paciente, `eps_aseguradora` FROM `paciente` WHERE `numero_documento` = '1099999888';
UPDATE `paciente` SET `telefono` = '3157778899', `direccion` = 'Carrera 43A # 20-10' WHERE `numero_documento` = '1099999888';
DELETE FROM `paciente` WHERE `numero_documento` = '1099999888';

-- 9. historia_clinica
SELECT hc.`id_historia`, p.`numero_documento`, CONCAT(p.`nombres`, ' ', p.`apellidos`) AS paciente, hc.`antecedentes_medicos`, hc.`alergias` 
FROM `historia_clinica` hc INNER JOIN `paciente` p ON hc.`id_paciente` = p.`id_paciente` WHERE p.`id_paciente` = 11;
UPDATE `historia_clinica` SET `antecedentes_medicos` = 'Hipertensión controlada', `alergias` = 'Alergia a Penicilina' WHERE `id_paciente` = 11;

-- 10. novedad_operativa
INSERT INTO `novedad_operativa` (`id_personal`, `tipo_novedad`, `descripcion`) VALUES (1, 'MANTENIMIENTO', 'Calibración de autoclave');
SELECT * FROM `novedad_operativa` WHERE `id_personal` = 1 ORDER BY `id_novedad` DESC LIMIT 1;
UPDATE `novedad_operativa` SET `descripcion` = 'Autoclave calibrada exitosamente' WHERE `id_personal` = 1 AND `descripcion` = 'Calibración de autoclave';
DELETE FROM `novedad_operativa` WHERE `id_personal` = 1 AND `descripcion` = 'Autoclave calibrada exitosamente';

-- 11. cita
INSERT INTO `cita` (`id_paciente`, `id_especialista`, `id_servicio`, `fecha_hora`, `motivo`, `estado_cita`) 
VALUES (11, 1, 1, '2026-11-20 10:00:00', 'Valoración de calza', 'PROGRAMADA');
SELECT c.`id_cita`, c.`fecha_hora`, c.`estado_cita`, CONCAT(p.`nombres`, ' ', p.`apellidos`) AS paciente 
FROM `cita` c INNER JOIN `paciente` p ON c.`id_paciente` = p.`id_paciente` WHERE c.`id_paciente` = 11;
UPDATE `cita` SET `estado_cita` = 'CANCELADA' WHERE `id_paciente` = 11 AND `fecha_hora` = '2026-11-20 10:00:00';
DELETE FROM `cita` WHERE `id_paciente` = 11 AND `fecha_hora` = '2026-11-20 10:00:00';

-- 12. consulta
SELECT co.`id_consulta`, co.`id_cita`, co.`motivo_consulta`, co.`diagnostico`, co.`procedimiento_realizado`, co.`prescripcion_medica` 
FROM `consulta` co WHERE co.`id_cita` = 1;
UPDATE `consulta` SET `prescripcion_medica` = 'Enjuague bucal con clorhexidina al 0.12%' WHERE `id_consulta` = 1;

-- 13. servicio
INSERT INTO `servicio` (`codigo_servicio`, `nombre_servicio`, `descripcion`, `precio_base`, `estado`) 
VALUES ('SERV-007', 'Fluorización Tópica', 'Aplicación de barniz de flúor preventivo', 70000.00, 'ACTIVO');
SELECT * FROM `servicio` WHERE `codigo_servicio` = 'SERV-007';
UPDATE `servicio` SET `precio_base` = 75000.00 WHERE `codigo_servicio` = 'SERV-007';
DELETE FROM `servicio` WHERE `codigo_servicio` = 'SERV-007';

-- 14. consulta_servicio
INSERT INTO `consulta_servicio` (`id_consulta`, `id_servicio`, `cantidad`, `observaciones`) VALUES (2, 2, 1, 'Profilaxis en control')
ON DUPLICATE KEY UPDATE `cantidad` = 1;
SELECT cs.`id_consulta`, s.`nombre_servicio`, cs.`cantidad`, cs.`observaciones` 
FROM `consulta_servicio` cs INNER JOIN `servicio` s ON cs.`id_servicio` = s.`id_servicio` WHERE cs.`id_consulta` = 2;
DELETE FROM `consulta_servicio` WHERE `id_consulta` = 2 AND `id_servicio` = 2;

-- 15. diente
SELECT * FROM `diente` WHERE `numero_fdi` = 11;
UPDATE `diente` SET `nombre_diente` = 'Incisivo Central Superior Derecho (Permanente)' WHERE `numero_fdi` = 11;

-- 16. odontograma
INSERT INTO `odontograma` (`id_historia`, `id_diente`, `cara_diente`, `diagnostico`, `estado_tratamiento`) 
VALUES (1, 12, 'VESTIBULAR', 'Desmineralización incipiente', 'EN_OBSERVACION');
SELECT * FROM `odontograma` WHERE `id_historia` = 1 AND `id_diente` = 12;
UPDATE `odontograma` SET `estado_tratamiento` = 'REALIZADO' WHERE `id_historia` = 1 AND `id_diente` = 12;
DELETE FROM `odontograma` WHERE `id_historia` = 1 AND `id_diente` = 12;

-- 17. metodo_pago
INSERT INTO `metodo_pago` (`nombre_metodo`, `descripcion`) VALUES ('NEQUI_QR', 'Pago digital vía QR');
SELECT * FROM `metodo_pago` WHERE `nombre_metodo` = 'NEQUI_QR';
UPDATE `metodo_pago` SET `descripcion` = 'Pago instantáneo QR Nequi / Bancolombia' WHERE `nombre_metodo` = 'NEQUI_QR';
DELETE FROM `metodo_pago` WHERE `nombre_metodo` = 'NEQUI_QR';

-- 18. venta
INSERT INTO `venta` (`id_paciente`, `id_servicio`, `monto_total`, `monto_pagado`, `modalidad_pago`, `numero_cuotas`) 
VALUES (11, 2, 120000.00, 60000.00, 'CREDITO', 2);
SELECT `id_venta`, `id_paciente`, `monto_total`, `monto_pagado`, `saldo_pendiente`, `estado_venta` FROM `venta` WHERE `id_paciente` = 11 ORDER BY `id_venta` DESC LIMIT 1;
UPDATE `venta` SET `monto_pagado` = 120000.00 WHERE `id_paciente` = 11 AND `monto_total` = 120000.00;
DELETE FROM `venta` WHERE `id_paciente` = 11 AND `monto_total` = 120000.00;

-- 19. pago_venta
INSERT INTO `pago_venta` (`id_venta`, `id_metodo`, `monto_abonado`, `numero_cuota_actual`) VALUES (1, 1, 40000.00, 2);
SELECT pv.`id_pago`, pv.`id_venta`, mp.`nombre_metodo`, pv.`monto_abonado`, pv.`fecha_pago` 
FROM `pago_venta` pv INNER JOIN `metodo_pago` mp ON pv.`id_metodo` = mp.`id_metodo` WHERE pv.`id_venta` = 1;
UPDATE `pago_venta` SET `monto_abonado` = 50000.00 WHERE `id_venta` = 1 AND `numero_cuota_actual` = 2;
DELETE FROM `pago_venta` WHERE `id_venta` = 1 AND `numero_cuota_actual` = 2;

-- 20. log_auditoria
INSERT INTO `log_auditoria` (`id_usuario`, `accion`, `tabla_afectada`, `detalles`) VALUES (1, 'UPDATE', 'usuario', 'Prueba auditoría');
SELECT * FROM `log_auditoria` ORDER BY `id_log` DESC LIMIT 5;
DELETE FROM `log_auditoria` WHERE `detalles` = 'Prueba auditoría';

-- 21. password_reset
INSERT INTO `password_reset` (`id_usuario`, `token_hash`, `expira_en`) 
VALUES (1, 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', DATE_ADD(NOW(), INTERVAL 1 HOUR));
SELECT * FROM `password_reset` WHERE `id_usuario` = 1;
UPDATE `password_reset` SET `usado_en` = NOW() WHERE `id_usuario` = 1;
DELETE FROM `password_reset` WHERE `id_usuario` = 1;