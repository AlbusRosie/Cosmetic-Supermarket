import 'package:flutter/material.dart';
import '../../../models/user.dart';
import '../shared/app_drawer.dart';
import 'user_manager.dart';
import 'package:provider/provider.dart';
import '../../../components/colors.dart';

class UsersScreen extends StatefulWidget {
  static const routeName = '/users';
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late Future<void> _fetchUsers;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers = Future.value(); // Placeholder
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUsers = Provider.of<UserManager>(context, listen: false).fetchUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.menu, color: color4, size: 30),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 290,
                    padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                    decoration: BoxDecoration(
                      color: color17,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search customers...",
                              hintStyle:
                                  TextStyle(color: color4.withOpacity(0.7)),
                            ),
                            style: TextStyle(color: color4),
                          ),
                        ),
                        Icon(Icons.search, color: color4, size: 30.0),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: FutureBuilder(
                  future: _fetchUsers,
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(color: color11));
                    }
                    return Consumer<UserManager>(
                      builder: (ctx, userManager, child) {
                        var customers = userManager.customers;
                        if (_searchQuery.isNotEmpty) {
                          customers = customers.where((user) {
                            final username = user.username.toLowerCase();
                            final email = (user.email ?? '').toLowerCase();
                            final phone = (user.phone)
                                .toLowerCase(); // Thêm tìm kiếm theo phone
                            return username.contains(_searchQuery) ||
                                email.contains(_searchQuery) ||
                                phone.contains(_searchQuery);
                          }).toList();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                "Total Customers: ${customers.length}",
                                style: TextStyle(
                                  color: color4,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              child: customers.isEmpty
                                  ? Center(
                                      child: Text(
                                        _searchQuery.isNotEmpty
                                            ? "No customers found matching '$_searchQuery'"
                                            : "No customers found",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[600]),
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.all(8.0),
                                      itemCount: customers.length,
                                      itemBuilder: (ctx, i) => Card(
                                        color: color2,
                                        elevation: 2,
                                        child: GestureDetector(
                                          onTap: () => _showUserDetailsPopup(
                                              context, customers[i]),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              radius: 25,
                                              backgroundColor:
                                                  color4.withOpacity(0.2),
                                              backgroundImage:
                                                  customers[i].avatar != null &&
                                                          customers[i]
                                                              .avatar!
                                                              .isNotEmpty
                                                      ? NetworkImage(
                                                          customers[i].avatar!)
                                                      : null,
                                              child:
                                                  customers[i].avatar == null ||
                                                          customers[i]
                                                              .avatar!
                                                              .isEmpty
                                                      ? Text(
                                                          customers[i]
                                                                  .username
                                                                  .isNotEmpty
                                                              ? customers[i]
                                                                  .username[0]
                                                                  .toUpperCase()
                                                              : 'U',
                                                          style: TextStyle(
                                                              color: color4,
                                                              fontSize: 20),
                                                        )
                                                      : null,
                                            ),
                                            title: Text(
                                              customers[i].username,
                                              style: TextStyle(
                                                  color: color4,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              customers[i].email ?? 'No email',
                                              style: TextStyle(color: color4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUserDetailsPopup(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: color13,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Customer Details",
                    style: TextStyle(
                      color: color4,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: color4.withOpacity(0.2),
                        backgroundImage:
                            user.avatar != null && user.avatar!.isNotEmpty
                                ? NetworkImage(user.avatar!)
                                : null,
                        child: user.avatar == null || user.avatar!.isEmpty
                            ? Text(
                                user.username.isNotEmpty
                                    ? user.username[0].toUpperCase()
                                    : 'U',
                                style: TextStyle(color: color4, fontSize: 24),
                              )
                            : null,
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.username,
                            style: TextStyle(
                              color: color4,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            user.email ?? 'No email',
                            style: TextStyle(color: color4),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 15),
                  _buildDetailRow('Phone', user.phone),
                  _buildDetailRow('Address', user.address ?? 'Not provided'),
                  _buildDetailRow('Role', user.urole ?? 'customer'),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: IconButton(
                icon: Icon(Icons.close, color: color4, size: 28),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(color: color4, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 200,
            child: Text(
              value,
              style: TextStyle(color: color4),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
