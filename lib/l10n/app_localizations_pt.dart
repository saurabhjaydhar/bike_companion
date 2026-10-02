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
      'Isto vai apagar permanentemente todas as motos, abastecimentos, revisões, despesas e documentos. Esta ação não pode ser desfeita.';

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
      'Isto apaga permanentemente a sua conta Firebase. Os seus dados locais permanecem neste dispositivo. Esta ação não pode ser desfeita.';

  @override
  String get settingsDeleteAccountError =>
      'Não foi possível apagar a conta. Entre novamente e tente outra vez.';

  @override
  String get appTitle => 'Bike Companion';

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
      'Acompanhe combustível, revisões e despesas\nda sua moto';

  @override
  String get authContinueWithGoogle => 'Continuar com Google';

  @override
  String get authContinueWithoutAccount => 'Continuar sem conta';

  @override
  String get authTerms =>
      'Ao continuar, aceita os nossos Termos e a Política de Privacidade.';

  @override
  String get onboardingWelcomeTitle => 'A sua moto,\nsempre saudável';

  @override
  String get onboardingWelcomeBody =>
      'Acompanhe combustível, revisões, despesas e documentos — tudo num só lugar. Saiba exatamente quando a sua moto precisa de atenção.';

  @override
  String get onboardingGetStarted => 'Começar';

  @override
  String get onboardingAddMyBike => 'Adicionar a minha moto';

  @override
  String get fieldBrand => 'Marca';

  @override
  String get fieldModel => 'Modelo';

  @override
  String get fieldModelHint => 'ex.: Classic 350, Activa';

  @override
  String get fieldNickname => 'Nome da moto';

  @override
  String get fieldNicknameHint => 'Como prefere chamá-la?';

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
  String get addBikeInvalidFormat =>
      'Formato inválido. Use um formato como MH12DE1234 ou DL01AA1234.';

  @override
  String get addBikeNotFound => 'Veículo não encontrado na base de dados.';

  @override
  String get addBikeApiLimit =>
      'Limite da API atingido. Tente novamente mais tarde.';

  @override
  String get addBikeNoInternet =>
      'Sem acesso à internet. Verifique a sua rede.';

  @override
  String get addBikeFetchFailed =>
      'Não foi possível obter os dados do veículo.';

  @override
  String get addBikeTitle => 'Adicione a sua moto';

  @override
  String get addBikeSubtitle =>
      'Insira a matrícula/placa e obteremos os dados do veículo automaticamente.';

  @override
  String get addBikeExamples => 'ex.: UK07AB1234 · DL01AA1234 · MH12DE1234';

  @override
  String get addBikeContinue => 'Continuar →';

  @override
  String get addBikeFetching => 'Consultando dados do veículo…';

  @override
  String get vehicleBrandRequired => 'A marca é obrigatória';

  @override
  String get vehicleModelRequired => 'O modelo é obrigatório';

  @override
  String get vehicleSaveFailed => 'Falha ao guardar a moto. Tente novamente.';

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
  String get vehicleVariant => 'Versão';

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
  String get vehicleSaveBike => 'Guardar moto';

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
  String get garageEmptyTitle => 'Ainda sem motos';

  @override
  String get garageEmptyBody =>
      'Adicione a sua primeira moto para começar a acompanhar combustível, revisões e despesas.';

  @override
  String get garageYourBikes => 'As suas motos';

  @override
  String get garageAddAnother => 'Adicionar outra moto';

  @override
  String get garageStatBikes => 'motos';

  @override
  String get garageStatAlerts => 'alertas';

  @override
  String garageDeleteBike(String name) {
    return 'Apagar $name';
  }

  @override
  String garageDeleteBikeTitle(String name) {
    return 'Apagar $name?';
  }

  @override
  String get garageDeleteBikeBody =>
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
  String get fuelReceiptSoon => 'Leitura de recibos em breve!';

  @override
  String get fuelScanReceipt => 'Digitalizar recibo';

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
  String get navRides => 'Passeios';

  @override
  String get navDocs => 'Docs';

  @override
  String get ridesComingSoon => 'Monitorização de passeios por GPS\nem breve';

  @override
  String get noBikeSelected => 'Selecione primeiro uma moto em Início.';

  @override
  String get offlineBanner => 'Sem internet — modo offline';

  @override
  String notifDocBody(String title, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$title expira em $days dias',
      one: '$title expira amanhã',
    );
    return '$_temp0';
  }

  @override
  String notifDocTitle(int days) {
    return 'Documento expira em $days dias';
  }

  @override
  String get notifDocTomorrowTitle => 'Documento expira amanhã!';

  @override
  String notifServiceOverdueTitle(String bike) {
    return 'Revisão atrasada — $bike';
  }

  @override
  String notifServiceOverdueBody(String service) {
    return '$service precisa de atenção';
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
  String get addBikeHubSubtitle =>
      'Digitalize o cartão RC ou preencha os dados manualmente.';

  @override
  String get addBikeScanTitle => 'Digitalizar cartão RC';

  @override
  String get addBikeScanBody =>
      'Tire uma foto do RC e nós preenchemos os dados.';

  @override
  String get addBikeManualTitle => 'Inserir manualmente';

  @override
  String get addBikeManualBody => 'Digite os dados da sua moto.';

  @override
  String get addBikeLookupTitle => 'Buscar pela matrícula';

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
  String get vehicleScanSuccess =>
      'Dados lidos do RC. Confira tudo antes de guardar.';

  @override
  String get vehicleScanFailure =>
      'Não foi possível ler o RC com clareza. Preencha os dados abaixo.';

  @override
  String get vehicleSectionYourBike => 'A SUA MOTO';
}
