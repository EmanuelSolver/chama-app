import 'package:flutter/material.dart';
import '../dashboardPages/home_page.dart';
import '../dashboardPages/savings_page.dart';
import '../dashboardPages/discussion_forum_page.dart';
import '../dashboardPages/appAdmin/manage_chamas.dart';
import '../dashboardPages/chamaAdmin/manage_chama_members.dart';
import '../dashboardPages/chamaAdmin/add_chama_member.dart';
import '../dashboardPages/appAdmin/global_reports_page.dart';

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
  int _selectedIndex = 0;
  late List<Widget> _pages;

  // Initialize variables with default values
  double totalSavings = 0.0;
  double loansBorrowed = 0.0;
  double paymentsMade = 0.0;
  List<double> savingTrends = [57, 33, 8, 7, 13, 20, 27, 78, 40, 50, 25, 23];

  @override
  void initState() {
    super.initState();

    // Initialize _pages based on user role
    _initializePages();
    _initializeDashboard();
  }

  void _initializePages() {
    // Initialize _pages based on user role logic
    _pages = [
      HomePage(
        userRole: widget.userRole,
        totalSavings: totalSavings,
        loansBorrowed: loansBorrowed,
        paymentsMade: paymentsMade,
        savingsTrends: savingTrends,
      ),
      const SavingsPage(),
      if (widget.userRole != 'appAdmin')
        DiscussionForumPage(), // Hide discussion forum for appAdmin
      if (widget.userRole == 'chamaAdmin')
        ManageChamaMembersPage(), // Only show for chamaAdmin
      if (widget.userRole == 'chamaAdmin')
        const AddChamaMemberPage(), // Only show for chamaAdmin
      if (widget.userRole == 'appAdmin')
        const ManageChamasPage(), // Only show for appAdmin
      if (widget.userRole == 'appAdmin')
        const GlobalReportsPage(), // Only show for appAdmin
    ];

    // Remove null entries that were not added due to user role restrictions
    _pages.removeWhere((page) => page == null);
  }

  void _initializeDashboard() {
    setState(() {
      // Fetch or set default values for totalSavings, loansBorrowed, and paymentsMade
      totalSavings = 1000.0; // Set real value or fetch from backend
      loansBorrowed = 200.0; // Set real value or fetch from backend
      paymentsMade = 150.0; // Set real value or fetch from backend
      savingTrends = savingTrends;
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
                  Text('Username: ${widget.username}',
                      style: const TextStyle(color: Colors.white)),
                  Text('Email: ${widget.email}',
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
            ..._getDrawerItems(),
          ],
        ),
      ),
      body: _pages[_selectedIndex], // Accessing the pages
    );
  }

  List<Widget> _getDrawerItems() {
    List<Widget> items = [];

    // Common drawer items for all users
    items.addAll([
      _createDrawerItem(text: 'Home', index: 0, icon: Icons.home),
    ]);

    int indexCounter = 1; // Start from index 1 as Home is 0

    // Conditional drawer items based on userRole
    if (widget.userRole != 'appAdmin') {
      items.add(_createDrawerItem(
          text: 'Savings', index: indexCounter++, icon: Icons.savings));
      items.add(_createDrawerItem(
          text: 'Discussion Forum', index: indexCounter++, icon: Icons.forum));
    }
    if (widget.userRole == 'chamaAdmin') {
      items.add(_createDrawerItem(
          text: 'Manage Chama Members', index: indexCounter++, icon: Icons.people));
      items.add(_createDrawerItem(
          text: 'Add Chama Member', index: indexCounter++, icon: Icons.person_add));
    }
    if (widget.userRole == 'appAdmin') {
      items.add(_createDrawerItem(
          text: 'Manage Chamas', index: indexCounter++, icon: Icons.group));
      items.add(_createDrawerItem(
          text: 'Global Reports', index: indexCounter++, icon: Icons.bar_chart));
    }

    return items;
  }

  Widget _createDrawerItem(
      {required String text, required int index, required IconData icon}) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(text),
      onTap: () {
        _onItemTapped(index);
        Navigator.pop(context); // Close drawer after selection
      },
    );
  }

  void _onItemTapped(int index) {
    if (index < _pages.length) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      // Log or handle the case where the user tries to select an unavailable index
      debugPrint('Invalid page index: $index');
    }
  }
}
