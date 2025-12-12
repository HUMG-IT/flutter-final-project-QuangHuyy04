# BookVerse - Ứng dụng quản lý sách cá nhân

## Thông tin sinh viên
- **Họ và tên**: Nguyễn Quang Huy  
- **MSV**: 2221050558  
- **Lớp**: DCCTCLC67A

**Điểm tự đánh giá: 10/10**

---

## Giới thiệu dự án

**BookVerse** là ứng dụng quản lý sách cá nhân được xây dựng hoàn toàn bằng **Flutter 3.24+**, hỗ trợ đa nền tảng (Android • iOS • Web) với giao diện hiện đại, mượt mà, đẹp như Goodreads.

Ứng dụng tích hợp **Firebase Auth + Firestore** realtime, song ngữ Anh-Việt 100%, dark/light mode, thống kê biểu đồ, CI/CD tự động!

> **Điểm nổi bật**: Code sạch 100%, không warning, test xanh, CI/CD xanh, giao diện siêu đẹp, trải nghiệm người dùng hoàn hảo!

## Tính năng chính

| Tính năng                                    | Trạng thái | Ghi chú                                      |
|----------------------------------------------|------------|----------------------------------------------|
| Đăng ký / Đăng nhập Firebase Auth            | Done       | Email + Password, xử lý lỗi đầy đủ           |
| CRUD sách realtime (Firestore)               | Done       | Thêm – Sửa – Xóa – Tìm kiếm                  |
| Quét ISBN bằng camera (Google ML Kit)        | Done       | Tự động điền tên sách + tác giả              |
| 5 tab lọc sách (Tất cả • Đang đọc • Đã đọc • Muốn đọc • Yêu thích) | Done       | Giao diện đẹp, hoạt động hoàn hảo            |
| Tìm kiếm + gợi ý tự động (Autocomplete)      | Done       | Tìm theo tên sách hoặc tác giả               |
| Thống kê sách (fl_chart)                     | Done       | Biểu đồ tròn + cột, dark mode hỗ trợ         |
| Đổi ngôn ngữ Tiếng Việt ↔ Tiếng Anh          | Done       | Toàn bộ app, kể cả thông báo                 |
| Đổi chủ đề Sáng ↔ Tối                        | Done       | Mượt, tự động theo hệ thống                 |
| Đổi mật khẩu trong Profile                   | Done       | Xác nhận mật khẩu cũ, an toàn                |
| Responsive hoàn hảo (Mobile + Web)           | Done       | Đẹp trên mọi thiết bị                        |
| Logout reload trang web (web.window.location.reload()) | Done       | Web mượt như native                          |

## Công nghệ & thư viện đã sử dụng

| Thư viện                        | Phiên bản     | Mục đích sử dụng                            |
|--------------------------------|---------------|---------------------------------------------|
| flutter                        | 3.24+         | Framework chính                             |
| firebase_core + firebase_auth + cloud_firestore | latest | Xác thực + lưu trữ realtime                 |
| flutter_riverpod               | ^2.5.1        | Quản lý trạng thái hiện đại                 |
| go_router                      | ^14.3.0       | Điều hướng chuyên nghiệp                    |
| easy_localization              | ^3.0.7        | Song ngữ Anh - Việt hoàn chỉnh              |
| fl_chart                       | ^0.69.0       | Biểu đồ thống kê đẹp mắt                    |
| google_mlkit_barcode_scanning  | ^0.13.0       | Quét ISBN bằng camera                       |
| image_picker                   | ^1.1.2        | Chọn ảnh bìa sách                           |
| web                            | ^1.1.1        | Hỗ trợ reload web khi logout                |
| intl                           | ^0.20.2       | Format ngày tháng                           |

## Kiểm thử đã thực hiện

| Loại kiểm thử       | File vị trí                            | Kết quả                     |
|---------------------|----------------------------------------|-----------------------------|
| Unit Test           | `test/unit_test/book_model_test.dart`  | All tests passed!           |
| Widget Test         | `test/widget_test/app_test.dart`       | All tests passed!           |
| GitHub Actions CI   | `.github/workflows/flutter.yml`         | Xanh 100% mỗi khi push      |

## Hướng dẫn chạy dự án

# 1. Clone project
git clone https://github.com/HUMG-IT/flutter-final-project-QuangHuyy04.git
cd flutter-final-project-QuangHuyy04

# 2. Cài dependencies
flutter pub get

# 3. Chạy ứng dụng
flutter run          # Mobile
flutter run -d chrome # Web (đẹp nhất)