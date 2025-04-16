import 'dart:async';
import 'package:flutter/material.dart';
import '../models/adventure.dart';
import '../models/game_state.dart';

// TODO: Import models (Adventure, Scenario) when needed
// TODO: Import controller/provider when needed

/// MainScreenView representa a tela principal da aplicação,
/// exibindo banners, aventuras em andamento e opções de cenários.
class MainScreenView extends StatefulWidget {
  const MainScreenView({super.key});

  @override
  State<MainScreenView> createState() => _MainScreenViewState();
}

class _MainScreenViewState extends State<MainScreenView> {
  // Controlador para o PageView dos banners
  final PageController _bannerController = PageController();
  // Timer para alternar os banners automaticamente
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    // Inicia o timer quando o widget é criado
    _startBannerTimer();
  }

  @override
  void dispose() {
    // Cancela o timer e descarta o controller quando o widget é removido
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  // Método para iniciar o timer de rotação dos banners
  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_bannerController.hasClients) {
        final nextPage = (_bannerController.page?.round() ?? 0) + 1;
        const int itemCount = 3; // Número de banners
        _bannerController.animateToPage(
          nextPage >= itemCount ? 0 : nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Reinicia o timer quando o usuário interage manualmente
  void _onBannerManualInteraction() {
    _bannerTimer?.cancel();
    _startBannerTimer();
  }

  @override
  Widget build(BuildContext context) {
    // Dados simulados para layout
    final ongoingAdventures = <Map<String, dynamic>>[
      {
        'title': 'The Crystal Cave',
        'progress': 90,
        'image': 'assets/images/banner_image_1.jpg',
        'progressValue': 0.9
      },
      {
        'title': 'Shadows over Neon City',
        'progress': 60,
        'image': 'assets/images/banner_image_1.jpg',
        'progressValue': 0.6
      },
      {
        'title': 'The Emerald Forest dos dias comprido para testes estranhos',
        'progress': 10,
        'image': 'assets/images/banner_image_1.jpg',
        'progressValue': 0.1
      },
    ];

    final scenarios = <Map<String, String>>[
      {
        'title': 'The Lost Temple',
        'genre': 'Fantasy',
        'description': 'Explore ancient ruins and uncover hidden secrets in a mysterious temple.',
        'image': 'assets/images/banner_image_2.jpg'
      },
      {
        'title': 'Cyberpunk Heist',
        'genre': 'Sci‑Fi',
        'description': 'Plan and execute a high‑stakes heist in a futuristic cyberpunk city.',
        'image': 'assets/images/banner_image_2.jpg'
      },
      {
        'title': 'Cosmic Horror',
        'genre': 'Horror',
        'description': 'Face unknown terrors and unravel cosmic mysteries beyond our reality.',
        'image': 'assets/images/banner_image_2.jpg'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('RPG Adventures'), // TODO: substituir por logo
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Instructions',
            onPressed: () => Navigator.pushNamed(context, '/instructions'),
          ),
          IconButton(
            icon: const Icon(Icons.subscriptions_outlined),
            tooltip: 'Subscription',
            onPressed: () => Navigator.pushNamed(context, '/subscription'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // === Banner ===
          SliverToBoxAdapter(
            child: SizedBox(
              height: 400,
              child: PageView.builder(
                controller: _bannerController,
                itemCount: 3,
                onPageChanged: (_) => _onBannerManualInteraction(),
                itemBuilder: (ctx, i) {
                  final imgs = [
                    'assets/images/banner_image_1.jpg',
                    'assets/images/banner_image_2.jpg',
                    'assets/images/banner_image_3.jpg',
                  ];
                  const shade = 0.6;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      // Imagem de fundo
                      Image.asset(imgs[i], fit: BoxFit.cover),
                      // Sombreamento escuro
                      Container(color: Colors.black.withOpacity(shade)),
                      // Conteúdo do banner
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Título da Aventura ${i + 1}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Gênero de Exemplo',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.white70),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                'Descrição da aventura ${i + 1}. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/chat',
                                  arguments: {
                                    'adventureId': 'banner_${i + 1}',
                                    'adventureTitle': 'Título da Aventura ${i + 1}',
                                  },
                                );
                              },
                              child: const Text('Iniciar Aventura'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // === Ongoing Adventures ===
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
              child: Text(
                'Ongoing Adventures',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.blue.shade300),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: ongoingAdventures.map((adv) => Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: _buildAdventureCard(
                      context,
                      title: adv['title'],
                      imagePath: adv['image'],
                      progressValue: adv['progressValue'],
                      progress: adv['progress'],
                      onContinue: () {
                        Navigator.pushNamed(context, '/chat',
                            arguments: {
                              'adventureId': 'adventure_${ongoingAdventures.indexOf(adv) + 1}',
                              'adventureTitle': adv['title'],
                            });
                      },
                    ),
                  )).toList(),
                ),
              ),
            ),
          ),

          // === Available Scenarios ===
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 32, 8, 8),
              child: Text(
                'Available Scenarios',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.blue.shade300),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: scenarios.map((s) => ScenarioCard(
                  title: s['title']!,
                  genre: s['genre']!,
                  description: s['description']!,
                  imagePath: s['image']!,
                  onStart: () {
                    Navigator.pushNamed(context, '/chat',
                        arguments: {
                          'adventureId': 'new_${s['title']}',
                          'adventureTitle': s['title'],
                        });
                  },
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para os cards de aventura
Widget _buildAdventureCard(
  BuildContext context, {
  required String title,
  required String imagePath,
  required double progressValue,
  required int progress,
  required VoidCallback onContinue,
}) {
  const shade = 0.4;
  return Container(
    width: 288,
    height: 132, // Altura fixa para manter consistência (126 + 6)
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
      ],
    ),
    child: Stack(
      fit: StackFit.expand,
      children: [
        // Imagem de fundo
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
        // Sombreamento escuro
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.black.withOpacity(shade),
          ),
        ),
        // Conteúdo do card
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 8),
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: LinearProgressIndicator(
                      value: progressValue,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade300),
                      minHeight: 17.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Text(
                      '$progress% uncovered',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Center(
                  child: ElevatedButton(
                    onPressed: onContinue,
                    child: const Text('Continue'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


/// ScenarioCard: Cartão fixo que exibe descrição completa e botão Start sempre.
class ScenarioCard extends StatelessWidget {
  final String title;
  final String genre;
  final String description;
  final String imagePath;
  final VoidCallback onStart;

  const ScenarioCard({
    Key? key,
    required this.title,
    required this.genre,
    required this.description,
    required this.imagePath,
    required this.onStart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const shade = 0.4;
    return Container(
      width: 216,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(genre, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
          const SizedBox(height: 8),
          Text(description, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: onStart, child: const Text('Start'))),
        ],
      ),
    );
  }
}

// === DOCUMENTAÇÃO ===
// [ID: 006] 16/04/2025 - Ajustes nos cards de Ongoing Adventures
// - Aumento da largura em 20% (240 → 288)
// - Altura ajustada (180 → 126 → 132)
// - Alinhamento do texto de progresso à esquerda
// - Mudança da cor do texto de progresso para preto
// - Bordas arredondadas na barra de progresso
// - Centralização vertical do texto na barra
// - Botão "Continue" abaixado em 15px
// - Grossura da barra aumentada (12 → 13.2 → 23.2)
// - Overflow com "..." para títulos longos
// - Ajustes de espaçamento interno
// [ID: 005] 16/04/2025 - Cada widget controla sua própria altura
// - Ongoing Adventures: substituído SizedBox/SliverToBoxAdapter por SingleChildScrollView+Row
// - Available Scenarios: substituído SliverGrid por Wrap para altura dinâmica
// [ID: 004] 16/04/2025 - Banner agora rola junto com o scroll
// [ID: 003] 16/04/2025 - Cards de Ongoing Adventures restaurados (altura reduzida em 20%)
// [ID: 002] 16/04/2025 - Cards de Cenário Ajustados sem expansão
// [ID: 001] 16/04/2025 - Auto‑scroll do banner

// === INSTRUÇÕES FUTURAS ===
// - Ajustar paddings e espaçamentos conforme UX desejado
// - Substituir dados simulados por provider/controller
