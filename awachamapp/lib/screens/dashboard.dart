import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../../dashboardPages/home_page.dart';
import '../../../dashboardPages/savings_page.dart';
import '../../../dashboardPages/discussion_forum_page.dart';
import '../../../dashboardPages/appAdmin/manage_chamas.dart';
import '../../../dashboardPages/appAdmin/global_reports_page.dart';
import '../../../dashboardPages/appAdmin/register_chama.dart';
import '../../../dashboardPages/chamaAdmin/manage_chama_members.dart';
import '../../../dashboardPages/chamaAdmin/add_chama_member.dart';
import '../../../dashboardPages/profile_page.dart';
import '../dashboardPages/profile_edit.dart';

class DashboardScreen extends StatefulWidget {
  final String userRole;
  final String username;
  final String email;
  final String chama;

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
  final AuthService _authService = AuthService(); // Create an instance of AuthService

  int _selectedIndex = 0;
  late List<Widget> _pages;
  late List<String> _drawerTitles; // Titles for drawer items

  // Initialize variables with default values
  double totalSavings = 0.0;
  double loansBorrowed = 0.0;
  double paymentsMade = 0.0;
  List<double> savingTrends = [57, 33, 8, 7, 13, 20, 27, 78, 40, 50, 25, 23];

  @override
  void initState() {
    super.initState();

    // Initialize _pages and drawer items based on user role
    _initializePagesAndDrawer();
    _initializeDashboard();
  }

  void _initializePagesAndDrawer() {
    _pages = [
      HomePage(
        userRole: widget.userRole,
        totalSavings: totalSavings,
        loansBorrowed: loansBorrowed,
        paymentsMade: paymentsMade,
        savingsTrends: savingTrends,
      ),
      ProfilePage(),
      const SavingsPage(),
      if (widget.userRole != 'appAdmin') DiscussionForumPage(),
      if (widget.userRole == 'chamaAdmin') ManageChamaMembersPage(),
      if (widget.userRole == 'chamaAdmin') const AddChamaMemberPage(),
      if (widget.userRole == 'appAdmin') const ManageChamasPage(),
      if (widget.userRole == 'appAdmin') const GlobalReportsPage(),
      if (widget.userRole == 'appAdmin') RegisterChamaPage(),
      const ProfileEditPage(),
    ];

    _drawerTitles = [
      'Home',
      'Profile',
      'Savings',
      if (widget.userRole != 'appAdmin') 'Discussion Forum',
      if (widget.userRole == 'chamaAdmin') 'Manage Members',
      if (widget.userRole == 'chamaAdmin') 'Add New Member',
      if (widget.userRole == 'appAdmin') 'Manage Chamas',
      if (widget.userRole == 'appAdmin') 'Global Reports',
      if (widget.userRole == 'appAdmin') 'Register New Chama',
      'Settings',
      'Sign Out'
    ];
  }

  void _initializeDashboard() {
    setState(() {
      totalSavings = 1000.0; // Set real value or fetch from backend
      loansBorrowed = 200.0; // Set real value or fetch from backend
      paymentsMade = 150.0; // Set real value or fetch from backend
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chama Dashboard'),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chama,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('${widget.username}',
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            ..._getDrawerItems(),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  List<Widget> _getDrawerItems() {
    List<Widget> items = [];

    // Generate drawer items based on the drawer titles
    for (int i = 0; i < _drawerTitles.length; i++) {
      items.add(_createDrawerItem(
        text: _drawerTitles[i],
        index: i,
        icon: _getDrawerIcon(_drawerTitles[i]),
      ));
    }

    return items;
  }

  Widget _createDrawerItem({
    required String text,
    required int index,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(text),
      onTap: () {
        if (text == 'Sign Out') {
          _signOut(context); // Call the sign-out method
        } else {
          _onItemTapped(index);
          Navigator.pop(context); // Close drawer after selection
        } 
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  IconData _getDrawerIcon(String title) {
    switch (title) {
      case 'Home':
        return Icons.home;
      case 'Profile':
        return Icons.person;
      case 'Savings':
        return Icons.savings;
      case 'Discussion Forum':
        return Icons.forum;
      case 'Manage Members':
        return Icons.people;
      case 'Add New Member':
        return Icons.person_add;
      case 'Manage Chamas':
        return Icons.group;
      case 'Register New Chama':
        return Icons.add;
      case 'Global Reports':
        return Icons.bar_chart;
      case 'Settings':
        return Icons.settings;
      case 'Sign Out': 
        return Icons.exit_to_app;
      default:
        return Icons.menu;
    }
  }

  void _signOut(BuildContext context) async {
    try {
      await _authService.signOut(); // Call the signOut method from AuthService
      Navigator.of(context).pushReplacementNamed('/login'); // Navigate to login after successful sign out
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }
}


