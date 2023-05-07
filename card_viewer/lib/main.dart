import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
        ),
      ),
      home: const MyHomePage(
        title: 'Card Viewer',
      ),
    );
  }
}

class Movie {
  final String name;
  final int releaseYear;
  final String poster;
  final double rating;
  final String storyline;
  final String youtube;
  Movie(
      {required this.name,
      required this.releaseYear,
      required this.rating,
      required this.poster,
      required this.storyline,
      required this.youtube});
}

Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

List<Movie> movies = [
  Movie(
    name: "The Super Mario Bros. Movie",
    releaseYear: 2023,
    rating: 7.4,
    poster:
        "https://dx35vtwkllhj9.cloudfront.net/universalstudios/super-mario-bros/images/regions/us/onesheet.jpg",
    storyline:
        "A Brooklyn plumber named Mario travels through the Mushroom Kingdom with a princess named Peach and an anthropomorphic mushroom named Toad to find Mario's brother, Luigi, and to save the world from a ruthless fire-breathing Koopa named Bowser.",
    youtube: "https://www.youtube.com/watch?v=RjNcTBXTk4I",
  ),
  Movie(
      name: "The Last of Us",
      releaseYear: 2023,
      rating: 8.9,
      poster:
          "https://assets.kompasiana.com/items/album/2023/01/16/mv5bzguzyti3m2etzmm0yy00nguylwi4odetn2q3zgjlyzhhzju3xkeyxkfqcgdeqxvyntm0oty1oqatat-v1-63c50e674addee1402102c65.jpg",
      storyline:
          "20 years after modern civilization has been destroyed, Joel, a hardened survivor, is hired to smuggle Ellie, a 14-year-old girl, out of an oppressive quarantine zone. What starts as a small job soon becomes a brutal heartbreaking journey as they both must traverse the U.S. and depend on each other for survival.",
      youtube: "https://www.youtube.com/watch?v=uLtkt8BonwM")
];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PaletteGenerator? palette;
  Future<void>? _launched;

  @override
  void initState() {
    super.initState();
    getImagePalette(
      const NetworkImage(
        "https://dx35vtwkllhj9.cloudfront.net/universalstudios/super-mario-bros/images/regions/us/onesheet.jpg",
      ),
    );
  }

  Future<void> getImagePalette(ImageProvider image) async {
    palette = await PaletteGenerator.fromImageProvider(
      image,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {},
      onHorizontalDragUpdate: (details) {
        print(details.delta.dx);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final item = movies[index];
              return movieCard(context, item, palette, _launched, setState);
            }),
      ),
    );
  }
}

Widget movieCard(BuildContext context, Movie item, PaletteGenerator? palette,
    Future<void>? launched, StateSetter setState) {
  return Container(
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(item.poster),
        fit: BoxFit.cover,
      ),
    ),
    child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5,
        sigmaY: 5,
      ),
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 8,
          color: palette?.paletteColors[6].color,
          child: SizedBox(
            width: 340,
            height: 620,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: NetworkImage(item.poster),
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  child: Text(
                    item.name.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: palette?.paletteColors[1].color,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.releaseYear.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: palette?.paletteColors[3].color,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        "|",
                        style: TextStyle(
                          color: palette?.paletteColors[3].color,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.star_rate,
                      color: Colors.amber,
                    ),
                    Text(
                      '${item.rating.toString()}/10',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: palette?.paletteColors[3].color,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 20,
                  ),
                  child: Text(
                    item.storyline.toString(),
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: palette?.paletteColors[3].color,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      launched = _launchUrl(
                        Uri.parse(item.youtube),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: palette?.paletteColors[1].color,
                  ),
                  child: Text(
                    "Watch Trailer",
                    style: TextStyle(
                      color: palette?.paletteColors[1].bodyTextColor,
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
