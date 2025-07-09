import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'instrument_controller.g.dart';

@riverpod
class InstrumentController extends _$InstrumentController {
  @override
  Future<List<dynamic>> build() async {
    return await _fetchInstruments();
  }

  Future<List<dynamic>> _fetchInstruments() async {
    final response = await Supabase.instance.client.from('instruments').select();
    return response;
  }

  Future<void> addInstrument(String name) async {
    state = const AsyncValue.loading();
    
    try {
      await Supabase.instance.client.from('instruments').insert({'name': name});
      state = AsyncValue.data(await _fetchInstruments());
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateInstrument(int id, String name) async {
    state = const AsyncValue.loading();
    
    try {
      await Supabase.instance.client
          .from('instruments')
          .update({'name': name})
          .eq('id', id);
      state = AsyncValue.data(await _fetchInstruments());
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteInstrument(int id) async {
    state = const AsyncValue.loading();
    
    try {
      await Supabase.instance.client
          .from('instruments')
          .delete()
          .eq('id', id);
      state = AsyncValue.data(await _fetchInstruments());
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
} 