package com.chalow.rideshare.service.impl;

import com.chalow.rideshare.dto.DriverDTO;
import com.chalow.rideshare.dto.PageResponse;
import com.chalow.rideshare.dto.RideOfferDTO;
import com.chalow.rideshare.dto.UserDTO;
import com.chalow.rideshare.repository.RideRequestRepository;
import com.chalow.rideshare.service.RideService;
import org.springframework.data.domain.PageImpl;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
public class SimpleRideService implements RideService {
    private final RideRequestRepository rideRequestRepository;

    public SimpleRideService(RideRequestRepository rideRequestRepository) {
        this.rideRequestRepository = rideRequestRepository;
    }
    @Override
    public List<DriverDTO.RideRequestDetails> findCachedNearbyRideRequests(UserDTO.UserResponse driver, double lat, double lon, double radiusKm) { return Collections.emptyList(); }

    @Override
    public DriverDTO.OfferResponse makeRideOffer(UserDTO.UserResponse driver, String rideRequestId, DriverDTO.OfferRequest request) {
        var rideReq = rideRequestRepository.findByTripId(rideRequestId).orElse(null);
        if (rideReq == null) return new DriverDTO.OfferResponse("ERROR", null, "Ride request not found");
        // basic validation and echo
        return new DriverDTO.OfferResponse("SUCCESS", "offer-" + System.currentTimeMillis(), "Offer submitted");
    }

    @Override
    public void cancelRideRequest(UserDTO.UserResponse driver, String confirmationId) { }

    @Override
    public DriverDTO.StatusResponse confirmArrivalWithImage(UserDTO.UserResponse driver, String confirmationId, Double lat, Double lon, java.time.LocalDateTime timestamp, org.springframework.web.multipart.MultipartFile image) { return new DriverDTO.StatusResponse("SUCCESS", "arrived"); }

    @Override
    public DriverDTO.StatusResponse completeRide(UserDTO.UserResponse driver, String confirmationId, DriverDTO.RideCompletionRequest request) { return new DriverDTO.StatusResponse("SUCCESS", "completed"); }

    @Override
    public PageResponse<DriverDTO.AcceptedRidesResponse> getAcceptedRides(UserDTO.UserResponse driver, org.springframework.data.domain.Pageable pageable) { return new PageResponse<>(Collections.emptyList(), new PageImpl<>(Collections.emptyList())); }

    @Override
    public PageResponse<DriverDTO.CompletedRideResponse> getCompletedRides(UserDTO.UserResponse driver, org.springframework.data.domain.Pageable pageable) { return new PageResponse<>(Collections.emptyList(), new PageImpl<>(Collections.emptyList())); }

    @Override
    public PageResponse<RideOfferDTO.OfferResponse> getDriverOffers(UserDTO.UserResponse driver, org.springframework.data.domain.Pageable pageable) { return new PageResponse<>(Collections.emptyList(), new PageImpl<>(Collections.emptyList())); }

    @Override
    public DriverDTO.OfferResponse updateRideOffer(UserDTO.UserResponse driver, String offerId, DriverDTO.OfferRequest request) { return new DriverDTO.OfferResponse("OK","1","updated"); }

    @Override
    public RideOfferDTO.OfferResponse getDriverOffer(UserDTO.UserResponse driver, String offerId) { return new RideOfferDTO.OfferResponse(); }

    @Override
    public DriverDTO.DriverStatusResponse getDriverStatusAndEarnings(UserDTO.UserResponse driver) { return new DriverDTO.DriverStatusResponse("ACTIVE", java.math.BigDecimal.ZERO, "OK", java.time.LocalDateTime.now()); }

    @Override
    public DriverDTO.StatusResponse rateRider(UserDTO.UserResponse driver, String confirmationId, Object request) { return new DriverDTO.StatusResponse("SUCCESS","rated"); }
}
