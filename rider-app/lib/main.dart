import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      'Speedy X Delivery',
      'Rider Login',
      'Rider Email',
      'Password',
      'LOGIN',
      'New Rider?',
      'Contact Admin to Join',
      'Admin creates and activates all rider accounts.',
      'Please enter email and password.',
      'Invalid email or password.',
      'Network error. Please try again.',
      'Logout',
      'Welcome Rider',
      'Dashboard',
      'My Orders',
      'My Earnings',
      'Live Location',
      'My Profile',
      'Total Orders',
      'Completed',
      'Pending',
      'AED',
      'No orders assigned yet',
      'Your assigned orders will appear here.',
      'Your earnings will appear here.',
      'Location tracking will be available soon.',
      'Account Information',
      'Email',
      'Status',
      'Logged In',
      'Demo data only',
      'Online',
      'Offline',
      'English',
      'Urdu',
      'Arabic',
      'Customer',
      'Phone',
      'Delivery Address',
      'Amount',
      'Payment',
      'Order Status',
      'Update Status',
      'Call Customer',
      'Open Map',
      'Order Details',
      'Loading orders...',
      'Could not load orders.',
      'No orders assigned to your account.',
      'Status updated successfully.',
      'Update failed. Please try again.',
      'Select Status',
      'Processing',
      'Confirmed',
      'Packed',
      'Shipped',
      'Out for Delivery',
      'Delivered',
      'Completed',
      'Cancelled',
      'Returned',
      'Order Number',
    ],
    'ur': [
      'اسپیڈی ایکس ڈیلیوری',
      'رائڈر لاگ اِن',
      'رائڈر ای میل',
      'پاس ورڈ',
      'لاگ اِن',
      'نئے رائڈر ہیں؟',
      'شامل ہونے کے لیے ایڈمن سے رابطہ کریں',
      'رائڈر اکاؤنٹ ایڈمن بنائے گا اور فعال کرے گا۔',
      'ای میل اور پاس ورڈ درج کریں۔',
      'ای میل یا پاس ورڈ غلط ہے۔',
      'انٹرنیٹ کا مسئلہ ہے، دوبارہ کوشش کریں۔',
      'لاگ آؤٹ',
      'خوش آمدید رائڈر',
      'ڈیش بورڈ',
      'میرے آرڈرز',
      'میری کمائی',
      'لائیو لوکیشن',
      'میری پروفائل',
      'کل آرڈرز',
      'مکمل',
      'زیرِ التوا',
      'درہم',
      'ابھی کوئی آرڈر نہیں دیا گیا',
      'ایڈمن کے دیے گئے آرڈرز یہاں نظر آئیں گے۔',
      'آپ کی کمائی یہاں نظر آئے گی۔',
      'لوکیشن ٹریکنگ جلد دستیاب ہوگی۔',
      'اکاؤنٹ کی معلومات',
      'ای میل',
      'اسٹیٹس',
      'لاگ اِن ہے',
      'صرف ڈیمو ڈیٹا',
      'آن لائن',
      'آف لائن',
      'English',
      'اردو',
      'العربية',
      'کسٹمر',
      'فون',
      'ڈیلیوری ایڈریس',
      'رقم',
      'ادائیگی',
      'آرڈر کا اسٹیٹس',
      'اسٹیٹس تبدیل کریں',
      'کسٹمر کو کال کریں',
      'نقشے پر دیکھیں',
      'آرڈر کی تفصیلات',
      'آرڈرز لوڈ ہو رہے ہیں...',
      'آرڈرز لوڈ نہیں ہو سکے۔',
      'آپ کے اکاؤنٹ پر کوئی آرڈر نہیں ہے۔',
      'اسٹیٹس کامیابی سے تبدیل ہوگیا۔',
      'تبدیلی ناکام ہوگئی، دوبارہ کوشش کریں۔',
      'اسٹیٹس منتخب کریں',
      'پروسیسنگ',
      'کنفرم',
      'پیک ہو گیا',
      'شپ ہو گیا',
      'ڈیلیوری کے لیے روانہ',
      'ڈیلیور ہو گیا',
      'مکمل',
      'منسوخ',
      'واپس',
      'آرڈر نمبر',
    ],
    'ar': [
      'سبيدي إكس للتوصيل',
      'تسجيل دخول السائق',
      'البريد الإلكتروني',
      'كلمة المرور',
      'تسجيل الدخول',
      'سائق جديد؟',
      'تواصل مع الإدارة للانضمام',
      'تقوم الإدارة بإنشاء حساب السائق وتفعيله.',
      'يرجى إدخال البريد الإلكتروني وكلمة المرور.',
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
      'خطأ في الاتصال. حاول مرة أخرى.',
      'تسجيل الخروج',
      'مرحباً أيها السائق',
      'لوحة التحكم',
      'طلباتي',
      'أرباحي',
      'الموقع المباشر',
      'ملفي الشخصي',
      'إجمالي الطلبات',
      'مكتمل',
      'قيد الانتظار',
      'درهم',
      'لا توجد طلبات معينة حتى الآن',
      'ستظهر الطلبات المعينة لك هنا.',
      'ستظهر أرباحك هنا.',
      'سيكون تتبع الموقع متاحاً قريباً.',
      'معلومات الحساب',
      'البريد الإلكتروني',
      'الحالة',
      'تم تسجيل الدخول',
      'بيانات تجريبية فقط',
      'متصل',
      'غير متصل',
      'English',
      'اردو',
      'العربية',
      'العميل',
      'الهاتف',
      'عنوان التوصيل',
      'المبلغ',
      'الدفع',
      'حالة الطلب',
      'تحديث الحالة',
      'اتصل بالعميل',
      'افتح الخريطة',
      'تفاصيل الطلب',
      'جار تحميل الطلبات...',
      'تعذر تحميل الطلبات.',
      'لا توجد طلبات معينة لحسابك.',
      'تم تحديث الحالة بنجاح.',
      'فشل التحديث. حاول مرة أخرى.',
      'اختر الحالة',
      'قيد المعالجة',
      'تم التأكيد',
      'تم التغليف',
      'تم الشحن',
      'خرج للتوصيل',
      'تم التوصيل',
      'مكتمل',
      'ملغى',
      'مرتجع',
      'رقم الطلب',
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
                          value: 'en',
                          child: Text('English'),
                        ),
                        DropdownMenuItem(
                          value: 'ur',
                          child: Text('اردو'),
                        ),
                        DropdownMenuItem(
                          value: 'ar',
                          child: Text('العربية'),
                        ),
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

  CollectionReference<Map<String, dynamic>> get ordersRef =>
      FirebaseFirestore.instance.collection('orders');

  Query<Map<String, dynamic>> get myOrdersQuery =>
      ordersRef.where(
        'assignedRiderUid',
        isEqualTo: widget.user.uid,
      );

  Future<void> updateOrderStatus(
    String orderId,
    String newStatus,
  ) async {
    final t = Words.data[widget.language]!;

    try {
      await ordersRef.doc(orderId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t[50])),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${t[51]} $e')),
        );
      }
    }
  }

  Future<void> openLink(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String statusText(String status, List<String> t) {
    switch (status) {
      case 'Processing':
        return t[53];
      case 'Confirmed':
        return t[54];
      case 'Packed':
        return t[55];
      case 'Shipped':
        return t[56];
      case 'Out for Delivery':
        return t[57];
      case 'Delivered':
        return t[58];
      case 'Completed':
        return t[59];
      case 'Cancelled':
        return t[60];
      case 'Returned':
        return t[61];
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Words.data[widget.language]!;
    final rtl = widget.language != 'en';

    final pages = [
      dashboard(t),
      ordersPage(t),
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
        body: SafeArea(child: pages[selected]),
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
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: myOrdersQuery.snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? [];

        final completed = docs.where((d) {
          final s = d.data()['status'];
          return s == 'Delivered' || s == 'Completed';
        }).length;

        final pending = docs.length - completed;

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
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (snapshot.hasError)
              Text('${t[48]} ${snapshot.error}',
                  style: const TextStyle(color: Colors.red)),
            Row(
              children: [
                Expanded(child: statCard(Icons.inventory_2, t[18],
                    snapshot.hasData ? '${docs.length}' : '...')),
                const SizedBox(width: 12),
                Expanded(child: statCard(Icons.check_circle, t[19],
                    snapshot.hasData ? '$completed' : '...')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: statCard(Icons.pending_actions, t[20],
                    snapshot.hasData ? '$pending' : '...')),
                const SizedBox(width: 12),
                Expanded(child: statCard(Icons.wallet, t[15], '${t[21]} 0')),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              t[14],
              style: const TextStyle(
                  fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (snapshot.connectionState == ConnectionState.waiting)
              Center(child: Text(t[47]))
            else if (snapshot.hasError)
              Text(t[48], style: const TextStyle(color: Colors.red))
            else if (docs.isEmpty)
              emptyCard(Icons.inbox, t[22], t[23])
            else
              ...docs.take(3).map((d) => orderCard(d, t)),
          ],
        );
      },
    );
  }

  Widget ordersPage(List<String> t) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: myOrdersQuery.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text(t[47]));
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                '${t[48]}\n${snapshot.error}',
                te
