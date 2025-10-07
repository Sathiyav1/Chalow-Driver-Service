package com.chalow.rideshare.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "ride_offers")
public class RideOffer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "ride_request_id")
    private RideRequest rideRequest;
}
