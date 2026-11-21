import 'package:flutter_test/flutter_test.dart';
import 'package:secure_http/utils/validators.dart';

void main() {
  group('isValidEmail', () {
    test('email valid', () {
      expect(Validators.isValidEmail('budi@amikom.ac.id'), isTrue);
      expect(Validators.isValidEmail('a.b@c.co'), isTrue);
    });

    test('email tidak valid', () {
      expect(Validators.isValidEmail(''), isFalse);
      expect(Validators.isValidEmail('budi'), isFalse);
      expect(Validators.isValidEmail('budi@'), isFalse);
      expect(Validators.isValidEmail('budi@amikom'), isFalse);
      expect(Validators.isValidEmail('bu di@amikom.ac.id'), isFalse);
      expect(Validators.isValidEmail('a@@b.com'), isFalse);
    });
  });

  group('sanitize', () {
    test('tag script di-escape', () {
      expect(
        Validators.sanitize('<script>alert("x")</script>'),
        '&lt;script&gt;alert(&quot;x&quot;)&lt;/script&gt;',
      );
    });

    test('kutip tunggal, ampersand, dan spasi', () {
      expect(Validators.sanitize("  O'Neil & Co  "), 'O&#x27;Neil &amp; Co');
    });

    test('teks biasa tidak berubah', () {
      expect(Validators.sanitize('Halo Dunia'), 'Halo Dunia');
    });
  });

  group('validateText', () {
    test('kosong atau hanya spasi', () {
      expect(Validators.validateText(null, fieldName: 'Nama'),
          'Nama tidak boleh kosong');
      expect(Validators.validateText('   ', fieldName: 'Nama'),
          'Nama tidak boleh kosong');
    });

    test('di luar batas panjang', () {
      expect(Validators.validateText('ab', minLength: 3), isNotNull);
      expect(Validators.validateText('a' * 101), isNotNull);
    });

    test('tepat di batas panjang', () {
      expect(Validators.validateText('abc', minLength: 3), isNull);
      expect(Validators.validateText('a' * 100), isNull);
    });
  });

  group('validasi tambahan (Latihan 3)', () {
    test('validatePhone', () {
      expect(Validators.validatePhone('081234567890'), isNull);
      expect(Validators.validatePhone('08123'), isNotNull);
      expect(Validators.validatePhone('0812-3456-7890'), isNotNull);
      expect(Validators.validatePhone('08123456789012'), isNotNull);
    });

    test('validateUrl', () {
      expect(Validators.validateUrl('https://amikom.ac.id'), isNull);
      expect(Validators.validateUrl('http://localhost:8080'), isNull);
      expect(Validators.validateUrl('ftp://amikom.ac.id'), isNotNull);
      expect(Validators.validateUrl('amikom.ac.id'), isNotNull);
      expect(Validators.validateUrl('https://'), isNotNull);
    });

    test('validatePassword', () {
      expect(Validators.validatePassword('Rahasia1!'), isNull);
      expect(Validators.validatePassword('Ra1!'), isNotNull);
      expect(Validators.validatePassword('rahasia1!'), isNotNull);
      expect(Validators.validatePassword('Rahasiaa!'), isNotNull);
      expect(Validators.validatePassword('Rahasia12'), isNotNull);
    });
  });
}
