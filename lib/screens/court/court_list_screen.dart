import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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

  Future<void> _openMapByAddress(String address) async {
    final encoded = Uri.encodeComponent(address);
    final mapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encoded');

    final launched = await launchUrl(
      mapsUri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không thể mở Google Maps")),
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
            subtitle: InkWell(
              onTap: () => _openMapByAddress(court.address),
              child: Text(
                court.address,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
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