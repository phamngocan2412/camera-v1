import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'profile_title': 'Profile',
      'free_plan': 'Free Plan',
      'upgrade_premium': 'Upgrade to Premium',
      'general_settings': 'GENERAL SETTINGS',
      'notifications': 'Notifications',
      'language': 'Language',
      'dark_mode': 'Dark Mode',
      'support_legal': 'SUPPORT & LEGAL',
      'help_center': 'Help Center',
      'privacy_policy': 'Privacy Policy',
      'terms_of_service': 'Terms of Service',
      'log_out': 'Log Out',
      'app_version': 'App Version',
      // Login
      'help': 'Help',
      'welcome': 'Welcome',
      'login_subtitle': 'Please enter your details to continue.',
      'login_tab': 'Log In',
      'signup_tab': 'Sign Up',
      'email_username': 'Email or Username',
      'email_username_hint': 'Enter email or username',
      'error_email_username': 'Please enter your email or username',
      'forgot_password': 'Forgot Password?',
      'or_continue_with': 'OR CONTINUE WITH',
      // Register
      'create_account': 'Create your account',
      'register_subtitle': 'Connect to your smart home today.',
      'first_name': 'First Name',
      'first_name_hint': 'Enter your first name',
      'last_name': 'Last Name',
      'last_name_hint': 'Enter your last name',
      'phone_number': 'Phone Number',
      'search_country': 'Search country',
      'email': 'Email Address',
      'email_hint': 'name@example.com',
      'password': 'Password',
      'password_hint': 'Enter your password',
      'confirm_password': 'Confirm Password',
      'confirm_password_hint': 'Confirm your password',
      'sign_up_btn': 'Sign Up',
      'terms_agree': 'By signing up, you agree to our ',
      'and': ' & ',
      'or_signup_with': 'Or sign up with',
      // Validation
      'error_first_name': 'Please enter your first name',
      'error_first_name_length': 'First name must be at least 2 characters',
      'error_last_name': 'Please enter your last name',
      'error_last_name_length': 'Last name must be at least 2 characters',
      'error_phone': 'Please enter your phone number',
      'error_phone_valid': 'Please enter a valid phone number',
      'error_email': 'Please enter your email',
      'error_email_valid': 'Please enter a valid email',
      'error_password': 'Please enter your password',
      'error_password_length': 'Password must be at least 6 characters',
      'error_confirm_password': 'Please confirm your password',
      'error_password_match': 'Passwords do not match',
      // Home
      'my_home': 'My Home',
      'safety_first': 'SAFETY FIRST',
      'status': 'STATUS',
      'online': 'ONLINE',
      'living_areas': 'Living Areas',
      'entrance_outdoor': 'Entrance & Outdoor',
      'nav_home': 'Home',
      'nav_events': 'Events',
      'nav_smart': 'Smart',
      'nav_storage': 'Storage',
      'nav_profile': 'Profile',
      // Verification
      'verification_title': 'Verification',
      'code_sent_to': 'We sent a code to',
      'resend_code': 'Resend Code',
      'resend_code_in': 'Resend Code in',
      // Forgot Password
      'forgot_password_page_title': 'Forgot Password',
      'forgot_password_instruction':
          'Don\'t worry! It happens. Please enter the email address linked to your smart camera account.',
      'send_reset_code': 'Send Reset Code',
      'remember_password_question': 'Remember Password? ',
      'need_help_question': 'Need Help?',
      // Reset Password
      'reset_password_title': 'Reset Password',
      'reset_password_instruction':
          'Enter the OTP code sent to your email and your new password.',
      'new_password': 'New Password',
      'reset_password_button': 'Reset Password',
      'error_password_empty': 'Please enter a new password',
      'error_confirm_password_match': 'Passwords do not match',
      'otp_expired_resend': 'OTP expired. Please resend code.',
      'resend': 'Resend',
      // Backend Errors
      'error_invalid_otp': 'Invalid OTP code',
      'error_otp_expired': 'OTP code has expired',
      'error_user_not_found': 'User not found',
      'error_too_many_attempts':
          'Too many failed attempts. Please request a new OTP.',
      'error_server': 'Server error. Please try again later.',
      // Change Password
      'change_password': 'Change Password',
      'old_password': 'Old Password',
      'enter_old_password': 'Enter old password',
      'new_password_label': 'New Password',
      'enter_new_password': 'Enter new password',
      'confirm_new_password': 'Confirm New Password',
      'change_password_success': 'Password changed successfully',
      'error_password_incorrect': 'Old password incorrect',
    },
    'vi': {
      'profile_title': 'Hồ sơ',
      'free_plan': 'Gói miễn phí',
      'upgrade_premium': 'Nâng cấp Premium',
      'general_settings': 'CÀI ĐẶT CHUNG',
      'notifications': 'Thông báo',
      'language': 'Ngôn ngữ',
      'dark_mode': 'Chế độ tối',
      'support_legal': 'HỖ TRỢ & PHÁP LÝ',
      'help_center': 'Trung tâm trợ giúp',
      'privacy_policy': 'Chính sách bảo mật',
      'terms_of_service': 'Điều khoản dịch vụ',
      'log_out': 'Đăng xuất',
      'app_version': 'Phiên bản ứng dụng',
      // Login
      'help': 'Trợ giúp',
      'welcome': 'Chào mừng',
      'login_subtitle': 'Vui lòng nhập thông tin để tiếp tục.',
      'login_tab': 'Đăng nhập',
      'signup_tab': 'Đăng ký',
      'email_username': 'Email hoặc Tên đăng nhập',
      'email_username_hint': 'Nhập email hoặc tên đăng nhập',
      'error_email_username': 'Vui lòng nhập email hoặc tên đăng nhập',
      'forgot_password': 'Quên mật khẩu?',
      'or_continue_with': 'HOẶC TIẾP TỤC VỚI',
      // Register
      'create_account': 'Tạo tài khoản',
      'register_subtitle': 'Kết nối ngôi nhà thông minh ngay hôm nay.',
      'first_name': 'Họ',
      'first_name_hint': 'Nhập họ của bạn',
      'last_name': 'Tên',
      'last_name_hint': 'Nhập tên của bạn',
      'phone_number': 'Số điện thoại',
      'search_country': 'Tìm quốc gia',
      'email': 'Địa chỉ Email',
      'email_hint': 'name@example.com',
      'password': 'Mật khẩu',
      'password_hint': 'Nhập mật khẩu',
      'confirm_password': 'Xác nhận mật khẩu',
      'confirm_password_hint': 'Nhập lại mật khẩu',
      'sign_up_btn': 'Đăng ký',
      'terms_agree': 'Bằng cách đăng ký, bạn đồng ý với ',
      'and': ' & ',
      'or_signup_with': 'Hoặc đăng ký bằng',
      // Validation
      'error_first_name': 'Vui lòng nhập họ',
      'error_first_name_length': 'Họ phải có ít nhất 2 ký tự',
      'error_last_name': 'Vui lòng nhập tên',
      'error_last_name_length': 'Tên phải có ít nhất 2 ký tự',
      'error_phone': 'Vui lòng nhập số điện thoại',
      'error_phone_valid': 'Số điện thoại không hợp lệ',
      'error_email': 'Vui lòng nhập email',
      'error_email_valid': 'Email không hợp lệ',
      'error_password': 'Vui lòng nhập mật khẩu',
      'error_password_length': 'Mật khẩu phải có ít nhất 6 ký tự',
      'error_confirm_password': 'Vui lòng xác nhận mật khẩu',
      'error_password_match': 'Mật khẩu không khớp',
      // Home
      'my_home': 'Nhà tôi',
      'safety_first': 'AN TOÀN LÀ TRÊN HẾT',
      'status': 'TRẠNG THÁI',
      'online': 'TRỰC TUYẾN',
      'living_areas': 'Khu vực sinh hoạt',
      'entrance_outdoor': 'Lối vào & Ngoài trời',
      'nav_home': 'Trang chủ',
      'nav_events': 'Sự kiện',
      'nav_smart': 'Thông minh',
      'nav_storage': 'Lưu trữ',
      'nav_profile': 'Hồ sơ',
      // Verification
      'verification_title': 'Xác thực',
      'code_sent_to': 'Mã đã được gửi đến',
      'resend_code': 'Gửi lại mã',
      'resend_code_in': 'Gửi lại mã sau',
      // Forgot Password
      'forgot_password_page_title': 'Quên Mật Khẩu',
      'forgot_password_instruction':
          'Đừng lo! Vui lòng nhập địa chỉ email liên kết với tài khoản của bạn.',
      'send_reset_code': 'Gửi Mã Khôi Phục',
      'remember_password_question': 'Bạn đã nhớ mật khẩu? ',
      'need_help_question': 'Cần trợ giúp?',
      // Reset Password
      'reset_password_title': 'Đặt Lại Mật Khẩu',
      'reset_password_instruction':
          'Nhập mã OTP đã được gửi đến email và mật khẩu mới của bạn.',
      'new_password': 'Mật khẩu mới',
      'reset_password_button': 'Đặt Lại Mật Khẩu',
      'error_password_empty': 'Vui lòng nhập mật khẩu mới',
      'error_confirm_password_match': 'Mật khẩu không khớp',
      'otp_expired_resend': 'Mã OTP đã hết hạn. Vui lòng gửi lại.',
      'resend': 'Gửi lại',
      // Backend Errors
      'error_invalid_otp': 'Mã OTP không hợp lệ',
      'error_otp_expired': 'Mã OTP đã hết hạn',
      'error_user_not_found': 'Không tìm thấy người dùng',
      'error_too_many_attempts':
          'Quá nhiều lần thử lại. Vui lòng yêu cầu mã OTP mới.',
      'error_server': 'Lỗi máy chủ. Vui lòng thử lại sau.',
      // Change Password
      'change_password': 'Đổi Mật Khẩu',
      'old_password': 'Mật khẩu cũ',
      'enter_old_password': 'Nhập mật khẩu cũ',
      'new_password_label': 'Mật khẩu mới',
      'enter_new_password': 'Nhập mật khẩu mới',
      'confirm_new_password': 'Xác nhận mật khẩu mới',
      'change_password_success': 'Đổi mật khẩu thành công',
      'error_password_incorrect': 'Mật khẩu cũ không chính xác',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'vi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
