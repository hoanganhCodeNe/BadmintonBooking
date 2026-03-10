import 'package:flutter/material.dart';
import '../../models/court.dart';
import '../../models/user.dart';
import '../../repositories/court_repository.dart';
import 'court_detail_screen.dart';

class CourtListScreen extends StatefulWidget {
  final User user;

  const CourtListScreen({super.key, required this.user});

  @override
  State<CourtListScreen> createState() => _CourtListScreenState();
}

class _CourtListScreenState extends State<CourtListScreen> {

  final CourtRepository repository = CourtRepository();
  List<Court> courts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCourts();
  }

  void loadCourts() async {
    try {
      final data = await repository.getAllCourts();
      if (!mounted) return;
      setState(() {
        courts = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi tải danh sách sân: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (courts.isEmpty) {
      return const Center(child: Text("Chưa có sân nào"));
    }

    return ListView.builder(
      itemCount: courts.length,
      itemBuilder: (context, index) {

        final court = courts[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.sports_tennis, color: Colors.green),
            title: Text(court.name),
            subtitle: Text(court.address),
            trailing: const Icon(Icons.arrow_forward_ios),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourtDetailScreen(
                    court: court,
                    user: widget.user,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}