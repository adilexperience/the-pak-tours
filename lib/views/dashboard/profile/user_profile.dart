import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';
import 'package:the_pak_tours/models/models_exporter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class TouristProfileScreen extends StatefulWidget {
  const TouristProfileScreen({Key? key}) : super(key: key);

  @override
  _TouristProfileScreenState createState() => _TouristProfileScreenState();
}

class _TouristProfileScreenState extends State<TouristProfileScreen> {
  late UserModel _user;
  File? _selectedImage;

  final TextEditingController _usernameController = TextEditingController();

  bool _isLoading = true, isProfileLoading = false;

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightText.withOpacity(0.10),
      body: Stack(
        children: [
          _isLoading
              ? Positioned.fill(
                  child: Stack(
                    children: [
                      Container(
                        color: AppColors.strongText.withOpacity(0.25),
                      ),
                      const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                )
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PrimaryCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                "Update Profile",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5.0),
                              const Text(
                                "Easily update your profile picture or username. It's never been easy before",
                                style: TextStyle(
                                  color: AppColors.lightText,
                                  fontSize: 13.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 40.0),
                              Row(
                                children: [
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundColor: AppColors.lightText
                                            .withOpacity(0.45),
                                        backgroundImage: _selectedImage ==
                                                    null &&
                                                _user.imageUrl.isEmpty
                                            ? const AssetImage(
                                                "assets/images/user.png",
                                              )
                                            : _selectedImage != null
                                                ? FileImage(_selectedImage!)
                                                : NetworkImage(_user.imageUrl)
                                                    as ImageProvider,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: isProfileLoading
                                            ? const GlassmorphismedWidget(
                                                padding: EdgeInsets.all(5.0),
                                                child: Center(
                                                  child:
                                                      CupertinoActivityIndicator(),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () =>
                                                    _processImageUpload(),
                                                child:
                                                    const GlassmorphismedWidget(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    Icons.image,
                                                    size: 20.0,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 20.0),
                                  Text(
                                    _user.name,
                                    style: const TextStyle(
                                      color: AppColors.strongText,
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40.0),
                              InputField(
                                controller: _usernameController,
                                leadingIcon: Icons.person,
                                fieldHint: _user.name,
                              ),
                              const SizedBox(height: 40.0),
                              PrimaryButton(
                                onPressed: () => _processUpdate(),
                                buttonText: "Update Profile",
                              ),
                              const SizedBox(height: 40.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  PrimaryButton(
                                    onPressed: () =>
                                        ApiRequests.signOut(context),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 20.0,
                                    ),
                                    buttonColor: Colors.white,
                                    buttonText: "Logout",
                                    buttonTextColor: Colors.black,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void _getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _user = await ApiRequests.getLoggedInUser();
      _isLoading = false;
      setState(() {});
    }
  }

  void _processUpdate() async {
    String newName = _usernameController.text.trim();
    if (newName.isEmpty || newName == _user.name) {
      showTopSnackBar(
        context,
        const CustomSnackBar.error(message: "Please enter new name to proceed"),
      );
      return;
    }
    if (newName.isNotEmpty) {
      setState(() {
        FocusScope.of(context).unfocus();
        _isLoading = true;
      });
      ApiRequests.updateUsername(_usernameController.text.trim()).then((value) {
        _usernameController.clear();
        _getUser();
      }).onError((error, stackTrace) {
        _showError(error.toString());
      });
    }
  }

  _showError(String error) {
    setState(() {
      _isLoading = false;
    });
    showTopSnackBar(context, CustomSnackBar.error(message: error));
  }

  void _processImageUpload() async {
    isProfileLoading = true;
    setState(() {});
    await _pickImage();

    await ApiRequests.uploadSelectedImage(_selectedImage!)
        .then((imageURL) async {
      await ApiRequests.updateProfileImageURL(imageURL);
      _getUser();
    });

    isProfileLoading = false;
    setState(() {});
  }

  Future<void> _pickImage() async {
    ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) _selectedImage = File(image.path);
    setState(() {});
  }
}
