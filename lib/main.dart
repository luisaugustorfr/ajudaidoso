import 'package:flutter/material.dart';

void main() {
  runApp(const AmparoApp());
}

class AmparoApp extends StatelessWidget {
  const AmparoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amparo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF176B60),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8F6),
      ),
      home: const HomePage(),
    );
  }
}

class PdfDocument {
  final String title;
  final String description;
  final String category;
  final IconData icon;
  final String url;

  const PdfDocument({
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.url,
  });
}

const List<PdfDocument> documents = [
  PdfDocument(
    title: 'Guia de Saúde do Idoso',
    description: 'Cuidados com a saúde e qualidade de vida.',
    category: 'Saúde',
    icon: Icons.health_and_safety_outlined,
    url: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  ),
  PdfDocument(
    title: 'Direitos da Pessoa Idosa',
    description: 'Conheça seus direitos e benefícios.',
    category: 'Direitos',
    icon: Icons.gavel_outlined,
    url: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  ),
  PdfDocument(
    title: 'Celular sem Complicação',
    description: 'Aprenda a usar aplicativos e mensagens.',
    category: 'Tecnologia',
    icon: Icons.smartphone_outlined,
    url: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  ),
  PdfDocument(
    title: 'Alimentação Saudável',
    description: 'Dicas para uma alimentação equilibrada.',
    category: 'Saúde',
    icon: Icons.restaurant_outlined,
    url: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  ),
  PdfDocument(
    title: 'Bem-estar e Lazer',
    description: 'Atividades para o corpo e a mente.',
    category: 'Bem-estar',
    icon: Icons.spa_outlined,
    url: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  ),
  PdfDocument(
    title: 'Segurança na Internet',
    description: 'Aprenda a identificar golpes digitais.',
    category: 'Tecnologia',
    icon: Icons.shield_outlined,
    url: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  ),
  PdfDocument(
    title: 'Exercícios para o Dia a Dia',
    description: 'Movimentos leves para uma rotina ativa.',
    category: 'Bem-estar',
    icon: Icons.directions_walk_outlined,
    url: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  ),
  PdfDocument(
    title: 'Benefícios Sociais',
    description: 'Informações sobre serviços e benefícios.',
    category: 'Direitos',
    icon: Icons.volunteer_activism_outlined,
    url: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  ),
];

