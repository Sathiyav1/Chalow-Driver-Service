package com.chalow.rideshare.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class DriverDTO {
    public static class DriverProfileResponse {
        private Long id;
        private String name;
        public Long getId() { return id; }
        public String getName() { return name; }
    }

    public static class DriverStatusResponse {
        private String status;
        private BigDecimal earnings;
        private String message;
        private LocalDateTime timestamp;
        public DriverStatusResponse(String status, BigDecimal earnings, String message, LocalDateTime timestamp) {
            this.status = status; this.earnings = earnings; this.message = message; this.timestamp = timestamp;
        }
    }

    public static class OfferRequest {
        private Double offerPrice;
        public Double getOfferPrice() { return offerPrice; }
        public boolean isOfferPriceValid(double distanceMiles) { return offerPrice != null && offerPrice >= 1.0; }
        public static java.math.BigDecimal calculateMinimumOfferPrice(double distanceMiles) { return java.math.BigDecimal.valueOf(1.0); }
    }

    public static class OfferResponse {
        private String status; private String offerId; private String message;
        public OfferResponse(String status, String offerId, String message) { this.status = status; this.offerId = offerId; this.message = message; }
    }

    public static class RideRequestDetails {}
    public static class HotspotInfo { public HotspotInfo(double a, double b, int c, double d) {} }
    public static class DriverProfileResponseWrapper {}
    public static class DriverUpdateRequest {}
    public static class StatusResponse { public StatusResponse(String s, String m) {} }
    public static class RideCompletionRequest {}
    public static class AcceptedRidesResponse {}
    public static class CompletedRideResponse {}
}
