import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wiki_discuss/resources/firestore_methods.dart';
import 'package:wiki_discuss/screens/follows_screen.dart';
import 'package:wiki_discuss/screens/profile_screen.dart';
import 'package:wiki_discuss/screens/help_screen.dart';
import 'dart:convert';
import '../resources/setting_methods.dart';
import '../widgets/wiki_discuss.dart';
import 'wiki_page_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  String searchText = '';
  bool isLoading = false;
  List<dynamic> searchResults = [];
  List<dynamic> popularTitles = [];
  FireStoreMethods methods = FireStoreMethods();
  List<bool> isSelected = [mode.isLight, !mode.isLight];

  @override
  void initState() {
    super.initState();
    fetchMostPopularTitles();
    mode.addListener(listener);
  }
  listener(){
    if(mounted) {
      setState(() {});
    }
  }
  @override
  void dispose() {
    mode.removeListener(listener);
    super.dispose();
  }

  Map<String, dynamic> fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return snapshot;
  }

  void fetchMostPopularTitles() async {
    setState(() {
      isLoading = true;
    });
    final snapshot = await FirebaseFirestore.instance
        .collection('pages')
        .orderBy('count', descending: true)
        .limit(10)
        .get();
    setState(() {
      popularTitles = snapshot.docs.map(fromSnap).toList();
      isLoading = false;
    });
  }

  void _onSearchTextChanged(String value) {
    setState(() {
      searchText = value;
    });
    if (searchText.isEmpty) {
      // Clear searchResults when searchText is empty
      setState(() {
        searchResults = [];
      });
    } else {
      _searchWikiPages();
    }
  }

  Future<void> _searchWikiPages() async {
    final response = await http.get(
      Uri.parse(
          'https://en.wikipedia.org/w/api.php?action=query&format=json&list=search&utf8=1&srsearch=$searchText'),
    );
    if (response.statusCode == 200) {
      if (json.decode(response.body)['query'] == null) {
        setState(() {
          searchResults = [];
        });
      } else {
        setState(() {
          searchResults = json.decode(response.body)['query']['search'];
        });
      }
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : buildScaffold(context);
  }

  Widget buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: mode.background,
      body: buildBody(context),
      endDrawer: buildEndDrawer(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        buildPadding(context),
        buildPositioned(context),
      ],
    );
  }

  Widget buildPadding(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 96, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WikiDiscuss(),
          const SizedBox(height: 40), // Increased height for more space
          buildTextField(),
          const SizedBox(height: 25), // Decreased height for less space
          if (searchText.isEmpty)
             Text(
              '   Most Searched Pages:',
              style: TextStyle(color: mode.letters, fontSize: 18,
              fontWeight: FontWeight.bold),
            ),
          if (searchText.isNotEmpty)
            Text(
              '   Results pages:',
              style: TextStyle(color: mode.letters, fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          buildExpanded(context),
        ],
      ),
    );
  }

  Widget buildTextField() {
    return TextField(
      key: const ValueKey('SearchTextField'),
      decoration: InputDecoration(
        hintText: 'Search Wikipedia pages',
        hintStyle: TextStyle(color: mode.letters),
        //hintStyle: TextStyle(color: Colors.white60, fontSize: 17),
        prefixIcon: Icon(
          Icons.search,
          color: mode.letters,
        ),
      ),
      style: TextStyle(
        color: mode.letters,
      ),
      onChanged: _onSearchTextChanged,
    );
  }

  Widget buildExpanded(BuildContext context) {
    return Expanded(
      child: searchText.isNotEmpty && searchResults.isEmpty
          ? Center(child: Text('No results found', style: TextStyle(color: mode.letters)))
          : buildListViewBuilder(context),
    );
  }

  Widget buildListViewBuilder(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: searchText.isNotEmpty
          ? searchResults.length
          : popularTitles.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> results = searchText.isNotEmpty
            ? searchResults[index]
            : popularTitles[index];
        return ListTile(
          title: Text(
            results['title']!,
            style: TextStyle(color: mode.letters),
          ),
          onTap: () {
            methods.incPage(
              results['pageid']!.toString(),
              results['title']!,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WikiPageScreen(
                  title: results['title']!,
                  id: results['pageid']!.toString(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildPositioned(BuildContext context) {
    return Positioned(
      top: 72,
      right: 16,
      child: Builder(
        builder: (context) => IconButton(
          key: const ValueKey("MenuIconButton"),
          icon: Icon(
            Icons.menu,
            color: mode.letters,
            size: 32,
          ),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ),
    );
  }

  Widget buildEndDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: mode.isLight ? Colors.grey[200] : Colors.grey[900], // set the color here
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 70),
                children: [
                  buildListTile(context, Icons.person, 'Profile', const ProfileScreen()),
                  buildListTile(context, CupertinoIcons.bookmark_fill, 'Followed Pages', const FollowedScreen()),
                  buildListTile(context, Icons.help, 'Help', const HelpScreen()),
                  //buildListTile(context, Icons.settings, 'Settings', const SettingsScreen()),
                ],
              ),
            ),
            buildSwitchListTile(),
          ],
        ),
      ),
    );
  }

  Widget buildSwitchListTile() {
    return ListTile(
      trailing: ToggleButtons(
        borderColor: Colors.transparent,
        fillColor: Colors.transparent,
        borderWidth: 0,
        selectedBorderColor: Colors.transparent,
        selectedColor: Colors.transparent,
        borderRadius: BorderRadius.circular(0),
        onPressed: (int index) {
          setState(() {
            for (int i = 0; i < isSelected.length; i++) {
              if (i == index) {
                isSelected[i] = true;
                mode.switchmode(i == 0); // change mode when button is pressed
              } else {
                isSelected[i] = false;
              }
            }
          });
        },
        isSelected: isSelected,
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return RotationTransition(child: child, turns: animation);
            },
            child: Icon(
              isSelected[0] ? Icons.wb_sunny : Icons.wb_sunny_outlined,
              color: mode.letters,
              key: Key(isSelected[0] ? '1' : '2'),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return RotationTransition(turns: animation, child: child);
            },
            child: Icon(
              isSelected[1] ? Icons.nights_stay : Icons.nights_stay_outlined,
              color: mode.letters,
              key: Key(isSelected[1] ? '3' : '4'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListTile(BuildContext context, IconData icon, String text, Widget screen) {
    return ListTile(
      leading: Icon(
          icon,
          color: mode.letters,
      ),
      title: Text(
          text,
          style: TextStyle(color: mode.letters)
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => screen,
          ),
        );
      },
    );
  }

}
