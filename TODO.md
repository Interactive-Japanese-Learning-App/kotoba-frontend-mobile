# TODO - OTP UI + Countdown

- [ ] Update `lib/app/modules/otp/controllers/otp_controller.dart`:
  - tambah countdown 60 detik
  - tambah state `canResend`, `secondsRemaining`, `isResending`
  - tambah `startCountdown()` dan `resendOtp()`
  - timer disposed di `onClose()`
- [ ] Update `lib/app/modules/otp/views/otp_view.dart`:
  - tambah tampilan countdown (mm:ss)
  - tambah tombol “Kirim ulang OTP” yang disabled saat timer aktif
  - rapikan layout agar senada (padding/typography/button style)
- [ ] Update `lib/app/data/services/api_service.dart` (jika perlu):
  - tambahkan `resendOtp({required String email})` untuk endpoint yang sesuai
- [ ] Testing cepat:
  - hot restart aplikasi
  - verifikasi countdown & tombol resend

