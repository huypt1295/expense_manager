# Household & Personal Workspace Experience

## 1. Business Objectives
- Cho phép người dùng duy trì dữ liệu tài chính cá nhân và đồng thời cộng tác trong các không gian chi tiêu chung (household/workspace).
- Bảo đảm quyền riêng tư cho khoản chi cá nhân đồng thời tăng tính minh bạch và khả năng truy vết cho giao dịch chung.
- Mở rộng nền tảng để hỗ trợ quản trị thành viên, phân quyền, và các gói tính phí theo hộ gia đình.

## 2. Đối tượng & Vai trò
- **Người dùng cá nhân**: đăng nhập bằng email/Google/Facebook; luôn có "Không gian cá nhân" mặc định.
- **Household/Workspace**: không gian chung có tên, biểu tượng, loại tiền tệ, và danh sách thành viên.
- **Vai trò thành viên**
  - `Owner`: toàn quyền, quản lý thành viên, chuyển nhượng quyền sở hữu.
  - `Editor`: tạo/sửa/xoá giao dịch và ngân sách nhưng không quản lý vai trò.
  - `Viewer`: chỉ xem dữ liệu và báo cáo.

## 3. Trạng thái hệ thống
| Trạng thái | Mô tả | Quyền truy cập |
|------------|-------|----------------|
| Chỉ cá nhân | Người dùng chưa tạo hoặc tham gia household. | Xem & thao tác dữ liệu cá nhân dưới `users/{uid}`. |
| Đa không gian | Người dùng có ít nhất một household và vẫn giữ không gian cá nhân. | Có thể chuyển đổi giữa cá nhân và từng household. |
| Mất quyền household | Người dùng bị gỡ khỏi household. | Vẫn truy cập khoản cá nhân; thấy banner thông báo mất quyền với household đó. |

## 4. Luồng nghiệp vụ chính

### 4.1 Onboarding & Tạo Household
1. Người dùng đăng nhập.
2. Hệ thống kiểm tra danh sách membership:
   - Nếu rỗng: khởi chạy wizard 3 bước
     1. Đặt tên, biểu tượng household.
     2. Chọn loại tiền mặc định.
     3. (Tuỳ chọn) mời thành viên qua email/mã chia sẻ.
   - Nếu đã có household: mở modal chọn không gian làm việc.
3. Sau khi chọn, lưu `householdId` hiện tại vào `CurrentWorkspace` để điều hướng dashboard.

### 4.2 Chọn & Chuyển Không Gian
1. Header hiển thị tên + avatar của không gian hiện tại.
2. Nhấn vào header để mở danh sách:
   - "Không gian cá nhân của tôi" (đi kèm ghi chú "Chỉ mình bạn").
   - Các household đã tham gia, hiển thị số thành viên và vai trò.
   - Nút "Tạo household mới".
3. Chọn một mục → cập nhật context, reload dữ liệu giao dịch/ngân sách theo không gian đó.

### 4.3 Quản lý thành viên Household
1. Từ trang cài đặt household, `Owner`/`Editor` truy cập tab "Thành viên".
2. Hành động khả dụng:
   - Gửi lời mời: nhập email hoặc tạo mã.
   - Quản lý lời mời đang chờ (huỷ, gửi lại).
   - Đổi vai trò (Owner → chuyển quyền, Editor/Viewer → nâng/hạ quyền).
   - Gỡ thành viên hoặc để thành viên tự rời.
3. Người nhận lời mời
   - Nhấn link → đăng nhập → thấy màn hình xác nhận thông tin household và vai trò.
   - Bấm "Tham gia" → household xuất hiện trong danh sách không gian.

### 4.4 Tạo & Quản lý Giao Dịch
| Bối cảnh | UI/UX | Ghi chú nghiệp vụ |
|---------|-------|--------------------|
| Không gian cá nhân | Bottom sheet thêm giao dịch hiển thị segmented control "Phạm vi: Cá nhân / Chia sẻ" (default = Cá nhân). | Lưu giao dịch dưới `users/{uid}` với `scope = personal`. |
| Household | Bottom sheet hiển thị tên household, badge vai trò; phạm vi khoá ở household. | Lưu dưới `households/{householdId}` với `scope = household`, trường `createdBy` và `lastUpdatedBy`. |
| Chuyển giao dịch cá nhân → household | Swipe action "Chia sẻ với household" hoặc menu trong chi tiết giao dịch. | Sao chép dữ liệu sang collection household, lưu `sharedFrom = personal`, log hoạt động. |
| Sao chép giao dịch chung → cá nhân | Menu dành cho Owner/Editor: "Sao chép bản cá nhân". | Tạo giao dịch mới trong không gian cá nhân để làm bản riêng. |

