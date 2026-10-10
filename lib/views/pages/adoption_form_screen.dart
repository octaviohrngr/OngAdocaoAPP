import 'package:flutter/material.dart';

/// Tela de solicitação de adoção com formulário do adotante.
class AdoptionFormScreen extends StatefulWidget {
  const AdoptionFormScreen({super.key});

  @override
  State<AdoptionFormScreen> createState() => _AdoptionFormScreenState();
}

class _AdoptionFormScreenState extends State<AdoptionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  String _housingType = 'Apartamento';
  String? _timeAlone;
  bool _agreedToTerms = false;

  static const Color _primaryGreen = Color(0xFF3BAA57);

  final List<String> _timeAloneOptions = [
    'Menos de 2 horas',
    '2 a 4 horas',
    '4 a 8 horas',
    'Mais de 8 horas',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _agreedToTerms) {
      // Navegar para a tela de confirmação (adoption_success_screen.dart)
    } else if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa concordar com os termos.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text(
          'Atipattas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Solicitação de Adoção',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Você está a um passo de dar um lar cheio de amor para o Bento.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1552053831-71594a27632d',
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bento',
                              style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                          Text('Vira-lata, Macho, 2 anos',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Seus Dados',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _FieldLabel('Nome Completo'),
                TextFormField(
                  controller: _nameController,
                  decoration:
                      _inputDecoration('Digite seu nome completo'),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 14),
                _FieldLabel('E-mail'),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration('seu@email.com'),
                  validator: (value) =>
                      (value == null || !value.contains('@'))
                          ? 'E-mail inválido'
                          : null,
                ),
                const SizedBox(height: 14),
                _FieldLabel('Telefone'),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration('(00) 00000-0000'),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 24),
                const Text('Sobre a Rotina',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _FieldLabel('Tipo de Moradia'),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        value: 'Casa',
                        groupValue: _housingType,
                        activeColor: _primaryGreen,
                        title: const Text('Casa'),
                        onChanged: (value) =>
                            setState(() => _housingType = value!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        value: 'Apartamento',
                        groupValue: _housingType,
                        activeColor: _primaryGreen,
                        title: const Text('Apartamento'),
                        onChanged: (value) =>
                            setState(() => _housingType = value!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _FieldLabel('Tempo médio que o animal ficará sozinho (por dia)'),
                DropdownButtonFormField<String>(
                  value: _timeAlone,
                  decoration: _inputDecoration('Selecione uma opção'),
                  items: _timeAloneOptions
                      .map((option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _timeAlone = value),
                  validator: (value) =>
                      value == null ? 'Selecione uma opção' : null,
                ),
                const SizedBox(height: 14),
                _FieldLabel('Mensagem para o abrigo (opcional)'),
                TextFormField(
                  controller: _messageController,
                  maxLines: 4,
                  decoration: _inputDecoration(
                    'Conte um pouco sobre você e por que deseja adotar o Bento...',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      activeColor: _primaryGreen,
                      onChanged: (value) =>
                          setState(() => _agreedToTerms = value ?? false),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          'Declaro que as informações acima são verdadeiras '
                          'e concordo com os termos de adoção responsável.',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey[700]),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Enviar Solicitação  ➤'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _primaryGreen),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}
