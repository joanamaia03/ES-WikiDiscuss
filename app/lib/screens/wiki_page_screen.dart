import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wiki_discuss/resources/firestore_methods.dart';
import 'package:wiki_discuss/resources/setting_methods.dart';
import 'package:wiki_discuss/screens/chat_screen.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wiki_discuss/screens/wiki_page_screen.dart';


class WikiPageScreen extends StatefulWidget {
  final String title;
  final String id;
  //const WikiPageScreen({super.key, required this.title,required this.id});

  const WikiPageScreen({Key? key, required this.title, required this.id}) : super(key: key);

  @override
  WikiPageScreenState createState() => WikiPageScreenState();
}

class WikiPageScreenState extends State<WikiPageScreen> {
  late WebViewController _webViewController;
  bool _isLoadingPage = true;
  double _loadingProgress = 0;
  ValueNotifier<bool> _canGoBackNotifier = ValueNotifier<bool>(false);
  String currentTitle = '';
  String currentId = '';
  FireStoreMethods methods = FireStoreMethods();
  List<Map<String, String>> browsingStack = [];

  @override
  void initState() {
    super.initState();
    currentTitle = widget.title;
    currentId = widget.id;
  }

  String _parseTitleFromUrl(String url) {
    var uri = Uri.parse(url);
    var pathSegments = uri.pathSegments;
    if (pathSegments.length > 1 && pathSegments.first == 'wiki') {
      // Directly decode the URL segment and replace underscores with spaces in the title
      String title = pathSegments[1];
      title = title.replaceAll('%20', ' ');
      title = title.replaceAll('_', ' ');
      return title;
    }
    return '';
  }

  Future<String> _getIdFromWikipediaAPI(String title) async {
    final response = await http.get(
      Uri.parse(
        'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=info&utf8=1&titles=$title',
      ),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['query'] == null) {
        throw Exception('No page found with the specified title');
      } else {
        final pages = data['query']['pages'];
        if (pages is Map<String, dynamic>) {
          // The keys of the 'pages' map are the page IDs. We'll return the first one.
          return pages.keys.first;
        }
      }
    } else {
      throw Exception('Failed to retrieve page ID');
    }
    return '';
  }

  Future<String> getIdForTitle(String title) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('pages')
        .where('title', isEqualTo: title)
        .get();

    if (snapshot.docs.isEmpty) {
      return '';
    } else {
      return snapshot.docs.first.id; // Return the ID of the first (and likely only) matching document
    }
  }

  Future<bool> _canGoBack() async {
    return await _webViewController.canGoBack();
  }

  Future<void> updateCanGoBack() async {
    _canGoBackNotifier.value = await _webViewController.canGoBack();
  }

  Future<void> _goBack() async {
    if (await _webViewController.canGoBack()) {
      browsingStack.removeLast();  // Pop the current page off the stack

      if (browsingStack.isNotEmpty) {
        // Update the current ID and title to match the new top of the stack
        Map<String, String> lastPage = browsingStack.last;
        currentId = lastPage['id']!;
        currentTitle = lastPage['title']!;
      } else {
        // If there's nothing else on the stack, just use empty strings
        currentId = '';
        currentTitle = '';
      }

      await _webViewController.goBack();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final FireStoreMethods _firestoreService = FireStoreMethods();
    return Scaffold(
      key: ValueKey('WikiPageScreen:' + widget.title),
      appBar: buildAppBar(context),
      body: buildBody(context, _firestoreService),
      floatingActionButton: buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: mode.background,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          size: 32,
        ),
        color:mode.letters,
        onPressed: () => _goBack(),
      ),
      title: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Text(
          'Wiki Discuss',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 30.0,
              color: mode.letters,
              height: 0.8,
              fontWeight: FontWeight.bold,
              fontFamily: 'Asar'
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget buildBody(BuildContext context, FireStoreMethods _firestoreService) {
    return Stack(
      children: [
        buildWebView(context, _firestoreService),
        if (_isLoadingPage)
          const Center(
            child: CircularProgressIndicator(),
          ),
        if (_loadingProgress < 1 && !_isLoadingPage)
          LinearProgressIndicator(
            value: _loadingProgress,
            backgroundColor:mode.letters,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
      ],
    );
  }

  WebView buildWebView(BuildContext context, FireStoreMethods _firestoreService) {
    return WebView(
      initialUrl:
      'https://en.m.wikipedia.org/wiki/${widget.title}?mobileaction=toggle_view_mobile',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _webViewController = webViewController;
      },
      onPageStarted: (_) {
        setState(() {
          _isLoadingPage = true;
          _loadingProgress = 0;
        });
      },
      onPageFinished: (_) {
        setState(() {
          _isLoadingPage = false;
          _loadingProgress = 1;
        });
        updateCanGoBack();
      },
      onProgress: (int progress) {
        setState(() {
          _loadingProgress = progress / 100;
        });
      },
      navigationDelegate: (NavigationRequest request) async {
        String newTitle = _parseTitleFromUrl(request.url);

        if(newTitle.isNotEmpty){
          String newId = await _getIdFromWikipediaAPI(newTitle);
          _firestoreService.incPage(newId, newTitle);
          currentTitle = newTitle;
          currentId = newId;

          // Push the new page to the stack
          browsingStack.add({'id': newId, 'title': newTitle});
        }

        return NavigationDecision.navigate;
      },
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.cyanAccent,
      onPressed: () async {
        if (currentId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(name: currentTitle,id: currentId),
            ),
          );
        } else {
          print('Error: currentId is empty\n');
        }
      },
      child: const Icon(
        Icons.chat,
        key: ValueKey("ChatIconButton"),
      ),
    );
  }

}