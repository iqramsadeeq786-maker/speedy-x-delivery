
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1266D5),
        ),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            return RiderDashboard(
              user: snapshot.data!,
              language: language,
              onLanguageChanged: (v) {
                setState(() => language = v);
              },
            );
          }

          return LoginPage(
            language: language,
            onLanguageChanged: (v) {
              setState(() => language = v);
            },
          );
        },
      ),
    );
  }
}

class Words {
  static const Map<String, List<String>> data = {
    'en': [
      'Speedy X Delivery', 'Rider Login', 'Rider Email',
      'Password', 'LOGIN', 'New Rider?',
      'Contact Admin to Join',
      'Admin creates and activates all rider accounts.',
      'Please enter email and password.',
      'Invalid email or password.',
      'Network error. Please try again.',
      'Logout', 'Welcome Rider', 'Dashboard', 'My Orders',
      'My Earnings', 'Live Location', 'My Profile',
      'Total Orders', 'Completed', 'Pending', 'AED',
      'No orders assigned yet', 'Your assigned orders will appear here.',
      'Your earnings will appear here.',
      'Location tracking will be available soon.',
      'Account Information', 'Email', 'Status',
      'Logged In', 'Demo data only', 'Online',
      'Offline', 'English', 'Urdu', 'Arabic'
    ],
    'ur': [
      'اسپیڈی ایکس ڈیلیوری', 'رائڈر لاگ اِن', 'رائڈر ای میل',
      'پاس ورڈ', 'لاگ اِن', 'نئے رائڈر ہیں؟',
      'شامل ہونے کے لیے ایڈمن سے رابطہ کریں',
      'رائڈر اکاؤنٹ ایڈمن بنائے گا اور فعال کرے گا۔',
      'ای میل اور پاس ورڈ درج کریں۔',
      'ای میل یا پاس ورڈ غلط ہے۔',
      'انٹرنیٹ کا مسئلہ ہے، دوبارہ کوشش کریں۔',
      'لاگ آؤٹ', 'خوش آمدید رائڈر', 'ڈیش بورڈ',
      'میرے آرڈرز', 'میری کمائی', 'لائیو لوکیشن',
      'میری پروفائل', 'کل آرڈرز', 'مکمل', 'زیرِ التوا',
      'درہم', 'ابھی کوئی آرڈر نہیں دیا گیا',
      'ایڈمن کے دیے گئے آرڈرز یہاں نظر آئیں گے۔',
      'آپ کی کمائی یہاں نظر آئے گی۔',
      'لوکیشن ٹریکنگ جلد دستیاب ہوگی۔',
      'اکاؤنٹ کی معلومات', 'ای میل', 'اسٹیٹس',
      'لاگ اِن ہے', 'صرف ڈیمو ڈیٹا', 'آن لائن',
      'آف لائن', 'English', 'اردو', 'العربية'
    ],
    'ar': [
      'سبيدي إكس للتوصيل', 'تسجيل دخول السائق',
      'البريد الإلكتروني', 'كلمة المرور', 'تسجيل الدخول',
      'سائق جديد؟', 'تواصل مع الإدارة للانضمام',
      'تقوم الإدارة بإنشاء حساب السائق وتفعيله.',
      'يرجى إدخال البريد الإلكتروني وكلمة المرور.',
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
      'خطأ في الاتصال. حاول مرة أخرى.',
      'تسجيل الخروج', 'مرحباً أيها السائق', 'لوحة التحكم',
      'طلباتي', 'أرباحي', 'الموقع المباشر', 'ملفي الشخصي',
      'إجمالي الطلبات', 'مكتمل', 'قيد الانتظار',
      'درهم', 'لا توجد طلبات معينة حتى الآن',
      'ستظهر الطلبات المعينة لك هنا.',
      'ستظهر أرباحك هنا.',
      'سيكون تتبع الموقع متاحاً قريباً.',
      'معلومات الحساب', 'البريد الإلكتروني', 'الحالة',
      'تم تسجيل الدخول', 'بيانات تجريبية فقط', 'متصل',
      'غير متصل', 'English', 'اردو', 'العربية'
    ],
  };

  static String get(String lang, int index) =>
      data[lang]![index];
}

class LoginPage extends StatefulWidget {
  final String language;
  final ValueChanged<String> onLanguageChanged;

