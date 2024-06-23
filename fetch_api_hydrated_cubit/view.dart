import 'package:api_client/api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_block/fetch_api_hydrated_cubit/state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'cubit.dart';

Future<void> main()  async {
  prettyDioLogger();
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'hydrated cubit  App',
      home: MyScreen(),
    );
  }
}

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('hydrated cubit app'),
      ),
      body: BlocProvider(
        create: (context) => ApiFetchHydratedCubit(),
        child: BlocBuilder<ApiFetchHydratedCubit, ApiFetchState>(
          builder: (context, state) {
            switch (state.uiState) {
              case UIState.idle:
                return const Center(child: Text('Idle State'));
              case UIState.inProgress:
                return const Center(child: CircularProgressIndicator());
              case UIState.success:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Success State'),
                      Text(state.apiResponse.toString()),
                    ],
                  ),
                );
              case UIState.genericError:
                return  Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      const Text('Generic Error State'),
                      Text(state.failureMessage ?? ""),
                      ElevatedButton(onPressed: () {
                        context.read<ApiFetchHydratedCubit>().fetchData();
                      } , child: const Text('reload'),
                      )
                    ],
                  ),
                );
              case UIState.invalidCredentialsError:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Invalid Credentials Error State'),
                      Text(state.failureMessage ?? ""),
                      ElevatedButton(onPressed: () {
                        context.read<ApiFetchHydratedCubit>().fetchData();
                      } , child: const Text('reload'),
                      )

                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}




