---
trigger: always_on
---

mode: local
enforcement: strict

workspace:
  name: flutter-clean-architecture-local
  description: >
    Local Antigravity workspace with full filesystem access.
    AI is allowed to read, analyze, refactor, and reorganize code,
    but MUST strictly follow Clean Architecture rules.

filesystem_access:
  read: true
  write: true
  refactor: true
  rename: true
  delete: false   # Không tự ý xóa file nếu chưa được yêu cầu rõ

analysis_requirements:
  mandatory_before_coding:
    - Scan entire lib/ directory
    - Read pubspec.yaml and pubspec.lock
    - Detect state management solution
    - Detect existing domains and features
    - Detect DI pattern (get_it / provider / manual)

  forbidden_assumptions:
    - Do not assume missing layers
    - Do not create new architecture patterns
    - Do not change folder structure without approval

architecture:
  pattern: Clean Architecture
  layers:
    core:
      allowed_imports: []
    domain:
      allowed_imports: []
    data:
      allowed_imports:
        - domain
        - core
    presentation:
      allowed_imports:
        - domain
        - core

  forbidden_dependencies:
    - from: domain
      to: data
    - from: domain
      to: presentation
    - from: presentation
      to: data

project_structure:
  enforce_existing_structure: true
  auto_create_missing_folders: true

state_management:
  detected_from_project: true
  rules:
    - UI must never call API or DB
    - BLoC/Cubit must depend ONLY on UseCases
    - RepositoryImpl injection into UI/BLoC is forbidden
    - One feature = one BLoC (unless explicitly shared)

models_and_entities:
  entity:
    rules:
      - Must be pure Dart
      - No annotations
      - No JSON logic
      - No dependency on Flutter or Data layer

  model:
    rules:
      - Must use freezed or json_serializable
      - Manual fromJson/toJson is forbidden
      - Must convert to Entity via mapper or extension
      - JSON keys must be snake_case

  enforcement:
    - Scan project for Entity used as Model → REPORT ERROR
    - Scan project for JSON annotations in Domain → REPORT ERROR

error_handling:
  domain:
    rules:
      - Always return Either<Failure, T>
      - Throwing exceptions is forbidden
  data:
    rules:
      - Catch low-level exceptions
      - Map exceptions to Failure
  failure_location: core/error

dependency_injection:
  tool: get_it
  rules:
    - DI registration must be centralized
    - No lazy DI inside UI widgets
    - No direct instantiation of RepositoryImpl in BLoC
    - UseCases must depend on Repository interfaces only

ui_rules:
  widgets:
    - Prefer StatelessWidget
    - StatefulWidget only with justification
    - Use const constructors wherever possible
    - Extract widgets when build() > 50 lines

  layout:
    - Hardcoded width/height is forbidden
    - Use LayoutBuilder or MediaQuery
    - SizedBox preferred over Container for spacing

  build_method:
    - Business logic is forbidden
    - API / UseCase calls forbidden

localization:
  rules:
    - Hardcoded UI strings forbidden
    - Must use easy_localization or equivalent
    - Localization keys must be reused

assets:
  rules:
    - Asset paths must be centralized
    - assets.dart is mandatory
    - No string literal asset paths in UI

naming_convention:
  files: snake_case
  classes: PascalCase
  folders: snake_case
  widgets:
    pages: _page.dart
    components: _widget.dart
    bloc: _bloc.dart

orchestrator_behavior:
  before_task:
    - Summarize current architecture
    - Identify impacted domains/features
    - Propose file-level change list

  during_task:
    - Modify only listed files
    - Follow existing code style
    - Keep changes minimal and focused

  after_task:
    - Validate architecture rules
    - Report any rule violations
    - Suggest refactor if needed (DO NOT auto-apply)

flutter_go_contract:
  enforcement: strict
  rules:
    - Contract must be defined before implementation
    - Go structs use snake_case JSON
    - Flutter models must match via @JsonKey
    - Field mismatch is a hard error
    - Breaking changes must be explicitly listed

ai_common_mistakes_forbidden:
  - Merging Entity and Model
  - Creating god-classes
  - Injecting concrete classes into BLoC
  - Logic inside build()
  - Silent architecture changes
  - Hardcoded sizes or strings

output_policy:
  code_style: follow_existing_project
  verbosity: concise
  comments: explain why, not what

goal:
  - Maintainable long-term codebase
  - Predictable architecture
  - Refactor-safe structure
  - AI acts as senior Flutter engineer, not code generator
