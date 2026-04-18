import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/api_service.dart';

class AdminPushScreen extends StatefulWidget {
  const AdminPushScreen({super.key});

  @override
  State<AdminPushScreen> createState() => _AdminPushScreenState();
}

class _AdminPushScreenState extends State<AdminPushScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _userSearchController = TextEditingController();

  Map<String, dynamic>? _selectedUser;
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  bool _isSending = false;

  Future<void> _searchUsers(String query) async {
    if (query.length < 2) return;
    
    setState(() => _isSearching = true);
    try {
      final res = await _apiService.get('/admin/users/search', queryParameters: {'q': query});
      if (res.data['success']) {
        setState(() => _searchResults = res.data['users']);
      }
    } catch (e) {
      debugPrint('Search error: $e');
    } finally {
      setState(() => _isSearching = false);
    }
  }

  Future<void> _sendNotification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);
    try {
      final payload = {
        'title': _titleController.text,
        'message': _messageController.text,
        'targetUserId': _selectedUser?['id'], // Null if sending to ALL
      };

      final res = await _apiService.post('/admin/broadcast', data: payload);
      
      if (mounted) {
        final bool isSuccess = res.data['success'] == true;
        
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSuccess ? const Color(0xFFE2E000) : Colors.orange[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess ? Icons.check_rounded : Icons.info_outline_rounded,
                    color: const Color(0xFF0E2244),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  isSuccess ? '¡SOLICITUD EXITOSA!' : 'AVISO DE ENVÍO',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: const Color(0xFF0E2244),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  res.data['message'] ?? 'Proceso finalizado.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      if (isSuccess) Navigator.pop(context); // Back to profile only if success
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0E2244),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('ENTENDIDO', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error en el servidor: $e', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0E2244);
    const yellow = Color(0xFFE2E000);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text('CENTRO PUSH'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'COMUNICACIÓN ELITE',
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: navy.withOpacity(0.3),
                ),
              ),
              const SizedBox(height: 24),

              // TARGET SELECTION
              _buildSectionTitle('DESTINATARIO', navy),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.people_alt_rounded, color: _selectedUser == null ? yellow : navy),
                      title: Text(
                        _selectedUser == null ? 'Todos los Usuarios (Broadcast)' : _selectedUser!['name'],
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: navy),
                      ),
                      subtitle: Text(
                        _selectedUser == null ? 'Envío masivo a toda la red' : _selectedUser!['email'],
                        style: GoogleFonts.inter(fontSize: 11),
                      ),
                      trailing: _selectedUser != null 
                        ? IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() => _selectedUser = null))
                        : null,
                    ),
                    if (_selectedUser == null) ...[
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          onChanged: _searchUsers,
                          decoration: InputDecoration(
                            hintText: 'Buscar anunciante por nombre...',
                            hintStyle: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                            border: InputBorder.none,
                            icon: const Icon(Icons.search, size: 20, color: Colors.grey),
                          ),
                        ),
                      ),
                      if (_isSearching) const LinearProgressIndicator(minHeight: 2),
                      if (_searchResults.isNotEmpty)
                        Container(
                          constraints: const BoxConstraints(maxHeight: 150),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final user = _searchResults[index];
                              return ListTile(
                                dense: true,
                                title: Text(user['name'], style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                                subtitle: Text(user['email'], style: const TextStyle(fontSize: 10)),
                                onTap: () => setState(() {
                                  _selectedUser = user;
                                  _searchResults = [];
                                }),
                              );
                            },
                          ),
                        ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // MESSAGE FORM
              _buildSectionTitle('CONTENIDO', navy),
              const SizedBox(height: 12),
              _buildTextField('Título', _titleController, Icons.title, navy),
              const SizedBox(height: 16),
              _buildTextField('Mensaje', _messageController, Icons.message, navy, maxLines: 4),

              const SizedBox(height: 48),

              // SEND BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSending ? null : _sendNotification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 10,
                    shadowColor: navy.withOpacity(0.3),
                  ),
                  child: _isSending 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('DESPLEGAR NOTIFICACIÓN', style: GoogleFonts.outfit(fontWeight: FontWeight.w900, letterSpacing: 1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color navy) {
    return Text(
      title,
      style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: navy.withOpacity(0.5)),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, Color navy, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
        style: GoogleFonts.inter(color: navy, fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: navy, size: 20),
          hintText: label,
          hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 13),
          contentPadding: const EdgeInsets.all(20),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
