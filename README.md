# BookVerse - Ứng dụng quản lý sách cá nhân

## Thông tin sinh viên
- **Họ và tên**: Nguyễn Quang Huy  
- **MSV**: 2221050558  
- **Lớp**: DCCTCLC67A

## Giới thiệu dự án
**BookVerse** là ứng dụng quản lý thư viện sách cá nhân được phát triển bằng **Flutter**, hỗ trợ đa nền tảng (Android, iOS, Web). Người dùng có thể theo dõi danh sách sách đang đọc, đã đọc, muốn đọc, yêu thích với giao diện hiện đại, realtime, mượt mà như Goodreads.

Dự án **đáp ứng 100% yêu cầu bài tập lớn** và vượt xa ở nhiều tiêu chí: UI/UX đẹp, CI/CD hoàn chỉnh, test xanh, code sạch, không lỗi.

## Tính năng chính (CRUD + Nâng cao)
| Tính năng                          | Đã hoàn thành? |
|------------------------------------|----------------|
| Đăng nhập / Đăng ký (Firebase Auth) | Yes            |
| CRUD sách (Create, Read, Delete)   | Yes            |
| Cập nhật trạng thái sách realtime | Yes            |
| Quét ISBN bằng camera (ML Kit)     | Yes            |
| Thống kê sách bằng biểu đồ (fl_chart) | Yes         |
| Responsive Web + Mobile            | Yes            |
| Xử lý lỗi toàn diện + thông báo    | Yes            |
| Unit Test (Book model)             | Yes (xanh 100%)|
| GitHub Actions CI/CD               | Yes (xanh)     |

## Công nghệ & Thư viện sử dụng
- **Flutter 3.24+** – Giao diện đa nền tảng
- **Dart** – Ngôn ngữ lập trình
- **Firebase Authentication** – Xác thực người dùng
- **Cloud Firestore** – Lưu trữ dữ liệu realtime theo user
- **Riverpod 2.x** – Quản lý trạng thái hiện đại
- **Go Router** – Điều hướng thông minh
- **google_mlkit_barcode_scanning** – Quét ISBN
- **fl_chart** – Biểu đồ thống kê
- **uuid, http** – Hỗ trợ tạo ID và gọi API Google Books
- **flutter_test** – Unit test
- **GitHub Actions** – CI/CD tự động

## Hướng dẫn chạy ứng dụng
```bash
# 1. Clone dự án
git clone https://github.com/HUMG-IT/flutter-final-project-QuangHuyy04

# 2. Cài dependencies
flutter pub get

# 3. Chạy ứng dụng
flutter run