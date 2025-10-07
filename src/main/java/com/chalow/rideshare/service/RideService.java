package com.chalow.rideshare.service;

import com.chalow.rideshare.dto.DriverDTO;
import com.chalow.rideshare.dto.PageResponse;
import com.chalow.rideshare.dto.UserDTO;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface RideService {
    List<DriverDTO.RideRequestDetails> findCachedNearbyRideRequests(UserDTO.UserResponse driver, double lat, double lon, double radiusKm);
    DriverDTO.OfferResponse makeRideOffer(UserDTO.UserResponse driver, String rideRequestId, DriverDTO.OfferRequest request);
    void cancelRideRequest(UserDTO.UserResponse driver, String confirmationId);
    DriverDTO.StatusResponse confirmArrivalWithImage(UserDTO.UserResponse driver, String confirmationId, Double lat, Double lon, java.time.LocalDateTime timestamp, org.springframework.web.multipart.MultipartFile image);
    DriverDTO.StatusResponse completeRide(UserDTO.UserResponse driver, String confirmationId, DriverDTO.RideCompletionRequest request);
    PageResponse<DriverDTO.AcceptedRidesResponse> getAcceptedRides(UserDTO.UserResponse driver, Pageable pageable);
    PageResponse<DriverDTO.CompletedRideResponse> getCompletedRides(UserDTO.UserResponse driver, Pageable pageable);
    PageResponse<com.chalow.rideshare.dto.RideOfferDTO.OfferResponse> getDriverOffers(UserDTO.UserResponse driver, Pageable pageable);
    DriverDTO.OfferResponse updateRideOffer(UserDTO.UserResponse driver, String offerId, DriverDTO.OfferRequest request);
    com.chalow.rideshare.dto.RideOfferDTO.OfferResponse getDriverOffer(UserDTO.UserResponse driver, String offerId);
    DriverDTO.DriverStatusResponse getDriverStatusAndEarnings(UserDTO.UserResponse driver);
    DriverDTO.StatusResponse rateRider(UserDTO.UserResponse driver, String confirmationId, Object request);
}
