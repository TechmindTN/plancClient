import 'package:get/get.dart' show GetPage, Transition;

import '../../which.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/phone_verification_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/views/register_view2.dart';
import '../modules/book_e_service/bindings/book_e_service_binding.dart';
import '../modules/book_e_service/views/book_e_service_view.dart';
import '../modules/category/bindings/category_binding.dart';
import '../modules/category/views/categories_view.dart';
import '../modules/category/views/category_view.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/checkout/views/confirmation_view.dart';
import '../modules/e_provider/bindings/e_provider_binding.dart';
import '../modules/e_provider/views/e_provider_e_services_view.dart';
import '../modules/e_provider/views/e_provider_view.dart';
import '../modules/e_service/bindings/e_service_binding.dart';
import '../modules/e_service/views/e_service_view.dart';
import '../modules/favorites/bindings/favorites_binding.dart';
import '../modules/favorites/views/favorites_view.dart';
import '../modules/feedback/bindings/feedback_binding.dart';
import '../modules/feedback/views/feedback_view.dart';
import '../modules/feedback/views/rating_view.dart';

import '../modules/help_privacy/bindings/help_privacy_binding.dart';
import '../modules/help_privacy/views/help_view.dart';
import '../modules/help_privacy/views/privacy_view.dart';
import '../modules/home/views/home2_view.dart';
import '../modules/messages/views/chats_view.dart';
import '../modules/network_error/network_error.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/root/bindings/root_binding.dart';
import '../modules/root/views/root_view.dart';
import '../modules/search/views/search_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/language_view.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/settings/views/theme_mode_view.dart';
import '../modules/tasks/views/bill_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.ROOT;

  static final routes = [
    GetPage(name: Routes.ROOT, page: () => RootView(), binding: RootBinding()),
    GetPage(name: Routes.HOME, page: () => Home2View()),
    GetPage(
        name: Routes.FEEDBACK,
        page: () => FeedbackView(),
        binding: FeedbackBinding()),
    GetPage(
        name: Routes.RATING,
        page: () => RatingView(),
        binding: FeedbackBinding()),
    GetPage(name: Routes.CHAT, page: () => ChatsView()),
    GetPage(
        name: Routes.SETTINGS,
        page: () => SettingsView(),
        binding: SettingsBinding()),
    GetPage(
        name: Routes.SETTINGS_THEME_MODE,
        page: () => ThemeModeView(),
        binding: SettingsBinding()),
    GetPage(
        name: Routes.SETTINGS_LANGUAGE,
        page: () => LanguageView(),
        binding: SettingsBinding()),
    GetPage(
        name: Routes.PROFILE,
        page: () => ProfileView(),
        binding: ProfileBinding()),
    GetPage(
        name: Routes.CATEGORY,
        page: () => CategoryView(),
        binding: CategoryBinding()),
    GetPage(
        name: Routes.CATEGORIES,
        page: () => CategoriesView(),
        binding: CategoryBinding()),
    GetPage(
        name: Routes.LOGIN, page: () => LoginView(), binding: AuthBinding()),
    GetPage(
        name: Routes.REGISTER,
        page: () => RegisterView(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.REGISTER2,
        page: () => RegisterView2(),
        binding: AuthBinding()),
    GetPage(name: Routes.BILL, page: () => BillView(), binding: AuthBinding()),
    GetPage(
        name: Routes.FORGOT_PASSWORD,
        page: () => ForgotPasswordView(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.PHONE_VERIFICATION,
        page: () => PhoneVerificationView(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.E_SERVICE,
        // page: () => EServiceView(),
        binding: EServiceBinding(),
        transition: Transition.downToUp),
    GetPage(
        name: Routes.BOOK_E_SERVICE,
        page: () => BookEServiceView(),
        binding: BookEServiceBinding()),

    GetPage(
        name: Routes.NETWORKERROR,
        page: () => NetworkError(),
        // binding: BookEServiceBinding()
        ),
    GetPage(
        name: Routes.CHECKOUT,
        page: () => CheckoutView(),
        binding: CheckoutBinding()),
    GetPage(
        name: Routes.CONFIRMATION,
        page: () => ConfirmationView(),
        binding: CheckoutBinding()),
    GetPage(
        name: Routes.SEARCH,
        page: () => SearchView(),
        binding: RootBinding(),
        transition: Transition.downToUp),
    GetPage(
        name: Routes.NOTIFICATIONS,
        page: () => NotificationsView(),
        binding: NotificationsBinding()),
    GetPage(
        name: Routes.FAVORITES,
        page: () => FavoritesView(),
        binding: FavoritesBinding()),
    GetPage(
        name: Routes.PRIVACY,
        page: () => PrivacyView(),
        binding: HelpPrivacyBinding()),
    GetPage(
        name: Routes.HELP,
        page: () => HelpView(),
        binding: HelpPrivacyBinding()),
    GetPage(
        name: Routes.E_PROVIDER,
        page: () => EProviderView(),
        binding: EProviderBinding()),
    GetPage(
        name: Routes.E_PROVIDER_E_SERVICES,
        page: () => EProviderEServicesView(),
        binding: EProviderBinding()),
  ];
}
