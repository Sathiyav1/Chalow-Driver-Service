package com.chalow.rideshare.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import org.locationtech.jts.geom.Point;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "ride_requests")
public class RideRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, updatable = false)
    private String tripId = UUID.randomUUID().toString();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "rider_id", nullable = false)
    @JsonIgnore
    private User rider;

    @Column(name = "rider_id", insertable = false, updatable = false)
    private Long riderId;

    @Column(columnDefinition = "geometry(Point,4326)")
    @NotNull
    private Point startLocation;

    private String startAddress;

    @Column(columnDefinition = "geometry(Point,4326)")
    @NotNull
    private Point endLocation;

    private String endAddress;

    @NotNull
    private LocalDateTime requestedPickupTime;

    @Min(1)
    private Integer numberOfPassengers;

    @DecimalMin("0.01")
    private BigDecimal offerPrice;

    @Enumerated(EnumType.STRING)
    @NotNull
    private RideStatus status = RideStatus.PENDING;

    private String notes;

    @Column(name = "created_at", columnDefinition = "TIMESTAMP")
    private LocalDateTime createdAt;

    @Column(name = "updated_at", columnDefinition = "TIMESTAMP")
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "rideRequest", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonIgnore
    private List<RideOffer> offers;

    @OneToOne(mappedBy = "rideRequest", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonIgnore
    private Ride ride;

    // Constructors, getters and other fields copied from original repo (omitted for brevity in this extracted project)
    public RideRequest() {}

    public Point getStartLocation() { return startLocation; }
    public Point getEndLocation() { return endLocation; }

    public enum RideStatus {
        PENDING,
        LISTED,
        ACCEPTED,
        PAYMENT_PENDING,
        CONFIRMED,
        IN_PROGRESS,
        COMPLETED,
        CANCELLED,
        LATE,
        DELETED,
        NO_ENOUGH_TIME,
        TOO_MUCH_TIME_AHEAD
    }
}
