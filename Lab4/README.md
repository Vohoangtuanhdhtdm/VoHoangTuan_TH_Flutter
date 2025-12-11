# 🌤️ Flutter Weather App

Link video: https://drive.google.com/file/d/1l33whX0EbBiwIBRqWs-txwg85jaMAQ9h/view?usp=sharing

## 📱 Tính năng (Features)

### 🌟 Tính năng cốt lõi (Core Features)

- **Thời tiết hiện tại:** Hiển thị nhiệt độ, trạng thái (mưa, nắng...), độ ẩm, áp suất, tốc độ gió, giờ mọc/lặn mặt trời.
- **Dự báo chi tiết:**
  - Dự báo hàng giờ (Hourly Forecast) trong 24h tới.
  - Dự báo 5 ngày tiếp theo (Daily Forecast) với nhiệt độ thấp nhất/cao nhất.
- **Định vị tự động:** Tự động lấy dữ liệu thời tiết tại vị trí GPS hiện tại.
- **Tìm kiếm:** Tìm kiếm và xem thời tiết của bất kỳ thành phố nào trên thế giới.

### 🚀 Tính năng nâng cao (Advanced Features)

- **Offline Mode (Caching):** Tự động lưu cache dữ liệu lần cuối cùng tải về. Người dùng vẫn xem được thời tiết khi không có kết nối mạng.
- **Cài đặt (Settings):** Tùy chỉnh đơn vị nhiệt độ (Celsius °C / Fahrenheit °F).
- **Quản lý trạng thái:** Sử dụng `AsyncNotifier` của Riverpod để xử lý các trạng thái Loading, Error, và Data một cách mượt mà.
- **Xử lý lỗi:** Hiển thị thông báo thân thiện khi lỗi mạng, lỗi API hoặc không có quyền truy cập vị trí.

---

## 📸 Hình ảnh minh họa (Screenshots)

|                  Màn hình chính                   |                      Tìm kiếm                       |                       Cài đặt                       | Chế độ Offline/Lỗi |
| :-----------------------------------------------: | :-------------------------------------------------: | :-------------------------------------------------: | :----------------: |
| <img src="screenshot/lab4-home.png" width="200"/> | <img src="screenshot/lab4-search.png" width="200"/> | <img src="screenshot/lab4-detail.png" width="200"/> |

---

## 🛠️ Cài đặt & Hướng dẫn chạy (Installation)

### 1. Yêu cầu (Prerequisites)

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (phiên bản ổn định mới nhất)
- Tài khoản [OpenWeatherMap](https://openweathermap.org/) để lấy API Key (miễn phí).

### 2. Thiết lập môi trường (Environment Setup)

Vì lý do bảo mật, API Key không được lưu trực tiếp trên GitHub. Cần thiết lập file môi trường:

1.  Tạo file tên là `.env` tại thư mục gốc của dự án (cùng cấp với `pubspec.yaml`).
2.  Copy nội dung từ file `.env.example` sang `.env`.
3.  Thay thế nội dung bằng API Key của bạn:

```env
API_WEATHER_KEY=dien_api_key_cua_ban_vao_day
```
