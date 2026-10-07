// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonDelete => 'Apagar';

  @override
  String get commonOther => 'Outro';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsAppearance => 'Aparência';

  @override
  String get settingsSystemDefault => 'Padrão do sistema';

  @override
  String get settingsLight => 'Claro';

  @override
  String get settingsDark => 'Escuro';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsAbout => 'Sobre';

  @override
  String get settingsVersion => 'Versão';

  @override
  String get settingsBuiltWithFlutter => 'Feito com Flutter';

  @override
  String get settingsAccount => 'Conta';

  @override
  String get settingsSignedIn => 'Sessão iniciada';

  @override
  String get settingsSignOut => 'Sair';

  @override
  String get settingsSignOutTitle => 'Sair da conta?';

  @override
  String get settingsSignOutBody =>
      'Os seus dados locais permanecem neste dispositivo. Pode entrar novamente quando quiser.';

  @override
  String get settingsData => 'Dados';

  @override
  String get settingsClearAllData => 'Apagar todos os dados';

  @override
  String get settingsClearTitle => 'Apagar todos os dados?';

  @override
  String get settingsClearBody =>
      'Isso excluirá permanentemente todos os veículos, abastecimentos, revisões, despesas e documentos. Não é possível desfazer.';

  @override
  String get settingsDataCleared => 'Todos os dados foram apagados';

  @override
  String get settingsDeleteAccount => 'Apagar conta';

  @override
  String get settingsDeleteAccountSubtitle =>
      'Remove a sua conta permanentemente (GDPR)';

  @override
  String get settingsDeleteAccountTitle => 'Apagar conta?';

  @override
  String get settingsDeleteAccountBody =>
      'Isso exclui permanentemente sua conta e tudo o que está salvo na nuvem — veículos, registros e fotos de documentos. Os dados neste telefone permanecem. Não é possível desfazer.';

  @override
  String get settingsDeleteAccountError =>
      'Não foi possível apagar a conta. Entre novamente e tente outra vez.';

  @override
  String get appTitle => 'Garajo';

  @override
  String get commonContinue => 'Continuar';

  @override
  String authSignInFailed(String error) {
    return 'Falha ao entrar: $error';
  }

  @override
  String get authOfflineTitle => 'Continuar sem conta?';

  @override
  String get authOfflineBody =>
      'Os seus dados serão guardados apenas neste dispositivo. Não terão backup nem serão sincronizados com outros dispositivos.\n\nPode entrar quando quiser nas Configurações.';

  @override
  String get authOfflineError =>
      'Não foi possível iniciar a sessão offline. Tente novamente.';

  @override
  String get authTagline =>
      'Controle combustível, revisões e despesas\nda sua moto, scooter ou carro';

  @override
  String get authContinueWithGoogle => 'Continuar com Google';

  @override
  String get authContinueWithoutAccount => 'Continuar sem conta';

  @override
  String get authTerms =>
      'Ao continuar, aceita os nossos Termos e a Política de Privacidade.';

  @override
  String get onboardingWelcomeTitle => 'Bem-vindo ao Garajo';

  @override
  String get onboardingAddMyVehicle => 'Adicionar meu veículo';

  @override
  String get fieldBrand => 'Marca';

  @override
  String get fieldModel => 'Modelo';

  @override
  String get fieldModelHint => 'ex.: Classic 350, Activa';

  @override
  String get fieldNickname => 'Apelido';

  @override
  String get fieldNicknameHint => 'Como prefere chamá-lo?';

  @override
  String get fieldColour => 'Cor';

  @override
  String get fieldSelectDate => 'Selecionar data';

  @override
  String get fieldCurrentOdometer => 'Quilometragem atual (km)';

  @override
  String get fieldInsuranceExpiry => 'Validade do seguro';

  @override
  String get fieldPucExpiry => 'Validade do PUC';

  @override
  String get validationRequired => 'Obrigatório';

  @override
  String get validationEnterNumber => 'Insira um número';

  @override
  String get addVehicleInvalidFormat =>
      'Formato inválido. Use um formato como MH12DE1234 ou DL01AA1234.';

  @override
  String get addVehicleNotFound => 'Veículo não encontrado na base de dados.';

  @override
  String get addVehicleApiLimit =>
      'Limite da API atingido. Tente novamente mais tarde.';

  @override
  String get addVehicleNoInternet =>
      'Sem acesso à internet. Verifique a sua rede.';

  @override
  String get addVehicleFetchFailed =>
      'Não foi possível obter os dados do veículo.';

  @override
  String get addVehicleTitle => 'Adicione seu veículo';

  @override
  String get addVehicleSubtitle =>
      'Insira a matrícula/placa e obteremos os dados do veículo automaticamente.';

  @override
  String get addVehicleExamples => 'ex.: UK07AB1234 · DL01AA1234 · MH12DE1234';

  @override
  String get addVehicleContinue => 'Continuar →';

  @override
  String get addVehicleFetching => 'Consultando dados do veículo…';

  @override
  String get vehicleBrandRequired => 'A marca é obrigatória';

  @override
  String get vehicleModelRequired => 'O modelo é obrigatório';

  @override
  String get vehicleSaveFailed =>
      'Não foi possível salvar o veículo. Tente novamente.';

  @override
  String get vehicleDetailsTitle => 'Dados do veículo';

  @override
  String get vehicleSectionRegistration => 'DOCUMENTAÇÃO';

  @override
  String get vehicleRcNumber => 'Número do RC';

  @override
  String get vehicleSectionInfo => 'INFORMAÇÕES DO VEÍCULO';

  @override
  String get vehicleManufacturer => 'Fabricante';

  @override
  String get vehicleFuelType => 'Combustível';

  @override
  String get vehicleClass => 'Categoria do veículo';

  @override
  String get vehicleSectionRegistrationDetails => 'DADOS DA DOCUMENTAÇÃO';

  @override
  String get vehicleRegistrationDate => 'Data de matrícula';

  @override
  String get vehicleSectionIdentifiers => 'IDENTIFICADORES';

  @override
  String get vehicleEngineNumber => 'Número do motor';

  @override
  String get vehicleChassisNumber => 'Número do chassis';

  @override
  String get vehicleSaveVehicle => 'Salvar veículo';

  @override
  String get vehicleFetchSuccess =>
      'Dados do veículo obtidos. Reveja e confirme.';

  @override
  String get vehicleFetchFailure =>
      'Não foi possível obter os dados do veículo. Insira-os manualmente abaixo.';

  @override
  String commonError(String error) {
    return 'Erro: $error';
  }

  @override
  String get commonThisMonth => 'este mês';

  @override
  String get garageTitle => 'A minha garagem';

  @override
  String get garageEmptyTitle => 'Nenhum veículo ainda';

  @override
  String get garageEmptyBody =>
      'Adicione sua primeira moto, scooter ou carro para controlar combustível, revisões e despesas.';

  @override
  String get garageYourVehicles => 'Seus veículos';

  @override
  String get garageAddAnother => 'Adicionar outro veículo';

  @override
  String get garageStatVehicles => 'veículos';

  @override
  String get garageStatAlerts => 'alertas';

  @override
  String garageDeleteVehicle(String name) {
    return 'Apagar $name';
  }

  @override
  String garageDeleteVehicleTitle(String name) {
    return 'Apagar $name?';
  }

  @override
  String get garageDeleteVehicleBody =>
      'Todos os abastecimentos, revisões e despesas serão apagados.';

  @override
  String get commonToday => 'Hoje';

  @override
  String get commonYesterday => 'Ontem';

  @override
  String commonDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'há $count dias',
      one: 'há 1 dia',
    );
    return '$_temp0';
  }

  @override
  String get commonNotSet => 'Não definido';

  @override
  String get fieldOdometer => 'Quilometragem';

  @override
  String get dashboardTitle => 'Painel';

  @override
  String get dashboardLogFuel => 'Adicionar abastecimento';

  @override
  String get dashboardRecentActivity => 'Atividade recente';

  @override
  String get dashboardSeeAll => 'Ver tudo';

  @override
  String get dashboardThisMonth => 'Este mês';

  @override
  String get dashboardLastFuel => 'Último abastecimento';

  @override
  String get dashboardNotLogged => 'Sem dados';

  @override
  String dashboardAvgMileage(String mileage) {
    return '$mileage km/L em média';
  }

  @override
  String get dashboardNextService => 'Próxima revisão';

  @override
  String get dashboardUpToDate => 'Em dia';

  @override
  String dashboardDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'faltam $count dias',
      one: 'falta 1 dia',
    );
    return '$_temp0';
  }

  @override
  String get dashboardFuelStop => 'Abastecimento';

  @override
  String fuelOdometerTooLow(int km) {
    return 'A quilometragem deve ser maior que a da última entrada ($km km)';
  }

  @override
  String get fuelLogged => 'Abastecimento guardado!';

  @override
  String get fuelCurrentOdometer => 'Quilometragem atual';

  @override
  String fuelLastEntry(int km) {
    return 'Última entrada: $km km';
  }

  @override
  String fuelKmSinceLastEstimate(int km, String litres) {
    return '$km km desde o último abastecimento · ~$litres L estimados';
  }

  @override
  String fuelKmSinceLast(int km) {
    return '$km km desde o último abastecimento';
  }

  @override
  String get fuelAddMoreDetails => 'Adicionar mais detalhes';

  @override
  String get fuelLitresFilled => 'Litros abastecidos';

  @override
  String get fuelAmountPaid => 'Valor pago';

  @override
  String get fuelStationOptional => 'Posto de abastecimento (opcional)';

  @override
  String get fuelStationHint => 'HP, Indian Oil, Bharat...';

  @override
  String get fuelSave => 'Guardar abastecimento';

  @override
  String get fuelHistoryTitle => 'Histórico de combustível';

  @override
  String get fuelHistoryEmptyTitle => 'Ainda sem abastecimentos';

  @override
  String get fuelHistoryEmptyBody =>
      'Adicione o seu primeiro abastecimento a partir do painel.';

  @override
  String get fuelAvgMileageAllTime => 'Consumo médio (desde sempre)';

  @override
  String get fieldNotesOptional => 'Notas (opcional)';

  @override
  String get serviceStatusGood => 'Bom';

  @override
  String get serviceDueSoon => 'Em breve';

  @override
  String get serviceStatusOverdue => 'Atrasada';

  @override
  String get serviceHistory => 'Histórico';

  @override
  String serviceLast(String date) {
    return 'Última: $date';
  }

  @override
  String get serviceEmptyTitle => 'Nenhuma revisão';

  @override
  String get serviceEmptyBody =>
      'Toque em qualquer item em \"Em breve\" para adicionar uma revisão.';

  @override
  String get serviceLogTitle => 'Adicionar revisão';

  @override
  String get serviceType => 'Tipo de revisão';

  @override
  String get serviceOdometerKm => 'Quilometragem (km)';

  @override
  String get serviceCost => 'Custo (₹)';

  @override
  String get serviceNotesHint => 'Oficina, peças substituídas...';

  @override
  String get serviceSave => 'Guardar revisão';

  @override
  String get serviceOilChange => 'Troca de óleo';

  @override
  String get serviceOilFilter => 'Filtro de óleo';

  @override
  String get serviceAirFilter => 'Filtro de ar';

  @override
  String get serviceChainClean => 'Limpeza da corrente';

  @override
  String get serviceChainLube => 'Lubrificação da corrente';

  @override
  String get serviceBrakePads => 'Pastilhas de freio';

  @override
  String get serviceTyres => 'Pneus';

  @override
  String get serviceBattery => 'Bateria';

  @override
  String get serviceCoolant => 'Líquido de arrefecimento';

  @override
  String get expenseFuel => 'Combustível';

  @override
  String get expenseService => 'Revisão';

  @override
  String get expenseParts => 'Peças';

  @override
  String get expenseInsurance => 'Seguro';

  @override
  String get expenseParking => 'Estacionamento';

  @override
  String get expenseAccessories => 'Acessórios';

  @override
  String get expenseFine => 'Multa';

  @override
  String get docRc => 'Documento do veículo (RC)';

  @override
  String get docInsurance => 'Seguro';

  @override
  String get docDrivingLicence => 'Carta de condução / CNH';

  @override
  String get docPuc => 'Certificado PUC';

  @override
  String get docInvoice => 'Fatura de compra';

  @override
  String get docWarranty => 'Certificado de garantia';

  @override
  String get gradeExcellent => 'Estado excelente';

  @override
  String get gradeGood => 'Bom estado';

  @override
  String get gradeFair => 'Estado razoável';

  @override
  String get gradePoor => 'Precisa de atenção';

  @override
  String get gradeCritical => 'Crítico — faça a revisão já';

  @override
  String get expensesTitle => 'Despesas';

  @override
  String get expensesExportCsv => 'Exportar CSV';

  @override
  String get expensesByCategory => 'Por categoria';

  @override
  String get expensesTransactions => 'Transações';

  @override
  String get expensesEmptyTitle => 'Sem despesas';

  @override
  String get expensesEmptyBody =>
      'Toque em + para adicionar a primeira despesa deste mês.';

  @override
  String get expensesCsvHeader => 'Data,Categoria,Valor (₹),Nota';

  @override
  String expensesCsvSubject(String month) {
    return 'Despesas — $month';
  }

  @override
  String get expensesTotalSpent => 'Total gasto';

  @override
  String expensesVsLastMonth(String percent) {
    return '$percent% vs. mês anterior';
  }

  @override
  String get expensesAddTitle => 'Adicionar despesa';

  @override
  String get expensesCategory => 'Categoria';

  @override
  String get expensesAmount => 'Valor (₹)';

  @override
  String get expensesNoteOptional => 'Nota (opcional)';

  @override
  String get expensesNoteHint => 'Estabelecimento, descrição...';

  @override
  String get expensesSave => 'Guardar despesa';

  @override
  String get documentsTitle => 'Documentos';

  @override
  String get documentsEmptyTitle => 'Sem documentos';

  @override
  String get documentsEmptyBody =>
      'Guarde o RC, o seguro, o PUC e mais, tudo num só lugar.';

  @override
  String get documentsExpiringSoon => 'Expira em breve';

  @override
  String get documentsValid => 'Válido';

  @override
  String get documentsExpired => 'Expirado';

  @override
  String get documentsNoExpiry => 'Sem validade';

  @override
  String documentsExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Expira em $count dias',
      one: 'Expira em 1 dia',
    );
    return '$_temp0';
  }

  @override
  String get documentsDelete => 'Apagar documento';

  @override
  String get documentsExpiry => 'Validade';

  @override
  String get documentsAddTitle => 'Adicionar documento';

  @override
  String get documentsType => 'Tipo de documento';

  @override
  String get documentsTitleField => 'Título';

  @override
  String get documentsTitleHint => 'ex.: RC, apólice n.º...';

  @override
  String get documentsExpiryOptional => 'Data de validade (opcional)';

  @override
  String get documentsPhotoSelected => 'Foto selecionada';

  @override
  String get documentsAttachPhoto => 'Anexar foto';

  @override
  String get documentsSave => 'Guardar documento';

  @override
  String get navHome => 'Início';

  @override
  String get navDocs => 'Docs';

  @override
  String get noVehicleSelected => 'Primeiro escolha um veículo na aba Início.';

  @override
  String get offlineBanner => 'Sem internet — modo offline';

  @override
  String notifServiceOverdueTitle(String vehicle) {
    return 'Revisão atrasada — $vehicle';
  }

  @override
  String get healthOilNone =>
      'Nenhuma troca de óleo — adicione a primeira revisão';

  @override
  String healthOilGood(int km) {
    return 'Óleo trocado há $km km — tudo bem';
  }

  @override
  String get healthOilOverdue => 'Troca de óleo atrasada!';

  @override
  String healthOilDue(int km) {
    return 'Troca de óleo dentro de ~$km km';
  }

  @override
  String get healthChainNone => 'Nenhuma manutenção da corrente';

  @override
  String healthChainGood(int km) {
    return 'Corrente revista há $km km';
  }

  @override
  String healthChainDue(int km) {
    return 'Manutenção da corrente dentro de ~$km km';
  }

  @override
  String get healthAirNone => 'Nenhuma manutenção do filtro de ar';

  @override
  String healthAirGood(String km) {
    return 'Filtro de ar trocado há $km mil km';
  }

  @override
  String get healthAirDue => 'Troca do filtro de ar em breve';

  @override
  String get healthBrakesNone => 'Nenhuma revisão dos freios';

  @override
  String healthBrakesGood(String km) {
    return 'Freios verificados há $km mil km';
  }

  @override
  String get healthBrakesDue => 'Inspeção dos freios recomendada';

  @override
  String get healthTyresNone => 'Nenhuma manutenção dos pneus';

  @override
  String healthTyresGood(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'Pneus trocados há $months meses',
      one: 'Pneus trocados há 1 mês',
    );
    return '$_temp0';
  }

  @override
  String get healthTyresDue => 'Inspeção dos pneus recomendada';

  @override
  String get healthBatteryNone => 'Nenhuma manutenção da bateria';

  @override
  String healthBatteryGood(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'Bateria trocada há $months meses',
      one: 'Bateria trocada há 1 mês',
    );
    return '$_temp0';
  }

  @override
  String get healthBatteryDue => 'Verificação da bateria recomendada';

  @override
  String get healthInsuranceNotSet => 'Data de validade do seguro não definida';

  @override
  String get healthInsuranceExpired => 'Seguro EXPIRADO — renove imediatamente';

  @override
  String healthInsuranceExpiring(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'O seguro expira em $days dias — renove já',
      one: 'O seguro expira em 1 dia — renove já',
    );
    return '$_temp0';
  }

  @override
  String healthInsuranceValid(int days) {
    return 'Seguro válido por mais $days dias';
  }

  @override
  String get healthEconomyNeedMore =>
      'Adicione mais abastecimentos para acompanhar o rendimento';

  @override
  String healthEconomyAverage(String mileage) {
    return 'Média: $mileage km/L';
  }

  @override
  String healthEconomyStable(String mileage) {
    return 'Rendimento estável em $mileage km/L';
  }

  @override
  String get healthEconomyDropping =>
      'Rendimento em queda — pode ser necessária uma revisão';

  @override
  String get healthEconomyDeclining =>
      'Rendimento em ligeira queda — acompanhe';

  @override
  String get addVehicleHubSubtitle =>
      'Digitalize o cartão RC ou preencha os dados manualmente.';

  @override
  String get addVehicleScanTitle => 'Digitalizar cartão RC';

  @override
  String get addVehicleScanBody =>
      'Tire uma foto do RC e nós preenchemos os dados.';

  @override
  String get addVehicleManualTitle => 'Inserir manualmente';

  @override
  String get addVehicleManualBody =>
      'Digite você mesmo os dados do seu veículo.';

  @override
  String get addVehicleLookupTitle => 'Buscar pela matrícula';

  @override
  String get scanTakePhoto => 'Tirar foto';

  @override
  String get scanChooseGallery => 'Escolher da galeria';

  @override
  String get scanUseGemini => 'Ler com Gemini AI';

  @override
  String get scanUseGeminiBody =>
      'Mais preciso. A foto do RC é enviada ao Google para ler os dados do veículo. Desativado, a foto é lida apenas no seu dispositivo.';

  @override
  String get scanReading => 'Lendo o RC…';

  @override
  String get scanTitle => 'Digitalize seu RC';

  @override
  String get scanSubtitle =>
      'Adicione fotos dos dois lados do cartão RC — cada lado tem dados diferentes. Para um livreto RC ou RC digital, uma foto basta.';

  @override
  String get scanFront => 'Frente';

  @override
  String get scanFrontHint => 'Placa, número do chassi e do motor';

  @override
  String get scanBack => 'Verso';

  @override
  String get scanBackHint => 'Fabricante, modelo e categoria do veículo';

  @override
  String get scanAddPhoto => 'Toque para adicionar uma foto';

  @override
  String get scanRemovePhoto => 'Remover foto';

  @override
  String get scanReadDetails => 'Ler dados';

  @override
  String get scanPickerError =>
      'Não foi possível abrir a câmera ou a galeria. Verifique as permissões do app em Ajustes.';

  @override
  String get vehicleScanSuccess =>
      'Dados lidos do RC. Confira tudo antes de guardar.';

  @override
  String get vehicleScanFailure =>
      'Não foi possível ler o RC com clareza. Preencha os dados abaixo.';

  @override
  String get vehicleSectionYourVehicle => 'SEU VEÍCULO';

  @override
  String get vahanSmsButton => 'Consultar no VAHAN por SMS';

  @override
  String get vahanSmsHint =>
      'Envia a sua matrícula ao serviço oficial de SMS do VAHAN. A resposta chega nas suas mensagens — copie os dados para este formulário.';

  @override
  String get vahanSmsError => 'Não foi possível abrir o app de mensagens.';

  @override
  String get vehicleRegValidity => 'Registro válido até';

  @override
  String get dueRegistration => 'Registro';

  @override
  String notifExpiryTitle(String item, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$item vence em $days dias',
      one: '$item vence amanhã',
    );
    return '$_temp0';
  }

  @override
  String notifServiceDueTitle(String item, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$item previsto em $days dias',
      one: '$item previsto para amanhã',
    );
    return '$_temp0';
  }

  @override
  String notifDueBody(String vehicle, String date) {
    return '$vehicle · $date. Toque para atualizar.';
  }

  @override
  String get comingUpTitle => 'Em breve';

  @override
  String get comingUpEmpty => 'Tudo certo: nada vence em breve.';

  @override
  String dueInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'em $days dias',
      one: 'amanhã',
      zero: 'hoje',
    );
    return '$_temp0';
  }

  @override
  String dueOverdue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias de atraso',
      one: '1 dia de atraso',
    );
    return '$_temp0';
  }

  @override
  String get dueAddDate => 'Adicionar data';

  @override
  String get dueServiceSoon => 'Em breve';

  @override
  String get dueServiceOverdue => 'Atrasado';

  @override
  String dueValidUntil(String item) {
    return '$item válido até';
  }

  @override
  String get dueUpdated => 'Data salva: lembretes atualizados';

  @override
  String get remindersTurnOn => 'Ativar';

  @override
  String get remindersOffBody =>
      'Os lembretes estão desativados. Ative-os para saber antes quando vencem o seguro, o PUC e as revisões.';

  @override
  String get remindersMutedNote =>
      'Os lembretes estão desativados para este veículo.';

  @override
  String get remindersPermissionTitle => 'Receber lembretes?';

  @override
  String get remindersPermissionBody =>
      'Avisaremos 30, 7 e 1 dia antes de o seguro, o PUC e os documentos vencerem — às 9h, nunca à noite.';

  @override
  String get remindersNotNow => 'Agora não';

  @override
  String get remindersEnableInSettings =>
      'As notificações estão bloqueadas. Ative-as para este app nos Ajustes do telefone.';

  @override
  String get settingsReminders => 'Lembretes';

  @override
  String settingsRemindersNext(String item, String date) {
    return 'Próximo: $item · $date';
  }

  @override
  String get settingsRemindersNone => 'Nada vence em breve';

  @override
  String get expensesModeMonth => 'Mês';

  @override
  String get expensesModeYear => 'Ano';

  @override
  String expensesVsLastYear(String percent) {
    return '$percent% vs. ano passado';
  }

  @override
  String get expensesAvgMonthly => 'Média / mês';

  @override
  String get expensesCostPerKm => 'Custo / km';

  @override
  String get expensesFuelPerKm => 'Combustível / km';

  @override
  String get expensesNeedOdometer =>
      'Registre abastecimentos ou revisões com a quilometragem para ver o custo por km.';

  @override
  String get expensesFromFuelLog => 'Abastecimento';

  @override
  String get expensesFromService => 'Revisão';

  @override
  String get expensesDeleted => 'Despesa excluída';

  @override
  String get commonUndo => 'Desfazer';

  @override
  String get budgetTitle => 'Orçamento';

  @override
  String budgetOf(String spent, String budget) {
    return '$spent de $budget';
  }

  @override
  String budgetLeft(String amount) {
    return 'Restam $amount';
  }

  @override
  String budgetLeftOf(String left, String budget) {
    return 'Restam $left de $budget';
  }

  @override
  String budgetOver(String amount) {
    return '$amount acima do orçamento';
  }

  @override
  String get budgetSet => 'Definir orçamento';

  @override
  String get budgetSetPrompt => 'Defina um orçamento para controlar os gastos.';

  @override
  String get budgetSheetTitle => 'Orçamento de gastos';

  @override
  String get budgetMonthly => 'Orçamento mensal';

  @override
  String get budgetYearly => 'Orçamento anual';

  @override
  String budgetSuggested(String amount) {
    return 'Sugerido pelos meses recentes: $amount';
  }

  @override
  String get budgetSave => 'Salvar orçamento';

  @override
  String get budgetRemove => 'Remover orçamento';

  @override
  String budgetAlertTitle(String vehicle) {
    return 'Alerta de orçamento — $vehicle';
  }

  @override
  String budgetAlertMonth(int percent) {
    return 'Você usou $percent% do orçamento deste mês.';
  }

  @override
  String budgetAlertYear(int percent) {
    return 'Você usou $percent% do orçamento deste ano.';
  }

  @override
  String get garageSpending => 'Gastos';

  @override
  String get garageThisYear => 'Este ano';

  @override
  String get vehicleTypeTitle => 'TIPO DE VEÍCULO';

  @override
  String get vehicleTypeDetected =>
      'Detectado no seu RC — altere se estiver errado.';

  @override
  String get vehicleTypeBike => 'Moto';

  @override
  String get vehicleTypeScooter => 'Scooter';

  @override
  String get vehicleTypeCar => 'Carro';

  @override
  String get serviceWheelAlignment => 'Alinhamento';

  @override
  String get serviceAcService => 'Revisão do ar-condicionado';

  @override
  String get serviceWipers => 'Palhetas';

  @override
  String get onboardingSlideTrackTitle => 'Cada rupia sob controle';

  @override
  String get onboardingSlideTrackBody =>
      'Combustível, revisões e despesas em um só lugar, com orçamentos e custo por km para cada veículo.';

  @override
  String get onboardingSlideRemindTitle => 'Nunca perca uma data';

  @override
  String get onboardingSlideRemindBody =>
      'Lembretes antes de vencerem o seguro, o PUC e as revisões — às 9h, nunca à noite.';

  @override
  String get onboardingSlideScanTitle => 'Digitalize, não digite';

  @override
  String get onboardingSlideScanBody =>
      'Fotografe seu RC e preencheremos os dados do seu veículo.';

  @override
  String fuelLitresFromPrice(String litres, String price) {
    return '≈ $litres L a ₹$price/L (seu último abastecimento)';
  }

  @override
  String get logButton => 'Registrar';

  @override
  String get logSheetTitle => 'O que você quer registrar?';

  @override
  String get logFuelSub => 'Litros, custo e consumo';

  @override
  String get logExpenseSub => 'Peças, seguro, estacionamento, pedágios';

  @override
  String get logServiceSub => 'Troca de óleo, corrente, pneus';

  @override
  String get logOdometerTitle => 'Atualizar hodômetro';

  @override
  String get logOdometerSub => 'Mantenha seus km em dia';

  @override
  String get logDocumentSub => 'Documento, seguro, emissões';

  @override
  String get odometerSave => 'Salvar leitura';

  @override
  String get odometerUpdated => 'Hodômetro atualizado';

  @override
  String get odometerInvalid => 'Digite uma leitura em km';

  @override
  String fuelOdometerEstimated(int km) {
    return 'Estimado pelos seus $km km habituais entre abastecimentos. Ajuste se precisar.';
  }

  @override
  String fuelTripMileage(int km, String litres, String mileage) {
    return '$km km · $litres L · $mileage km/L';
  }

  @override
  String get vehicleEditTitle => 'Editar veículo';

  @override
  String get vehicleUpdated => 'Veículo atualizado';

  @override
  String get vehicleMoreDetails => 'Mais detalhes';

  @override
  String get vehicleSectionDueDates => 'DATAS DE RENOVAÇÃO';

  @override
  String get healthFuelEconomy => 'Consumo';

  @override
  String get healthBreakdownTitle => 'Saúde do veículo';

  @override
  String get healthBreakdownBody =>
      'O que compõe a pontuação. Resolva os primeiros itens para aumentá-la.';

  @override
  String get healthFixLog => 'Registrar';

  @override
  String get healthFixUpdate => 'Atualizar data';

  @override
  String get onboardingHaveAccount => 'Já tenho uma conta';

  @override
  String get backupTitle => 'Faça backup da sua garagem';

  @override
  String get backupBody =>
      'Salvo só neste celular. Entre com o Google para proteger e sincronizar.';

  @override
  String get backupLater => 'Depois';

  @override
  String get backupAction => 'Fazer backup';

  @override
  String get backupDone => 'Garagem salva na sua conta Google';

  @override
  String get settingsGuest => 'Convidado';
}
