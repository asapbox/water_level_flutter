import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:level_river/models/gauge_station.dart';
import 'package:level_river/services/graphql_provider.dart';

import '../models/year_chart.dart';

class GaugeRepository {
  final GraphqlProvider _graphqlProvider;

  GaugeRepository({required graphqlProvider}) : _graphqlProvider = graphqlProvider;

  Future<List<GaugeStation>> fetchGaugeStations({
    required List<String> slugs,
    required int first,
  }) {
    return _graphqlProvider.allRiverGraphqlProvider.fetchGaugeStations(
      slugs: slugs,
      first: 100,
    );
  }

  Future<List<GaugeStation>> searchGaugeStations({required String query}) async {
    return _graphqlProvider.allRiverGraphqlProvider.fetchGaugeStations(
      search: query,
    );
  }

  Future<List<YearChart>> fetchYearCharts(String slug) async {
    final uri = Uri.parse('https://wl.vpsss.ru/api/v1/charts/years_chart/$slug');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((e) => YearChart.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }
}
