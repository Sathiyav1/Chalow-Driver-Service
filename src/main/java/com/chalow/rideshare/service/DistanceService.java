package com.chalow.rideshare.service;

import org.locationtech.jts.geom.Point;

public interface DistanceService {
    enum DistanceUnit { MILES, KILOMETERS }

    class DistanceResult { private double distance; public double getDistance(){ return distance; } }

    DistanceResult calculateDistance(Point a, Point b, DistanceUnit unit);
}
