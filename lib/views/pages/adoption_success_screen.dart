
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

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

  String? _housingType;
  String? _aloneTime;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryGreen,
        title: const Text(
          'Formulário de Adoção',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(
              Icons.volunteer_activism,
              size: 48,
              color: AppColors.accentGreen,
            ),
            const SizedBox(height: 12),
            const Text(
              'Vamos encontrar seu novo melhor amigo!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Preencha as informações abaixo para demonstrar '
                  'seu interesse em adotar.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textGray,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            _sectionTitle('Seus dados'),
            const SizedBox(height: 12),

            _textField(
              controller: _nameController,
              label: 'Nome completo',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe seu nome completo.';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            _textField(
              controller: _emailController,
              label: 'E-mail',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe seu e-mail.';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                    .hasMatch(value.trim())) {
                  return 'Informe um e-mail válido.';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            _textField(
              controller: _phoneController,
              label: 'Telefone',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe seu telefone.';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            _sectionTitle('Sobre sua moradia'),
            const SizedBox(height: 12),

            _dropdown(
              label: 'Tipo de moradia',
              value: _housingType,
              items: const [
                'Casa com quintal',
                'Casa sem quintal',
                'Apartamento',
                'Chácara ou sítio',
              ],
              onChanged: (value) {
                setState(() => _housingType = value);
              },
              validator: (value) {
                if (value == null) {
                  return 'Selecione seu tipo de moradia.';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            _dropdown(
              label: 'Quanto tempo o animal ficará sozinho?',
              value: _aloneTime,
              items: const [
                'Quase nunca',
                'Até 2 horas por dia',
                'De 2 a 6 horas por dia',
                'Mais de 6 horas por dia',
              ],
              onChanged: (value) {
                setState(() => _aloneTime = value);
              },
              validator: (value) {
                if (value == null) {
                  return 'Selecione uma opção.';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            _sectionTitle('Conte mais sobre você'),
            const SizedBox(height: 12),

            _textField(
              controller: _messageController,
              label: 'Mensagem para a ONG',
              icon: Icons.chat_bubble_outline,
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Conte um pouco sobre seu interesse em adotar.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColors.primaryGreen,
              value: _acceptedTerms,
              onChanged: (value) {
                setState(() => _acceptedTerms = value ?? false);
              },
              title: const Text(
                'Aceito os termos e autorizo o uso dos dados '
                    'para análise da solicitação de adoção.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textDark,
                ),
              ),
            ),

            if (!_acceptedTerms)
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  'O aceite dos termos é obrigatório.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textGray,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.pets),
                label: const Text('Enviar solicitação'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'O envio do formulário não garante a aprovação da adoção. '
                  'A ONG entrará em contato para dar continuidade ao processo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textGray,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryGreen,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.textDark,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.accentGreen),
        filled: true,
        fillColor: AppColors.cardBackground,
        labelStyle: const TextStyle(color: AppColors.textGray),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      validator: validator,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.cardBackground,
        labelStyle: const TextStyle(
          color: AppColors.textGray,
          fontSize: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: const TextStyle(fontSize: 13),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  void _submitForm() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) return;

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa aceitar os termos para continuar.'),
        ),
      );
      return;
    }

    // Dados mocados: futuramente serão enviados para a API.
    final formData = {
      'nome': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'telefone': _phoneController.text.trim(),
      'tipoMoradia': _housingType,
      'tempoMedioSozinho': _aloneTime,
      'mensagem': _messageController.text.trim(),
      'aceitarTermos': _acceptedTerms,
    };

    debugPrint('Solicitação de adoção: $formData');

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: const Text(
            'Solicitação preenchida!',
            style: TextStyle(color: AppColors.primaryGreen),
          ),
          content: const Text(
            'Os dados foram validados. Quando a API estiver integrada, '
                'a solicitação poderá ser enviada para a ONG.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text(
                'Entendi',
                style: TextStyle(color: AppColors.primaryGreen),
              ),
            ),
          ],
        );
      },
    );
  }
}
