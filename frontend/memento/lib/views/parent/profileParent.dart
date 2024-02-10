import 'package:memento/views/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:memento/services/localDb/localDb.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileParent extends StatefulWidget {
  const ProfileParent({super.key});

  @override
  State<ProfileParent> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileParent> {
  String? userName = "loading...";
  String? userEmail = "";
  String? phoneNumber = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _handleLogout() async {
    try {
      //await LocalDb.clearUserData(); // Clears user data from SharedPreferences
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Login())); // Navigate to the login screen
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Use the user's UID to fetch additional data from Firestore
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore.instance.collection('parent').doc(user.uid).get();

      setState(() {
        userName = userData['name'];
        userEmail = userData['email'];
        phoneNumber = userData['mobile'];
      });
    }
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(height: height * 0.05),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 20),

                  // user info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName ?? "Loading...",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                LineAwesomeIcons.envelope,
                                size: 16,
                              ),
                              SizedBox(width: width * 0.01),
                              Text(
                                userEmail ?? "Loading..",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 5,
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                LineAwesomeIcons.phone,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 5,
                                height: 10,
                              ),
                              Text(
                                phoneNumber ?? "No phone number",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width*0.03, vertical: height*0.005),
                                decoration: BoxDecoration(
                                  color: Colors
                                      .grey[200], // Light gray background color
                                  borderRadius: BorderRadius.circular(
                                      20), // Circular border radius
                                ),
                                child: Text(
                                  "Parent",
                                  style: TextStyle(
                                      // Define the style for the text if needed
                                      ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 5,
                            height: 10,
                          ),

                        ],
                      ),
                    ],
                  ),



                  // SizedBox(
                  //   height: 10,
                  //   width: width*0.03,
                  // ),


                  // avart image
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  SizedBox(
                    height: height * 0.02,
                    width: width * 0.05,
                  ),
                ],
              ),
              // profile image

              // text content //edit profile button
              const SizedBox(height: 24),

              // edit button
              SizedBox(
                width: width * 0.45,
                height: height * 0.06,
                child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(
                          userName: userName ?? "",
                          userEmail: userEmail ?? "",
                          phoneNumber: phoneNumber ?? "",
                          onUpdateName: (name) {
                            setState(() {
                              userName = name;
                            });
                          },
                          onUpdateEmail: (email) {
                            setState(() {
                              userEmail = email;
                            });
                          },
                          onUpdateMobile: (mobile) {
                            setState(() {
                              phoneNumber = mobile;
                            });
                          },
                        ),
                      ),
                    ),

                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.white; // Transparent background color
                    }),
                    side: MaterialStateProperty.all(
                        BorderSide(color: Colors.black)), // Black border
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, color: Colors.black), // Edit icon
                      SizedBox(width: 8), // Spacer between icon and text
                      Text(
                        "Edit Profile",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: height * 0.02),

              // accessiblity features
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Light gray background color
                  borderRadius:
                      BorderRadius.circular(12), // Circular border radius
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.04,
                              vertical: height * 0.02),
                          decoration: BoxDecoration(
                            color: Colors.black, // Light gray background color
                            borderRadius: BorderRadius.circular(
                                50), // Circular border radius
                          ),
                          child: const Icon(
                            LineAwesomeIcons.language,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Text("Change"),
                        Text("Language")
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.04,
                              vertical: height * 0.02),
                          decoration: BoxDecoration(
                            color: Colors.black, // Light gray background color
                            borderRadius: BorderRadius.circular(
                                50), // Circular border radius
                          ),
                          child: const Icon(
                            LineAwesomeIcons.language,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Text("Change "),
                        Text("Font Size"),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.04,
                              vertical: height * 0.02),
                          decoration: BoxDecoration(
                            color: Colors.black, // Light gray background color
                            borderRadius: BorderRadius.circular(
                                50), // Circular border radius
                          ),
                          child: const Icon(
                            LineAwesomeIcons.language,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Text("Use"),
                        Text("Voice"),
                      ],
                    ),
                  ],
                ),
              ),

              // Add more Text widgets for other user details if needed
              const SizedBox(height: 10),
              MenuItemWidget(
                  title: "settings",
                  icon: LineAwesomeIcons.cog,
                  onPress: () {}),
              MenuItemWidget(
                  title: "Notifications",
                  icon: LineAwesomeIcons.bell,
                  onPress: () {}),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(height: 10),
              MenuItemWidget(
                  title: "Information",
                  icon: LineAwesomeIcons.info,
                  onPress: () {}),
              MenuItemWidget(
                title: "Logout",
                textColor: Colors.red,
                icon: LineAwesomeIcons.alternate_sign_out,
                endIcon: false,
                onPress: _handleLogout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  const MenuItemWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.3),
        ),
        child: Icon(
          icon,
          color: Colors.black,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.apply(color: textColor),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(LineAwesomeIcons.angle_right,
                  size: 18, color: Colors.grey))
          : null,
    );
  }
}

// edit profile
class EditProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String phoneNumber;
  final Function(String) onUpdateName;
  final Function(String) onUpdateEmail;
  final Function(String) onUpdateMobile;

  const EditProfileScreen({
    required this.userName,
    required this.userEmail,
    required this.phoneNumber,
    required this.onUpdateName,
    required this.onUpdateEmail,
    required this.onUpdateMobile,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? phoneError;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with current user data
    nameController.text = widget.userName;
    phoneController.text = widget.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Your input fields for name, email, and phone
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),

            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                errorText: phoneError,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _handleSave(),
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    // Validate phone number
    if (!isValidPhoneNumber(phoneController.text)) {
      setState(() {
        phoneError = 'Enter a valid phone number';
      });
      return;
    }

    // Implement logic to update user data in Firestore
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('parent').doc(user.uid).update({
          'name': nameController.text,
          'phone': phoneController.text,
        });

        // Update local state with new data
        widget.onUpdateName(nameController.text);
        widget.onUpdateMobile(phoneController.text);

        // Navigate back to the profile screen
        Navigator.pop(context);
      } catch (e) {
        print("Error updating profile: $e");
        // Handle error, show a snackbar, etc.
      }
    }
  }

  bool isValidPhoneNumber(String phoneNumber) {
    // Add your phone number validation logic using regex
    // Here, I'm using a simple regex for demonstration purposes
    RegExp phoneRegex = RegExp(r'^\d{10}$');
    return phoneRegex.hasMatch(phoneNumber);
  }
}
