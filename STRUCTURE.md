1. root app

lib
├── app
│   └── app.dart
├── core
│   ├── config
│   │   ├── app_config.dart
│   │   └── app_config_cubit.dart
│   ├── constants
│   │   ├── data_constant.dart
│   │   └── mock_data.dart
│   ├── di
│   │   ├── injector.config.dart
│   │   └── injector.dart
│   ├── domain
│   │   └── entities
│   │       └── user_entity.dart
│   ├── firebase
│   │   └── firebase_options.dart
│   └── routing
│       └── app_router.dart
├── features
│   ├── add_expense
│   │   └── presentation
│   │       └── add_expense
│   │           ├── bloc
│   │           │   ├── expense_bloc.dart
│   │           │   ├── expense_event.dart
│   │           │   └── expense_state.dart
│   │           ├── constants
│   │           │   └── expense_constants.dart
│   │           ├── helpers
│   │           │   └── expense_image_helper.dart
│   │           ├── services
│   │           │   ├── README.md
│   │           │   └── expense_ai_service.dart
│   │           ├── widgets
│   │           │   ├── expense_form_fields.dart
│   │           │   ├── expense_scan_section.dart
│   │           │   └── image_source_bottom_sheet.dart
│   │           └── expense_form_bottom_sheet.dart
│   ├── auth
│   │   ├── data
│   │   │   └── repositories
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain
│   │   │   ├── entities
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases
│   │   │       ├── sign_in_with_fb_usecase.dart
│   │   │       └── sign_in_with_google_usecase.dart
│   │   └── presentation
│   │       └── login
│   │           ├── bloc
│   │           │   ├── auth_bloc.dart
│   │           │   ├── auth_effect.dart
│   │           │   ├── auth_event.dart
│   │           │   └── auth_state.dart
│   │           └── login_page.dart
│   ├── budget
│   │   └── presentation
│   │       └── budget
│   │           └── budget_page.dart
│   ├── home
│   │   └── presentation
│   │       └── home
│   │           ├── bloc
│   │           │   ├── home_bloc.dart
│   │           │   ├── home_effect.dart
│   │           │   ├── home_event.dart
│   │           │   └── home_state.dart
│   │           ├── home_page.dart
│   │           └── home_tab.dart
│   ├── profile_setting
│   │   ├── data
│   │   │   ├── models
│   │   │   │   └── user_model.dart
│   │   │   └── repositories
│   │   │       └── user_repository_impl.dart
│   │   ├── domain
│   │   │   ├── entities
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories
│   │   │   │   └── user_repository.dart
│   │   │   └── usecases
│   │   │       └── get_user_usecase.dart
│   │   └── presentation
│   │       └── profile
│   │           └── profile_setting_page.dart
│   └── transactions
│       └── presentation
│           └── transactions
│               └── transaction_page.dart
└── main.dart


2. Flutter Resource
shared_packages/flutter_resource
├── LICENSE
├── README.md
├── analysis_options.yaml
├── assets
│   ├── fonts
│   │   ├── Roboto-Black.ttf
│   │   ├── Roboto-Bold.ttf
│   │   ├── Roboto-Light.ttf
│   │   ├── Roboto-Medium.ttf
│   │   ├── Roboto-Regular.ttf
│   │   ├── Roboto-Thin.ttf
│   │   ├── SFUIText-Bold.ttf
│   │   ├── SFUIText-Heavy.ttf
│   │   ├── SFUIText-Light.ttf
│   │   ├── SFUIText-Medium.ttf
│   │   ├── SFUIText-Regular.ttf
│   │   └── SFUIText-Semibold.ttf
│   ├── images
│   │   ├── ic_facebook.webp
│   │   └── ic_google.webp
│   ├── json
│   │   └── bankListLocal.json
│   └── lotties
│       └── lottie_loading.json
├── lib
│   ├── flutter_resource.dart
│   ├── l10n
│   │   ├── gen
│   │   │   ├── intl
│   │   │   │   ├── messages_all.dart
│   │   │   │   ├── messages_en.dart
│   │   │   │   └── messages_vi.dart
│   │   │   └── l10n.dart
│   │   ├── intl_en.arb
│   │   └── intl_vi.arb
│   └── src
│       ├── di
│       │   ├── injector.dart
│       │   └── injector.module.dart
│       ├── localization
│       │   ├── locale_constants.dart
│       │   ├── locale_service_impl.dart
│       │   └── localization.dart
│       ├── resources
│       │   ├── assets.dart
│       │   ├── images.dart
│       │   ├── resources.dart
│       │   └── tp_anim.dart
│       └── theme
│           ├── app_color_extension.dart
│           ├── app_theme.dart
│           ├── color_tokens.dart
│           ├── colors.dart
│           ├── theme.dart
│           └── typography.dart
├── pubspec.lock
└── pubspec.yaml


