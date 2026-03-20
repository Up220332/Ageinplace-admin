import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> locales = [
  MapLocale("es", LocaleData.ES),
  MapLocale("en", LocaleData.EN),
];

mixin LocaleData {
  // Títulos y textos generales
  static const String titleCaregiver = "titleCaregiver";
  static const String body = "body";
  static const String inputEmail = "inputEmail";
  static const String inputPassword = "inputPassword";
  static const String inputLogIn = "inputLogIn";
  static const String passwordForgotten = "passwordForgotten";
  static const String es = "es";
  static const String en = "en";
  static const String passwordForgottenText1 = "passwordForgottenText1";
  static const String passwordForgottenText2 = "passwordForgottenText2";
  static const String inputSend = "inputSend";
  static const String errorField = "errorField";
  static const String logging = "logging";
  static const String errorOccurredLog = "errorOccurredLog";
  static const String errorOccurredPas = "errorOccurredPas";
  static const String sendingPassword = "sendingPassword";

  // Traducciones para Viviendas
  static const String viviendasTitulo = "viviendasTitulo";
  static const String viviendasNoHay = "viviendasNoHay";
  static const String viviendasAnade = "viviendasAnade";
  static const String viviendasAnadir = "viviendasAnadir";
  static const String viviendasInactivas = "viviendasInactivas";
  static const String viviendasDesactivarTitulo = "viviendasDesactivarTitulo";
  static const String viviendasConfirmarDesactivar =
      "viviendasConfirmarDesactivar";
  static const String viviendasCancelar = "viviendasCancelar";
  static const String viviendasDesactivar = "viviendasDesactivar";
  static const String viviendasError = "viviendasError";
  static const String viviendasErrorDesactivar = "viviendasErrorDesactivar";
  static const String viviendasOk = "viviendasOk";
  static const String viviendasSalirApp = "viviendasSalirApp";
  static const String viviendasSi = "viviendasSi";
  static const String viviendasNo = "viviendasNo";
  static const String viviendasDetalle = "viviendasDetalle";
  static const String viviendasInformacion = "viviendasInformacion";
  static const String viviendasHabitaciones = "viviendasHabitaciones";
  static const String viviendasCuidadores = "viviendasCuidadores";
  static const String viviendasPacientes = "viviendasPacientes";
  static const String viviendasSensores = "viviendasSensores";
  static const String viviendasModificar = "viviendasModificar";
  static const String viviendasDireccion = "viviendasDireccion";
  static const String viviendasPortalPuerta = "viviendasPortalPuerta";
  static const String viviendasPiso = "viviendasPiso";
  static const String viviendasLocalidad = "viviendasLocalidad";
  static const String viviendasProvincia = "viviendasProvincia";
  static const String viviendasPais = "viviendasPais";
  static const String viviendasCodigoPostal = "viviendasCodigoPostal";
  static const String viviendasCoordenadas = "viviendasCoordenadas";
  static const String viviendasPlantas = "viviendasPlantas";
  static const String viviendasFechaAlta = "viviendasFechaAlta";
  static const String viviendasInformacionCompleta =
      "viviendasInformacionCompleta";
  static const String viviendasActivo = "viviendasActivo";
  static const String viviendasInactivo = "viviendasInactivo";

  // Traducciones para NavBars
  static const String navGestionViviendas = "navGestionViviendas";
  static const String navGestionAdministradores = "navGestionAdministradores";
  static const String navGestionWearables = "navGestionWearables";
  static const String navGestionSensores = "navGestionSensores";
  static const String navGestionVariables = "navGestionVariables";
  static const String navGestionPreguntas = "navGestionPreguntas";
  static const String navVariablesSanitarias = "navVariablesSanitarias";
  static const String navVariablesSociales = "navVariablesSociales";
  static const String navTipoCuidador = "navTipoCuidador";
  static const String navTipoWearable = "navTipoWearable";
  static const String navTipoSensor = "navTipoSensor";
  static const String navTipoHabitacion = "navTipoHabitacion";
  static const String navConfigurarADLs = "navConfigurarADLs";
  static const String navListaCuidadores = "navListaCuidadores";
  static const String navListaPacientes = "navListaPacientes";
  static const String navConfiguracion = "navConfiguracion";
  static const String navCambiarContrasena = "navCambiarContrasena";
  static const String navModificarDatos = "navModificarDatos";
  static const String navCambiarIdioma = "navCambiarIdioma";
  static const String navSeleccionarIdioma = "navSeleccionarIdioma";
  static const String navCerrarSesion = "navCerrarSesion";
  static const String navConfirmarCerrarSesion = "navConfirmarCerrarSesion";
  static const String navCancelar = "navCancelar";
  static const String navSi = "navSi";

  // Traducciones para Habitaciones
  static const String habitacionesDe = "habitacionesDe";
  static const String habitacionesNoHay = "habitacionesNoHay";
  static const String habitacionesAnade = "habitacionesAnade";
  static const String habitacionesAnadir = "habitacionesAnadir";
  static const String habitacionesInactivas = "habitacionesInactivas";
  static const String habitacionesModificar = "habitacionesModificar";
  static const String habitacionesDesactivar = "habitacionesDesactivar";
  static const String habitacionesModificarTitulo =
      "habitacionesModificarTitulo";
  static const String habitacionesTipo = "habitacionesTipo";
  static const String habitacionesDescripcion = "habitacionesDescripcion";
  static const String habitacionesNumeroPlanta = "habitacionesNumeroPlanta";
  static const String habitacionesGuardarCambios = "habitacionesGuardarCambios";
  static const String habitacionesDesactivarTitulo =
      "habitacionesDesactivarTitulo";
  static const String habitacionesConfirmarDesactivar =
      "habitacionesConfirmarDesactivar";
  static const String habitacionesCancelar = "habitacionesCancelar";
  static const String habitacionesError = "habitacionesError";
  static const String habitacionesErrorDesactivar =
      "habitacionesErrorDesactivar";
  static const String habitacionesAceptar = "habitacionesAceptar";
  static const String habitacionesPlanta = "habitacionesPlanta";
  static const String campoObligatorio = "campoObligatorio";
  static const String soloNumeros = "soloNumeros";

  // Traducciones para Nueva Habitación
  static const String nuevaHabitacionTitulo = "nuevaHabitacionTitulo";
  static const String nuevaHabitacionHeader = "nuevaHabitacionHeader";
  static const String nuevaHabitacionInfo = "nuevaHabitacionInfo";
  static const String nuevaHabitacionTipo = "nuevaHabitacionTipo";
  static const String nuevaHabitacionSeleccioneTipo =
      "nuevaHabitacionSeleccioneTipo";
  static const String nuevaHabitacionDescripcion = "nuevaHabitacionDescripcion";
  static const String nuevaHabitacionNumeroPlanta =
      "nuevaHabitacionNumeroPlanta";
  static const String nuevaHabitacionCrear = "nuevaHabitacionCrear";
  static const String nuevaHabitacionExito = "nuevaHabitacionExito";
  static const String nuevaHabitacionCreada = "nuevaHabitacionCreada";
  static const String nuevaHabitacionError = "nuevaHabitacionError";
  static const String nuevaHabitacionErrorCrear = "nuevaHabitacionErrorCrear";
  static const String nuevaHabitacionAceptar = "nuevaHabitacionAceptar";

  // Traducciones para Habitaciones Inactivas
  static const String habitacionesInactivasTitulo =
      "habitacionesInactivasTitulo";
  static const String habitacionesInactivasNoHay = "habitacionesInactivasNoHay";
  static const String habitacionesInactivasDescripcion =
      "habitacionesInactivasDescripcion";
  static const String habitacionesInactiva = "habitacionesInactiva";
  static const String habitacionesFechaBaja = "habitacionesFechaBaja";
  static const String habitacionesActivarTitulo = "habitacionesActivarTitulo";
  static const String habitacionesConfirmarActivar =
      "habitacionesConfirmarActivar";
  static const String habitacionesActivar = "habitacionesActivar";
  static const String habitacionesErrorActivar = "habitacionesErrorActivar";

  // Traducciones para Administradores
  static const String adminTitulo = "adminTitulo";
  static const String adminNoHayActivos = "adminNoHayActivos";
  static const String adminAnade = "adminAnade";
  static const String adminAgregar = "adminAgregar";
  static const String adminInactivos = "adminInactivos";
  static const String adminActivo = "adminActivo";
  static const String adminInactivo = "adminInactivo";
  static const String adminEmail = "adminEmail";
  static const String adminTelefono = "adminTelefono";
  static const String adminFechaNacimiento = "adminFechaNacimiento";
  static const String adminFechaAlta = "adminFechaAlta";
  static const String adminFechaBaja = "adminFechaBaja";
  static const String adminOrganizacion = "adminOrganizacion";
  static const String adminEstado = "adminEstado";
  static const String adminDesactivar = "adminDesactivar";
  static const String adminActivar = "adminActivar";
  static const String adminModificar = "adminModificar";
  static const String adminInactivosTitulo = "adminInactivosTitulo";
  static const String adminNoHayInactivos = "adminNoHayInactivos";
  static const String adminInactivosDescripcion = "adminInactivosDescripcion";
  static const String adminActivarAdministrador = "adminActivarAdministrador";

  // Traducciones para Nuevo Administrador
  static const String newAdminTitulo = "newAdminTitulo";
  static const String newAdminHeader = "newAdminHeader";
  static const String newAdminInfoPersonal = "newAdminInfoPersonal";
  static const String newAdminNombre = "newAdminNombre";
  static const String newAdminPrimerApellido = "newAdminPrimerApellido";
  static const String newAdminSegundoApellido = "newAdminSegundoApellido";
  static const String newAdminFechaNacimiento = "newAdminFechaNacimiento";
  static const String newAdminInfoContacto = "newAdminInfoContacto";
  static const String newAdminEmail = "newAdminEmail";
  static const String newAdminEmailInvalido = "newAdminEmailInvalido";
  static const String newAdminTelefono = "newAdminTelefono";
  static const String newAdminTelefonoInvalido = "newAdminTelefonoInvalido";
  static const String newAdminBuscar = "newAdminBuscar";
  static const String newAdminInfoAdicional = "newAdminInfoAdicional";
  static const String newAdminOrganizacion = "newAdminOrganizacion";
  static const String newAdminContinuar = "newAdminContinuar";
  static const String newAdminCompletarCampos = "newAdminCompletarCampos";
  static const String newAdminError = "newAdminError";
  static const String newAdminExito = "newAdminExito";
  static const String newAdminCorreoEnviado = "newAdminCorreoEnviado";
  static const String newAdminAceptar = "newAdminAceptar";
  static const String newAdminEmailRegistrado = "newAdminEmailRegistrado";
  static const String newAdminErrorCrear = "newAdminErrorCrear";
  static const String newAdminMenorEdad = "newAdminMenorEdad";
  static const String newAdminMenorEdadMsg = "newAdminMenorEdadMsg";
  static const String newAdminCerrar = "newAdminCerrar";

  // Traducciones para Wearables
  static const String wearablesTitulo = "wearablesTitulo";
  static const String wearablesNoHay = "wearablesNoHay";
  static const String wearablesAnade = "wearablesAnade";
  static const String wearablesAnadir = "wearablesAnadir";
  static const String wearablesAnadirTitulo = "wearablesAnadirTitulo";
  static const String wearablesModificar = "wearablesModificar";
  static const String wearablesModificarTitulo = "wearablesModificarTitulo";
  static const String wearablesDesactivar = "wearablesDesactivar";
  static const String wearablesDesactivarTitulo = "wearablesDesactivarTitulo";
  static const String wearablesConfirmarDesactivar =
      "wearablesConfirmarDesactivar";
  static const String wearablesCancelar = "wearablesCancelar";
  static const String wearablesError = "wearablesError";
  static const String wearablesErrorDesactivar = "wearablesErrorDesactivar";
  static const String wearablesExito = "wearablesExito";
  static const String wearablesAceptar = "wearablesAceptar";
  static const String wearablesExistente = "wearablesExistente";
  static const String wearablesONuevo = "wearablesONuevo";
  static const String wearablesSeleccionar = "wearablesSeleccionar";
  static const String wearablesId = "wearablesId";
  static const String wearablesTipo = "wearablesTipo";
  static const String wearablesContinuar = "wearablesContinuar";
  static const String wearablesGuardarCambios = "wearablesGuardarCambios";
  static const String wearablesRellenarCampos = "wearablesRellenarCampos";
  static const String wearablesSeleccionarUnaOp = "wearablesSeleccionarUnaOp";
  static const String wearablesSeleccionarTipo = "wearablesSeleccionarTipo";
  static const String wearablesSeleccionarOpcion = "wearablesSeleccionarOpcion";
  static const String wearablesOtros = "wearablesOtros";
  static const String wearablesEspecifiqueTipo = "wearablesEspecifiqueTipo";
  static const String wearablesAnadido = "wearablesAñadido";
  static const String wearablesYaExiste = "wearablesYaExiste";
  static const String wearablesYaAsignado = "wearablesYaAsignado";

  // Traducciones para Pacientes
  static const String pacientesDeLaVivienda = "pacientesDeLaVivienda";
  static const String pacientesNoHayEnVivienda = "pacientesNoHayEnVivienda";
  static const String pacientesAnadeConBoton = "pacientesAnadeConBoton";
  static const String pacientesAnadirTitulo = "pacientesAnadirTitulo";
  static const String pacientesAnadirOpcion = "pacientesAnadirOpcion";
  static const String pacientesAnadir = "pacientesAnadir";
  static const String pacientesNuevo = "pacientesNuevo";
  static const String pacientesExistente = "pacientesExistente";
  static const String pacientesActivo = "pacientesActivo";
  static const String pacientesInactivo = "pacientesInactivo";
  static const String pacientesDesactivarTitulo = "pacientesDesactivarTitulo";
  static const String pacientesConfirmarDesactivar =
      "pacientesConfirmarDesactivar";
  static const String pacientesCancelar = "pacientesCancelar";
  static const String pacientesDesactivar = "pacientesDesactivar";
  static const String pacientesError = "pacientesError";
  static const String pacientesErrorDesactivar = "pacientesErrorDesactivar";
  static const String pacientesOk = "pacientesOk";
  static const String pacienteInfoPersonal = "pacienteInfoPersonal";
  static const String pacienteEmail = "pacienteEmail";
  static const String pacienteTelefono = "pacienteTelefono";
  static const String pacienteNacimiento = "pacienteNacimiento";
  static const String pacientePatologia = "pacientePatologia";
  static const String pacienteAutonomia = "pacienteAutonomia";
  static const String pacienteEstado = "pacienteEstado";
  static const String pacienteDispositivos = "pacienteDispositivos";
  static const String pacienteEditar = "pacienteEditar";
  static const String pacienteInfoCompleta = "pacienteInfoCompleta";

  // Traducciones para Modificar Paciente
  static const String modPacienteTitulo = "modPacienteTitulo";
  static const String modPacienteHeader = "modPacienteHeader";
  static const String modPacienteInfoPersonal = "modPacienteInfoPersonal";
  static const String modPacienteNombre = "modPacienteNombre";
  static const String modPacientePrimerApellido = "modPacientePrimerApellido";
  static const String modPacienteSegundoApellido = "modPacienteSegundoApellido";
  static const String modPacienteFechaNacimiento = "modPacienteFechaNacimiento";
  static const String modPacienteInfoContacto = "modPacienteInfoContacto";
  static const String modPacienteEmail = "modPacienteEmail";
  static const String modPacienteEmailInvalido = "modPacienteEmailInvalido";
  static const String modPacienteTelefono = "modPacienteTelefono";
  static const String modPacienteTelefonoInvalido =
      "modPacienteTelefonoInvalido";
  static const String modPacienteBuscar = "modPacienteBuscar";
  static const String modPacienteOrganizacion = "modPacienteOrganizacion";
  static const String modPacienteVariables = "modPacienteVariables";
  static const String modPacienteVariablesSociales =
      "modPacienteVariablesSociales";
  static const String modPacienteVariablesSanitarias =
      "modPacienteVariablesSanitarias";
  static const String modPacienteGuardar = "modPacienteGuardar";
  static const String modPacienteError = "modPacienteError";
  static const String modPacienteExito = "modPacienteExito";
  static const String modPacienteModificado = "modPacienteModificado";
  static const String modPacienteAceptar = "modPacienteAceptar";
  static const String modPacienteEmailRegistrado = "modPacienteEmailRegistrado";
  static const String modPacienteErrorModificar = "modPacienteErrorModificar";
  static const String modPacientePatologia = "modPacientePatologia";
  static const String modPacienteEspecifiquePatologia =
      "modPacienteEspecifiquePatologia";
  static const String modPacienteVariableSocial = "modPacienteVariableSocial";
  static const String modPacienteEspecifiqueVariable =
      "modPacienteEspecifiqueVariable";

  // Traducciones para Modificar Vivienda
  static const String modViviendaTitulo = "modViviendaTitulo";
  static const String modViviendaUbicacion = "modViviendaUbicacion";
  static const String modViviendaDireccion = "modViviendaDireccion";
  static const String modViviendaNumero = "modViviendaNumero";
  static const String modViviendaPiso = "modViviendaPiso";
  static const String modViviendaPuerta = "modViviendaPuerta";
  static const String modViviendaLocalizacion = "modViviendaLocalizacion";
  static const String modViviendaLocalidad = "modViviendaLocalidad";
  static const String modViviendaProvincia = "modViviendaProvincia";
  static const String modViviendaPais = "modViviendaPais";
  static const String modViviendaCodigoPostal = "modViviendaCodigoPostal";
  static const String modViviendaAdicional = "modViviendaAdicional";
  static const String modViviendaNumeroPlantas = "modViviendaNumeroPlantas";
  static const String modViviendaLatitud = "modViviendaLatitud";
  static const String modViviendaLongitud = "modViviendaLongitud";
  static const String modViviendaGuardar = "modViviendaGuardar";
  static const String modViviendaExito = "modViviendaExito";
  static const String modViviendaModificada = "modViviendaModificada";
  static const String modViviendaError = "modViviendaError";
  static const String modViviendaAceptar = "modViviendaAceptar";
  static const String modViviendaDuplicada = "modViviendaDuplicada";
  static const String modViviendaCompletarCampos = "modViviendaCompletarCampos";
  static const String soloNumerosPunto = "soloNumerosPunto";

  static const String pacientetitulo = "pacientetitulo";

  // Traducciones para Cuidadores
  static const String cuidadoresDe = "cuidadoresDe";
  static const String cuidadoresNoHay = "cuidadoresNoHay";
  static const String cuidadoresAnade = "cuidadoresAnade";
  static const String cuidadoresAnadir = "cuidadoresAnadir";
  static const String cuidadoresAnadirTitulo = "cuidadoresAnadirTitulo";
  static const String cuidadoresAnadirOpcion = "cuidadoresAnadirOpcion";
  static const String cuidadoresNuevo = "cuidadoresNuevo";
  static const String cuidadoresExistente = "cuidadoresExistente";
  static const String cuidadoresActivo = "cuidadoresActivo";
  static const String cuidadoresInactivo = "cuidadoresInactivo";
  static const String cuidadoresEmail = "cuidadoresEmail";
  static const String cuidadoresTelefono = "cuidadoresTelefono";
  static const String cuidadoresFechaNacimiento = "cuidadoresFechaNacimiento";
  static const String cuidadoresParentesco = "cuidadoresParentesco";
  static const String cuidadoresOrganizacion = "cuidadoresOrganizacion";
  static const String cuidadoresEstado = "cuidadoresEstado";
  static const String cuidadoresDeshabilitar = "cuidadoresDeshabilitar";
  static const String cuidadoresEditar = "cuidadoresEditar";

  // Traducciones para Nuevo Cuidador
  static const String newCuidadorTitulo = "newCuidadorTitulo";
  static const String newCuidadorHeader = "newCuidadorHeader";
  static const String newCuidadorInfoPersonal = "newCuidadorInfoPersonal";
  static const String newCuidadorNombre = "newCuidadorNombre";
  static const String newCuidadorPrimerApellido = "newCuidadorPrimerApellido";
  static const String newCuidadorSegundoApellido = "newCuidadorSegundoApellido";
  static const String newCuidadorFechaNacimiento = "newCuidadorFechaNacimiento";
  static const String newCuidadorInfoContacto = "newCuidadorInfoContacto";
  static const String newCuidadorEmail = "newCuidadorEmail";
  static const String newCuidadorEmailInvalido = "newCuidadorEmailInvalido";
  static const String newCuidadorTelefono = "newCuidadorTelefono";
  static const String newCuidadorTelefonoInvalido =
      "newCuidadorTelefonoInvalido";
  static const String newCuidadorBuscar = "newCuidadorBuscar";
  static const String newCuidadorOrganizacion = "newCuidadorOrganizacion";
  static const String newCuidadorInfoCuidador = "newCuidadorInfoCuidador";
  static const String newCuidadorTipo = "newCuidadorTipo";
  static const String newCuidadorSeleccioneTipo = "newCuidadorSeleccioneTipo";
  static const String newCuidadorCrear = "newCuidadorCrear";
  static const String newCuidadorOtros = "newCuidadorOtros";
  static const String newCuidadorEspecifiqueParentesco =
      "newCuidadorEspecifiqueParentesco";
  static const String newCuidadorExito = "newCuidadorExito";
  static const String newCuidadorCreado = "newCuidadorCreado";
  static const String newCuidadorError = "newCuidadorError";
  static const String newCuidadorAceptar = "newCuidadorAceptar";
  static const String newCuidadorEmailRegistrado = "newCuidadorEmailRegistrado";
  static const String newCuidadorErrorCrear = "newCuidadorErrorCrear";
  static const String newCuidadorMenorEdad = "newCuidadorMenorEdad";
  static const String newCuidadorMenorEdadMsg = "newCuidadorMenorEdadMsg";
  static const String newCuidadorCerrar = "newCuidadorCerrar";

  // TIPOS DE CUIDADOR (para traducción de valores)
  static const String cuidadorFormal = "Cuidador Formal";
  static const String responsableSanitario = "Responsable Sanitario";
  static const String familiar = "Familiar";
  static const String vecino = "Vecino";
  static const String amigo = "Amigo";
  static const String voluntario = "Voluntario";
  static const String otros = "Otros";


  static const String viviendasActivar = 'viviendasActivar';
  static const String viviendasSeguroActivar = 'viviendasSeguroActivar';
  static const String viviendasConfirmarActivar = 'viviendasConfirmarActivar';


  static const Map<String, dynamic> ES = {
    // Títulos y textos generales
    pacientetitulo: 'Paciente',
    titleCaregiver: 'Pacientes',
    body: 'Bienvenido! Es un gusto volver a verte',
    inputEmail: 'Correo electrónico',
    inputPassword: 'Contraseña',
    inputLogIn: 'Iniciar sesión',
    passwordForgotten: '¿Ha olvidado su contraseña?',
    es: 'Español',
    en: 'Inglés',
    passwordForgottenText1: 'Introduzca su correo electrónico',
    passwordForgottenText2: 'Se le enviará un correo con su contraseña',
    inputSend: 'Enviar',
    errorField: 'El campo no puede estar vacío',
    logging: 'Iniciando sesión...',
    errorOccurredLog: 'Correo o contraseña incorrecta. Intenta de nuevo',
    sendingPassword: 'Enviando contraseña al correo...',
    errorOccurredPas: 'Correo incorrecto. Intenta de nuevo',

    // Traducciones para Viviendas
    viviendasTitulo: 'Viviendas',
    viviendasNoHay: 'No hay viviendas registradas',
    viviendasAnade: 'Añade viviendas usando el botón +',
    viviendasAnadir: 'Añadir Vivienda',
    viviendasInactivas: 'Viviendas Inactivas',
    viviendasDesactivarTitulo: '¿Desactivar vivienda?',
    viviendasConfirmarDesactivar:
        '¿Está seguro que desea desactivar la vivienda en {direccion}?',
    viviendasCancelar: 'Cancelar',
    viviendasDesactivar: 'Desactivar',
    viviendasError: 'Error',
    viviendasErrorDesactivar: 'Algo salió mal al desactivar la vivienda',
    viviendasOk: 'OK',
    viviendasSalirApp: '¿Salir de la aplicación?',
    viviendasSi: 'Sí',
    viviendasNo: 'No',
    viviendasDetalle: 'Detalle de la Vivienda',
    viviendasInformacion: 'Información de la Vivienda',
    viviendasHabitaciones: 'Habitaciones',
    viviendasCuidadores: 'Cuidadores',
    viviendasPacientes: 'Pacientes',
    viviendasSensores: 'Sensores',
    viviendasModificar: 'Modificar Vivienda',
    viviendasDireccion: 'Dirección',
    viviendasPortalPuerta: 'Portal/Puerta',
    viviendasPiso: 'Piso',
    viviendasLocalidad: 'Localidad',
    viviendasProvincia: 'Provincia',
    viviendasPais: 'País',
    viviendasCodigoPostal: 'Código Postal',
    viviendasCoordenadas: 'Coordenadas',
    viviendasPlantas: 'Plantas',
    viviendasFechaAlta: 'Fecha de alta',
    viviendasInformacionCompleta: 'INFORMACIÓN DE LA VIVIENDA',
    viviendasActivo: 'Activo',
    viviendasInactivo: 'Inactivo',

    // Traducciones para NavBars
    navGestionViviendas: 'Gestión de Viviendas',
    navGestionAdministradores: 'Gestión de Administradores',
    navGestionWearables: 'Gestión de Wearables',
    navGestionSensores: 'Gestión de Sensores',
    navGestionVariables: 'Gestión de Variables',
    navGestionPreguntas: 'Gestión de preguntas',
    navVariablesSanitarias: 'Variables Sanitarias',
    navVariablesSociales: 'Variables Sociales',
    navTipoCuidador: 'Tipo de Cuidador',
    navTipoWearable: 'Tipo de Wearable',
    navTipoSensor: 'Tipo de Sensor',
    navTipoHabitacion: 'Tipo de Habitación',
    navConfigurarADLs: 'Configurar Duración de ADLs',
    navListaCuidadores: 'Lista de Cuidadores',
    navListaPacientes: 'Lista de Pacientes',
    navConfiguracion: 'Configuración',
    navCambiarContrasena: 'Cambiar contraseña',
    navModificarDatos: 'Modificar Datos',
    navCambiarIdioma: 'Cambiar Idioma',
    navSeleccionarIdioma: 'Seleccionar idioma',
    navCerrarSesion: 'Cerrar sesión',
    navConfirmarCerrarSesion: '¿Estás seguro de que deseas cerrar sesión?',
    navCancelar: 'Cancelar',
    navSi: 'Sí',

    // Traducciones para Habitaciones
    habitacionesDe: 'Habitaciones de',
    habitacionesNoHay: 'No hay habitaciones en esta vivienda',
    habitacionesAnade: 'Añade habitaciones usando el botón +',
    habitacionesAnadir: 'Añadir Habitación',
    habitacionesInactivas: 'Habitaciones Inactivas',
    habitacionesModificar: 'Modificar',
    habitacionesDesactivar: 'Desactivar',
    habitacionesModificarTitulo: 'Modificar Habitación',
    habitacionesTipo: 'Tipo de habitación',
    habitacionesDescripcion: 'Descripción',
    habitacionesNumeroPlanta: 'Número de Planta',
    habitacionesGuardarCambios: 'Guardar Cambios',
    habitacionesDesactivarTitulo: '¿Desactivar habitación?',
    habitacionesConfirmarDesactivar:
        '¿Está seguro que desea desactivar la habitación "{tipo}"?',
    habitacionesCancelar: 'Cancelar',
    habitacionesError: 'Error',
    habitacionesErrorDesactivar: 'Error al desactivar la habitación',
    habitacionesAceptar: 'Aceptar',
    habitacionesPlanta: 'Planta',
    campoObligatorio: 'Campo obligatorio',
    soloNumeros: 'Solo números',

    // Traducciones para Nueva Habitación
    nuevaHabitacionTitulo: 'Nueva Habitación',
    nuevaHabitacionHeader:
        'Complete los campos obligatorios (*) para añadir una nueva habitación',
    nuevaHabitacionInfo: 'INFORMACIÓN DE LA HABITACIÓN',
    nuevaHabitacionTipo: 'Tipo de habitación *',
    nuevaHabitacionSeleccioneTipo: 'Seleccione un tipo de habitación',
    nuevaHabitacionDescripcion: 'Descripción de la habitación *',
    nuevaHabitacionNumeroPlanta: 'Número de Planta *',
    nuevaHabitacionCrear: 'Crear Habitación',
    nuevaHabitacionExito: '¡Éxito!',
    nuevaHabitacionCreada: 'La habitación se ha creado correctamente',
    nuevaHabitacionError: 'Error',
    nuevaHabitacionErrorCrear: 'Error al crear la habitación',
    nuevaHabitacionAceptar: 'Aceptar',

    // Traducciones para Habitaciones Inactivas
    habitacionesInactivasTitulo: 'Habitaciones Inactivas',
    habitacionesInactivasNoHay: 'No hay habitaciones inactivas',
    habitacionesInactivasDescripcion:
        'Las habitaciones desactivadas aparecerán aquí',
    habitacionesInactiva: 'Inactiva',
    habitacionesFechaBaja: 'Baja',
    habitacionesActivarTitulo: '¿Activar habitación?',
    habitacionesConfirmarActivar:
        '¿Está seguro que desea activar la habitación "{tipo}"?',
    habitacionesActivar: 'Activar',
    habitacionesErrorActivar: 'Error al activar la habitación',

    // Traducciones para Administradores
    adminTitulo: 'Administradores',
    adminNoHayActivos: 'No hay administradores activos',
    adminAnade: 'Añade administradores usando el botón +',
    adminAgregar: 'Agregar administrador',
    adminInactivos: 'Administradores Inactivos',
    adminActivo: 'Activo',
    adminInactivo: 'Inactivo',
    adminEmail: 'Correo electrónico',
    adminTelefono: 'Teléfono',
    adminFechaNacimiento: 'Fecha de nacimiento',
    adminFechaAlta: 'Fecha de alta',
    adminFechaBaja: 'Fecha de baja',
    adminOrganizacion: 'Organización',
    adminEstado: 'Estado',
    adminDesactivar: 'Desactivar',
    adminActivar: 'Activar',
    adminModificar: 'Modificar',
    adminInactivosTitulo: 'Administradores Inactivos',
    adminNoHayInactivos: 'No hay administradores inactivos',
    adminInactivosDescripcion:
        'Los administradores desactivados aparecerán aquí',
    adminActivarAdministrador: 'Activar Administrador',

    // Traducciones para Nuevo Administrador
    newAdminTitulo: 'Nuevo Administrador',
    newAdminHeader:
        'Complete los campos obligatorios (*) para registrar un nuevo administrador',
    newAdminInfoPersonal: 'INFORMACIÓN PERSONAL',
    newAdminNombre: 'Nombre',
    newAdminPrimerApellido: 'Primer Apellido',
    newAdminSegundoApellido: 'Segundo Apellido',
    newAdminFechaNacimiento: 'Fecha de nacimiento',
    newAdminInfoContacto: 'INFORMACIÓN DE CONTACTO',
    newAdminEmail: 'Correo electrónico',
    newAdminEmailInvalido: 'Email inválido',
    newAdminTelefono: 'Teléfono',
    newAdminTelefonoInvalido: 'Número de teléfono inválido',
    newAdminBuscar: 'Buscar',
    newAdminInfoAdicional: 'INFORMACIÓN ADICIONAL',
    newAdminOrganizacion: 'Organización',
    newAdminContinuar: 'Continuar',
    newAdminCompletarCampos:
        'Por favor, complete todos los campos obligatorios',
    newAdminError: 'Error',
    newAdminExito: 'Éxito',
    newAdminCorreoEnviado:
        'Administrador creado correctamente. Se ha enviado un correo a {email}',
    newAdminAceptar: 'Aceptar',
    newAdminEmailRegistrado: 'El correo electrónico ya está registrado',
    newAdminErrorCrear: 'Error al crear el administrador',
    newAdminMenorEdad: 'Menor de edad',
    newAdminMenorEdadMsg: 'El administrador debe ser mayor de 18 años',
    newAdminCerrar: 'Cerrar',

    // Traducciones para Wearables
    wearablesTitulo: 'Wearables del Paciente',
    wearablesNoHay: 'No hay wearables asignados',
    wearablesAnade: 'Añade wearables usando el botón +',
    wearablesAnadir: 'Añadir Wearable',
    wearablesAnadirTitulo: 'Añadir Wearable',
    wearablesModificar: 'Modificar',
    wearablesModificarTitulo: 'Modificar Wearable',
    wearablesDesactivar: 'Desactivar',
    wearablesDesactivarTitulo: '¿Desactivar wearable?',
    wearablesConfirmarDesactivar:
        '¿Está seguro que desea desactivar el wearable {id}?',
    wearablesCancelar: 'Cancelar',
    wearablesError: 'Error',
    wearablesErrorDesactivar: 'Error al desactivar el wearable',
    wearablesExito: 'Éxito',
    wearablesAceptar: 'Aceptar',
    wearablesExistente: 'Wearable Existente',
    wearablesONuevo: 'O Nuevo Wearable',
    wearablesSeleccionar: 'Seleccionar wearable',
    wearablesId: 'ID del Wearable',
    wearablesTipo: 'Tipo de Wearable',
    wearablesContinuar: 'Continuar',
    wearablesGuardarCambios: 'Guardar Cambios',
    wearablesRellenarCampos: 'Por favor, rellene todos los campos',
    wearablesSeleccionarUnaOp: 'Seleccione solo una opción',
    wearablesSeleccionarTipo: 'Seleccione el tipo de wearable',
    wearablesSeleccionarOpcion:
        'Seleccione un wearable existente o cree uno nuevo',
    wearablesOtros: 'Otros',
    wearablesEspecifiqueTipo: 'Especifique el tipo',
    wearablesAnadido: 'Wearable añadido correctamente',
    wearablesYaExiste: 'El wearable ya existe',
    wearablesYaAsignado: 'Este wearable ya está asignado',

    // Traducciones para Pacientes
    pacientesDeLaVivienda: 'Pacientes de la vivienda',
    pacientesNoHayEnVivienda: 'No hay pacientes en esta vivienda',
    pacientesAnadeConBoton: 'Añade pacientes usando el botón +',
    pacientesAnadirTitulo: 'Añadir Paciente',
    pacientesAnadirOpcion: '¿Desea añadir un nuevo paciente o existente?',
    pacientesAnadir: 'Añadir Pacientes',
    pacientesNuevo: 'Nuevo',
    pacientesExistente: 'Existente',
    pacientesActivo: 'Activo',
    pacientesInactivo: 'Inactivo',
    pacientesDesactivarTitulo: '¿Desactivar paciente?',
    pacientesConfirmarDesactivar:
        '¿Está seguro que desea desactivar a',
    pacientesCancelar: 'Cancelar',
    pacientesDesactivar: 'Desactivar',
    pacientesError: 'Error',
    pacientesErrorDesactivar: 'Error al desactivar el paciente',
    pacientesOk: 'OK',
    pacienteInfoPersonal: 'Información Personal',
    pacienteEmail: 'Email',
    pacienteTelefono: 'Teléfono',
    pacienteNacimiento: 'Nacimiento',
    pacientePatologia: 'Patología',
    pacienteAutonomia: 'Autonomía',
    pacienteEstado: 'Estado',
    pacienteDispositivos: 'Dispositivos',
    pacienteEditar: 'Editar Paciente',
    pacienteInfoCompleta: 'INFORMACIÓN DEL PACIENTE',

    // Traducciones para Modificar Paciente
    modPacienteTitulo: 'Modificar Paciente',
    modPacienteHeader: 'Modifique los datos del paciente de esta vivienda',
    modPacienteInfoPersonal: 'INFORMACIÓN PERSONAL',
    modPacienteNombre: 'Nombre',
    modPacientePrimerApellido: 'Primer Apellido',
    modPacienteSegundoApellido: 'Segundo Apellido',
    modPacienteFechaNacimiento: 'Fecha de nacimiento *',
    modPacienteInfoContacto: 'INFORMACIÓN DE CONTACTO',
    modPacienteEmail: 'Correo electrónico',
    modPacienteEmailInvalido: 'Email inválido',
    modPacienteTelefono: 'Teléfono',
    modPacienteTelefonoInvalido: 'Número de teléfono inválido',
    modPacienteBuscar: 'Buscar',
    modPacienteOrganizacion: 'Organización',
    modPacienteVariables: 'VARIABLES DEL PACIENTE',
    modPacienteVariablesSociales: 'Variables Sociales',
    modPacienteVariablesSanitarias: 'Variables Sanitarias',
    modPacienteGuardar: 'Guardar Cambios',
    modPacienteError: 'Error',
    modPacienteExito: 'Éxito',
    modPacienteModificado: 'Paciente modificado correctamente',
    modPacienteAceptar: 'Aceptar',
    modPacienteEmailRegistrado: 'El correo electrónico ya está registrado',
    modPacienteErrorModificar: 'Error al modificar el paciente',
    modPacientePatologia: 'Patología',
    modPacienteEspecifiquePatologia: 'Especifique la patología',
    modPacienteVariableSocial: 'Variable Social',
    modPacienteEspecifiqueVariable: 'Especifique la variable social',

    // Traducciones para Modificar Vivienda
    modViviendaTitulo: 'Modificar Vivienda',
    modViviendaUbicacion: 'UBICACIÓN',
    modViviendaDireccion: 'Dirección',
    modViviendaNumero: 'Número',
    modViviendaPiso: 'Piso',
    modViviendaPuerta: 'Puerta',
    modViviendaLocalizacion: 'LOCALIZACIÓN',
    modViviendaLocalidad: 'Localidad',
    modViviendaProvincia: 'Provincia',
    modViviendaPais: 'País',
    modViviendaCodigoPostal: 'Código Postal',
    modViviendaAdicional: 'INFORMACIÓN ADICIONAL',
    modViviendaNumeroPlantas: 'Número de Plantas',
    modViviendaLatitud: 'Latitud',
    modViviendaLongitud: 'Longitud',
    modViviendaGuardar: 'Guardar Cambios',
    modViviendaExito: '¡Éxito!',
    modViviendaModificada: 'La vivienda se ha modificado correctamente',
    modViviendaError: 'Error',
    modViviendaAceptar: 'Aceptar',
    modViviendaDuplicada: 'Ya existe una vivienda con esa dirección',
    modViviendaCompletarCampos:
        'Por favor, completa todos los campos obligatorios',
    soloNumerosPunto: 'Solo números y punto',

    // Traducciones para Cuidadores
    cuidadoresDe: 'Cuidadores de',
    cuidadoresNoHay: 'No hay cuidadores en esta vivienda',
    cuidadoresAnade: 'Añade cuidadores usando el botón +',
    cuidadoresAnadir: 'Añadir cuidadores',
    cuidadoresAnadirTitulo: 'Añadir Cuidador',
    cuidadoresAnadirOpcion: '¿Desea añadir un nuevo cuidador o existente?',
    cuidadoresNuevo: 'Nuevo',
    cuidadoresExistente: 'Existente',
    cuidadoresActivo: 'Activo',
    cuidadoresInactivo: 'Inactivo',
    cuidadoresEmail: 'Correo electrónico',
    cuidadoresTelefono: 'Teléfono',
    cuidadoresFechaNacimiento: 'Fecha de nacimiento',
    cuidadoresParentesco: 'Parentesco',
    cuidadoresOrganizacion: 'Organización',
    cuidadoresEstado: 'Estado',
    cuidadoresDeshabilitar: 'Deshabilitar',
    cuidadoresEditar: 'Editar',

    // Traducciones para Nuevo Cuidador
    newCuidadorTitulo: 'Nuevo Cuidador',
    newCuidadorHeader:
        'Complete los campos obligatorios (*) para añadir un nuevo cuidador a la vivienda',
    newCuidadorInfoPersonal: 'INFORMACIÓN PERSONAL',
    newCuidadorNombre: 'Nombre',
    newCuidadorPrimerApellido: 'Primer Apellido',
    newCuidadorSegundoApellido: 'Segundo Apellido',
    newCuidadorFechaNacimiento: 'Fecha de nacimiento *',
    newCuidadorInfoContacto: 'INFORMACIÓN DE CONTACTO',
    newCuidadorEmail: 'Correo electrónico',
    newCuidadorEmailInvalido: 'Email inválido',
    newCuidadorTelefono: 'Teléfono',
    newCuidadorTelefonoInvalido: 'Número de teléfono inválido',
    newCuidadorBuscar: 'Buscar',
    newCuidadorOrganizacion: 'Organización',
    newCuidadorInfoCuidador: 'INFORMACIÓN DEL CUIDADOR',
    newCuidadorTipo: 'Tipo de Cuidador *',
    newCuidadorSeleccioneTipo: 'Seleccione un tipo de cuidador',
    newCuidadorCrear: 'Crear Cuidador',
    newCuidadorOtros: 'Otros',
    newCuidadorEspecifiqueParentesco: 'Especifique el parentesco',
    newCuidadorExito: 'Éxito',
    newCuidadorCreado: 'Cuidador creado correctamente',
    newCuidadorError: 'Error',
    newCuidadorAceptar: 'Aceptar',
    newCuidadorEmailRegistrado: 'El correo electrónico ya está registrado',
    newCuidadorErrorCrear: 'Error al crear el cuidador',
    newCuidadorMenorEdad: 'Menor de edad',
    newCuidadorMenorEdadMsg: 'El cuidador debe ser mayor de 18 años',
    newCuidadorCerrar: 'Cerrar',


    viviendasActivar: 'Activar Vivienda',
    viviendasSeguroActivar:'¿Estás seguro de que deseas activar la vivienda en',
    viviendasConfirmarActivar: 'Activar',
  };

  static const Map<String, dynamic> EN = {
    // Existing translations (login)
    pacientetitulo: 'Patient',
    titleCaregiver: 'Patients',
    body: 'Welcome back! Nice to see you again',
    inputEmail: 'Email',
    inputPassword: 'Password',
    inputLogIn: 'Sign in',
    passwordForgotten: 'Forgot your password?',
    es: 'Spanish',
    en: 'English',
    passwordForgottenText1: 'Enter your email address',
    passwordForgottenText2: 'An email will be sent to you with your password',
    inputSend: 'Send',
    errorField: 'The field cannot be empty',
    logging: 'Logging in...',
    errorOccurredLog: 'Incorrect email or password. Please try again',
    sendingPassword: 'Sending password to email...',
    errorOccurredPas: 'Incorrect email. Please try again',

    // Translations for Houses
    viviendasTitulo: 'Houses',
    viviendasNoHay: 'No houses registered',
    viviendasAnade: 'Add houses using the + button',
    viviendasAnadir: 'Add House',
    viviendasInactivas: 'Inactive Houses',
    viviendasDesactivarTitulo: 'Deactivate house?',
    viviendasConfirmarDesactivar:
        'Are you sure you want to deactivate the house at {direccion}?',
    viviendasCancelar: 'Cancel',
    viviendasDesactivar: 'Deactivate',
    viviendasError: 'Error',
    viviendasErrorDesactivar: 'Something went wrong deactivating the house',
    viviendasOk: 'OK',
    viviendasSalirApp: 'Exit application?',
    viviendasSi: 'Yes',
    viviendasNo: 'No',
    viviendasDetalle: 'House Details',
    viviendasInformacion: 'House Information',
    viviendasHabitaciones: 'Rooms',
    viviendasCuidadores: 'Caregivers',
    viviendasPacientes: 'Patients',
    viviendasSensores: 'Sensors',
    viviendasModificar: 'Modify House',
    viviendasDireccion: 'Address',
    viviendasPortalPuerta: 'Door/Entrance',
    viviendasPiso: 'Floor',
    viviendasLocalidad: 'City/Locality',
    viviendasProvincia: 'Province',
    viviendasPais: 'Country',
    viviendasCodigoPostal: 'Postal Code',
    viviendasCoordenadas: 'Coordinates',
    viviendasPlantas: 'Floors',
    viviendasFechaAlta: 'Registration Date',
    viviendasInformacionCompleta: 'HOUSE INFORMATION',
    viviendasActivo: 'Active',
    viviendasInactivo: 'Inactive',

    // Translations for NavBars
    navGestionViviendas: 'House Management',
    navGestionAdministradores: 'Administrator Management',
    navGestionWearables: 'Wearable Management',
    navGestionSensores: 'Sensor Management',
    navGestionVariables: 'Variable Management',
    navGestionPreguntas: 'Question Management',
    navVariablesSanitarias: 'Health Variables',
    navVariablesSociales: 'Social Variables',
    navTipoCuidador: 'Caregiver Type',
    navTipoWearable: 'Wearable Type',
    navTipoSensor: 'Sensor Type',
    navTipoHabitacion: 'Room Type',
    navConfigurarADLs: 'Configure ADL Duration',
    navListaCuidadores: 'Caregivers List',
    navListaPacientes: 'Patients List',
    navConfiguracion: 'Settings',
    navCambiarContrasena: 'Change Password',
    navModificarDatos: 'Edit Profile',
    navCambiarIdioma: 'Change Language',
    navSeleccionarIdioma: 'Select language',
    navCerrarSesion: 'Logout',
    navConfirmarCerrarSesion: 'Are you sure you want to logout?',
    navCancelar: 'Cancel',
    navSi: 'Yes',

    // Translations for Rooms
    habitacionesDe: 'Rooms of',
    habitacionesNoHay: 'No rooms in this house',
    habitacionesAnade: 'Add rooms using the + button',
    habitacionesAnadir: 'Add Room',
    habitacionesInactivas: 'Inactive Rooms',
    habitacionesModificar: 'Edit',
    habitacionesDesactivar: 'Deactivate',
    habitacionesModificarTitulo: 'Edit Room',
    habitacionesTipo: 'Room type',
    habitacionesDescripcion: 'Description',
    habitacionesNumeroPlanta: 'Floor Number',
    habitacionesGuardarCambios: 'Save Changes',
    habitacionesDesactivarTitulo: 'Deactivate room?',
    habitacionesConfirmarDesactivar:
        'Are you sure you want to deactivate the room "{tipo}"?',
    habitacionesCancelar: 'Cancel',
    habitacionesError: 'Error',
    habitacionesErrorDesactivar: 'Error deactivating room',
    habitacionesAceptar: 'Accept',
    habitacionesPlanta: 'Floor',
    campoObligatorio: 'Required field',
    soloNumeros: 'Numbers only',

    // Translations for New Room
    nuevaHabitacionTitulo: 'New Room',
    nuevaHabitacionHeader: 'Complete the required fields (*) to add a new room',
    nuevaHabitacionInfo: 'ROOM INFORMATION',
    nuevaHabitacionTipo: 'Room type *',
    nuevaHabitacionSeleccioneTipo: 'Select a room type',
    nuevaHabitacionDescripcion: 'Room description *',
    nuevaHabitacionNumeroPlanta: 'Floor Number *',
    nuevaHabitacionCrear: 'Create Room',
    nuevaHabitacionExito: 'Success!',
    nuevaHabitacionCreada: 'The room has been created successfully',
    nuevaHabitacionError: 'Error',
    nuevaHabitacionErrorCrear: 'Error creating room',
    nuevaHabitacionAceptar: 'Accept',

    // Translations for Inactive Rooms
    habitacionesInactivasTitulo: 'Inactive Rooms',
    habitacionesInactivasNoHay: 'No inactive rooms',
    habitacionesInactivasDescripcion: 'Deactivated rooms will appear here',
    habitacionesInactiva: 'Inactive',
    habitacionesFechaBaja: 'Deactivation date',
    habitacionesActivarTitulo: 'Activate room?',
    habitacionesConfirmarActivar:
        'Are you sure you want to activate the room "{tipo}"?',
    habitacionesActivar: 'Activate',
    habitacionesErrorActivar: 'Error activating room',

    // Translations for Administrators
    adminTitulo: 'Administrators',
    adminNoHayActivos: 'No active administrators',
    adminAnade: 'Add administrators using the + button',
    adminAgregar: 'Add administrator',
    adminInactivos: 'Inactive Administrators',
    adminActivo: 'Active',
    adminInactivo: 'Inactive',
    adminEmail: 'Email',
    adminTelefono: 'Phone',
    adminFechaNacimiento: 'Birth date',
    adminFechaAlta: 'Registration date',
    adminFechaBaja: 'Deactivation date',
    adminOrganizacion: 'Organization',
    adminEstado: 'Status',
    adminDesactivar: 'Deactivate',
    adminActivar: 'Activate',
    adminModificar: 'Edit',
    adminInactivosTitulo: 'Inactive Administrators',
    adminNoHayInactivos: 'No inactive administrators',
    adminInactivosDescripcion: 'Deactivated administrators will appear here',
    adminActivarAdministrador: 'Activate Administrator',

    // Translations for New Administrator
    newAdminTitulo: 'New Administrator',
    newAdminHeader:
        'Complete the required fields (*) to register a new administrator',
    newAdminInfoPersonal: 'PERSONAL INFORMATION',
    newAdminNombre: 'Name',
    newAdminPrimerApellido: 'First Surname',
    newAdminSegundoApellido: 'Second Surname',
    newAdminFechaNacimiento: 'Birth date',
    newAdminInfoContacto: 'CONTACT INFORMATION',
    newAdminEmail: 'Email',
    newAdminEmailInvalido: 'Invalid email',
    newAdminTelefono: 'Phone',
    newAdminTelefonoInvalido: 'Invalid phone number',
    newAdminBuscar: 'Search',
    newAdminInfoAdicional: 'ADDITIONAL INFORMATION',
    newAdminOrganizacion: 'Organization',
    newAdminContinuar: 'Continue',
    newAdminCompletarCampos: 'Please complete all required fields',
    newAdminError: 'Error',
    newAdminExito: 'Success',
    newAdminCorreoEnviado:
        'Administrator created successfully. An email has been sent to {email}',
    newAdminAceptar: 'Accept',
    newAdminEmailRegistrado: 'Email is already registered',
    newAdminErrorCrear: 'Error creating administrator',
    newAdminMenorEdad: 'Underage',
    newAdminMenorEdadMsg: 'The administrator must be over 18 years old',
    newAdminCerrar: 'Close',

    // Translations for Wearables
    wearablesTitulo: 'Patient Wearables',
    wearablesNoHay: 'No wearables assigned',
    wearablesAnade: 'Add wearables using the + button',
    wearablesAnadir: 'Add Wearable',
    wearablesAnadirTitulo: 'Add Wearable',
    wearablesModificar: 'Edit',
    wearablesModificarTitulo: 'Edit Wearable',
    wearablesDesactivar: 'Deactivate',
    wearablesDesactivarTitulo: 'Deactivate wearable?',
    wearablesConfirmarDesactivar:
        'Are you sure you want to deactivate the wearable {id}?',
    wearablesCancelar: 'Cancel',
    wearablesError: 'Error',
    wearablesErrorDesactivar: 'Error deactivating wearable',
    wearablesExito: 'Success',
    wearablesAceptar: 'Accept',
    wearablesExistente: 'Existing Wearable',
    wearablesONuevo: 'Or New Wearable',
    wearablesSeleccionar: 'Select wearable',
    wearablesId: 'Wearable ID',
    wearablesTipo: 'Wearable Type',
    wearablesContinuar: 'Continue',
    wearablesGuardarCambios: 'Save Changes',
    wearablesRellenarCampos: 'Please fill in all fields',
    wearablesSeleccionarUnaOp: 'Select only one option',
    wearablesSeleccionarTipo: 'Select the wearable type',
    wearablesSeleccionarOpcion:
        'Select an existing wearable or create a new one',
    wearablesOtros: 'Others',
    wearablesEspecifiqueTipo: 'Specify the type',
    wearablesAnadido: 'Wearable added successfully',
    wearablesYaExiste: 'The wearable already exists',
    wearablesYaAsignado: 'This wearable is already assigned',

    // Translations for Patients
    pacientesDeLaVivienda: 'Patients of the house',
    pacientesNoHayEnVivienda: 'No patients in this house',
    pacientesAnadeConBoton: 'Add patients using the + button',
    pacientesAnadirTitulo: 'Add Patient',
    pacientesAnadirOpcion: 'Do you want to add a new or existing patient?',
    pacientesAnadir: 'Add Patients',
    pacientesNuevo: 'New',
    pacientesExistente: 'Existing',
    pacientesActivo: 'Active',
    pacientesInactivo: 'Inactive',
    pacientesDesactivarTitulo: 'Deactivate patient?',
    pacientesConfirmarDesactivar:
        'Are you sure you want to deactivate',
    pacientesCancelar: 'Cancel',
    pacientesDesactivar: 'Deactivate',
    pacientesError: 'Error',
    pacientesErrorDesactivar: 'Error deactivating patient',
    pacientesOk: 'OK',
    pacienteInfoPersonal: 'Personal Information',
    pacienteEmail: 'Email',
    pacienteTelefono: 'Phone',
    pacienteNacimiento: 'Birth',
    pacientePatologia: 'Pathology',
    pacienteAutonomia: 'Autonomy',
    pacienteEstado: 'Status',
    pacienteDispositivos: 'Devices',
    pacienteEditar: 'Edit Patient',
    pacienteInfoCompleta: 'PATIENT INFORMATION',

    // Translations for Edit Patient
    modPacienteTitulo: 'Edit Patient',
    modPacienteHeader: 'Modify the patient data of this house',
    modPacienteInfoPersonal: 'PERSONAL INFORMATION',
    modPacienteNombre: 'Name',
    modPacientePrimerApellido: 'First Surname',
    modPacienteSegundoApellido: 'Second Surname',
    modPacienteFechaNacimiento: 'Birth date *',
    modPacienteInfoContacto: 'CONTACT INFORMATION',
    modPacienteEmail: 'Email',
    modPacienteEmailInvalido: 'Invalid email',
    modPacienteTelefono: 'Phone',
    modPacienteTelefonoInvalido: 'Invalid phone number',
    modPacienteBuscar: 'Search',
    modPacienteOrganizacion: 'Organization',
    modPacienteVariables: 'PATIENT VARIABLES',
    modPacienteVariablesSociales: 'Social Variables',
    modPacienteVariablesSanitarias: 'Health Variables',
    modPacienteGuardar: 'Save Changes',
    modPacienteError: 'Error',
    modPacienteExito: 'Success',
    modPacienteModificado: 'Patient modified successfully',
    modPacienteAceptar: 'Accept',
    modPacienteEmailRegistrado: 'Email is already registered',
    modPacienteErrorModificar: 'Error modifying patient',
    modPacientePatologia: 'Pathology',
    modPacienteEspecifiquePatologia: 'Specify the pathology',
    modPacienteVariableSocial: 'Social Variable',
    modPacienteEspecifiqueVariable: 'Specify the social variable',

    // Translations for Edit House
    modViviendaTitulo: 'Edit House',
    modViviendaUbicacion: 'LOCATION',
    modViviendaDireccion: 'Address',
    modViviendaNumero: 'Number',
    modViviendaPiso: 'Floor',
    modViviendaPuerta: 'Door',
    modViviendaLocalizacion: 'LOCATION (GEO)',
    modViviendaLocalidad: 'City/Locality',
    modViviendaProvincia: 'Province',
    modViviendaPais: 'Country',
    modViviendaCodigoPostal: 'Postal Code',
    modViviendaAdicional: 'ADDITIONAL INFORMATION',
    modViviendaNumeroPlantas: 'Number of Floors',
    modViviendaLatitud: 'Latitude',
    modViviendaLongitud: 'Longitude',
    modViviendaGuardar: 'Save Changes',
    modViviendaExito: 'Success!',
    modViviendaModificada: 'The house has been modified successfully',
    modViviendaError: 'Error',
    modViviendaAceptar: 'Accept',
    modViviendaDuplicada: 'A house with this address already exists',
    modViviendaCompletarCampos: 'Please complete all required fields',
    soloNumerosPunto: 'Numbers and decimal point only',

    // Translations for Caregivers
    cuidadoresDe: 'Caregivers of',
    cuidadoresNoHay: 'No caregivers in this house',
    cuidadoresAnade: 'Add caregivers using the + button',
    cuidadoresAnadir: 'Add caregivers',
    cuidadoresAnadirTitulo: 'Add Caregiver',
    cuidadoresAnadirOpcion: 'Do you want to add a new or existing caregiver?',
    cuidadoresNuevo: 'New',
    cuidadoresExistente: 'Existing',
    cuidadoresActivo: 'Active',
    cuidadoresInactivo: 'Inactive',
    cuidadoresEmail: 'Email',
    cuidadoresTelefono: 'Phone',
    cuidadoresFechaNacimiento: 'Birth date',
    cuidadoresParentesco: 'Relationship',
    cuidadoresOrganizacion: 'Organization',
    cuidadoresEstado: 'Status',
    cuidadoresDeshabilitar: 'Disable',
    cuidadoresEditar: 'Edit',

    // Translations for New Caregiver
    newCuidadorTitulo: 'New Caregiver',
    newCuidadorHeader:
        'Complete the required fields (*) to add a new caregiver to the house',
    newCuidadorInfoPersonal: 'PERSONAL INFORMATION',
    newCuidadorNombre: 'Name',
    newCuidadorPrimerApellido: 'First Surname',
    newCuidadorSegundoApellido: 'Second Surname',
    newCuidadorFechaNacimiento: 'Birth date *',
    newCuidadorInfoContacto: 'CONTACT INFORMATION',
    newCuidadorEmail: 'Email',
    newCuidadorEmailInvalido: 'Invalid email',
    newCuidadorTelefono: 'Phone',
    newCuidadorTelefonoInvalido: 'Invalid phone number',
    newCuidadorBuscar: 'Search',
    newCuidadorOrganizacion: 'Organization',
    newCuidadorInfoCuidador: 'CAREGIVER INFORMATION',
    newCuidadorTipo: 'Caregiver Type *',
    newCuidadorSeleccioneTipo: 'Select a caregiver type',
    newCuidadorCrear: 'Create Caregiver',
    newCuidadorOtros: 'Others',
    newCuidadorEspecifiqueParentesco: 'Specify the relationship',
    newCuidadorExito: 'Success',
    newCuidadorCreado: 'Caregiver created successfully',
    newCuidadorError: 'Error',
    newCuidadorAceptar: 'Accept',
    newCuidadorEmailRegistrado: 'Email is already registered',
    newCuidadorErrorCrear: 'Error creating caregiver',
    newCuidadorMenorEdad: 'Underage',
    newCuidadorMenorEdadMsg: 'The caregiver must be over 18 years old',
    newCuidadorCerrar: 'Close',


    viviendasActivar: 'Activate Home',
    viviendasSeguroActivar: 'Are you sure you want to activate the home at',
    viviendasConfirmarActivar: 'Activate',
  };
}
