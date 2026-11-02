// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(preferences)
final preferencesProvider = PreferencesProvider._();

final class PreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  PreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return preferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$preferencesHash() => r'05bbf35b1c4786a80c23292c7ff0dfbba05bb026';

@ProviderFor(billsRepository)
final billsRepositoryProvider = BillsRepositoryProvider._();

final class BillsRepositoryProvider
    extends
        $FunctionalProvider<BillsRepository, BillsRepository, BillsRepository>
    with $Provider<BillsRepository> {
  BillsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'billsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$billsRepositoryHash();

  @$internal
  @override
  $ProviderElement<BillsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BillsRepository create(Ref ref) {
    return billsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BillsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BillsRepository>(value),
    );
  }
}

String _$billsRepositoryHash() => r'173e7ed4a0bc47964195680aab02fd1119c6b113';
