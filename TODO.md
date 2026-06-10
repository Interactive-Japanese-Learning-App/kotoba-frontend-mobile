# TODO - Reset Password Fix

- [ ] Fix compile errors in `ResetPasswordView`
  - [ ] Remove const_constructor_with_field_initialized_by_non_const by moving RxBool fields out of class-level final const context.
  - [ ] Address const_eval_extension_method issues (likely due to `const` usage combined with `.obs`/`RxBool`).
  - [ ] Remove `override_on_non_overriding_member` by changing `@override` usage (currently incorrectly annotated on fields).
- [ ] Add basic password validations (empty + min length) and guard missing Get.arguments values (email/otp) in `ResetPasswordController`.
- [ ] Improve UX: set keyboard/input actions and optional onSubmitted trigger.
- [ ] Re-run `flutter analyze` to confirm errors resolved.

