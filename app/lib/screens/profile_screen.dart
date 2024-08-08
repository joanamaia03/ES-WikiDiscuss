import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wiki_discuss/screens/sign_in_screen.dart';
import 'package:wiki_discuss/widgets/firebase_ui_button.dart';
import '../resources/auth_methods.dart';
import '../resources/setting_methods.dart';
import '../resources/storage_methods.dart';
import '../utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  var userData = {};
  final TextEditingController nameController = TextEditingController();
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    getData();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    String? url = await StorageMethods().getDownloadUrl(
        "profile_images/${FirebaseAuth.instance.currentUser!.uid}");
    if (mounted) {
      setState(() {
        _profileImageUrl = url;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImageUrl = null;
      });
      File imageFile = File(pickedFile.path);
      String downloadUrl = await StorageMethods()
          .uploadImageToStorage("profile_images", imageFile.readAsBytesSync());
      setState(() {
        _profileImageUrl = downloadUrl;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void updateName(String newName) async {
    setState(() {
      isLoading = true;
    });
    try {
      final User user = auth.currentUser!;
      await FirebaseFirestore.instance.collection('users')
          .doc(user.uid)
          .update({'username': newName});
      userData['username'] = newName;
      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final User user = auth.currentUser!;
      var userSnap = await FirebaseFirestore.instance.collection('users')
          .doc(user.uid)
          .get();

      userData = userSnap.data()!;
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loadingIndicator()
        : Scaffold(
          backgroundColor: mode.background,
          appBar: buildAppBar(context),
          body: buildBody(context),
        );
  }

  Widget loadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: mode.background,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          key: ValueKey("BackIconButton"),
        ),
        color: mode.letters,
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Profile',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: mode.letters,
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        buildProfileSection(context),
        buildLogoutButton(context),
      ],
    );
  }

  Widget buildProfileSection(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          const SizedBox(height: 30),
          buildProfilePicture(),
          const SizedBox(height: 64),
          buildDetailsSection(),
        ],
      ),
    );
  }

  Widget buildProfilePicture() {
    return CircleAvatar(
      radius: 100,
      child: Stack(
        children: [
          GestureDetector(
            child: ClipOval(
              child: _profileImageUrl != null
                  ? Image.network(
                _profileImageUrl!,
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              )
                  : Image.asset(
                "lib/assets/profile_photo.jpg",
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueGrey,
              ),
              child: IconButton(
                icon: const Icon(Icons.image),
                color: mode.background,
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildNameSection(),
          const SizedBox(height: 24),
          buildEmailSection(),
        ],
      ),
    );
  }

  Widget buildNameSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: TextStyle(
                color: mode.letters,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              userData['username']!,
              style: TextStyle(
                color: mode.letters,
                fontSize: 18,
              ),
            ),
          ],
        ),
        buildNameEditButton(),
      ],
    );
  }

  Widget buildNameEditButton() {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Update Nam",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildNameUpdateField(),
                    const SizedBox(height: 16),
                    buildNameSaveButton(),
                  ],
                ),
              ),
            );
          },
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(mode.background),
        // Other button style properties can also be set here.
      ),
      child: Icon(Icons.edit,color:mode.letters),
    );
  }

  Widget buildNameUpdateField() {
    return TextFormField(
      controller: nameController,
      style: const TextStyle(
        fontSize: 18,
      ),
      decoration: InputDecoration(
        labelText: "New Name",
        labelStyle: TextStyle(
          color: mode.letters,
          fontSize: 18,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: mode.letters),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: mode.background),
        ),
      ),
    );
  }

  Widget buildNameSaveButton() {
    return ElevatedButton(
      onPressed: () {
        updateName(nameController.text);
        Navigator.pop(context);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(mode.background),
        // Other button style properties can also be set here.
      ),
      child: const Text(
        "Save",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildEmailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Email Address',
          style: TextStyle(
            color: mode.letters,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          userData['email']!,
          style: TextStyle(
            color: mode.letters,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: firebaseUIButton(context, 'Logout', () async {
        await AuthMethods().signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
              (route) => false,
        );
      }),
    );
  }
}