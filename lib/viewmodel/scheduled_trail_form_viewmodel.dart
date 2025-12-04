import 'package:flutter/material.dart';
import 'package:pe_na_pedra/controller/routes_controller.dart';
import 'package:pe_na_pedra/controller/scheduled_trails_controller.dart';
import 'package:pe_na_pedra/model/scheduled_trail.dart';
import 'package:pe_na_pedra/model/trail_route.dart';

class ScheduledTrailFormViewModel {
  final formKey = GlobalKey<FormState>();

  final RoutesController _routesController = RoutesController();
  final ScheduledTrailsController _scheduledController =
      ScheduledTrailsController();

  late final String idToken;
  ScheduledTrail? editing;

  final meetingPoint = ValueNotifier<String>('');
  final meetingTime = ValueNotifier<TimeOfDay?>(null);
  final meetingDate = ValueNotifier<DateTime?>(null);
  final selectedRoute = ValueNotifier<TrailRoute?>(null);

  final isSaving = ValueNotifier<bool>(false);
  final routes = ValueNotifier<List<TrailRoute>>([]);
  final isLoadingRoutes = ValueNotifier<bool>(false);
  final meetingPointController = TextEditingController();
  bool isUpdating = false;

  Future<void> loadRoutes() async {
    isLoadingRoutes.value = true;

    try {
      final result = await _routesController.fetchRoutes(idToken: idToken);
      routes.value = result;
    } catch (e) {
      debugPrint("Erro ao carregar rotas: $e");
    } finally {
      isLoadingRoutes.value = false;
    }
  }

  ScheduledTrail? submit() {
    final valid = formKey.currentState!.validate();
    if (!valid) return null;

    formKey.currentState!.save();

    if (selectedRoute.value == null ||
        meetingTime.value == null ||
        meetingDate.value == null) {
      return null;
    }

    final formattedTime =
        "${meetingTime.value!.hour.toString().padLeft(2, '0')}:${meetingTime.value!.minute.toString().padLeft(2, '0')}";

    return ScheduledTrail(
      id: editing?.id,
      routeId: selectedRoute.value!.id!,
      meetingPoint: meetingPoint.value,
      meetingTime: formattedTime,
      meetingDate: meetingDate.value!,
    );
  }

  Future<bool> saveToFirebase(ScheduledTrail trail) async {
    try {
      isSaving.value = true;
      if (trail.id != null && trail.id!.isNotEmpty) {
        // ---------------------------
        //   ATUALIZAR EXISTENTE
        // ---------------------------
        await _scheduledController.updateScheduledTrail(
          trail.id!,
          trail,
          idToken: idToken,
        );
      } else {
        // ---------------------------
        //   CRIAR NOVO
        // ---------------------------
        await _scheduledController.createScheduledTrail(
          trail,
          idToken: idToken,
        );
      }

      return true;
    } catch (e) {
      debugPrint("Erro ao salvar trilha: $e");
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  void delete(String id) async {
    await _scheduledController.deleteScheduledTrail(
      id,
      idToken: idToken,
    );
  }

  void dispose() {
    meetingPoint.dispose();
    meetingTime.dispose();
    meetingDate.dispose();
    selectedRoute.dispose();
    routes.dispose();
    isLoadingRoutes.dispose();
    isSaving.dispose();
  }
}
