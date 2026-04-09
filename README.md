# Quản Lý Sinh Viên - Flutter App

Ứng dụng quản lý sinh viên đơn giản được xây dựng bằng Flutter, sử dụng SQLite để lưu trữ dữ liệu cục bộ.

## 🚀 Tính năng chính

- **Quản lý danh sách:** Xem, thêm, sửa, xóa thông tin sinh viên.
- **Tính toán điểm:** Tự động tính điểm tổng kết, điểm chữ (A, B, C, D, F) và điểm tích lũy (hệ 4.0).
- **Thống kê:** 
    - Tổng số sinh viên.
    - Số lượng sinh viên đủ tư cách thi (điểm thành phần >= 4.0).
    - Tìm sinh viên có điểm cao nhất và thấp nhất.
- **Dữ liệu mẫu:** Chức năng tự động tạo 70 sinh viên mẫu để test ứng dụng.
- **Giao diện:** Đơn giản, dễ sử dụng với các màn hình Chào mừng, Quản lý, Thống kê và Giới thiệu.

## 🛠 Công nghệ sử dụng

- **Ngôn ngữ:** Dart
- **Framework:** Flutter
- **Cơ sở dữ liệu:** `sqflite` (SQLite)
- **Thư viện hỗ trợ:** `path`, `intl`, `cupertino_icons`

## 📦 Yêu cầu hệ thống

- Flutter SDK: `^3.11.4` trở lên.
- Android Studio / VS Code đã cài đặt Flutter plugin.

## ⚙️ Cài đặt và Chạy ứng dụng

1. **Clone repository:**
   ```bash
   git clone <url-cua-ban>
   cd qlsinhvien
   ```

2. **Cài đặt các dependencies:**
   ```bash
   flutter pub get
   ```

3. **Chạy ứng dụng:**
   - Kết nối thiết bị Android/iOS hoặc mở Emulator.
   - Chạy lệnh:
   ```bash
   flutter run
   ```

## 📤 Các bước đẩy code lên Git

Nếu bạn chưa khởi tạo git trong thư mục này, hãy làm theo các bước sau:

1. **Khởi tạo Git:**
   ```bash
   git init
   ```

2. **Thêm các file vào staging:**
   ```bash
   git add .
   ```

3. **Commit lần đầu:**
   ```bash
   git commit -m "Initial commit: Ứng dụng Quản lý sinh viên"
   ```

4. **Tạo Repository trên GitHub/GitLab/Bitbucket** và lấy URL (ví dụ: `https://github.com/user/qlsinhvien.git`).

5. **Kết nối Local Repo với Remote Repo:**
   ```bash
   git remote add origin <URL_CUA_BAN>
   ```

6. **Đẩy code lên:**
   ```bash
   git push -u origin main
   ```

---
*Dự án được thực hiện cho mục đích học tập.*
