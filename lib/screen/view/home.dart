import 'dart:developer';
import 'package:chat_app/controllers/home_controller.dart';
import 'package:chat_app/routes/routes.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../modal/user_model.dart';
import '../../my_app.dart';
import '../../services/firestore_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeController controller = Get.put(homeController());

  @override
  void initState() {
    super.initState();
    controller.fatchuserData();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat Room",
          style: GoogleFonts.lato(),
        ),
      ),
      drawer: buildDrawer(context),
      body: buildUserList(),
    );
  }

  Widget buildDrawer(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: StreamBuilder(
        stream: FireStoreService.fireStoreService.fetchCurrentUser(),
        builder: (context, snapshot) {
          var data = snapshot.data;
          Map<String, dynamic> myUser = data?.data() ?? {};
          log("$myUser");

          return Column(
            children: [
              buildDrawerHeader(myUser, context),
              Expanded(
                child:
                    SingleChildScrollView(child: buildDrawerOptions(context)),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Powered by Taksh",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildDrawerHeader(Map<String, dynamic> myUser, BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.black, Colors.grey[800]!]
              : [Colors.blueAccent, Colors.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            GestureDetector(
              onTap: () => showProfileDialog(myUser, context),
              child: CircleAvatar(
                radius: 37,
                backgroundImage: NetworkImage(controller.image.value),
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              myUser['name'] ?? "User",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              myUser['email'] ?? "Email",
              style: TextStyle(fontSize: 14, color: Colors.grey[300]),
            ),
          ],
        );
      }),
    );
  }

  /// ✅ **Drawer Options including Theme Toggle**
  Widget buildDrawerOptions(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        buildDrawerTile(Icons.chat, "Chats", Colors.blueAccent, () {}),
        buildDrawerTile(Icons.group, "Groups", Colors.green, () {}),
        buildDrawerTile(Icons.settings, "Settings", Colors.grey, () {}),
        Obx(() {
          return SwitchListTile(
            title: Text("Dark Mode",
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color)),
            secondary: const Icon(Icons.dark_mode, color: Colors.orange),
            value: themeController.isDarkMode,
            onChanged: (value) => themeController.toggleTheme(),
          );
        }),
        buildDrawerTile(Icons.logout, "Logout", Colors.red, () async {
          await AuthService.authService.signOut();
          Get.offNamed(Routes.login);
        }),
      ],
    );
  }

  /// ✅ **Drawer Tile Widget for Clean Code**
  Widget buildDrawerTile(
      IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
      onTap: onTap,
    );
  }

  /// ✅ **User List with Chat Navigation**
  Widget buildUserList() {
    return StreamBuilder<List<UserModel>>(
      stream: FireStoreService.fireStoreService.fetchUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        List<UserModel> users = snapshot.data!;
        String currentUserEmail =
            AuthService.authService.currentUser?.email ?? "";
        users.removeWhere((user) => user.email == currentUserEmail);

        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: users.length,
          separatorBuilder: (context, index) =>
              Divider(color: Theme.of(context).dividerColor),
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Get.toNamed(Routes.detail, arguments: users[index]);
              },
              title: Text(
                users[index].name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              subtitle: Text(
                users[index].email,
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
              trailing: const Icon(Icons.message, color: Colors.blueAccent),
            );
          },
        );
      },
    );
  }

  void showProfileDialog(Map<String, dynamic> myUser, BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        controller.image.value,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error,
                              size: 100, color: Colors.grey);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      myUser['name'] ?? "User",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      myUser['email'] ?? "Email",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(Icons.close, size: 24, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
