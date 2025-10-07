package com.chalow.rideshare.service.impl;

import com.chalow.rideshare.service.DistanceService;
import org.locationtech.jts.geom.Point;
import org.springframework.stereotype.Service;

@Service
public class SimpleDistanceService implements DistanceService {
    @Override
    public DistanceResult calculateDistance(Point a, Point b, DistanceUnit unit) { return new DistanceResult(); }
}
