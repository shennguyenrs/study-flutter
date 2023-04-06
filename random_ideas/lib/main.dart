import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Random Ideas',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: const MyAppPage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favWords = <WordPair>[];
  var historyList = <WordPair>[];
  GlobalKey? historyListKey;

  // Go to next word
  void getNext() {
    historyList.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  // Add word to the favorite array
  void toggleLike() {
    if (favWords.contains(current)) {
      favWords.remove(current);
    } else {
      favWords.add(current);
    }
    notifyListeners();
  }

  // Remove word from favorites list
  void removeFav(WordPair pair) {
    favWords.remove(pair);
    notifyListeners();
  }
}

class MyAppPage extends StatefulWidget {
  const MyAppPage({super.key});

  @override
  State<MyAppPage> createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  var selectedPage = 0;
  late Widget page;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!
        .copyWith(color: theme.colorScheme.onPrimary);

    switch (selectedPage) {
      case 0:
        page = const GeneratorPage();
        break;

      case 1:
        page = const FavoritesPage();
        break;

      default:
        throw UnimplementedError('no widget for $selectedPage');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Random Ideas",
            style: style,
          ),
          centerTitle: true,
          backgroundColor: theme.primaryColor,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: theme.primaryColor),
                child: const Text(
                  "Menu",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: theme.primaryColor,
                ),
                title: const Text(
                  "Home",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  setState(
                    () {
                      selectedPage = 0;
                    },
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.favorite,
                  color: theme.primaryColor,
                ),
                title: const Text(
                  "Favorites",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  setState(
                    () {
                      selectedPage = 1;
                    },
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: page,
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    late IconData icon;

    // Change the icon if the keyword is in the favorites array
    if (appState.favWords.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: HistoryListView(),
            ),
            const SizedBox(height: 5),
            BigCard(pair: pair),
            const SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: BottomButtons(appState: appState, icon: icon),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomButtons extends StatelessWidget {
  const BottomButtons({
    super.key,
    required this.appState,
    required this.icon,
  });

  final MyAppState appState;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            appState.toggleLike();
          },
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(
                width: 4,
              ),
              const Text("Like"),
            ],
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            appState.getNext();
          },
          child: const Text("Next"),
        ),
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair});

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstStyle = theme.textTheme.displayMedium!.copyWith(
        color: theme.colorScheme.onPrimary, fontWeight: FontWeight.w200);
    final secondStyle = theme.textTheme.displayMedium!.copyWith(
        color: theme.colorScheme.onPrimary, fontWeight: FontWeight.w700);

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              pair.first,
              style: firstStyle,
              semanticsLabel: pair.first,
            ),
            Text(
              pair.second,
              style: secondStyle,
              semanticsLabel: pair.second,
            )
          ],
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    if (appState.favWords.isEmpty) {
      return const Center(child: Text("No favorites"));
    }

    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child:
                Text("You have ${appState.favWords.length} favorites words:"),
          ),
          Expanded(
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
              ),
              children: [
                for (var pair in appState.favWords)
                  ListTile(
                    leading: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: theme.colorScheme.primary,
                        onPressed: () {
                          appState.removeFav(pair);
                        }),
                    title: Text(pair.asLowerCase),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryListView extends StatefulWidget {
  const HistoryListView({super.key});

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  final _key = GlobalKey();

  static const Gradient _maskingGradient = LinearGradient(
    colors: [Colors.transparent, Colors.black],
    stops: [0.0, 0.9],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        initialItemCount: appState.historyList.length,
        itemBuilder: (context, index, animation) {
          final pair = appState.historyList[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Center(
              child: Column(
                children: [
                  Text(
                    pair.asLowerCase,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
