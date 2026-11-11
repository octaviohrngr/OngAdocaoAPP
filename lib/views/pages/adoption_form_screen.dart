
import 'package:flutter/material.dart';
import '../../viewmodels/adoption_form_viewmodel.dart';
import '../../data/services/auth_session.dart';
import 'adoption_success_screen.dart';
import 'login_view.dart';
import '../../models/animal.dart';
import '../theme/app_colors.dart';
import 'adoption_success_screen.dart';


class AdoptionFormScreen extends StatefulWidget {
  final Animal animal;

  const AdoptionFormScreen({
    super.key,
    required this.animal,
  });

  @override
  State<AdoptionFormScreen> createState() =>
      _AdoptionFormScreenState();
}

class _AdoptionFormScreenState extends State<AdoptionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final AdoptionFormViewModel _viewModel = AdoptionFormViewModel();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  String? _housingType;
  String? _timeAlone;
  bool _agreedToTerms = false;

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
    _viewModel.dispose();
    super.dispose();
  }


  Future<void> _submit() async {
    if (_viewModel.isLoading) return;

    final formularioValido =
        _formKey.currentState?.validate() ?? false;

    if (!formularioValido) return;

    if (_housingType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione o tipo de moradia.'),
        ),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Você precisa concordar com os termos de adoção.',
          ),
        ),
      );
      return;
    }

    if (AuthSession.token == null ||
        AuthSession.token!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Faça login para enviar sua solicitação.',
          ),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginView(),
        ),
      );
      return;
    }

    final sucesso = await _viewModel.enviarSolicitacao(
      animal: widget.animal,
      nome: _nameController.text,
      email: _emailController.text,
      telefone: _phoneController.text,
      tipoMoradia: _housingType!,
      tempoMedioSozinho: _timeAlone!,
      mensagem: _messageController.text,
      aceitarTermos: _agreedToTerms,
    );

    if (!mounted) return;

    if (sucesso) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AdoptionSuccessScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _viewModel.mensagemErro ??
                'Não foi possível enviar a solicitação.',
          ),
          backgroundColor: Colors.red,
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
        surfaceTintColor: Colors.white,
        foregroundColor: AppColors.primaryGreen,
        centerTitle: true,
        title: const Text(
          'Atipattas',
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Solicitação de Adoção',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Você está a um passo de dar um lar cheio '
                    'de amor para ${widget.animal.nome}.',
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: AppColors.textGray,
                ),
              ),

              const SizedBox(height: 22),

              _animalCard(),

              const SizedBox(height: 22),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  16,
                  20,
                  16,
                  18,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Seus Dados'),

                      const SizedBox(height: 18),

                      const _FieldLabel('Nome Completo'),

                      TextFormField(
                        controller: _nameController,
                        textCapitalization:
                        TextCapitalization.words,
                        decoration: _inputDecoration(
                          'Digite seu nome completo',
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Informe seu nome completo';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      const _FieldLabel('E-mail'),

                      TextFormField(
                        controller: _emailController,
                        keyboardType:
                        TextInputType.emailAddress,
                        decoration: _inputDecoration(
                          'seu@email.com',
                        ),
                        validator: (value) {
                          final email = value?.trim() ?? '';

                          if (email.isEmpty ||
                              !email.contains('@') ||
                              !email.contains('.')) {
                            return 'Informe um e-mail válido';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      const _FieldLabel('Telefone'),

                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration(
                          '(00) 00000-0000',
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Informe seu telefone';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 28),

                      _sectionTitle('Sobre a Rotina'),

                      const SizedBox(height: 18),

                      const _FieldLabel('Tipo de Moradia'),

                      Row(
                        children: [
                          _housingOption('Casa'),
                          const SizedBox(width: 8),
                          _housingOption('Apartamento'),
                        ],
                      ),

                      const SizedBox(height: 18),

                      const _FieldLabel(
                        'Tempo médio que o animal ficará sozinho '
                            '(por dia)',
                      ),

                      DropdownButtonFormField<String>(
                        value: _timeAlone,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.textDark,
                        ),
                        decoration: _inputDecoration(
                          'Selecione uma opção',
                        ),
                        items: _timeAloneOptions.map((option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(
                              option,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textDark,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _timeAlone = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Selecione uma opção';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      const _FieldLabel(
                        'Mensagem para o abrigo (opcional)',
                      ),

                      TextFormField(
                        controller: _messageController,
                        maxLines: 3,
                        textCapitalization:
                        TextCapitalization.sentences,
                        decoration: _inputDecoration(
                          'Conte um pouco sobre você e por '
                              'que deseja adotar ${widget.animal.nome}...',
                        ),
                      ),

                      const SizedBox(height: 22),

                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _agreedToTerms,
                              activeColor:
                              AppColors.primaryGreen,
                              side: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _agreedToTerms =
                                      value ?? false;
                                });
                              },
                            ),
                          ),

                          const SizedBox(width: 10),

                          const Expanded(
                            child: Text(
                              'Declaro que as informações acima '
                                  'são verdadeiras e concordo com '
                                  'os termos de adoção responsável.',
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.5,
                                color: AppColors.textGray,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),


                      ListenableBuilder(
                        listenable: _viewModel,
                        builder: (context, _) {
                          return SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed:
                              _viewModel.isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor:
                                AppColors.primaryGreen.withOpacity(0.6),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: _viewModel.isLoading
                                  ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Enviar Solicitação',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 19,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _animalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.animal.foto1,
              width: 62,
              height: 62,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 62,
                  height: 62,
                  color: AppColors.inputFill,
                  child: const Icon(
                    Icons.pets,
                    color: AppColors.primaryGreen,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.animal.nome,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '${widget.animal.raca}, '
                      '${widget.animal.idadeEstimada} anos',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),

        const SizedBox(height: 8),

        Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey.shade200,
        ),
      ],
    );
  }

  Widget _housingOption(String value) {
    final selected = _housingType == value;

    return InkWell(
      onTap: () {
        setState(() {
          _housingType = value;
        });
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected
                ? AppColors.primaryGreen
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: selected
                      ? AppColors.primaryGreen
                      : Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? Center(
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),
              )
                  : null,
            ),

            const SizedBox(width: 6),

            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppColors.textGray,
        fontSize: 12,
      ),
      filled: true,
      fillColor: AppColors.inputFill,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(
          color: AppColors.primaryGreen,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
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
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}