### 4.5 Ngân sách & Báo cáo
- Bộ lọc phạm vi (Personal / Household / Tất cả) áp dụng cho biểu đồ và báo cáo.
- Ngân sách trong household có trường `ownerMemberId` để biết ai tạo; history hiển thị thay đổi theo thành viên.
- Trong không gian cá nhân, người dùng vẫn tạo ngân sách riêng không hiển thị cho household.

### 4.6 Hoạt động & Thông báo
- Activity feed theo household ghi lại: thành viên tham gia/rời, giao dịch lớn, thay đổi ngân sách, chia sẻ giao dịch.
- Thông báo đẩy/email:
  - Có lời mời household mới.
  - Vai trò bị thay đổi hoặc bị gỡ.
  - Giao dịch do bạn tạo bị người khác chỉnh sửa (tuỳ cấu hình).  
- Banner in-app thông báo ngay khi người dùng mất quyền truy cập household.

## 5. Thành phần UI chính

### 5.1 Header/Workspace Switcher
- Vị trí: đầu dashboard và hầu hết màn hình chính.
- Thành phần: avatar household, tên, vai trò; icon mũi tên mở modal/bottom sheet.
- Modal hiển thị danh sách không gian, kèm quick actions (tạo mới, quản lý thành viên).

### 5.2 Dashboard
- **Không gian cá nhân**: biểu đồ thu chi, danh sách giao dịch không hiển thị avatar; banner gợi ý “Chia sẻ với household” khi phát hiện chi tiêu lớn.
- **Household**: biểu đồ tổng hợp cho mọi thành viên, bộ lọc theo thành viên, widget "Hoạt động gần đây".

### 5.3 Danh sách Giao dịch
- Badge màu sắc phân biệt phạm vi (`Personal`/`Household`).
- Avatar nhỏ hoặc tên viết tắt của người tạo.
- Thao tác swipe:
  - Cá nhân: sửa, xoá, chia sẻ với household.
  - Household: sửa/xoá (tuỳ vai trò), sao chép về cá nhân.

### 5.4 Bottom Sheet Thêm Giao dịch
- Header chứa segmented control phạm vi (Personal/Household) hoặc label cố định khi đang ở household.
- Trường "Người thực hiện" tự động điền bằng tên người dùng (đọc-only).
- Toggle "Đánh dấu chi tiêu chung" để chuyển sang household khi đang ở không gian cá nhân.

### 5.5 Trang Quản lý Thành viên
- Chia nhóm theo vai trò, hiển thị trạng thái lời mời.
- Action menu từng thành viên (đổi quyền, gỡ, nhắc tham gia).
- Tab riêng cho lời mời chờ xác nhận.

### 5.6 Thông báo & Activity Feed
- Panel hoặc màn hình riêng hiển thị log thời gian thực.
- Badge thông báo trên icon household khi có sự kiện mới.

## 6. Edge Cases & Quy tắc
- Người dùng rời household → giao dịch household vẫn thuộc về household; người dùng bị điều hướng về không gian cá nhân.
- Offline: cho phép thêm giao dịch ở cả hai không gian; khi đồng bộ kiểm tra quyền hiện tại. Nếu mất quyền trước khi đồng bộ, giao dịch được lưu dạng nháp và yêu cầu chọn không gian khác.
- Household chỉ còn một thành viên (`Owner`) → hiển thị cảnh báo; cho phép chuyển đổi household thành "Cá nhân" hoặc mời thêm người.

## 7. Tích hợp với hạ tầng hiện tại
- `CurrentWorkspace` duy trì `householdId` đang chọn và phát sự kiện khi thay đổi.
- Repository/data source nhận cả `uid` và `workspaceId` (hoặc cờ cá nhân) để đọc/ghi dữ liệu đúng nơi.
- Security rules Firestore kiểm tra membership trước khi cho phép truy cập tài nguyên household.

## 8. KPI & Theo dõi
- Số lượng household được tạo mỗi tuần.
- Tỉ lệ người dùng hoạt động đồng thời ở ít nhất 2 không gian.
- Tỉ lệ giao dịch chia sẻ vs cá nhân.
- Số lượng lời mời được chấp nhận.

## 9. Phụ lục: Tài nguyên hỗ trợ thiết kế
- Ảnh chụp màn hình app hiện tại: thư mục `screenshot/`.
- Tài liệu kiến trúc hiện hành: tham khảo `documents/transactions`, `documents/budget`, `documents/home`.
