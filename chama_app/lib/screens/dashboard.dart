import 'package:flutter/material.dart';
import '../dashboardPages/home_page.dart';
import '../dashboardPages/savings_page.dart';
import '../dashboardPages/discussion_forum_page.dart';
import '../dashboardPages/appAdmin/manage_chamas.dart';
import '../dashboardPages/appAdmin/global_reports_page.dart';
import '../dashboardPages/appAdmin/register_chama.dart';
import '../dashboardPages/chamaAdmin/manage_chama_members.dart';
import '../dashboardPages/chamaAdmin/add_chama_member.dart';

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
      const SavingsPage(),
      if (widget.userRole != 'appAdmin') DiscussionForumPage(),
      if (widget.userRole == 'chamaAdmin') ManageChamaMembersPage(),
      if (widget.userRole == 'chamaAdmin') const AddChamaMemberPage(),
      if (widget.userRole == 'appAdmin') const ManageChamasPage(),
      if (widget.userRole == 'appAdmin') const GlobalReportsPage(),
      if (widget.userRole == 'appAdmin') RegisterChamaPage(),
    ];

    _drawerTitles = [
      'Home',
      'Savings',
      if (widget.userRole != 'appAdmin') 'Discussion Forum',
      if (widget.userRole == 'chamaAdmin') 'Manage Members',
      if (widget.userRole == 'chamaAdmin') 'Add New Member',
      if (widget.userRole == 'appAdmin') 'Manage Chamas',
      if (widget.userRole == 'appAdmin') 'Global Reports',
      if (widget.userRole == 'appAdmin') 'Register New Chama',
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
                    Text('Username: ${widget.username}',
                        style: const TextStyle(color: Colors.white)),
                    Text('Email: ${widget.email}',
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
        _onItemTapped(index);
        Navigator.pop(context); // Close drawer after selection
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
      default:
        return Icons.menu;
    }
  }
}
