# 🔄 UserEntity Refactor Summary

## 📋 **Vấn đề ban đầu:**
- Có 2 `UserEntity` ở 2 vị trí khác nhau:
  - `lib/features/auth/domain/entities/user_entity.dart`
  - `lib/features/profile_setting/domain/entities/user_entity.dart`

## ✅ **Giải pháp đã thực hiện:**

### 1. **Tạo UserEntity chung ở Core:**
- **Vị trí:** `lib/core/domain/entities/user_entity.dart`
- **Lý do:** Tránh duplicate code, đảm bảo consistency
- **Cấu trúc:** Kết hợp tất cả fields cần thiết từ cả 2 UserEntity cũ

### 2. **Cập nhật Auth Feature:**
- **Repository:** Sử dụng UserEntity từ core
- **BLoC:** Cập nhật events và states (tạm thời không dùng freezed)
- **UI:** Cập nhật login page

### 3. **Cập nhật Profile Setting Feature:**
- **Model:** Tạo UserModel mới với conversion methods
- **Repository:** Sử dụng UserEntity từ core

## 🏗️ **Cấu trúc mới:**

```
lib/
├── core/
│   └── domain/
│       └── entities/
│           └── user_entity.dart          # ✅ UserEntity chung
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart      # 🔄 Export từ core
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart  # ✅ Sử dụng core UserEntity
│   │   └── data/
│   │       └── repositories/
│   │           └── auth_repository_impl.dart
│   └── profile_setting/
│       ├── domain/
│       │   └── entities/
│       │       └── user_entity.dart      # 🔄 Export từ core
│       └── data/
│           └── models/
│               └── user_model.dart       # ✅ Conversion với core UserEntity
```

## 📝 **UserEntity Fields:**

```dart
class UserEntity {
  final String id;           // ✅ Từ auth
  final String email;        // ✅ Từ cả 2
  final String? displayName; // ✅ Từ cả 2
  final String? photoURL;    // ✅ Từ auth
  final String? providerId;  // ✅ Từ auth
  final String? createdAt;   // ✅ Từ profile
  final String? updatedAt;   // ✅ Từ profile
}
```

## 🚀 **Bước tiếp theo:**

1. **Chạy build_runner:**
   ```bash
   flutter packages pub run build_runner build
   ```

2. **Cài đặt dependencies:**
   ```bash
   flutter pub get
   ```

3. **Test tính năng:**
   - Auth flow hoạt động bình thường
   - Profile setting có thể lưu/load user data
   - Không có duplicate code

## 💡 **Lợi ích:**

- ✅ **Single Source of Truth:** Một UserEntity duy nhất
- ✅ **Consistency:** Tất cả features sử dụng cùng một entity
- ✅ **Maintainability:** Dễ maintain và extend
- ✅ **Type Safety:** Đảm bảo type safety across features
- ✅ **Clean Architecture:** Tuân thủ nguyên tắc Clean Architecture

## ⚠️ **Lưu ý:**

- Các file cũ vẫn được giữ lại như export files để tránh breaking changes
- Có thể xóa các file export này sau khi đã migrate hoàn toàn
- UserModel trong profile_setting có thể được refactor thêm nếu cần
