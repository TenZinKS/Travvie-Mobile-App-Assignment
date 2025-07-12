class DashboardEntity {
  final int completedTrips;
  final int cancelledTrips;
  final int upcomingTrips;
  final int wishlistCount;
  final double completionRate;
  final String travellerRank;

  DashboardEntity({
    required this.completedTrips,
    required this.cancelledTrips,
    required this.upcomingTrips,
    required this.wishlistCount,
    required this.completionRate,
    required this.travellerRank,
  });
}