  const LoginPage({
    super.key,
    required this.language,
    required this.onLanguageChanged,
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

  Future<void> contactAdmin() async {
    final uri = Uri.parse(
      'https://wa.me/97150335951?text=${Uri.encodeComponent("Hello, I want to join Speedy X Delivery as a rider.")}',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> login() async {
    final t = Words.data[widget.language]!;

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
            ? t[10]
            : t[9];
      });
    } catch (_) {
      setState(() => error = t[10]);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Words.data[widget.language]!;
    final rtl = widget.language != 'en';

    return Directionality(
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
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
                        DropdownMenuItem(
                          value: 'en', child: Text('English')),
                        DropdownMenuItem(
                          value: 'ur', child: Text('اردو')),
                        DropdownMenuItem(
                          value: 'ar', child: Text('العربية')),
                      ],
                      onChanged: (v) {
                        if (v != null) widget.onLanguageChanged(v);
                      },
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      'speedy_x_app_icon.png',
                      width: 120,
                      height: 120,
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
                    Text(t[5], textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: contactAdmin,
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
      ),
    );
  }
}

class RiderDashboard extends StatefulWidget {
  final User user;
  final String language;
  final ValueChanged<String> onLanguageChanged;

  const RiderDashboard({
    super.key,
    required this.user,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  State<RiderDashboard> createState() => _RiderDashboardState();
}

class _RiderDashboardState extends State<RiderDashboard> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final t = Words.data[widget.language]!;
    final rtl = widget.language != 'en';

    final pages = [
      dashboard(t),
      orders(t),
      earnings(t),
      location(t),
      profile(t),
    ];

    return Directionality(
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t[0]),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.language),
              onSelected: widget.onLanguageChanged,
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'en', child: Text('English')),
                PopupMenuItem(value: 'ur', child: Text('اردو')),
                PopupMenuItem(value: 'ar', child: Text('العربية')),
              ],
            ),
            IconButton(
              tooltip: t[11],
              icon: const Icon(Icons.logout),
              onPressed: () => FirebaseAuth.instance.signOut(),
            ),
          ],
        ),
        body: SafeArea(
          child: pages[selected],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selected,
          onDestinationSelected: (value) {
            setState(() => selected = value);
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: const Icon(Icons.dashboard),
              label: t[13],
            ),
            NavigationDestination(
              icon: const Icon(Icons.receipt_long),
              label: t[14],
            ),
            NavigationDestination(
              icon: const Icon(Icons.account_balance_wallet),
              label: t[15],
            ),
            NavigationDestination(
              icon: const Icon(Icons.location_on),
              label: t[16],
            ),
            NavigationDestination(
              icon: const Icon(Icons.person),
              label: t[17],
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboard(List<String> t) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t[12],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.user.email ?? '',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12),
              const Chip(
                label: Text('Demo Dashboard'),
                avatar: Icon(Icons.info_outline),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: statCard(
                Icons.inventory_2,
                t[18],
                '0',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: statCard(
                Icons.check_circle,
                t[19],
                '0',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: statCard(
                Icons.pending_actions,
                t[20],
                '0',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: statCard(
                Icons.wallet,
                t[15],
                '${t[21]} 0',
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          t[14],
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        emptyCard(Icons.inbox, t[22], t[23]),
        const SizedBox(height: 18),
        Text(
          t[16],
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        emptyCard(Icons.location_on, t[25], t[25]),
      ],
    );
  }

  Widget statCard(IconData icon, String title, String value) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget emptyCard(IconData icon, String title, String subtitle) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Icon(icon, size: 38, color: Colors.grey),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget orders(List<String> t) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text(
          t[14],
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        emptyCard(Icons.inbox, t[22], t[23]),
      ],
    );
  }

  Widget earnings(List<String> t) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text(
          t[15],
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        statCard(Icons.account_balance_wallet, t[15], '${t[21]} 0'),
        const SizedBox(height: 12),
        emptyCard(Icons.bar_chart, t[30], t[24]),
      ],
    );
  }

  Widget location(List<String> t) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text(
          t[16],
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        emptyCard(Icons.location_on, t[16], t[26]),
        const SizedBox(height: 12),
        Text(
          'GPS is not connected yet.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget profile(List<String> t) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text(
          t[17],
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const CircleAvatar(
          radius: 42,
          child: Icon(Icons.person, size: 45),
        ),
        const SizedBox(height: 20),
        Card(
          child: ListTile(
            leading: const Icon(Icons.email),
            title: Text(t[27]),
            subtitle: Text(widget.user.email ?? ''),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.verified_user),
            title: Text(t[28]),
            subtitle: Text(t[29]),
          ),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => FirebaseAuth.instance.signOut(),
          icon: const Icon(Icons.logout),
          label: Text(t[11]),
        ),
      ],
    );
  }
}
