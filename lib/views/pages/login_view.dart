import 'package:flutter/material.dart';
import 'package:ong_adocao_app/viewmodels/login_viewmodel.dart';
import 'package:ong_adocao_app/views/pages/home_view.dart';
import 'package:ong_adocao_app/views/pages/signup_screen.dart';
import 'package:ong_adocao_app/views/theme/app_colors.dart';
import 'admin_animals_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LoginViewModel viewModel = LoginViewModel();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    viewModel.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final perfil = await viewModel.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (perfil == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewModel.erro ??
                'Não foi possível entrar. Confira seu e-mail e sua senha.',
          ),
        ),
      );
      return;
    }

    if (perfil == 'admin') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const AdminAnimalsView(),
        ),
            (route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const HomeView(),
        ),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primaryGreen,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SafeArea(
        // Reconstrói a tela quando o ViewModel avisar que algo mudou
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Form(
                  key: _formKey,
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
                          child: const Icon(
                            Icons.pets,
                            size: 44,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Bem-vindo de volta!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Entre na sua conta e encontre seu novo melhor amigo.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: AppColors.textGray,
                        ),
                      ),
                      const SizedBox(height: 32),
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
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Digite seu e-mail',
                          prefixIcon: const Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: viewModel.validateEmail,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Senha',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: viewModel.hidePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _login(),
                        decoration: InputDecoration(
                          hintText: 'Digite sua senha',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: viewModel.toggleHidePassword,
                            icon: Icon(
                              viewModel.hidePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: viewModel.validatePassword,
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: viewModel.isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: viewModel.isLoading
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : const Text(
                            'Entrar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Flexible(
                            child: Text(
                              'Ainda não tem uma conta?',
                              style: TextStyle(color: AppColors.textGray),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignupScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Cadastre-se',
                              style: TextStyle(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}