import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../widgets/kobimat_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onLogin, this.onLoggedIn});

  /// Backend'e bağla (örn. Supabase auth). Hata fırlatırsa form hata gösterir.
  final Future<void> Function(String email, String password) onLogin;
  final VoidCallback? onLoggedIn;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.onLogin(_email.text.trim(), _password.text);
      widget.onLoggedIn?.call();
    } catch (_) {
      _error = 'E-posta veya şifre hatalı.';
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(KSpace.pageGutter, 48, KSpace.pageGutter, KSpace.section),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const KobimatLogo(size: 56, showWordmark: true),
            const SizedBox(height: KSpace.section),
            SurfaceCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Tekrar hoş geldin', style: t.titleLarge),
                const SizedBox(height: KSpace.helper),
                Text('Hesabına giriş yap ve gönderilerini yönet.',
                    style: t.bodyMedium?.copyWith(color: mutedOf(context))),
                const SizedBox(height: KSpace.field),
                LabeledField(
                    label: 'E-posta',
                    controller: _email,
                    hint: 'ornek@sirket.com',
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email]),
                const SizedBox(height: KSpace.field),
                LabeledField(
                    label: 'Şifre',
                    controller: _password,
                    hint: 'Şifren',
                    obscure: true,
                    errorText: _error,
                    autofillHints: const [AutofillHints.password]),
                const SizedBox(height: KSpace.field),
                PrimaryButton(label: 'Giriş yap', loading: _loading, onPressed: _submit),
                const SizedBox(height: KSpace.compact),
                TextAction(label: 'Şifremi unuttum', onPressed: () {}),
              ]),
            ),
            const SizedBox(height: KSpace.field),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text('Hesabın yok mu? Kayıt ol',
                    style: t.labelLarge?.copyWith(color: isDark(context) ? KColors.primaryLight : KColors.primaryDark)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
