/// Kumpulan fungsi validasi dan sanitasi input pengguna.
///
/// Method `validateXxx` dipakai sebagai `validator` di [TextFormField]:
/// mengembalikan pesan error jika tidak valid, atau `null` jika valid.
class Validators {
  Validators._();

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _phoneRegex = RegExp(r'^\d{10,13}$');

  /// `true` jika [email] berformat `nama@domain.tld`.
  static bool isValidEmail(String email) => _emailRegex.hasMatch(email);

  /// `true` jika [value] tidak null dan tidak hanya berisi spasi.
  static bool isNotEmpty(String? value) =>
      value != null && value.trim().isNotEmpty;

  /// `true` jika panjang [value] (setelah trim) di antara [min] dan [max].
  static bool hasValidLength(String value, {int min = 1, int max = 100}) {
    final length = value.trim().length;
    return length >= min && length <= max;
  }

  /// Mengganti karakter `&`, `<`, `>`, `"`, dan `'` dengan HTML entity
  /// untuk mencegah XSS, lalu membuang spasi di awal dan akhir.
  static String sanitize(String input) {
    return input
        .replaceAll('&', '&amp;') // harus pertama agar entity lain tidak ikut diubah
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .trim();
  }

  /// Memvalidasi teks wajib dengan panjang [minLength] sampai [maxLength].
  static String? validateText(
    String? value, {
    String fieldName = 'Field',
    int minLength = 1,
    int maxLength = 100,
  }) {
    if (!isNotEmpty(value)) return '$fieldName tidak boleh kosong';
    if (!hasValidLength(value!, min: minLength, max: maxLength)) {
      return '$fieldName harus antara $minLength-$maxLength karakter';
    }
    return null;
  }

  /// Memvalidasi email.
  static String? validateEmail(String? value) {
    if (!isNotEmpty(value)) return 'Email tidak boleh kosong';
    if (!isValidEmail(value!.trim())) return 'Format email tidak valid';
    return null;
  }

  /// Memvalidasi nomor telepon: hanya angka, 10 sampai 13 digit.
  static String? validatePhone(String? value) {
    if (!isNotEmpty(value)) return 'Nomor telepon tidak boleh kosong';
    if (!_phoneRegex.hasMatch(value!.trim())) {
      return 'Nomor telepon harus 10-13 digit angka';
    }
    return null;
  }

  /// Memvalidasi URL: harus diawali `http://` atau `https://` dan punya host.
  static String? validateUrl(String? value) {
    if (!isNotEmpty(value)) return 'URL tidak boleh kosong';
    final uri = Uri.tryParse(value!.trim());
    if (uri == null ||
        !(uri.scheme == 'http' || uri.scheme == 'https') ||
        uri.host.isEmpty) {
      return 'URL harus diawali http:// atau https://';
    }
    return null;
  }

  /// Memvalidasi password: minimal 8 karakter, ada huruf kapital,
  /// angka, dan simbol.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
    if (value.length < 8) return 'Password minimal 8 karakter';
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung huruf kapital';
    }
    if (!value.contains(RegExp(r'\d'))) return 'Password harus mengandung angka';
    if (!value.contains(RegExp(r'[^A-Za-z0-9]'))) {
      return 'Password harus mengandung simbol';
    }
    return null;
  }
}
