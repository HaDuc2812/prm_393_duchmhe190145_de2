// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bills_viewmodels.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BillsViewModels)
final billsViewModelsProvider = BillsViewModelsProvider._();

final class BillsViewModelsProvider
    extends $AsyncNotifierProvider<BillsViewModels, List<Bills>> {
  BillsViewModelsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'billsViewModelsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$billsViewModelsHash();

  @$internal
  @override
  BillsViewModels create() => BillsViewModels();
}

String _$billsViewModelsHash() => r'16d28222c66c5a2aac50752cb414c2573efcd07b';

abstract class _$BillsViewModels extends $AsyncNotifier<List<Bills>> {
  FutureOr<List<Bills>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Bills>>, List<Bills>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Bills>>, List<Bills>>,
              AsyncValue<List<Bills>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
