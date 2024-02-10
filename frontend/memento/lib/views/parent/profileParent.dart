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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login())); // Navigate to the login screen
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
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/profile.png'),
              ),
              const SizedBox(height: 20),
              Text(
                userName ?? "Loading...",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        LineAwesomeIcons.envelope,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        userEmail ?? "Loading..",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        LineAwesomeIcons.phone,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        phoneNumber ?? "No phone number",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),



              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                height: 60,
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
                  child: const Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              // Add more Text widgets for other user details if needed
              const SizedBox(height: 24),
              const SizedBox(height: 10),
              MenuItemWidget(title: "settings", icon: LineAwesomeIcons.cog, onPress: () {}),
              MenuItemWidget(title: "Notifications", icon: LineAwesomeIcons.bell, onPress: () {}),
              const Divider(color: Colors.grey,),
              const SizedBox(height: 10),
              MenuItemWidget(title: "Information", icon: LineAwesomeIcons.info, onPress: () {}),
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
    this.endIcon=true,
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
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.blueAccent.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: Colors.blueAccent,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.apply(color: textColor),
      ),
      trailing: endIcon? Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: const Icon(LineAwesomeIcons.angle_right, size: 18, color: Colors.grey)):null,
    );
  }
}



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