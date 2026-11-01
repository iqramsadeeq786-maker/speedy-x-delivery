import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const SpeedyXRiderApp());

class SpeedyXRiderApp extends StatefulWidget {
  const SpeedyXRiderApp({super.key});
  @override
  State<SpeedyXRiderApp> createState() => _SpeedyXRiderAppState();
}

class _SpeedyXRiderAppState extends State<SpeedyXRiderApp> {
  String language = 'en';
  static const waNumber = '97150335951';
  static const words = {
    'en': ['Speedy X Delivery','Rider Login','Rider Email / ID','Password','LOGIN','New Rider?','Contact Admin to Join','Admin creates and activates all rider accounts.','Secure Firebase rider login must be configured before login works.'],
    'ur': ['اسپیڈی ایکس ڈیلیوری','رائڈر لاگ اِن','رائڈر ای میل / آئی ڈی','پاس ورڈ','لاگ اِن','نئے رائڈر ہیں؟','شامل ہونے کے لیے ایڈمن سے رابطہ کریں','رائڈر اکاؤنٹ ایڈمن بنائے گا اور فعال کرے گا۔','محفوظ Firebase لاگ اِن ترتیب دینے کے بعد لاگ اِن فعال ہوگا۔'],
    'ar': ['سبيدي إكس للتوصيل','تسجيل دخول السائق','بريد السائق / رقم التعريف','كلمة المرور','تسجيل الدخول','سائق جديد؟','تواصل مع الإدارة للانضمام','تقوم الإدارة بإنشاء حساب السائق وتفعيله.','سيتم تفعيل الدخول بعد إعداد مصادقة Firebase الآمنة.'],
  };
  Future<void> contact() async {
    final uri = Uri.parse('https://wa.me/$waNumber?text=${Uri.encodeComponent("Hello, I want to join Speedy X Delivery as a rider.")}');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
  @override
  Widget build(BuildContext context) {
    final t=words[language]!;
    final rtl=language!='en';
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      theme:ThemeData(colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xFF1266D5)),useMaterial3:true),
      home:Directionality(textDirection:rtl?TextDirection.rtl:TextDirection.ltr,child:Scaffold(
        body:SafeArea(child:Center(child:SingleChildScrollView(padding:const EdgeInsets.all(24),child:ConstrainedBox(
          constraints:const BoxConstraints(maxWidth:430),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
            Align(alignment:AlignmentDirectional.centerEnd,child:DropdownButton<String>(value:language,items:const [
              DropdownMenuItem(value:'en',child:Text('English')),DropdownMenuItem(value:'ur',child:Text('اردو')),DropdownMenuItem(value:'ar',child:Text('العربية'))],
              onChanged:(v)=>setState(()=>language=v??'en'))),
            const SizedBox(height:18),const CircleAvatar(radius:42,child:Icon(Icons.delivery_dining,size:48)),
            const SizedBox(height:18),Text(t[0],textAlign:TextAlign.center,style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.bold)),
            const SizedBox(height:8),Text(t[1],textAlign:TextAlign.center,style:Theme.of(context).textTheme.titleMedium),
            const SizedBox(height:28),TextField(decoration:InputDecoration(labelText:t[2],border:const OutlineInputBorder(),prefixIcon:const Icon(Icons.person_outline))),
            const SizedBox(height:14),TextField(obscureText:true,decoration:InputDecoration(labelText:t[3],border:const OutlineInputBorder(),prefixIcon:const Icon(Icons.lock_outline))),
            const SizedBox(height:18),FilledButton(onPressed:()=>showDialog<void>(context:context,builder:(c)=>AlertDialog(content:Text(t[8]),actions:[TextButton(onPressed:()=>Navigator.pop(c),child:const Text('OK'))])),child:Text(t[4])),
            const SizedBox(height:28),Text(t[5],textAlign:TextAlign.center,style:Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight:FontWeight.bold)),
            const SizedBox(height:8),OutlinedButton.icon(onPressed:contact,icon:const Icon(Icons.chat),label:Text(t[6])),
            const SizedBox(height:10),Text(t[7],textAlign:TextAlign.center,style:Theme.of(context).textTheme.bodySmall),
            const SizedBox(height:12),const Text('WhatsApp: +971 50 335 8951',textAlign:TextAlign.center)
          ])
        )))))
      )),
    );
  }
}