3. Flutter common
shared_packages/flutter_common
├── LICENSE
├── README.md
├── analysis_options.yaml
├── lib
│   ├── flutter_common.dart
│   └── src
│       ├── di
│       │   ├── injector.dart
│       │   └── injector.module.dart
│       └── utils
│           ├── color_utils.dart
│           ├── context_utils.dart
│           ├── date_time_utils.dart
│           ├── file_utils.dart
│           ├── intent_utils.dart
│           ├── num_utils.dart
│           ├── object_utils.dart
│           ├── regex_utils.dart
│           ├── string_utils.dart
│           ├── utils.dart
│           ├── validation_utils.dart
│           └── view_utils.dart
├── pubspec.lock
├── pubspec.yaml
└── test
    └── utils
        ├── color_utils_test.dart
        ├── context_utils_test.dart
        ├── date_time_utils_test.dart
        ├── file_utils_test.dart
        ├── intent_utils_test.dart
        ├── num_utils_test.dart
        ├── object_utils_test.dart
        ├── regex_utils_test.dart
        ├── string_utils_test.dart
        ├── test_utils.dart
        ├── validation_utils_test.dart
        └── view_utils_test.dart

4. Flutter Core
shared_packages/flutter_core
├── LICENSE
├── README.md
├── analysis_options.yaml
├── lib
│   ├── flutter_core.dart
│   └── src
│       ├── data
│       │   ├── caching
│       │   │   ├── caching.dart
│       │   │   ├── memory
│       │   │   │   ├── cache_entry.dart
│       │   │   │   └── memory_cache.dart
│       │   │   └── policy
│       │   │       ├── cache_policy.dart
│       │   │       └── cache_presets.dart
│       │   ├── database
│       │   │   ├── dao
│       │   │   │   ├── base_sqlite_dao.dart
│       │   │   │   └── key_value_cache_dao.dart
│       │   │   ├── database.dart
│       │   │   └── orchestrator
│       │   │       ├── app_database.dart
│       │   │       └── db_module.dart
│       │   ├── exceptions
│       │   │   ├── error_codes.dart
│       │   │   ├── exception_mapper.dart
│       │   │   └── exceptions.dart
│       │   ├── model
│       │   │   ├── base_model.dart
│       │   │   └── base_request.dart
│       │   ├── monitoring
│       │   │   └── ga
│       │   │       ├── firebase_ga_analytics.dart
│       │   │       └── analytics_service_impl.dart
│       │   ├── network
│       │   │   ├── constant
│       │   │   │   ├── api_constant.dart
│       │   │   │   └── constant.dart
│       │   │   ├── http_client.dart
│       │   │   ├── http_request.dart
│       │   │   ├── http_response.dart
│       │   │   ├── interceptor
│       │   │   │   ├── breadcrumb_interceptor.dart
│       │   │   │   ├── http_interceptor.dart
│       │   │   │   └── interceptor_chain.dart
│       │   │   ├── network.dart
│       │   │   └── retry_policies.dart
│       │   ├── repository
│       │   │   └── base_cache_repository.dart
│       │   └── data.dart
│       ├── di
│       │   ├── di.dart
│       │   ├── injector.dart
│       │   ├── injector.module.dart
│       │   └── module
│       │       ├── network_module.dart
│       │       └── third_party_module.dart
│       ├── domain
│       │   ├── analytics
│       │   │   ├── analytics_service.dart
│       │   │   └── analytics_service_impl.dart
│       │   ├── domain.dart
│       │   ├── entity.dart
│       │   ├── repository.dart
│       │   └── usercase.dart
│       ├── foundation
│       │   ├── failure.dart
│       │   ├── foundation.dart
│       │   ├── logger.dart
│       │   ├── monitoring
│       │   │   ├── adapters
│       │   │   │   └── firebase_crash_reporter.dart
│       │   │   ├── analytics.dart
│       │   │   └── crash_reporter.dart
│       │   ├── result.dart
│       │   └── stream
│       │       ├── disposable_base.dart
│       │       └── dispose_bag.dart
│       ├── localization
│       │   ├── locale_service.dart
│       │   └── localization.dart
│       └── presentation
│           ├── bloc
│           │   ├── base_bloc.dart
│           │   ├── base_bloc_event.dart
│           │   ├── base_bloc_state.dart
│           │   ├── base_cubit.dart
│           │   ├── bloc.dart
│           │   ├── crash_bloc_observer.dart
│           │   ├── effect
│           │   │   ├── effect.dart
│           │   │   ├── effect_bloc_consumer.dart
│           │   │   ├── effect_bloc_listener.dart
│           │   │   ├── effect_cosumer.dart
│           │   │   ├── effect_listener.dart
│           │   │   ├── effect_listener_multi.dart
│           │   │   └── effect_provider.dart
│           │   └── model
│           │       └── error_ui_model.dart
│           ├── navigation
│           │   ├── base_router.dart
│           │   ├── crash_route_observer.dart
│           │   ├── ga_route_observer.dart
│           │   └── navigation.dart
│           ├── presentation.dart
│           └── widgets
│               ├── base_stateful_widget.dart
│               ├── base_stateless_widget.dart
│               ├── ui_actions.dart
│               └── widgets.dart
├── pubspec.lock
├── pubspec.yaml
└── test
    └── flutter_core_test.dart
