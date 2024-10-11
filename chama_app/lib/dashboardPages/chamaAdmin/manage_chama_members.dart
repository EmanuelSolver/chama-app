import 'package:flutter/material.dart';

class ManageChamaMembersPage extends StatefulWidget {
  @override
  _ManageChamaMembersPageState createState() => _ManageChamaMembersPageState();
}

class _ManageChamaMembersPageState extends State<ManageChamaMembersPage> {
  // Sample data for members
  List<Member> members = [
    Member(name: 'Alice', savings: 5000, debt: 2000),
    Member(name: 'Bob', savings: 3000, debt: 1500),
    // Add more members as needed
  ];

  void _addMember() {
    // Logic to add a member
  }

  void _editMember(int index) {
    // Logic to edit a member's details
  }

  void _deleteMember(int index) {
    // Logic to delete a member
    setState(() {
      members.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Chama Members'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addMember,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(member.name),
                subtitle: Text('Savings: Ksh ${member.savings}, Debt: Ksh ${member.debt}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editMember(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteMember(index),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Member {
  final String name;
  final double savings;
  final double debt;

  Member({
    required this.name,
    required this.savings,
    required this.debt,
  });
}
