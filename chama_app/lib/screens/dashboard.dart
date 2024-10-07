import 'package:flutter/material.dart';
import '../dashboardPages/home_page.dart';
import '../dashboardPages/savings_page.dart';
import '../dashboardPages/discussion_forum_page.dart';
import '../dashboardPages/manage_chama_page.dart';
import '../dashboardPages/manage_members_page.dart';
import '../dashboardPages/user_management_page.dart';
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
    _initializeDashboard();
  }

  void _initializeDashboard() {
    // Fetch or set default values for totalSavings, loansBorrowed, and paymentsMade
    setState(() {
      totalSavings = 1000.0;  // Set real value or fetch from backend
      loansBorrowed = 200.0;   // Set real value or fetch from backend
      paymentsMade = 150.0;    // Set real value or fetch from backend
      savingTrends = savingTrends;
    });

    // Initialize pages based on user role
    _pages = [
      HomePage(
        userRole: widget.userRole,
        totalSavings: totalSavings,
        loansBorrowed: loansBorrowed,
        paymentsMade: paymentsMade,
        savingsTrends: savingTrends,
      ),
      const SavingsPage(),
      const DiscussionForumPage(),
      const ManageChamaPage(),
      const ManageMembersPage(),
      const UserManagementPage(),
      const GlobalReportsPage(),
    ];
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
                  Text('Username: ${widget.username}', style: const TextStyle(color: Colors.white)),
                  Text('Email: ${widget.email}', style: const TextStyle(color: Colors.white)),
                ],
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

    // Add your drawer items based on user role here
    items.addAll([
      _createDrawerItem(text: 'Home', index: 0, icon: Icons.home),
      _createDrawerItem(text: 'Savings', index: 1, icon: Icons.savings),
      _createDrawerItem(text: 'Discussion Forum', index: 2, icon: Icons.forum),
    ]);

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
