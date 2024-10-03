import 'package:flutter/material.dart';
import '../dashboardPages/home_page.dart';
import '../dashboardPages/savings_page.dart';
import '../dashboardPages/discussion_forum_page.dart';
import '../dashboardPages/manage_chama_page.dart';
import '../dashboardPages/manage_members_page.dart';
import '../dashboardPages/user_management_page.dart';
import '../dashboardPages/global_reports_page.dart';

class DashboardScreen extends StatefulWidget {
  final String userRole; // Add userRole parameter
  final String username; // Add username parameter
  final String email;    // Add email parameter
  final String chama;    // Add Chama parameter

  const DashboardScreen({
    super.key,
    required this.userRole,
    required this.username,
    required this.email,
    required this.chama,
  });

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _initializeDashboard();
  }

  void _initializeDashboard() {
    // Define the pages based on the user role
    if (widget.userRole == 'AwaChama Admin') {
      _pages = [
        const HomePage(),
        const SavingsPage(),
        const DiscussionForumPage(),
        const ManageChamaPage(),
        const ManageMembersPage(),
        const UserManagementPage(),
        const GlobalReportsPage(),
      ];
    } else if (widget.userRole == 'Chama Admin') {
      _pages = [
        const HomePage(),
        const SavingsPage(),
        const DiscussionForumPage(),
        const ManageMembersPage(),
      ];
    } else { // Assuming the user is a specific chama member
      _pages = [
        const HomePage(),
        const SavingsPage(),
        const DiscussionForumPage(),
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chama Dashboard'),
      ),
      // Add a drawer for navigation
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Updated Drawer Header with user info
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5.0), // Add padding around the text
                    alignment: Alignment.center, // Center align the text
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Use min to avoid extra space
                      crossAxisAlignment: CrossAxisAlignment.center, // Center the text horizontally
                      children: [
                        Text(
                          '${widget.chama}', // Main text
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4), // Add some space between the texts
                        const Text(
                          'in AwaChama', // Sub-text
                          style: TextStyle(
                            color: Colors.white70, // Slightly different color for sub-text
                            fontSize: 16, // Smaller font size for sub-text
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),
                  // User Credentials
                  Text(
                    'Username: ${widget.username}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Email: ${widget.email}',
                    style: const TextStyle(color: Colors.white),
                  ),

                ],
              ),
            ),
            // Add navigation items based on user role
            ..._getDrawerItems(), // Use a method to create the drawer items
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  List<Widget> _getDrawerItems() {
    List<Widget> items = [];
    
    // AwaChama Admin
    if (widget.userRole == 'AwaChama Admin') {
      items.addAll([
        _createDrawerItem(text: 'Home', index: 0, icon: Icons.home),
        _createDrawerItem(text: 'Savings', index: 1, icon: Icons.savings),
        _createDrawerItem(text: 'Discussion Forum', index: 2, icon: Icons.forum),
        _createDrawerItem(text: 'Manage Chama', index: 3, icon: Icons.group),
        _createDrawerItem(text: 'Manage Members', index: 4, icon: Icons.people),
        _createDrawerItem(text: 'User Management', index: 5, icon: Icons.admin_panel_settings),
        _createDrawerItem(text: 'Global Reports', index: 6, icon: Icons.report),
      ]);
    } 
    // Chama Admin
    else if (widget.userRole == 'Chama Admin') {
      items.addAll([
        _createDrawerItem(text: 'Home', index: 0, icon: Icons.home),
        _createDrawerItem(text: 'Savings', index: 1, icon: Icons.savings),
        _createDrawerItem(text: 'Discussion Forum', index: 2, icon: Icons.forum),
        _createDrawerItem(text: 'Manage Members', index: 3, icon: Icons.people),
      ]);
    } 
    // Specific chama member
    else {
      items.addAll([
        _createDrawerItem(text: 'Home', index: 0, icon: Icons.home),
        _createDrawerItem(text: 'Savings', index: 1, icon: Icons.savings),
        _createDrawerItem(text: 'Discussion Forum', index: 2, icon: Icons.forum),
      ]);
    }
    
    return items;
  }

  Widget _createDrawerItem({required String text, required int index, required IconData icon}) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(text),
      onTap: () {
        _onItemTapped(index);
        Navigator.pop(context);
      },
    );
  }
}
