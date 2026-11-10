
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
      'Speedy X Delivery', 'Rider Login', 'Rider Email', 'Password',
      'LOGIN', 'New Rider?', 'Contact Admin to Join',
      'Admin creates and activates all rider accounts.',
      'Please enter email and password.',
      'Invalid email or password.',
      'Network error. Please try again.', 'Logout', 'Welcome Rider',
      'Dashboard', 'My Orders', 'My Earnings', 'Live Location',
      'My Profile', 'Total Orders', 'Completed', 'Pending', 'AED',
      'No orders assigned yet',
      'Your assigned orders will appear here.',
      'Your earnings will appear here.',
      'Location tracking will be available soon.',
      'Account Information', 'Email', 'Status', 'Logged In',
      'Demo data only', 'Online', 'Offline', 'English', 'Urdu',
      'Arabic', 'Customer', 'Phone', 'Delivery Address', 'Amount',
      'Payment', 'Order Status', 'Update Status', 'Call Customer',
      'Open Map', 'Order Details', 'Loading orders...',
      'Could not load orders.',
      'No orders assigned to your account.',
      'Status updated successfully.',
      'Update failed. Please try again.',
      'Select Status', 'Processing', 'Confirmed', 'Packed',
      'Shipped', 'Out for Delivery', 'Delivered', 'Completed',
      'Cancelled', 'Returned', 'Order Number'
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
      'آف لائن', 'English', 'اردو', 'العربية',
      'کسٹمر', 'فون', 'ڈیلیوری ایڈریس', 'رقم',
      'ادائیگی', 'آرڈر کا اسٹیٹس', 'اسٹیٹس تبدیل کریں',
      'کسٹمر کو کال کریں', 'نقشے پر دیکھیں',
      'آرڈر کی تفصیلات', 'آرڈرز لوڈ ہو رہے ہیں...',
      'آرڈرز لوڈ نہیں ہو سکے۔',
      'آپ کے اکاؤنٹ پر کوئی آرڈر نہیں ہے۔',
      'اسٹیٹس کامیابی سے تبدیل ہوگیا۔',
      'تبدیلی ناکام ہوگئی، دوبارہ کوشش کریں۔',
      'اسٹیٹس منتخب کریں', 'پروسیسنگ', 'کنفرم',
      'پیک ہو گیا', 'شپ ہو گیا', 'ڈیلیوری کے لیے روانہ',
      'ڈیلیور ہو گیا', 'مکمل', 'منسوخ', 'واپس',
      'آرڈر نمبر'
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
      'إجمالي الطلبات', 'مكتمل', 'قيد الانتظار', 'درهم',
      'لا توجد طلبات معينة حتى الآن',
      'ستظهر الطلبات المعينة لك هنا.',
      'ستظهر أرباحك هنا.',
      'سيكون تتبع الموقع متاحاً قريباً.',
      'معلومات الحساب', 'البريد الإلكتروني', 'الحالة',
      'تم تسجيل الدخول', 'بيانات تجريبية فقط', 'متصل',
      'غير متصل', 'English', 'اردو', 'العربية',
      'العميل', 'الهاتف', 'عنوان التوصيل', 'المبلغ',
      'الدفع', 'حالة الطلب', 'تحديث الحالة',
      'اتصل بالعميل', 'افتح الخريطة', 'تفاصيل الطلب',
      'جار تحميل الطلبات...', 'تعذر تحميل الطلبات.',
      'لا توجد طلبات معينة لحسابك.',
      'تم تحديث الحالة بنجاح.',
      'فشل التحديث. حاول مرة أخرى.',
      'اختر الحالة', 'قيد المعالجة', 'تم التأكيد',
      'تم التغليف', 'تم الشحن', 'خرج للتوصيل',
      'تم التوصيل', 'مكتمل', 'ملغى', 'مرتجع',
      'رقم الطلب'
    ],
  };
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
      if (!mounted) return;
      setState(() {
        error = e.code == 'network-request-failed' ? t[10] : t[9];
      });
    } catch (_) {
      if (mounted) setState(() => error = t[10]);
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
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'ur', child: Text('اردو')),
                        DropdownMenuItem(value: 'ar', child: Text('العربية')),
                      ],
                      onChanged: (v) {
                        if (v != null) widget.onLanguageChanged(v);
                      },
                    ),
                    const SizedBox(height: 20),
                    const CircleAvatar(
                      radius: 55,
                      child: Icon(Icons.delivery_dining, size: 65),
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
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
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

  final List<String> allowedStatuses = const [
    'Confirmed',
    'Packed',
    'Shipped',
    'Out for Delivery',
    'Delivered',
    'Completed',
  ];

  CollectionReference<Map<String, dynamic>> get ordersRef =>
      FirebaseFirestore.instance.collection('orders');

  Query<Map<String, dynamic>> get myOrdersQuery => ordersRef.where(
        'assignedRiderUid',
        isEqualTo: widget.user.uid,
      );

  String valueOf(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value == null) return '';
    return value.toString();
  }

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
      case 'Processing': return t[53];
      case 'Confirmed': return t[54];
      case 'Packed': return t[55];
      case 'Shipped': return t[56];
      case 'Out for Delivery': return t[57];
      case 'Delivered': return t[58];
      case 'Completed': return t[59];
      case 'Cancelled': return t[60];
      case 'Returned': return t[61];
      default: return status;
    }
  }

  Widget statCard(IconData icon, String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 27, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget emptyCard(IconData icon, String title, String subtitle) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, size: 45, color: Colors.grey),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(subtitle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget orderCard(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
    List<String> t,
  ) {
    final data = document.data();
    final customer = valueOf(data, 'customerName');
    final phone = valueOf(data, 'phone').isNotEmpty
        ? valueOf(data, 'phone')
        : valueOf(data, 'customerPhone');
    final address = valueOf(data, 'address').isNotEmpty
        ? valueOf(data, 'address')
        : valueOf(data, 'deliveryAddress');
    final amount = valueOf(data, 'amount').isNotEmpty
        ? valueOf(data, 'amount')
        : valueOf(data, 'total');
    final payment = valueOf(data, 'payment');
    final status = valueOf(data, 'status');
    final orderNumber = valueOf(data, 'orderNumber').isNotEmpty
        ? valueOf(data, 'orderNumber')
        : document.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${t[62]}: $orderNumber',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(Icons.receipt_long, color: Colors.blue),
              ],
            ),
            const Divider(height: 22),
            Text('${t[36]}: ${customer.isEmpty ? '-' : customer}'),
            const SizedBox(height: 7),
            Text('${t[37]}: ${phone.isEmpty ? '-' : phone}'),
            const SizedBox(height: 7),
            Text('${t[38]}: ${address.isEmpty ? '-' : address}'),
            const SizedBox(height: 7),
            Text('${t[39]}: ${amount.isEmpty ? '-' : amount} ${t[21]}'),
            const SizedBox(height: 7),
            Text('${t[40]}: ${payment.isEmpty ? '-' : payment}'),
            const SizedBox(height: 7),
            Text('${t[42]}: ${statusText(status, t)}'),
            const SizedBox(height: 14),
            if (phone.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => openLink('tel:$phone'),
                  icon: const Icon(Icons.call),
                  label: Text(t[43]),
                ),
              ),
            if (address.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => openLink(
                    'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
                  ),
                  icon: const Icon(Icons.map),
                  label: Text(t[44]),
                ),
              ),
            const SizedBox(height: 8),
            Text(t[42], style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: allowedStatuses.contains(status) ? status : null,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: t[52],
              ),
              items: allowedStatuses.map((s) {
                return DropdownMenuItem<String>(
                  value: s,
                  child: Text(statusText(s, t)),
                );
              }).toList(),
              onChanged: (newStatus) {
                if (newStatus != null && newStatus != status) {
                  updateOrderStatus(document.id, newStatus);
                }
              },
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text(t[48]));
        }

        final docs = snapshot.data?.docs ?? [];
        final completed = docs.where((d) {
          return valueOf(d.data(), 'status') == 'Completed' ||
              valueOf(d.data(), 'status') == 'Delivered';
        }).length;

        final pending = docs.length - completed;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              t[12],
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 18),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.25,
              children: [
                statCard(Icons.receipt_long, t[18], '${docs.length}'),
                statCard(Icons.check_circle, t[19], '$completed'),
         
