import 'dart:async'; // استيراد مكتبة المؤقتات لإدارة عداد الـ OTP
import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UMS Login Assignment',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginFormScreen(),
    );
  }
}

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  // 1. المفتاح العام للتحقق من االنموذج
  final _formKey = GlobalKey<FormState>();

  // 2. متحكمات الحقول النصية وعُقد التركيز
  late final TextEditingController _academicIdController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  late final FocusNode _academicIdFocusNode;
  late final FocusNode _phoneFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _confirmPasswordFocusNode;

  // 3. متغيرات الحالة الديناميكية
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false; 

  // متغيرات خاصة بمؤقت الـ OTP (العداد التنازلي لمدة 60 ثانية)
  Timer? _otpTimer;
  int _startCountdown = 60;
  bool _isTimerActive = false;

  @override
  void initState() {
    super.initState();
    // تهيئة المتحكمات فور إنشاء كائن الحالة
    _academicIdController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _academicIdFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  // دالة بدء العداد التنازلي لإعادة إرسال الـ OTP
  void _startOtpCountdown() {
    setState(() {
      _isTimerActive = true;
      _startCountdown = 60;
    });

    // استخدام Timer.periodic لتنفيذ عداد تنازلي كل ثانية واحدة
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startCountdown > 0) {
        setState(() {
          _startCountdown--; // نقص ثانية من العداد
        });
      } else {
        timer.cancel(); // إيقاف العداد عند وصوله للصفر
        setState(() {
          _isTimerActive = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // تفريغ الموارد لمنع ال Memory Leaks
    _academicIdController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _academicIdFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    // إلغاء العداد التنازلي إن كان يعمل لضمان عدم حدوث تسريب في الذاكرة
    _otpTimer?.cancel();
    
    // استدعى السوبر دائماً في ختام الدالة
    super.dispose(); 
  }

  String? _validateAcademicIdOrEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال الرقم الأكاديمي أو البريد الإلكتروني'; // التحقق من الفراغ
    }
    final trimmed = value.trim();

    // فحص الرقم الأكاديمي (10 أرقام تبدأ بـ 20)
    final isAcademic = RegExp(r'^20\d{8}$').hasMatch(trimmed);

    // فحص البريد الإلكتروني القياسي
    final isEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(trimmed); 

    if (!isAcademic && !isEmail) {
      return 'يرجى إدخال رقم أكاديمي صحيح (يبدأ بـ 20 ويتكون من 10 أرقام) أو بريد معتمد';
    }
    return null; // القيمة صحيحة ومقبولة
  }

  String? _validateYemeniPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال رقم الهاتف اليمني';
    }
    final trimmed = value.trim();

    // تعبير نمطي يتحقق من أن الرقم يبدأ بـ 77, 73, 71, أو 78 ويليها 7 أرقام لتصبح الإجمالي 9 أرقام
    final phoneRegex = RegExp(r'^(77|73|71|78)\d{7}$');
    if (!phoneRegex.hasMatch(trimmed)) {
      return 'رقم الهاتف غير صحيح (يجب أن يبدأ بـ 77, 73, 71 أو 78 ويتكون من 9 أرقام)';
    }
    return null; // الرقم صحيح
  }

  Future<void> _handleLogin() async {
    // 1. إغلاق لوحة المفاتيح لإفساح المجال للرؤية
    FocusScope.of(context).unfocus(); 

    // 2. فحص صحة جميع حقول النموذج عبر FormKey
    if (!_formKey.currentState!.validate()) return; 

    // 3. تفعيل مؤشر التحميل وإعادة رسم الزر
    setState(() => _isLoading = true); 

    try {
      // محاكاة استدعاء شبكي غير متزامن مع السيرفر
      await Future.delayed(const Duration(seconds: 2)); 

      // حماية الـ Async Gap: فحص بقاء الشاشة حية
      if (!mounted) return; 
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تسجيل الدخول بنجاح! مرحباً بك في معمل فلاتر'),
          backgroundColor: Colors.green,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل دخول الطلاب | م. معاذ جابر'),),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey, // ربط المفتاح بالنموذج
            child: Column(
              children: [
                // 1. حقل الرقم الأكاديمي أو البريد
                TextFormField(
                  controller: _academicIdController,
                  focusNode: _academicIdFocusNode,
                  keyboardType: TextInputAction.next == TextInputAction.next ? TextInputType.text : TextInputType.text,
                  textInputAction: TextInputAction.next, // الانتقال للحقل التالي بسلاسة[cite: 22]
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_phoneFocusNode);
                  },
                  validator: _validateAcademicIdOrEmail,
                  decoration: const InputDecoration(
                    labelText: 'الرقم الأكاديمي أو البريد الإلكتروني',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. حقل رقم الهاتف اليمني الجديد
                TextFormField(
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  validator: _validateYemeniPhone,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف اليمني (77, 73, 71, 78)',
                    prefixIcon: Icon(Icons.phone_android),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // 3. حقل كلمة المرور الأساسية
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: _obscurePassword, // إخفاء أو إظهار الحروف
                  textInputAction: TextInputAction.next, // زر تم بلوحة المفاتيح
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'الرجاء إدخال كلمة المرور';
                    if (val.length < 6) return 'كلمة المرور يجب ألا تقل عن 6 خانات';
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        // تغيير الحالة لإعادة رسم الأيقونة وخاصية الإخفاء فقط
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // 4. حقل تأكيد كلمة المرور
                TextFormField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocusNode,
                  obscureText: _obscureConfirmPassword, // إخفاء أو إظهار الحروف
                  textInputAction: TextInputAction.done, // زر تم بلوحة المفاتيح
                  onFieldSubmitted: (_) => _handleLogin(), // الإرسال المباشر عند ضغط تم
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'الرجاء تأكيد كلمة المرور';
                    if (val != _passwordController.text) return 'كلمتا المرور غير متطابقتين تماماً'; 
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'تأكيد كلمة المرور',
                    prefixIcon: const Icon(Icons.lock_reset),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        // تغيير الحالة لإعادة رسم الأيقونة وخاصية الإخفاء فقط
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // 5. قسم مؤقت إعادة الإرسال (OTP Timer) وتفعيله
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isTimerActive ? 'إعادة الإرسال بعد: $_startCountdown ثانية' : 'لم تستلم الرمز؟',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: _isTimerActive
                          ? null // تعطيل الزر طالما العداد يعد تنازلياً
                          : () {
                              _startOtpCountdown(); // بدء العد التنازلي لمدة 60 ثانية
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تم إرسال رمز التحقق الجديد بنجاح')),
                              );
                            },
                      child: Text(
                        _isTimerActive ? 'انتظر قليلاً' : 'إعادة إرسال الرمز',
                        style: TextStyle(
                          color: _isTimerActive ? Colors.grey : Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 6. زر تسجيل الدخول
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin, // تعطيل عند التحميل
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('تسجيل الدخول', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}