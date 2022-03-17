import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mdi/mdi.dart';
import 'package:todo/models/user.dart';
import 'package:todo/screens/home.dart';
import 'package:todo/widgets/custom_appBar.dart';
import 'package:todo/helpers/firebase.dart';
import 'package:todo/widgets/custom_button.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  bool loading = false, autoValidate = false;
  File image;
  final picker = ImagePicker();

  User userInfo = User();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  DateFormat dobFormatter = DateFormat("dd MMM yyyy");

  @override
  void initState() {
    super.initState();
    firebase.getUserInfo(uid: firebase.getCurrentUser().uid).then((user) {
      try {
        _dobController.text =
            dobFormatter.format(DateTime.parse(user.dob ?? ""));
        _nameController.text = user.name ?? "";
        _phoneController.text =
            user?.phoneNumber != null ? user.phoneNumber.toString() : "";
        _addressController.text = user.address ?? "";
      } catch (e) {}

      setState(() {
        userInfo = user;
      });
    });
  }

  showLoading(value) {
    setState(() {
      loading = value;
    });
  }

  showPickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            ListTile(
              title: Text("From Camera"),
              leading: Icon(Icons.camera_alt),
              onTap: () async {
                Navigator.pop(context);
                final image = await picker.getImage(source: ImageSource.camera);
                setState(() {
                  this.image = File(image.path);
                });
              },
            ),
            ListTile(
              title: Text("From Gallery"),
              leading: Icon(Icons.image),
              onTap: () async {
                Navigator.pop(context);
                final image =
                    await picker.getImage(source: ImageSource.gallery);
                setState(() {
                  this.image = File(image.path);
                });
              },
            ),
          ],
        );
      },
    );
  }

  _showSnackbar(message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).accentColor,
      content: Text(message),
    ));
  }

  onCompleted() async {
    if (image != null) {
      showLoading(true);
      try {
        userInfo.imageUrl = await firebase.uploadFile(
            image, "/user/${userInfo.id}/profilePictures");
      } catch (e) {
        showLoading(false);
        if (e is PlatformException) {
          _showSnackbar(e.message);
        } else {
          _showSnackbar("Something Went Wrong. Try again Later");
        }
      }
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      showLoading(true);
      if (userInfo.dob == null) {
        _showSnackbar("Please Add Date Of Birth");
        showLoading(false);
        return;
      }
      await firebase.updateFirebaseUser(
          displayName: userInfo.name, photoURL: userInfo.imageUrl);
      firebase.updateUser(userInfo).then((value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }).catchError((e) {
        showLoading(false);
        if (e is PlatformException) {
          print(e);
          _showSnackbar(e.message);
          showLoading(false);
        } else {
          _showSnackbar("Something Went Wrong. Try again Later");
          showLoading(false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomAppbar("Update Profile", goBack: true),
            if (userInfo == null)
              Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 20),
                            Stack(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: Theme.of(context)
                                      .primaryColor
                                      .withAlpha(40),
                                  radius:
                                      MediaQuery.of(context).size.width * 0.2,
                                  backgroundImage: image != null
                                      ? FileImage(image)
                                      : NetworkImage(
                                          userInfo.imageUrl ?? "",
                                        ),
                                  child: image == null &&
                                          userInfo.imageUrl == null
                                      ? Icon(Icons.person,
                                          // color: AppColors.settingTextColor
                                          //     .withAlpha(120),
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3)
                                      : SizedBox(),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      showPickerDialog();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Icon(Mdi.cameraEnhance,
                                          // color:
                                          //     AppColors.backgroundColor,
                                          size: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TextFormField(
                              autovalidate: autoValidate,
                              controller: _nameController,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                hintStyle: Theme.of(context).textTheme.caption,
                                labelText: "Full Name",
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        color: Theme.of(context)
                                            .disabledColor
                                            .withAlpha(120)),
                              ),
                              onChanged: (value) {
                                userInfo.name = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) return "Mandatory Field";
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              autocorrect: autoValidate,
                              keyboardType: TextInputType.number,
                              controller: _phoneController,
                              decoration: InputDecoration(
                                hintStyle: Theme.of(context).textTheme.caption,
                                labelText: "Phone Number",
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        color: Theme.of(context)
                                            .disabledColor
                                            .withAlpha(120)),
                              ),
                              onChanged: (value) {
                                userInfo.phoneNumber = value;
                              },
                              validator: (value) {
                                if (value.isEmpty)
                                  return "Mandatory Field";
                                else if (value.length > 10) return "Invalid No";
                                return null;
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              autocorrect: autoValidate,
                              controller: _addressController,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                hintStyle: Theme.of(context).textTheme.caption,
                                labelText: "Address",
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        color: Theme.of(context)
                                            .disabledColor
                                            .withAlpha(120)),
                              ),
                              onChanged: (value) {
                                userInfo.address = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) return "Mandatory Field";
                                return null;
                              },
                            ),
                            SizedBox(height: 20.0),
                            GestureDetector(
                              onTap: () async {
                                DateTime date = await showDatePicker(
                                    context: context,
                                    initialDate: _dobController.text.isNotEmpty
                                        ? DateTime.parse(userInfo.dob)
                                        : DateTime.now(),
                                    firstDate: DateTime.parse("1900-01-01"),
                                    lastDate: DateTime.now());
                                if (date != null) {
                                  _dobController.text =
                                      dobFormatter.format(date);
                                  userInfo.dob = date.toString();
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(),
                                child: TextFormField(
                                  controller: _dobController,
                                  decoration: InputDecoration(
                                    labelText: 'Date Of Birth',
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                          color: Theme.of(context)
                                              .disabledColor
                                              .withAlpha(120),
                                        ),
                                  ),
                                  enabled: false,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            CustomButton(
                              label: "Update",
                              loading: loading,
                              onPress: () {
                                onCompleted();
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
