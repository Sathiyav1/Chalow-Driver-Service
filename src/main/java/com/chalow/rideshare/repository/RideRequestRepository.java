package com.chalow.rideshare.repository;

import com.chalow.rideshare.entity.RideRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RideRequestRepository extends JpaRepository<RideRequest, Long> {
    Optional<RideRequest> findByTripId(String tripId);
}
