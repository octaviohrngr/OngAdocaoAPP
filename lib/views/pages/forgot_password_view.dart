
import 'package:flutter/material.dart';

import '../../viewmodels/password_reset_viewmodel.dart';
import '../theme/app_colors.dart';
import 'login_view.dart';

InputDecoration resetInputDecoration(
    String hint, {
      IconData? icon,
      Widget? suffixIcon,
    }) {
  return InputDecoration(
    hintText: hint,
    prefixIcon: icon == null ? null : Icon(icon),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 17,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: AppColors.primaryGreen,
      ),
    ),
  );
}

class ResetPageLayout extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Widget child;

  const ResetPageLayout({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryGreen,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Icon(
                      icon,
                      size: 42,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textGray,
                  ),
                ),
                const SizedBox(height: 30),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() =>
      _ForgotPasswordViewState();
}

class _ForgotPasswordViewState
    extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _viewModel = PasswordResetViewModel();

  @override
  void dispose() {
    _emailController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _enviarCodigo() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    final sucesso = await _viewModel.solicitarCodigo(email);

    if (!mounted) return;

    if (sucesso) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyCodeView(email: email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _viewModel.erro ??
                'Não foi possível enviar o código.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResetPageLayout(
      title: 'Esqueceu sua senha?',
      description:
      'Informe o e-mail cadastrado para receber '
          'um código de verificação.',
      icon: Icons.mark_email_read_outlined,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'E-mail',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: resetInputDecoration(
                'Digite seu e-mail cadastrado',
                icon: Icons.email_outlined,
              ),
              validator: (value) {
                final email = value?.trim() ?? '';
                if (!RegExp(
                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                ).hasMatch(email)) {
                  return 'Informe um e-mail válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                return SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _viewModel.isLoading
                        ? null
                        : _enviarCodigo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _viewModel.isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      'Enviar código',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class VerifyCodeView extends StatefulWidget {
  final String email;

  const VerifyCodeView({
    super.key,
    required this.email,
  });

  @override
  State<VerifyCodeView> createState() =>
      _VerifyCodeViewState();
}

class _VerifyCodeViewState extends State<VerifyCodeView> {
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
  final _viewModel = PasswordResetViewModel();

  @override
  void dispose() {
    _codigoController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _verificarCodigo() async {
    if (!_formKey.currentState!.validate()) return;

    final codigo = _codigoController.text.trim();

    final resetToken = await _viewModel.verificarCodigo(
      email: widget.email,
      codigo: codigo,
    );

    if (!mounted) return;

    if (resetToken != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NewPasswordView(
            email: widget.email,
            codigo: codigo,
            resetToken: resetToken,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _viewModel.erro ??
                'Código de verificação inválido.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResetPageLayout(
      title: 'Verificar código',
      description:
      'Digite o código de 4 dígitos enviado para '
          '${widget.email}.',
      icon: Icons.verified_user_outlined,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Código de verificação',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _codigoController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                letterSpacing: 12,
                fontWeight: FontWeight.bold,
              ),
              decoration: resetInputDecoration(
                '0000',
                icon: Icons.pin_outlined,
              ),
              validator: (value) {
                if (!RegExp(r'^\d{4}$')
                    .hasMatch(value?.trim() ?? '')) {
                  return 'Digite os 4 dígitos do código';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                return SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _viewModel.isLoading
                        ? null
                        : _verificarCodigo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _viewModel.isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      'Verificar código',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NewPasswordView extends StatefulWidget {
  final String email;
  final String codigo;
  final String resetToken;

  const NewPasswordView({
    super.key,
    required this.email,
    required this.codigo,
    required this.resetToken,
  });

  @override
  State<NewPasswordView> createState() =>
      _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _senhaController = TextEditingController();
  final _confirmarController = TextEditingController();
  final _viewModel = PasswordResetViewModel();

  bool _ocultarSenha = true;
  bool _ocultarConfirmacao = true;

  @override
  void dispose() {
    _senhaController.dispose();
    _confirmarController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _salvarSenha() async {
    if (!_formKey.currentState!.validate()) return;

    final sucesso = await _viewModel.redefinirSenha(
      email: widget.email,
      codigo: widget.codigo,
      resetToken: widget.resetToken,
      novaSenha: _senhaController.text,
    );

    if (!mounted) return;

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Senha redefinida com sucesso! Faça login.',
          ),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginView(),
        ),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _viewModel.erro ??
                'Não foi possível redefinir a senha.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResetPageLayout(
      title: 'Criar nova senha',
      description:
      'Defina uma nova senha para acessar sua conta.',
      icon: Icons.lock_reset_outlined,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Nova senha',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _senhaController,
              obscureText: _ocultarSenha,
              decoration: resetInputDecoration(
                'Digite a nova senha',
                icon: Icons.lock_outline,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _ocultarSenha = !_ocultarSenha;
                    });
                  },
                  icon: Icon(
                    _ocultarSenha
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (value) {
                if ((value ?? '').length < 8) {
                  return 'A senha deve ter pelo menos 8 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            const Text(
              'Confirmar senha',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _confirmarController,
              obscureText: _ocultarConfirmacao,
              decoration: resetInputDecoration(
                'Confirme a nova senha',
                icon: Icons.lock_outline,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _ocultarConfirmacao =
                      !_ocultarConfirmacao;
                    });
                  },
                  icon: Icon(
                    _ocultarConfirmacao
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (value) {
                if (value != _senhaController.text) {
                  return 'As senhas não coincidem';
                }
                return null;
              },
            ),
            const SizedBox(height: 26),
            ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                return SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _viewModel.isLoading
                        ? null
                        : _salvarSenha,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _viewModel.isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      'Salvar nova senha',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