const List<String> categories = [
  'Todos',
  'Saúde',
  'Direitos',
  'Tecnologia',
  'Bem-estar',
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;
  String selectedCategory = 'Todos';
  String searchText = '';

  final Set<String> favorites = {};

  List<PdfDocument> get filteredDocuments {
    return documents.where((doc) {
      final query = searchText.toLowerCase();

      final matchesSearch =
          doc.title.toLowerCase().contains(query) ||
          doc.description.toLowerCase().contains(query);

      final matchesCategory =
          selectedCategory == 'Todos' ||
          doc.category == selectedCategory;

      final matchesFavorites =
          selectedTab != 2 || favorites.contains(doc.title);

      return matchesSearch &&
          matchesCategory &&
          matchesFavorites;
    }).toList();
  }

  void toggleFavorite(PdfDocument doc) {
    setState(() {
      if (favorites.contains(doc.title)) {
        favorites.remove(doc.title);
      } else {
        favorites.add(doc.title);
      }
    });
  }

  void openDocumentInfo(PdfDocument doc) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.picture_as_pdf,
            color: Color(0xFF176B60),
            size: 48,
          ),
          title: Text(doc.title),
          content: SelectableText(
            '${doc.description}\n\n'
            'Endereço do documento:\n${doc.url}',
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void showHelp() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Como usar o Amparo'),
          content: const Text(
            '1. Pesquise pelo nome do material.\n\n'
            '2. Escolha uma categoria para filtrar os documentos.\n\n'
            '3. Toque no coração para adicionar um favorito.\n\n'
            '4. Acesse a aba Favoritos para encontrar os materiais salvos.\n\n'
            '5. Toque em Abrir PDF para consultar as informações do documento.',
            style: TextStyle(
              fontSize: 17,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Entendi'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFavorites = selectedTab == 2;
    final isLibrary = selectedTab == 1;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 76,
        backgroundColor: const Color(0xFF176B60),
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.volunteer_activism,
                color: Color(0xFF176B60),
                size: 29,
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amparo',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Conhecimento e cuidado',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Ajuda',
            onPressed: showHelp,
            icon: const Icon(
              Icons.help_outline,
              size: 29,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (selectedTab == 0) _buildWelcome(),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'O que você procura?',
                  hintStyle: const TextStyle(fontSize: 17),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 28,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFD8E3DE),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFD8E3DE),
                    ),
                  ),
                ),
              ),
            ),            if (!isFavorites)
              SizedBox(
                height: 58,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 6,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final selected = selectedCategory == category;

                    return ChoiceChip(
                      label: Text(
                        category,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      selected: selected,
                      onSelected: (value) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      selectedColor: const Color(0xFFD1E9DF),
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: selected
                            ? const Color(0xFF176B60)
                            : const Color(0xFFD8E3DE),
                      ),
                      showCheckmark: false,
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
              child: Row(
                children: [
                  Icon(
                    isFavorites
                        ? Icons.favorite
                        : isLibrary
                            ? Icons.menu_book
                            : Icons.folder_open,
                    color: const Color(0xFF176B60),
                    size: 27,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isFavorites
                          ? 'Meus favoritos'
                          : isLibrary
                              ? 'Biblioteca de PDFs'
                              : 'Materiais para você',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF23443C),
                      ),
                    ),
                  ),
                  Text(
                    '${filteredDocuments.length} itens',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredDocuments.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        16, 4, 16, 20,
                      ),
                      itemCount: filteredDocuments.length,
                      itemBuilder: (context, index) {
                        return _buildDocumentCard(
                          filteredDocuments[index],
                        );
                      },
                    ),
            ),
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
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFD1E9DF),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, size: 27),
            selectedIcon: Icon(Icons.home, size: 27),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books_outlined, size: 27),
            selectedIcon: Icon(Icons.library_books, size: 27),
            label: 'Biblioteca',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border, size: 27),
            selectedIcon: Icon(Icons.favorite, size: 27),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }

  Widget _buildWelcome() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE1F1E9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
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
                    color: Color(0xFF174D40),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Encontre informações úteis para viver com '
                  'mais saúde, segurança e independência.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: Color(0xFF315A4D),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Icon(
            Icons.menu_book_rounded,
            size: 60,
            color: Color(0xFF176B60),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(PdfDocument doc) {
    final isFavorite = favorites.contains(doc.title);

    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
        side: const BorderSide(
          color: Color(0xFFE1E9E4),
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
                    color: const Color(0xFFE1F1E9),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    doc.icon,
                    color: const Color(0xFF176B60),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF253E35),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        doc.description,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.35,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        crossAxisAlignment:
                            WrapCrossAlignment.center,
                        children: [
                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.picture_as_pdf,
                                size: 18,
                                color: Color(0xFFB44343),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Documento PDF',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF7B4646),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            doc.category,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF176B60),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: isFavorite
                      ? 'Remover dos favoritos'
                      : 'Adicionar aos favoritos',
                  onPressed: () => toggleFavorite(doc),
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: isFavorite
                        ? Colors.redAccent
                        : Colors.blueGrey,
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
                onPressed: () => openDocumentInfo(doc),
                icon: const Icon(
                  Icons.picture_as_pdf,
                  size: 22,
                ),
                label: const Text(
                  'Abrir PDF',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF176B60),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off,
              size: 68,
              color: Color(0xFF8AA79A),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhum material encontrado',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tente pesquisar outro termo ou escolha '
              'uma categoria diferente.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  searchText = '';
                  selectedCategory = 'Todos';
                });
              },
              child: const Text(
                'Limpar filtros',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}