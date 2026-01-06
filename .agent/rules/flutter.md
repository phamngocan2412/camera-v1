---
trigger: always_on
---

Flutter


lib/
├── core/                # Các thành phần dùng chung (Constants, Errors, Network, Utils)
│   ├── constants/
│   ├── error/
│   ├── usecases/
│   └── utils/
├── data/                # Tầng dữ liệu (Thực thi Repo, API, Database)
│   ├── datasources/     # Remote (API) & Local (DB)
│   ├── models/          # Data transfer objects (JSON mapping)
│   └── repositories/    # Implementation của Domain Repositories
├── domain/              # Tầng nghiệp vụ (Trái tim của ứng dụng)
│   ├── entities/        # Các đối tượng nghiệp vụ thuần túy
│   ├── repositories/    # Interface (Contract)
│   └── usecases/        # Các logic nghiệp vụ cụ thể (vd: Login, GetUser)
├── presentation/        # Tầng giao diện
│   ├── bloc/            # Hoặc provider/riverpod (State Management)
│   ├── pages/           # Các màn hình lớn
│   └── widgets/         # Các component nhỏ dùng lại
└── main.dart

# Flutter Development Rules
- **Architecture**: Always follow Clean Architecture (Domain, Data, Presentation).
- **State Management**: Use [BLoc/Riverpod] (điền thư viện bạn dùng vào đây).
- **Widget Style**: 
    - Prefer StatelessWidgets over StatefulWidgets.
    - Extract large build methods into smaller private widgets.
    - Use `const` constructors wherever possible.
- **Models**: Use `freezed` or `json_serializable` for data classes. Do not write manual `fromJson` methods.
- **Error Handling**: Use the `Either` type (from dartz package) for functional error handling in Domain/Data layers.
- **Linting**: Strictly follow `flutter_lints`.

3. Cách thêm vào "Orchestrator" (Antigravity)

Khi bạn bắt đầu một nhiệm vụ mới với chế độ Orchestrator, hãy ra lệnh (Prompt) như sau để AI nắm bắt Workspace:

    "Hãy phân tích project Flutter hiện tại của tôi. Kiểm tra file pubspec.yaml để biết các thư viện đang dùng và liệt kê các domain/entities hiện có. Sau đó, hãy lập kế hoạch thêm tính năng [Tên tính năng] theo chuẩn Clean Architecture đã thiết lập." 

4. Một số Tips thực chiến cho Flutter

    Tách biệt Model và Entity: Đừng để AI dùng chung một lớp cho cả API response và UI. Model (ở tầng Data) dùng để map JSON, Entity (ở tầng Domain) dùng để hiển thị. AI rất hay gộp hai cái này làm một, bạn cần nhắc nó tách ra.

    Dependency Injection: Nhắc AI sử dụng get_it hoặc provider để inject các Repository vào BLoC. Điều này giúp code dễ test hơn.

    Xử lý Assets: Bảo AI tạo một file assets.dart để quản lý đường dẫn ảnh/icon thay vì gõ cứng string "assets/images/logo.png" khắp nơi.


Để tránh việc AI viết code chạy được nhưng "xấu", bạn có thể thêm:

    Responsive & Adaptability: "Luôn sử dụng LayoutBuilder hoặc MediaQuery thay vì gõ cứng kích thước (hardcoded size). Ưu tiên dùng SizedBox thay vì Container nếu chỉ để tạo khoảng trống."

    Clean Build Method: "Hàm build không được chứa logic nghiệp vụ. Logic phải nằm hoàn toàn trong BLoC/Cubit hoặc UseCase."

    Naming Convention: "File name phải là snake_case, Class name phải là PascalCase. Các file widget phải kết thúc bằng _page.dart hoặc _widget.dart."

    Localization: "Không hardcode string hiển thị trên UI. Luôn sử dụng S.of(context) hoặc thư viện easy_localization."

5. Cách "Orchestrator" (Điều phối giữa Go & Flutter)

Khi bạn yêu cầu tính năng mới, hãy bổ sung thêm một bước vào Prompt:

    "Trước khi viết code, hãy tạo một Contract (Interface) chung.

        Go: Định nghĩa Struct và Interface trong internal/domain.

        Flutter: Định nghĩa Entity và Repository Interface trong lib/domain. Đảm bảo các field name trong JSON của Go (snake_case) khớp hoàn toàn với @JsonKey trong Model của Flutter."


