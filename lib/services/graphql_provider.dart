import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:level_river/models/gauge.dart';
import 'package:level_river/models/gauge_station.dart';
import 'package:level_river/resources/resources.dart';
import 'package:level_river/utils/coercers.dart';

class GraphqlProvider {
  final AllRiverGraphqlProvider allRiverGraphqlProvider;

  GraphqlProvider() : allRiverGraphqlProvider = AllRiverGraphqlProvider();
}

class AllRiverGraphqlProvider {
  final GraphQLClient client;

  AllRiverGraphqlProvider._(this.client);

  factory AllRiverGraphqlProvider() {
    final client = GraphQLClient(
      link: HttpLink(Constants.urls.graphql),
      cache: GraphQLCache(),
    );
    return new AllRiverGraphqlProvider._(client);
  }

  Future<List<GaugeStation>> fetchGaugeStations(
      {int first = 20, String? search, List<String>? slugs, int firstGauges = 100}) async {
    const String getGaugeStations = r'''
  query gaugeStations($first: Int!, $search: String, $slugs: [String!], $firstGauges: Int!) {
    gaugeStations(first: $first, search: $search, slugs: $slugs) {
      slug
      location
      minGauge {
        level
        date
      }
      maxGauge {
        level
        date
      }
      water {
        slug
        name
        region {
          name
          slug
        }
      }
      gauges(first: $firstGauges, ordering: "-date") {
        level
        date
      }
    }
  }
''';
    final Map<String, dynamic> variables = {'first': first, 'firstGauges': firstGauges};
    if (slugs != null) variables['slugs'] = slugs;
    if (search != null) variables['search'] = search;
    final QueryOptions _options =
        QueryOptions(document: gql(getGaugeStations), variables: variables);
    App.warning('$variables');

    final queryResult = await client.query(_options);
    App.warning('${queryResult.data}');

    if (queryResult.exception != null) App.warning('${queryResult.exception}');
    final data = Map<String, dynamic>.from(queryResult.data!);
    final items = data['gaugeStations'] as List;
    return items.map((e) {
      return factoryGaugeStation(Map<String, dynamic>.from(e));
    }).toList();
  }

  Future<List<Gauge>> fetchGauges({
    required String gaugeStationSlug,
    required DateTime dateFrom,
    required DateTime dateTo,
    String? ordering,
  }) async {
    const String query = r'''
  query gauges($gaugeStationSlug: String!, $dateFrom: Date, $dateTo: Date, $ordering: String) {
    gauges(gaugeStationSlug: $gaugeStationSlug, dateFrom: $dateFrom, dateTo: $dateTo, ordering: $ordering) {
      level
      date
     }
  }
''';
    final Map<String, dynamic> variables = {
      'gaugeStationSlug': gaugeStationSlug,
      'dateFrom': fromDartDateTimeToGraphQLDate(dateFrom),
      'dateTo': fromDartDateTimeToGraphQLDate(dateTo),
      'ordering': ordering,
    };
    if (ordering != null) variables['ordering'] = ordering;
    final QueryOptions _options = QueryOptions(document: gql(query), variables: variables);
    final queryResult = await client.query(_options);
    App.warning('${_options.properties}');

    if (queryResult.exception != null) App.warning('${queryResult.exception}');
    App.warning('${queryResult.data}');

    final data = Map<String, dynamic>.from(queryResult.data!);
    final items = data['gauges'] as List;
    final r = items.map((e) {
      return factoryGauge(Map<String, dynamic>.from(e));
    }).toList();
    return r;
  }

  GaugeStation factoryGaugeStation(item) => GaugeStation.fromJson(item);

  Gauge factoryGauge(item) => Gauge.fromJson(item);
}
