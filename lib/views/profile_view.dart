import 'package:flutter/material.dart';
import 'package:pe_na_pedra/viewmodel/profile_viewmodel.dart';
import 'package:pe_na_pedra/provider/global_state_provider.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';
import 'package:pe_na_pedra/views/edit_profile_view.dart';
import 'package:pe_na_pedra/widegt/login_profile_content.dart';
import 'package:pe_na_pedra/widegt/login_prompt.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with AutomaticKeepAliveClientMixin {
  late ProfileViewModel _vm;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _vm = ProfileViewModel();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final global = GlobalStateProvider.of(
        context,
      );

      if (global.isLoggedIn) {
        await _vm.loadProfile(
          global.userId!,
          global.idToken!,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final global = GlobalStateProvider.of(context);

    if (!global.isLoggedIn) {
      return LoginPrompt(
        onLogin: () => Navigator.of(context).pushNamed(
          AppRoutes.login,
        ),
      );
    }

    return ValueListenableBuilder<bool>(
      valueListenable: _vm.isLoading,
      builder: (_, loading, __) {
        if (loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ValueListenableBuilder<String?>(
          valueListenable: _vm.errorMessage,
          builder: (_, error, __) {
            if (error != null) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(error, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => _vm.loadProfile(
                        global.userId!,
                        global.idToken!,
                      ),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              );
            }

            return ValueListenableBuilder<Map<String, dynamic>>(
              valueListenable: _vm.profileData,
              builder: (_, data, __) {
                return LoginProfileContent(
                  fullName: data['fullName'] ?? '',
                  phone: data['phone'] ?? '',
                  birthDate: _vm.formatBirthDate(data['birthDate']),
                  address: data['address'] ?? '',
                  onEditProfile: () async {
                    await Navigator.of(context).pushNamed(
                      AppRoutes.editProfile,
                      arguments: EditProfileViewArguments(
                        mode: EditProfileMode.editProfile,
                      ),
                    );

                    _vm.invalidateCache();
                    _vm.loadProfile(global.userId!, global.idToken!);
                  },
                  onLogout: global.logout,
                );
              },
            );
          },
        );
      },
    );
  }
}
