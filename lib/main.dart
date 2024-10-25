import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trainerdex/constants/app_theme.dart';
import 'package:trainerdex/views/home/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: initializeClient(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TrainerDex',
        theme: AppTheme.getAppTheme(),
        home: const HomeView(),
      ),
    );
  }

  ValueNotifier<GraphQLClient> initializeClient() {
    final HttpLink httpLink = HttpLink(
      'https://beta.pokeapi.co/graphql/v1beta',
      defaultHeaders: {'content-type': 'application/json', 'accept': '*/*'},
    );

    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(),
        link: httpLink,
      ),
    );

    return client;
  }
}
