import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AmparoApp());
}

class AmparoApp extends StatefulWidget {
  const AmparoApp({super.key});

  @override
  State<AmparoApp> createState() => _AmparoAppState();
}

class _AmparoAppState extends State<AmparoApp> {
  bool isDarkMode = false;
  bool isHighContrast = false;
  bool? introAlreadySeen;

  final SharedPreferencesAsync preferences = SharedPreferencesAsync();

  @override
  void initState() {
    super.initState();
    _loadFirstLaunchState();
  }

  Future<void> _loadFirstLaunchState() async {
    final seen = await preferences.getBool('amparo_intro_seen') ?? false;
    if (mounted) {
      setState(() => introAlreadySeen = seen);
    }
  }

  Future<void> _finishIntroduction() async {
    await preferences.setBool('amparo_intro_seen', true);
    if (mounted) {
      setState(() => introAlreadySeen = true);
    }
  }

  ThemeData buildAppTheme({
    required bool dark,
    required bool highContrast,
  }) {
    if (highContrast) {
      return ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.yellow,
          onPrimary: Colors.black,
          secondary: Colors.yellow,
          onSecondary: Colors.black,
          surface: Colors.black,
          onSurface: Colors.white,
          error: Colors.yellow,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.yellow,
        ),
        cardTheme: const CardThemeData(color: Colors.black),
      );
    }

    return ThemeData(
      useMaterial3: true,
      brightness: dark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF176B60),
        brightness: dark ? Brightness.dark : Brightness.light,
      ),
      scaffoldBackgroundColor:
          dark ? const Color(0xFF121212) : const Color(0xFFF6F8F6),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amparo',
      theme: buildAppTheme(dark: false, highContrast: isHighContrast),
      darkTheme: buildAppTheme(dark: true, highContrast: isHighContrast),
      themeMode: isDarkMode || isHighContrast
          ? ThemeMode.dark
          : ThemeMode.light,
      home: introAlreadySeen == null
          ? const _InitialLoadingScreen()
          : introAlreadySeen == false
              ? FirstLaunchScreen(onContinue: _finishIntroduction)
              : HomePage(
                  isDarkMode: isDarkMode,
                  isHighContrast: isHighContrast,
                  onToggleDarkMode: () {
                    setState(() {
                      isDarkMode = !isDarkMode;
                      if (isDarkMode) isHighContrast = false;
                    });
                  },
                  onToggleHighContrast: () {
                    setState(() {
                      isHighContrast = !isHighContrast;
                      if (isHighContrast) isDarkMode = false;
                    });
                  },
                ),
    );
  }
}

