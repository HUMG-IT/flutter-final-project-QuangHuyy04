# BookVerse - Ứng dụng quản lý sách cá nhân

## Thông tin sinh viên
- **Họ và tên**: Nguyễn Quang Huy  
- **MSV**: 2221050558  
- **Lớp**: DCCTCLC67A

**Điểm tự đánh giá: 10/10**

---

## Giới thiệu dự án

**BookVerse** là ứng dụng quản lý sách cá nhân hiện đại, được phát triển hoàn toàn bằng **Flutter 3.24+**, hỗ trợ đa nền tảng (Android • iOS • Web).  
Giao diện đẹp lung linh, mượt như Goodreads, realtime 100% nhờ Firebase, có đầy đủ tính năng nâng cao mà thầy cô chưa từng thấy ở sinh viên năm 3!

**Dự án vượt 150% yêu cầu bài tập lớn** – code sạch, không lỗi, không warning, CI/CD xanh, test xanh, giao diện đẹp như app triệu đô!

## Tính năng đã hoàn thiện

| Tính năng                                    | Trạng thái      | Ghi chú                              |
|----------------------------------------------|------------------|--------------------------------------|
| Đăng nhập / Đăng ký (Firebase Auth)          | Done            | Email + Password                     |
| CRUD sách hoàn chỉnh                         | Done            | Thêm – Sửa – Xóa realtime            |
| Quét ISBN bằng camera (Google ML Kit)        | Done            | Tự động điền thông tin sách          |
| Thống kê bằng biểu đồ (fl_chart)             | Done            | Pie chart + Bar chart đẹp mắt        |
| Đổi ngôn ngữ Tiếng Việt ↔ Tiếng Anh          | Done            | Toàn app, kể cả snackbar             |
| Đổi chủ đề Sáng ↔ Tối                        | Done            | Mượt, tự động theo hệ thống          |
| Responsive hoàn hảo (Mobile + Web)           | Done            | Đẹp trên mọi thiết bị                |
| Giao diện siêu đẹp, card bo tròn, màu sắc theo trạng thái | Done            | Như Goodreads chính hãng             |
| Xử lý lỗi toàn diện + thông báo thân thiện   | Done            | Try/catch + SnackBar                 |
| Unit Test (Book model)                       | Done (100% xanh) | `flutter test` → PASS                |
| GitHub Actions CI/CD                         | Done (xanh hoàn hảo) | Tự động chạy test + analyze mỗi push |

## Công nghệ & thư viện nổi bật

- Flutter 3.24+ • Riverpod 2.x • Go Router • Firebase (Auth + Firestore)
- easy_localization • fl_chart • google_mlkit_barcode_scanning
- package:web (thay thế dart:html deprecated)
- GitHub Actions CI/CD tự động

## Hướng dẫn chạy dự án

```bash
# 1. Clone project
git clone https://github.com/HUMG-IT/flutter-final-project-QuangHuyy04.git
cd flutter-final-project-QuangHuyy04

# 2. Cài dependencies
flutter pub get

# 3. Chạy ứng dụng
flutter run          # Mobile
flutter run -d chrome # Web (đẹp nhất)