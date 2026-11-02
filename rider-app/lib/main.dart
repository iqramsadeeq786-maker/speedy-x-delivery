
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SpeedyXRiderApp());
}

class SpeedyXRiderApp extends StatefulWidget {
  const SpeedyXRiderApp({super.key});

  @override
  State<SpeedyXRiderApp> createState() => _SpeedyXRiderAppState();
}

class _SpeedyXRiderAppState extends State<SpeedyXRiderApp> {
  String language = 'en';
  static const waNumber = '971503358951';

  static const words = {
    'en': [
      'Speedy X Delivery', 'Rider Login', 'Rider Email',
      'Password', 'LOGIN', 'New Rider?',
      'Contact Admin to Join',
      'Admin creates and activates all rider accounts.',
      'Please enter email and password.',
      'Login successful!', 'Invalid email or password.',
      'Network error. Please try again.',
      'Logout', 'Welcome Rider'
    ],
    'ur': [
      'اسپیڈی ایکس ڈیلیوری', 'رائڈر لاگ اِن', 'رائڈر ای میل',
      'پاس ورڈ', 'لاگ اِن', 'نئے رائڈر ہیں؟',
      'شامل ہونے کے لیے ایڈمن سے رابطہ کریں',
      'رائڈر اکاؤنٹ ایڈمن بنائے گا اور فعال کرے گا۔',
      'ای میل اور پاس ورڈ درج کریں۔',
      'لاگ اِن کامیاب ہوگیا!', 'ای میل یا پاس ورڈ غلط ہے۔',
      'انٹرنیٹ کا مسئلہ ہے، دوبارہ کوشش کریں۔',
      'لاگ آؤٹ', 'خوش آمدید رائڈر'
    ],
    'ar': [
      'سبيدي إكس للتوصيل', 'تسجيل دخول السائق', 'البريد الإلكتروني',
      'كلمة المرور', 'تسجيل الدخول', 'سائق جديد؟',
      'تواصل مع الإدارة للانضمام',
      'تقوم الإدارة بإنشاء حساب السائق وتفعيله.',
      'يرجى إدخال البريد الإلكتروني وكلمة المرور.',
      'تم تسجيل الدخول بنجاح!', 'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
      'خطأ في الاتصال. حاول مرة أخرى.',
      'تسجيل الخروج', 'مرحباً أيها السائق'
    ],
  };

  Future<void> contact() async {
    final uri = Uri.parse(
      'https://wa.me/$waNumber?text=${Uri.encodeComponent("Hello, I want to join Speedy X Delivery as a rider.")}',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final t = words[language]!;
    final rtl = language != 'en';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1266D5),
        ),
        useMaterial3: true,
      ),
      home: Directionality(
        textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(t[0]),
                  actions: [
                    TextButton(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: Text(t[12]),
                    ),
                  ],
                ),
                body: Center(
                  child: Text(
                    '${t[13]}\n${snapshot.data!.email ?? ''}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              );
            }

            return LoginPage(
              language: language,
              onLanguageChanged: (v) {
                setState(() => language = v);
              },
              contact: contact,
            );
          },
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  final String language;
  final ValueChanged<String> onLanguageChanged;
  final VoidCallback contact;

  const LoginPage({
    super.key,
    required this.language,
    required this.onLanguageChanged,
    required this.contact,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;
  String? error;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final t = wordsFor(widget.language);

    if (email.text.trim().isEmpty || password.text.isEmpty) {
      setState(() => error = t[8]);
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.code == 'network-request-failed'
            ? t[11]
            : t[10];
      });
    } catch (_) {
      setState(() => error = t[11]);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  List<String> wordsFor(String lang) {
    const data = {
      'en': [
        'Speedy X Delivery', 'Rider Login', 'Rider Email',
        'Password', 'LOGIN', 'New Rider?',
        'Contact Admin to Join',
        'Admin creates and activates all rider accounts.',
        'Please enter email and password.',
        'Login successful!', 'Invalid email or password.',
        'Network error. Please try again.',
        'Logout', 'Welcome Rider'
      ],
      'ur': [
        'اسپیڈی ایکس ڈیلیوری', 'رائڈر لاگ اِن', 'رائڈر ای میل',
        'پاس ورڈ', 'لاگ اِن', 'نئے رائڈر ہیں؟',
        'شامل ہونے کے لیے ایڈمن سے رابطہ کریں',
        'رائڈر اکاؤنٹ ایڈمن بنائے گا اور فعال کرے گا۔',
        'ای میل اور پاس ورڈ درج کریں۔',
        'لاگ اِن کامیاب ہوگیا!', 'ای میل یا پاس ورڈ غلط ہے۔',
        'انٹرنیٹ کا مسئلہ ہے، دوبارہ کوشش کریں۔',
        'لاگ آؤٹ', 'خوش آمدید رائڈر'
      ],
      'ar': [
        'سبيدي إكس للتوصيل', 'تسجيل دخول السائق', 'البريد الإلكتروني',
        'كلمة المرور', 'تسجيل الدخول', 'سائق جديد؟',
        'تواصل مع الإدارة للانضمام',
        'تقوم الإدارة بإنشاء حساب السائق وتفعيله.',
        'يرجى إدخال البريد الإلكتروني وكلمة المرور.',
        'تم تسجيل الدخول بنجاح!', 'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
        'خطأ في الاتصال. حاول مرة أخرى.',
        'تسجيل الخروج', 'مرحباً أيها السائق'
      ],
    };
    return data[lang]!;
  }

  @override
  Widget build(BuildContext context) {
    final t = wordsFor(widget.language);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButton<String>(
                    value: widget.language,
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'ur', child: Text('اردو')),
                      DropdownMenuItem(value: 'ar', child: Text('العربية')),
                    ],
                    onChanged: (v) {
                      if (v != null) widget.onLanguageChanged(v);
                    },
                  ),
                  const SizedBox(height: 18),
                  Image.asset(
                    'speedy_x_app_icon.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    t[0],
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(t[1], textAlign: TextAlign.center),
                  const SizedBox(height: 28),
                  TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: t[2],
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: t[3],
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    onSubmitted: (_) => login(),
                  ),
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: loading ? null : login,
                    child: loading
                        ? const CircularProgressIndicator()
                        : Text(t[4]),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  const SizedBox(height: 28),
                  Text(
                    t[5],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: widget.contact,
                    icon: const Icon(Icons.chat),
                    label: Text(t[6]),
                  ),
                  const SizedBox(height: 10),
                  Text(t[7], textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  const Text(
                    'WhatsApp: +971 50 335 8951',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