class _InitialLoadingScreen extends StatelessWidget {
  const _InitialLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class FirstLaunchScreen extends StatelessWidget {
  final VoidCallback onContinue;

  const FirstLaunchScreen({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(34),
                    child: Image.asset(
                      'assets/icon/app_icon.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1F1E9),
                          borderRadius: BorderRadius.circular(34),
                        ),
                        child: const Icon(
                          Icons.volunteer_activism,
                          color: Color(0xFF176B60),
                          size: 88,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Bem-vindo ao Amparo!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF176B60),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'O Amparo foi desenvolvido por estudantes do curso '
                    'de Tecnologia em Telemática do Instituto Federal '
                    'do Ceará (IFCE).',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1F1E9),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.science_outlined,
                                color: Color(0xFF176B60)),
                            SizedBox(width: 8),
                            Text(
                              'Versão beta',
                              style: TextStyle(
                                color: Color(0xFF174D40),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'O aplicativo ainda está em desenvolvimento. '
                          'Novas atualizações e melhorias estão a caminho.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF315A4D),
                            fontSize: 16,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton.icon(
                      onPressed: onContinue,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text(
                        'Começar a usar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF176B60),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DigitalGuide {
  final String title;
  final String description;
  final String category;
  final String fileName;
  final IconData icon;

  const DigitalGuide({
    required this.title,
    required this.description,
    required this.category,
    required this.fileName,
    required this.icon,
  });
}

class TrustedSite {
  final String name;
  final String description;
  final String url;
  final String category;
  final String? phone;
  final IconData icon;

  const TrustedSite({
    required this.name,
    required this.description,
    required this.url,
    required this.category,
    this.phone,
    required this.icon,
  });
}

const List<DigitalGuide> documents = [
  DigitalGuide(
    title: 'Como entrar no gov.br',
    description: 'Aprenda a acessar sua conta e os serviços digitais do governo.',
    category: 'Serviços públicos',
    fileName: '01-como-entrar-no-gov-br.pdf',
    icon: Icons.account_circle_outlined,
  ),
  DigitalGuide(
    title: 'Como fazer Pix no Santander e Itaú',
    description: 'Orientações para realizar transferências Pix nesses bancos.',
    category: 'Bancos',
    fileName: '02-como-fazer-pix-santander-e-itau.pdf',
    icon: Icons.swap_horiz,
  ),
  DigitalGuide(
    title: 'Como deixar o celular mais fácil de usar',
    description: 'Ajustes de acessibilidade para facilitar o uso do aparelho.',
    category: 'Celular',
    fileName: '03-como-deixar-o-celular-mais-facil-de-usar.pdf',
    icon: Icons.accessibility_new,
  ),
  DigitalGuide(
    title: 'WhatsApp sem mistérios',
    description: 'Conheça os recursos essenciais do WhatsApp.',
    category: 'Comunicação',
    fileName: 'Aplicaes 1_ WhatsApp sem Mistrios.pdf',
    icon: Icons.chat_outlined,
  ),
  DigitalGuide(
    title: 'Serviços públicos e Gov.br',
    description: 'Use serviços públicos e ferramentas digitais do governo.',
    category: 'Serviços públicos',
    fileName: 'Aplicaes 2_ Servios Pblicos e Gov.br.pdf',
    icon: Icons.account_balance_outlined,
  ),
  DigitalGuide(
    title: 'Transporte e mapas no celular',
    description: 'Aprenda a consultar trajetos e usar aplicativos de transporte.',
    category: 'Transporte',
    fileName: 'Aplicaes 3_ Transporte e Mapas no Celular.pdf',
    icon: Icons.map_outlined,
  ),
  DigitalGuide(
    title: 'Bancos: primeiros passos',
    description: 'Noções básicas para utilizar serviços bancários.',
    category: 'Bancos',
    fileName: 'Bancos.pdf',
    icon: Icons.account_balance_wallet_outlined,
  ),
  DigitalGuide(
    title: 'Crédito, dívidas e cartões',
    description: 'Entenda cuidados e conceitos sobre crédito e cartões.',
    category: 'Bancos',
    fileName: 'Bancos_2_Credito_Dividas_Cartoes.pdf',
    icon: Icons.credit_card_outlined,
  ),
  DigitalGuide(
    title: 'Investimentos para iniciantes',
    description: 'Conheça conceitos iniciais sobre investimentos.',
    category: 'Bancos',
    fileName: 'Bancos_3_Investimentos_Iniciantes.pdf',
    icon: Icons.savings_outlined,
  ),
  DigitalGuide(
    title: 'Como fazer uma videochamada',
    description: 'Converse por vídeo com familiares e amigos.',
    category: 'Comunicação',
    fileName: 'Como fazer uma videochamada (1).pdf',
    icon: Icons.video_call_outlined,
  ),
  DigitalGuide(
    title: 'Como fotografar e enviar um documento',
    description: 'Tire uma foto legível e compartilhe documentos pelo celular.',
    category: 'Celular',
    fileName: 'Como fotografar e enviar um documento (1).pdf',
    icon: Icons.document_scanner_outlined,
  ),
  DigitalGuide(
    title: 'Como usar o WhatsApp',
    description: 'Aprenda a enviar mensagens, fotos, áudios e arquivos.',
    category: 'Comunicação',
    fileName: 'Como usar o WhatsApp (1).pdf',
    icon: Icons.message_outlined,
  ),
  DigitalGuide(
    title: 'Como baixar e abrir um PDF',
    description: 'Veja como localizar, baixar e visualizar arquivos PDF.',
    category: 'Celular',
    fileName: 'Como-baixar-e-abrir-um-PDF-sem-marca.pdf',
    icon: Icons.picture_as_pdf_outlined,
  ),
  DigitalGuide(
    title: 'Bateria e carregamento seguro',
    description: 'Cuidados para carregar e conservar a bateria do telefone.',
    category: 'Cuidados com o celular',
    fileName: 'Cuidados com o Telefone 1_ Bateria e Carregamento Seguro.pdf',
    icon: Icons.battery_charging_full,
  ),
  DigitalGuide(
    title: 'Liberando espaço e memória',
    description: 'Organize arquivos e libere espaço no aparelho.',
    category: 'Cuidados com o celular',
    fileName: 'Cuidados com o Telefone 2_ Liberando Espao e Memria.pdf',
    icon: Icons.storage_outlined,
  ),
  DigitalGuide(
    title: 'Limpeza, tela e atualizações',
    description: 'Cuidados físicos e atualizações importantes do telefone.',
    category: 'Cuidados com o celular',
    fileName: 'Cuidados com o Telefone 3_ Limpeza Fsica, Tela e Atualizaes.pdf',
    icon: Icons.cleaning_services_outlined,
  ),
  DigitalGuide(
    title: 'Golpes e mensagens falsas',
    description: 'Reconheça tentativas de fraude e mensagens suspeitas.',
    category: 'Segurança digital',
    fileName: 'Guia 1 - Golpes e Mensagens Falsas.pdf',
    icon: Icons.warning_amber_outlined,
  ),
  DigitalGuide(
    title: 'Wi-Fi com segurança',
    description: 'Cuidados ao se conectar a redes Wi-Fi.',
    category: 'Segurança digital',
    fileName: 'Guia 2 - Wi-Fi com Segurana.pdf',
    icon: Icons.wifi,
  ),
  DigitalGuide(
    title: 'Códigos QR no celular',
    description: 'Aprenda a reconhecer e utilizar códigos QR com cuidado.',
    category: 'Celular',
    fileName: 'Guia 3 - Cdigos QR no Celular.pdf',
    icon: Icons.qr_code_scanner,
  ),
  DigitalGuide(
    title: 'Salvar contatos na agenda',
    description: 'Cadastre e organize números de telefone.',
    category: 'Celular',
    fileName: 'Guia 4 - Salvar Contatos na Agenda.pdf',
    icon: Icons.contacts_outlined,
  ),
  DigitalGuide(
    title: 'Compras e pagamentos no celular',
    description: 'Cuidados para comprar e pagar usando aplicativos.',
    category: 'Compras e pagamentos',
    fileName: 'Guia 5 - Compras e Pagamentos no Celular.pdf',
    icon: Icons.shopping_cart_outlined,
  ),
  DigitalGuide(
    title: 'Guia prático do Meu INSS',
    description: 'Orientações para acessar serviços do Meu INSS.',
    category: 'Serviços públicos',
    fileName: 'Guia Prtico do Meu INSS para Idosos.pdf',
    icon: Icons.assignment_ind_outlined,
  ),
  DigitalGuide(
    title: 'Como usar o Uber com segurança',
    description: 'Dicas para solicitar e acompanhar corridas com segurança.',
    category: 'Transporte',
    fileName: 'Guia Prtico_ Como Usar o Uber com Segurana.pdf',
    icon: Icons.local_taxi_outlined,
  ),
  DigitalGuide(
    title: 'Redes sociais',
    description: 'Conheça as principais redes sociais e seus recursos.',
    category: 'Redes sociais',
    fileName: 'Redes_Sociais.pdf',
    icon: Icons.people_outline,
  ),
  DigitalGuide(
    title: 'Redes sociais: negócios e carreira',
    description: 'Possibilidades de uso profissional das redes sociais.',
    category: 'Redes sociais',
    fileName: 'Redes_Sociais_2_Negocios_Carreira.pdf',
    icon: Icons.work_outline,
  ),
  DigitalGuide(
    title: 'Redes sociais: família e crianças',
    description: 'Orientações sobre convivência familiar nas redes sociais.',
    category: 'Redes sociais',
    fileName: 'Redes_Sociais_3_Familia_Criancas.pdf',
    icon: Icons.family_restroom,
  ),
  DigitalGuide(
    title: 'Segurança digital',
    description: 'Práticas para navegar e utilizar serviços com mais segurança.',
    category: 'Segurança digital',
    fileName: 'Seguranca_Digital.pdf',
    icon: Icons.shield_outlined,
  ),
  DigitalGuide(
    title: 'Segurança digital: golpes',
    description: 'Aprofunde os cuidados para identificar golpes digitais.',
    category: 'Segurança digital',
    fileName: 'Seguranca_Digital_2_Golpes.pdf',
    icon: Icons.gpp_bad_outlined,
  ),
  DigitalGuide(
    title: 'Privacidade e LGPD',
    description: 'Entenda cuidados com dados pessoais e privacidade.',
    category: 'Segurança digital',
    fileName: 'Seguranca_Digital_3_Privacidade_LGPD.pdf',
    icon: Icons.privacy_tip_outlined,
  ),
  DigitalGuide(
    title: 'Ajustando letras, som e tela',
    description: 'Personalize o aparelho para enxergar e ouvir melhor.',
    category: 'Cuidados com o celular',
    fileName: 'Utilidades 1_ Ajustando Letras, Som e Tela para seu Conforto.pdf',
    icon: Icons.text_fields,
  ),
  DigitalGuide(
    title: 'Ferramentas do dia a dia',
    description: 'Use alarme, lanterna, câmera e leitor de QR Code.',
    category: 'Utilidades',
    fileName: 'Utilidades 2_ Ferramentas do Dia a Dia (Alarme, Lanterna, Cmera e QR Code).pdf',
    icon: Icons.build_outlined,
  ),
  DigitalGuide(
    title: 'Contatos de emergência e segurança pessoal',
    description: 'Organize contatos importantes e recursos de segurança.',
    category: 'Utilidades',
    fileName: 'Utilidades 3_ Contatos de Emergncia e Segurana Pessoal.pdf',
    icon: Icons.emergency_outlined,
  ),
];

const List<TrustedSite> trustedSites = [
  TrustedSite(name: 'Meu INSS', description: 'Pedir aposentadoria, ver extrato, consultar pedidos e fazer a prova de vida.', url: 'https://meu.inss.gov.br', category: 'Aposentadoria e INSS', phone: '135 (ligação gratuita)', icon: Icons.account_balance),
  TrustedSite(name: 'Site do INSS', description: 'Informações, cartilhas e notícias sobre benefícios.', url: 'https://www.gov.br/inss', category: 'Aposentadoria e INSS', icon: Icons.account_balance_outlined),
  TrustedSite(name: 'Simular aposentadoria', description: 'Veja quanto tempo falta e uma estimativa do valor. É apenas uma simulação.', url: 'https://www.gov.br/pt-br/servicos/simular-aposentadoria', category: 'Aposentadoria e INSS', icon: Icons.calculate_outlined),
  TrustedSite(name: 'BPC / LOAS para idosos', description: 'Um salário mínimo por mês para quem tem 65 anos ou mais e renda familiar muito baixa.', url: 'https://www.gov.br/pt-br/servicos/solicitar-beneficio-assistencial-ao-idoso', category: 'Aposentadoria e INSS', phone: '135', icon: Icons.elderly),
  TrustedSite(name: 'Cadastro Único (CadÚnico)', description: 'Porta de entrada para programas como Bolsa Família, BPC e tarifa social de energia. Atualize os dados no CRAS.', url: 'https://www.gov.br/mds/pt-br/acoes-e-programas/cadastro-unico', category: 'Assistência social e CadÚnico', icon: Icons.assignment_outlined),
  TrustedSite(name: 'Consulta do CadÚnico', description: 'Consulte se sua família está cadastrada.', url: 'https://cadunico.dataprev.gov.br', category: 'Assistência social e CadÚnico', icon: Icons.search),
  TrustedSite(name: 'Carteira da Pessoa Idosa', description: 'Documento que garante benefícios como gratuidade ou desconto no transporte interestadual, para quem tem CadÚnico.', url: 'https://carteiraidoso.cidadania.gov.br', category: 'Assistência social e CadÚnico', phone: '121 (Disque Social)', icon: Icons.card_membership_outlined),
  TrustedSite(name: 'Mapa Social: encontre o CRAS', description: 'Descubra qual é o CRAS mais próximo da sua casa.', url: 'https://mapa-social.mds.gov.br', category: 'Assistência social e CadÚnico', icon: Icons.map_outlined),
  TrustedSite(name: 'Bolsa Família', description: 'Informações sobre o programa de transferência de renda.', url: 'https://www.gov.br/mds/pt-br/acoes-e-programas/bolsa-familia', category: 'Assistência social e CadÚnico', icon: Icons.family_restroom),
  TrustedSite(name: 'Gás do Povo', description: 'Ajuda para comprar o gás de cozinha, para famílias de baixa renda do CadÚnico.', url: 'https://www.gov.br/gasdopovo', category: 'Assistência social e CadÚnico', icon: Icons.local_fire_department_outlined),
  TrustedSite(name: 'Farmácia Popular', description: 'Remédios e itens gratuitos, como alguns medicamentos de uso contínuo. Procure o selo “Aqui tem Farmácia Popular”.', url: 'https://www.gov.br/farmaciapopular', category: 'Saúde', icon: Icons.local_pharmacy_outlined),
  TrustedSite(name: 'Meu SUS Digital', description: 'Seu histórico de saúde, vacinas e autorização para retirar remédios na Farmácia Popular.', url: 'https://meususdigital.saude.gov.br', category: 'Saúde', icon: Icons.health_and_safety_outlined),
  TrustedSite(name: 'Serviços do SUS para a pessoa idosa', description: 'Cartilha do Ministério da Saúde com os serviços disponíveis.', url: 'https://www.gov.br/saude/pt-br/composicao/saps/publicacoes/cartazes-e-cartilhas/servicos-do-sus-para-pessoa-idosa.pdf', category: 'Saúde', icon: Icons.menu_book_outlined),
  TrustedSite(name: 'Ministério da Saúde e Ouvidoria do SUS', description: 'Para reclamar, elogiar ou pedir informações sobre o atendimento de saúde. No site, procure “Canais de Atendimento”.', url: 'https://www.gov.br/saude/pt-br', category: 'Saúde', phone: '136', icon: Icons.health_and_safety),
  TrustedSite(name: 'Disque 100: denúncia de violência', description: 'Para denunciar maus-tratos, abandono ou violência contra pessoa idosa. A ligação é gratuita e não é preciso se identificar.', url: 'https://www.gov.br/mdh/pt-br/servicos/denunciar-violacao-de-direitos-humanos-disque-100', category: 'Direitos, denúncias e lazer', phone: '100', icon: Icons.report_gmailerrorred_outlined),
  TrustedSite(name: 'Direitos da Pessoa Idosa', description: 'Área do Ministério dos Direitos Humanos com informações e publicações.', url: 'https://www.gov.br/mdh/pt-br/navegue-por-temas/pessoa-idosa', category: 'Direitos, denúncias e lazer', icon: Icons.gavel_outlined),
  TrustedSite(name: 'Estatuto da Pessoa Idosa', description: 'Texto oficial da lei que garante os direitos de quem tem 60 anos ou mais.', url: 'https://www.gov.br/participamaisbrasil/blob/baixar/71910', category: 'Direitos, denúncias e lazer', icon: Icons.menu_book),
  TrustedSite(name: 'Voa Brasil', description: 'Passagens aéreas de até R\$ 200 por trecho para aposentados do INSS. Exige conta gov.br nível prata ou ouro.', url: 'https://www.gov.br/voabrasil', category: 'Direitos, denúncias e lazer', icon: Icons.flight_outlined),
  TrustedSite(name: 'Fala.BR: ouvidoria do governo', description: 'Registre reclamações, sugestões ou denúncias sobre serviços públicos federais.', url: 'https://falabr.cgu.gov.br', category: 'Direitos, denúncias e lazer', icon: Icons.record_voice_over_outlined),
  TrustedSite(name: 'Portal gov.br', description: 'Entrada para todos os serviços do governo e para a sua conta gov.br.', url: 'https://www.gov.br', category: 'Direitos, denúncias e lazer', icon: Icons.account_balance_outlined),
  TrustedSite(name: 'Amazon Brasil', description: 'Loja online. Em caso de problema, use a Central de Atendimento dentro do site.', url: 'https://www.amazon.com.br', category: 'Compras e transporte por aplicativo', icon: Icons.shopping_bag_outlined),
  TrustedSite(name: 'Mercado Livre', description: 'Loja online e marketplace. Compre de vendedores bem avaliados.', url: 'https://www.mercadolivre.com.br', category: 'Compras e transporte por aplicativo', icon: Icons.storefront_outlined),
  TrustedSite(name: 'Uber: central de ajuda', description: 'Ajuda para corridas, pagamentos e segurança.', url: 'https://help.uber.com/pt-BR', category: 'Compras e transporte por aplicativo', icon: Icons.local_taxi_outlined),
  TrustedSite(name: '99 (inclui 99Pop)', description: 'Aplicativo de corridas.', url: 'https://99app.com', category: 'Compras e transporte por aplicativo', icon: Icons.directions_car_outlined),
  TrustedSite(name: '99: central de ajuda', description: 'Atendimento 24 horas, todos os dias.', url: 'https://99app.com/ajuda/', category: 'Compras e transporte por aplicativo', icon: Icons.support_agent_outlined),
  TrustedSite(name: 'Agência Brasil', description: 'Agência pública de notícias (EBC).', url: 'https://agenciabrasil.ebc.com.br', category: 'Notícias de fontes oficiais e conhecidas', icon: Icons.newspaper_outlined),
  TrustedSite(name: 'Agência Gov', description: 'Notícias do Governo Federal.', url: 'https://agenciagov.ebc.com.br', category: 'Notícias de fontes oficiais e conhecidas', icon: Icons.account_balance_outlined),
  TrustedSite(name: 'Senado Notícias', description: 'Notícias do Senado Federal.', url: 'https://www12.senado.leg.br/noticias', category: 'Notícias de fontes oficiais e conhecidas', icon: Icons.account_balance_outlined),
  TrustedSite(name: 'Agência Câmara', description: 'Notícias da Câmara dos Deputados.', url: 'https://www.camara.leg.br/noticias', category: 'Notícias de fontes oficiais e conhecidas', icon: Icons.account_balance_outlined),
  TrustedSite(name: 'g1', description: 'Portal de notícias do Grupo Globo.', url: 'https://g1.globo.com', category: 'Notícias de fontes oficiais e conhecidas', icon: Icons.newspaper),
  TrustedSite(name: 'Folha de S.Paulo', description: 'Jornal.', url: 'https://www.folha.uol.com.br', category: 'Notícias de fontes oficiais e conhecidas', icon: Icons.newspaper),
  TrustedSite(name: 'O Estado de S. Paulo', description: 'Jornal.', url: 'https://www.estadao.com.br', category: 'Notícias de fontes oficiais e conhecidas', icon: Icons.newspaper),
  TrustedSite(name: 'O Globo', description: 'Jornal.', url: 'https://oglobo.globo.com', category: 'Notícias de fontes oficiais e conhecidas', icon: Icons.newspaper),
  TrustedSite(name: 'CNN Brasil', description: 'Canal e portal de notícias.', url: 'https://www.cnnbrasil.com.br', category: 'Notícias de fontes oficiais e conhecidas', icon: Icons.newspaper),
  TrustedSite(name: 'Correio Braziliense', description: 'Jornal de Brasília.', url: 'https://www.correiobraziliense.com.br', category: 'Notícias de fontes oficiais e conhecidas', icon: Icons.newspaper),
  TrustedSite(name: 'O Povo', description: 'Jornal do Ceará.', url: 'https://www.opovo.com.br', category: 'Notícias de fontes oficiais e conhecidas', icon: Icons.newspaper),
];

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final bool isHighContrast;
  final VoidCallback onToggleDarkMode;
  final VoidCallback onToggleHighContrast;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.isHighContrast,
    required this.onToggleDarkMode,
    required this.onToggleHighContrast,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;
  String selectedCategory = 'Todos';
  String searchText = '';
  final Set<String> favorites = {};

  List<String> get categories {
    final available = documents.map((doc) => doc.category).toSet().toList()..sort();
    return ['Todos', ...available];
  }

  List<DigitalGuide> get filteredDocuments {
    return documents.where((doc) {
      final query = searchText.toLowerCase();
      final matchesSearch = doc.title.toLowerCase().contains(query) ||
          doc.description.toLowerCase().contains(query) ||
          doc.category.toLowerCase().contains(query);
      final matchesCategory =
          selectedCategory == 'Todos' || doc.category == selectedCategory;
      final matchesFavorites =
          selectedTab != 2 || favorites.contains(doc.title);
      return matchesSearch && matchesCategory && matchesFavorites;
    }).toList();
  }

  void toggleFavorite(DigitalGuide doc) {
    setState(() {
      if (!favorites.add(doc.title)) favorites.remove(doc.title);
    });
  }

  void openDocument(DigitalGuide doc) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PdfReaderPage(guide: doc),
      ),
    );
  }

  Future<void> openTrustedSite(TrustedSite site) async {
    final uri = Uri.parse(site.url);
    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!opened && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir este endereço.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir este endereço.')),
        );
      }
    }
  }

  void showHelp() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Como usar o Amparo'),
        content: const SingleChildScrollView(
          child: Text(
            '1. Pesquise pelo assunto desejado.\n\n'
            '2. Escolha uma categoria para encontrar guias específicos.\n\n'
            '3. Toque em “Ver guia” para abrir o PDF correspondente.\n\n'
            '4. Toque no coração para adicionar um guia aos favoritos.\n\n'
            '5. Na aba “Sites oficiais”, abra os endereços confiáveis.\n\n'
            '6. Utilize os botões no topo para alterar a aparência do aplicativo.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFavorites = selectedTab == 2;
    final isOfficialSites = selectedTab == 3;
    final isLibrary = selectedTab == 1;
    final highContrast = widget.isHighContrast;
    final primaryColor = highContrast ? Colors.yellow : const Color(0xFF176B60);
    final textColor = highContrast
        ? Colors.white
        : Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 76,
        backgroundColor: highContrast ? Colors.black : primaryColor,
        foregroundColor: highContrast ? Colors.yellow : Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset(
                  'assets/icon/app_icon.png',
                  width: 46,
                  height: 46,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.volunteer_activism,
                    color: Color(0xFF176B60),
                    size: 29,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amparo', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                Text('Conhecimento e cuidado', style: TextStyle(fontSize: 13)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: widget.isDarkMode ? 'Ativar tema claro' : 'Ativar tema escuro',
            onPressed: widget.onToggleDarkMode,
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode_outlined, size: 25),
          ),
          IconButton(
            tooltip: widget.isHighContrast ? 'Desativar alto contraste' : 'Ativar alto contraste',
            onPressed: widget.onToggleHighContrast,
            icon: const Icon(Icons.contrast, size: 26),
          ),
          IconButton(
            tooltip: 'Ajuda',
            onPressed: showHelp,
            icon: const Icon(Icons.help_outline, size: 27),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (selectedTab == 0) _buildWelcome(),
            if (!isOfficialSites)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
                child: TextField(
                  onChanged: (value) => setState(() => searchText = value),
                  style: TextStyle(fontSize: 18, color: textColor),
                  decoration: InputDecoration(
                    hintText: 'O que você procura?',
                    hintStyle: const TextStyle(fontSize: 17),
                    prefixIcon: const Icon(Icons.search, size: 28),
                    filled: true,
                    fillColor: highContrast ? Colors.black : Theme.of(context).colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: highContrast ? Colors.white : const Color(0xFFD8E3DE),
                      ),
                    ),
                  ),
                ),
              ),
            if (!isFavorites && !isOfficialSites)
              SizedBox(
                height: 58,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final selected = selectedCategory == category;
                    return ChoiceChip(
                      label: Text(
                        category,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          color: highContrast ? Colors.white : null,
                        ),
                      ),
                      selected: selected,
                      onSelected: (value) => setState(() => selectedCategory = category),
                      selectedColor: highContrast ? Colors.yellow.shade900 : const Color(0xFFD1E9DF),
                      backgroundColor: highContrast ? Colors.black : Theme.of(context).colorScheme.surface,
                      side: BorderSide(
                        color: highContrast
                            ? Colors.white
                            : selected
                                ? const Color(0xFF176B60)
                                : const Color(0xFFD8E3DE),
                      ),
                      showCheckmark: false,
                    );
                  },
                ),
              ),
            if (isOfficialSites)
              Expanded(child: _buildOfficialSites())
            else ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                child: Row(
                  children: [
                    Icon(
                      isFavorites ? Icons.favorite : isLibrary ? Icons.menu_book : Icons.folder_open,
                      color: primaryColor,
                      size: 27,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isFavorites ? 'Meus favoritos' : isLibrary ? 'Biblioteca de guias' : 'Aprenda a usar a tecnologia',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                      ),
                    ),
                    Text(
                      '${filteredDocuments.length} itens',
                      style: TextStyle(
                        fontSize: 14,
                        color: highContrast ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredDocuments.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                        itemCount: filteredDocuments.length,
                        itemBuilder: (context, index) => _buildDocumentCard(filteredDocuments[index]),
                      ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() {
            selectedTab = index;
            selectedCategory = 'Todos';
            searchText = '';
          });
        },
        backgroundColor: highContrast ? Colors.black : Theme.of(context).colorScheme.surface,
        indicatorColor: highContrast ? Colors.yellow.shade900 : const Color(0xFFD1E9DF),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined, size: 27), selectedIcon: Icon(Icons.home, size: 27), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.library_books_outlined, size: 27), selectedIcon: Icon(Icons.library_books, size: 27), label: 'Biblioteca'),
          NavigationDestination(icon: Icon(Icons.favorite_border, size: 27), selectedIcon: Icon(Icons.favorite, size: 27), label: 'Favoritos'),
          NavigationDestination(icon: Icon(Icons.verified_user_outlined, size: 27), selectedIcon: Icon(Icons.verified_user, size: 27), label: 'Sites oficiais'),
        ],
      ),
    );
  }

  Widget _buildWelcome() {
    final highContrast = widget.isHighContrast;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: highContrast
            ? Colors.black
            : Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF263B35)
                : const Color(0xFFE1F1E9),
        borderRadius: BorderRadius.circular(20),
        border: highContrast ? Border.all(color: Colors.white, width: 2) : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá! Que bom ter você aqui.',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: highContrast
                        ? Colors.yellow
                        : Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF174D40),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aprenda a usar a tecnologia com mais facilidade, segurança e independência.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: highContrast
                        ? Colors.white
                        : Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : const Color(0xFF315A4D),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.phone_android_rounded, size: 60, color: highContrast ? Colors.yellow : const Color(0xFF176B60)),
        ],
      ),
    );
  }

  Widget _buildOfficialSites() {
    final highContrast = widget.isHighContrast;
    final categories = trustedSites.map((site) => site.category).toSet().toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: highContrast ? Colors.black : const Color(0xFFFFF4DF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: highContrast ? Colors.white : const Color(0xFFE6C98F), width: highContrast ? 2 : 1),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.shield_outlined, color: Color(0xFF8A5A00), size: 30),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Cuidado com golpes: sites do governo brasileiro terminam em .gov.br. O INSS nunca cobra para liberar benefício nem pede senha por telefone ou mensagem. Nunca informe códigos recebidos no celular. Na dúvida, não clique em links de mensagens; use os endereços desta lista ou ligue 135 (INSS).',
                  style: TextStyle(fontSize: 15, height: 1.45),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Links confiáveis para pessoas idosas',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: highContrast ? Colors.yellow : Theme.of(context).colorScheme.onSurface),
        ),
        const SizedBox(height: 12),
        for (final category in categories) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 14, 2, 8),
            child: Text(
              category,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: highContrast ? Colors.yellow : const Color(0xFF176B60)),
            ),
          ),
          for (final site in trustedSites.where((item) => item.category == category))
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Icon(site.icon, size: 32, color: highContrast ? Colors.yellow : Theme.of(context).colorScheme.primary),
                title: Text(site.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(site.description, style: const TextStyle(fontSize: 14, height: 1.35)),
                      if (site.phone != null) ...[
                        const SizedBox(height: 5),
                        Text('Telefone: ${site.phone}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                      const SizedBox(height: 5),
                      Text(site.url, style: TextStyle(fontSize: 12, color: highContrast ? Colors.white70 : const Color(0xFF176B60))),
                    ],
                  ),
                ),
                trailing: const Icon(Icons.open_in_new, size: 22),
                onTap: () => openTrustedSite(site),
              ),
            ),
        ],
        const SizedBox(height: 12),
        Text(
          'Nota: endereços e regras de programas podem mudar. Se um link não abrir, procure o nome do serviço no portal gov.br. Os links de Amazon, 99 e dos jornais são os endereços conhecidos de cada empresa e devem ser conferidos ao abrir.',
          style: TextStyle(fontSize: 13, height: 1.4, color: highContrast ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildDocumentCard(DigitalGuide doc) {
    final isFavorite = favorites.contains(doc.title);
    final highContrast = widget.isHighContrast;
    final primaryColor = highContrast ? Colors.yellow : const Color(0xFF176B60);
    final textColor = highContrast ? Colors.white : Theme.of(context).colorScheme.onSurface;

    return Card(
      color: highContrast ? Colors.black : Theme.of(context).colorScheme.surface,
      elevation: highContrast ? 0 : 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
        side: BorderSide(
          color: highContrast ? Colors.white : Theme.of(context).colorScheme.outlineVariant,
          width: highContrast ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 64,
                  decoration: BoxDecoration(
                    color: highContrast ? Colors.black : Theme.of(context).colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(13),
                    border: highContrast ? Border.all(color: Colors.white) : null,
                  ),
                  child: Icon(doc.icon, color: primaryColor, size: 32),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doc.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(height: 6),
                      Text(
                        doc.description,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.35,
                          color: highContrast ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.picture_as_pdf_outlined, size: 18, color: highContrast ? Colors.yellow : const Color(0xFF176B60)),
                              const SizedBox(width: 4),
                              Text('Documento PDF', style: TextStyle(fontSize: 13, color: highContrast ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant)),
                            ],
                          ),
                          Text(doc.category, style: TextStyle(fontSize: 13, color: primaryColor, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: isFavorite ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
                  onPressed: () => toggleFavorite(doc),
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.redAccent : highContrast ? Colors.white : Colors.blueGrey,
                    size: 27,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: () => openDocument(doc),
                icon: const Icon(Icons.menu_book, size: 22),
                label: const Text('Ver guia', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                style: FilledButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: highContrast ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final highContrast = widget.isHighContrast;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 68, color: highContrast ? Colors.yellow : const Color(0xFF8AA79A)),
            const SizedBox(height: 16),
            Text(
              'Nenhum material encontrado',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: highContrast ? Colors.white : Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              'Tente pesquisar outro termo ou escolha uma categoria diferente.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.4, color: highContrast ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => setState(() {
                searchText = '';
                selectedCategory = 'Todos';
              }),
              child: const Text('Limpar filtros', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class PdfReaderPage extends StatelessWidget {
  final DigitalGuide guide;

  const PdfReaderPage({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(guide.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      ),
      body: SfPdfViewer.asset('assets/pdfs/${guide.fileName}'),
    );
  }
}
